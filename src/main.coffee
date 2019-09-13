matching = require './matching'
scoring = require './scoring'
time_estimates = require './time_estimates'
feedback = require './feedback'

time = -> (new Date()).getTime()

frequency_lists_are_set = false

set_frequency_lists = (frequency_lists) ->
  matching.set_frequency_lists(frequency_lists)
  frequency_lists_are_set = true

zxcvbn = (password, user_inputs = []) ->
  if !frequency_lists_are_set
    throw new Error('You need to setup frequency_list before using zxcvbn.')

  start = time()
  # reset the user inputs matcher on a per-request basis to keep things stateless
  sanitized_inputs = []
  for arg in user_inputs
    if typeof arg in ["string", "number", "boolean"]
      sanitized_inputs.push arg.toString().toLowerCase()
  matching.set_user_input_dictionary sanitized_inputs
  matches = matching.omnimatch password
  result = scoring.most_guessable_match_sequence password, matches
  result.calc_time = time() - start
  attack_times = time_estimates.estimate_attack_times result.guesses
  for prop, val of attack_times
    result[prop] = val
  result.feedback = feedback.get_feedback result.score, result.sequence
  result

module.exports = Object.assign zxcvbn, { set_frequency_lists }
