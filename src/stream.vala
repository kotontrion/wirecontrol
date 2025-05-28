namespace Wirecontrol {
    [GtkTemplate (ui = "/com/github/kotontrion/wirecontrol/stream.ui")]
    public class Stream : Gtk.ListBoxRow {

        public AstalWp.Stream stream { get; construct; }
        public ListStore endpoints {get; construct; }

        [GtkChild]
        private unowned Gtk.Adjustment volume_adjust;
        [GtkChild]
        private unowned Gtk.ToggleButton mute_toggle;
        [GtkChild]
        private unowned Gtk.ToggleButton lock_toggle;
        [GtkChild]
        private unowned Gtk.Box channel_box;
        [GtkChild]
        private unowned Gtk.DropDown target_endpoint;

        public Stream (AstalWp.Stream stream, ListStore endpoints) {
            Object(stream: stream, endpoints: endpoints);

            stream.bind_property("volume", volume_adjust, "value", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            stream.bind_property("mute", mute_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            stream.bind_property("lock-channels", lock_toggle, "active", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);

            stream.notify["target-endpoint"].connect(() => {
                uint position;
                bool found = endpoints.find(stream.target_endpoint, out position);
                target_endpoint.selected = position;
            });

            uint position;
            bool found = endpoints.find(stream.target_endpoint, out position);
            target_endpoint.selected = position;

            target_endpoint.notify["selected"].connect(() => {
                var endpoint = endpoints.get_item(target_endpoint.selected);
                stream.target_endpoint = endpoint as AstalWp.Endpoint;
            });

            realize.connect(() => {
                get_root().bind_property("max-vol", volume_adjust, "upper", GLib.BindingFlags.SYNC_CREATE);
            });
          
            stream.notify["channels"].connect(recreate_channels);
            recreate_channels();
        }

        private void recreate_channels() {
           var widget = channel_box.get_first_child();
                while(widget != null) {
                  channel_box.remove(widget);
                  widget = channel_box.get_first_child();
                }
                if(stream.channels == null) return;
                foreach(var cv in stream.channels) {
                  var channel = new Wirecontrol.VolumeScale(cv);
                  channel_box.append(channel);
                }
        }
    }
}
