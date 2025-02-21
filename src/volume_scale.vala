namespace Wirecontrol {
    [GtkTemplate (ui = "/com/github/kotontrion/wirecontrol/volume_scale.ui")]
    public class VolumeScale : Gtk.Box {

        public AstalWp.ChannelVolume channel { get; construct; }

        [GtkChild]
        private unowned Gtk.Adjustment volume_adjust;

        public VolumeScale (AstalWp.ChannelVolume channel) {
            Object(channel: channel);

            channel.bind_property("volume", volume_adjust, "value", GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.SYNC_CREATE);
            realize.connect(() => {
                get_root().bind_property("max-vol", volume_adjust, "upper", GLib.BindingFlags.SYNC_CREATE);
            });
        }
    }
}
