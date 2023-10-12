import pulsectl

sinks = {
    'headphone': 'Quantum 600 Analog Stereo',
    'speakers': 'Built-in Audio Analog Stereo',
}


def get_sink_name_by_desc(default_sink_description):
    for key, value in sinks.items():
        if default_sink_description == value:
            return key

    return 'unknown'


class PulseCtr:
    def __init__(self):
        self.pulse = pulsectl.Pulse('my-client-name')

    def get_current_sink(self):
        default_sink_name = self.pulse.server_info().default_sink_name
        default_sink_description = 'unknown'

        for sink_input in self.pulse.sink_list():
            if sink_input.name == default_sink_name:
                default_sink_description = sink_input.description

        return get_sink_name_by_desc(default_sink_description)

    def switch_sink(self):
        desk = self.get_next_sink()
        print(desk)

        for sink in self.pulse.sink_list():
            if sink.description == desk:
                self.pulse.default_set(sink)

    def get_next_sink(self):
        current_sink = self.get_current_sink()

        if current_sink in sinks:
            current_index = list(sinks.keys()).index(current_sink)
            if current_index == len(sinks) - 1:
                return sinks[list(sinks.keys())[0]]
            else:
                return list(sinks.values())[current_index + 1]
        else:
            return list(sinks.values())[0]


def create():
    return PulseCtr()