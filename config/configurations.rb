module Configurations
  extend Mixlib::Config

  # Sickbay is a service that is able to fetch the status of multiple endpoints at once. You can read more about it and learn how deploy your own instance here:
  # https://github.com/IgorMarques/sickbay
  default :sickbay_url, ENV.fetch('SICKBAY_URL', 'https://sickbay.herokuapp.com')

  # Doctor is teh service where you can determine actions to be taken when a patient (service) is down for some reason
  default :doctor_url, ENV.fetch('DOCTOR_URL', 'https://sickbay.herokuapp.com')

  default :health_check_rate, ENV.fetch('HEALTH_CHECK_RATE', 1).to_i

  config_context :evaluating do
    default :entries_fetched, ENV.fetch('ENTRIES_FETCHED', 3).to_i

    default :entries_expected_to_be_ok, ENV.fetch('ENTRIES_OK', 2).to_i
  end
end
