namespace Wirecontrol {

    [GtkTemplate (ui = "/com/github/kotontrion/wirecontrol/window.ui")]
    public class Window : Adw.ApplicationWindow {

        private AstalWp.Audio audio;
        public double max_vol { get; private set; default=1;}

        [GtkChild]
        private unowned Gtk.ListBox playback_list;
        [GtkChild]
        private unowned Gtk.ListBox output_list;
        [GtkChild]
        private unowned Gtk.ListBox input_list;
        [GtkChild]
        private unowned Gtk.ListBox recorder_list;

        public Window (Gtk.Application app) {
            Object (application: app);

            this.audio = AstalWp.get_default().get_audio();

            SimpleAction stateful_action = new SimpleAction.stateful ("enable-overamplification", null, new Variant.boolean (false));
		    stateful_action.activate.connect (() => {
			    Variant state = stateful_action.get_state ();
			    bool overamplify = state.get_boolean ();
			    stateful_action.set_state (new Variant.boolean (!overamplify));
                if (overamplify) {
                    this.max_vol = 1;
                }
                else {
                    this.max_vol = 1.5;
                }
		    });
		    this.add_action (stateful_action);


            audio.stream_added.connect((audio, endpoint) => this.on_added(audio, endpoint, this.playback_list));
            audio.recorder_added.connect((audio, endpoint) => this.on_added(audio, endpoint, this.recorder_list));
            audio.speaker_added.connect((audio, endpoint) => this.on_added(audio, endpoint, this.output_list));
            audio.microphone_added.connect((audio, endpoint) => this.on_added(audio, endpoint, this.input_list));

            audio.stream_removed.connect((audio, endpoint) => this.on_removed(audio, endpoint, this.playback_list));
            audio.recorder_removed.connect((audio, endpoint) => this.on_removed(audio, endpoint, this.recorder_list));
            audio.speaker_removed.connect((audio, endpoint) => this.on_removed(audio, endpoint, this.output_list));
            audio.microphone_removed.connect((audio, endpoint) => this.on_removed(audio, endpoint, this.input_list));
        }

        private void on_added(AstalWp.Audio audio, AstalWp.Endpoint endpoint, Gtk.ListBox lb) {
            lb.append(new Wirecontrol.Endpoint(endpoint));
        }

        private void on_removed(AstalWp.Audio audio, AstalWp.Endpoint endpoint, Gtk.ListBox lb) {
            int i = 0;
            Wirecontrol.Endpoint? ep = (Wirecontrol.Endpoint) lb.get_row_at_index(0);
            while(ep != null) {
                if(ep.endpoint == endpoint) {
                    lb.remove(ep);
                    break;
                }
                ep = (Wirecontrol.Endpoint) lb.get_row_at_index(++i);
            }
        }
    }
}
