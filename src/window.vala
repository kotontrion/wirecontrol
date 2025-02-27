namespace Wirecontrol {

    [GtkTemplate (ui = "/com/github/kotontrion/wirecontrol/window.ui")]
    public class Window : Adw.ApplicationWindow {

        private AstalWp.Audio audio;
        private ListStore sinks;
        private ListStore sources;

        public double max_vol { get; private set; default=1;}

        [GtkChild]
        private unowned Gtk.ListBox playback_list;
        [GtkChild]
        private unowned Gtk.ListBox output_list;
        [GtkChild]
        private unowned Gtk.ListBox input_list;
        [GtkChild]
        private unowned Gtk.ListBox recorder_list;
        [GtkChild]
        private unowned Gtk.ListBox device_list;

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

            this.sinks = new ListStore(typeof(AstalWp.Endpoint));
            this.sources = new ListStore(typeof(AstalWp.Endpoint));

            audio.stream_added.connect((audio, endpoint) => this.on_stream_added(audio, endpoint, this.playback_list, this.sinks));
            audio.recorder_added.connect((audio, endpoint) => this.on_stream_added(audio, endpoint, this.recorder_list, this.sources));
            audio.speaker_added.connect((audio, endpoint) => this.on_endpoint_added(audio, endpoint, this.output_list, this.sinks));
            audio.microphone_added.connect((audio, endpoint) => this.on_endpoint_added(audio, endpoint, this.input_list, this.sources));
            audio.device_added.connect((audio, device) => this.on_device_added(audio, device, this.device_list));

            audio.stream_removed.connect((audio, endpoint) => this.on_stream_removed(audio, endpoint, this.playback_list));
            audio.recorder_removed.connect((audio, endpoint) => this.on_stream_removed(audio, endpoint, this.recorder_list));
            audio.speaker_removed.connect((audio, endpoint) => this.on_endpoint_removed(audio, endpoint, this.output_list, this.sinks));
            audio.microphone_removed.connect((audio, endpoint) => this.on_endpoint_removed(audio, endpoint, this.input_list, this.sources));
            audio.device_removed.connect((audio, device) => this.on_device_removed(audio, device, this.device_list));
        }

        private void on_stream_added(AstalWp.Audio audio, AstalWp.Stream endpoint, Gtk.ListBox lb, ListStore endpoints) {
            lb.append(new Wirecontrol.Stream(endpoint, endpoints));
        }

        private void on_stream_removed(AstalWp.Audio audio, AstalWp.Stream endpoint, Gtk.ListBox lb) {
            int i = 0;
            Wirecontrol.Stream? ep = (Wirecontrol.Stream) lb.get_row_at_index(0);
            while(ep != null) {
                if(ep.stream == endpoint) {
                    lb.remove(ep);
                    break;
                }
                ep = (Wirecontrol.Stream) lb.get_row_at_index(++i);
            }
        }

      private void on_endpoint_added(AstalWp.Audio audio, AstalWp.Endpoint endpoint, Gtk.ListBox lb, ListStore endpoints) {
          lb.append(new Wirecontrol.Endpoint(endpoint));
          endpoints.append(endpoint);
      }

      private void on_endpoint_removed(AstalWp.Audio audio, AstalWp.Endpoint endpoint, Gtk.ListBox lb, ListStore endpoints) {
          uint position;
          bool found = endpoints.find(endpoint, out position);
          if(found) endpoints.remove(position);
          
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
    
      private void on_device_added(AstalWp.Audio audioi, AstalWp.Device device, Gtk.ListBox lb) {
          lb.append(new Wirecontrol.Device(device));
      }

      private void on_device_removed(AstalWp.Audio audio, AstalWp.Device device, Gtk.ListBox lb) {
          int i = 0;
          Wirecontrol.Device? ep = (Wirecontrol.Device) lb.get_row_at_index(0);
          while(ep != null) {
              if(ep.device == device) {
                  lb.remove(ep);
                  break;
              }
              ep = (Wirecontrol.Device) lb.get_row_at_index(++i);
          }
      }
    }
}
