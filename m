From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Duplicated module names
Date: Fri, 29 Jan 2016 16:24:15 +1030
Message-ID: <87h9hxrkvs.fsf@rustcorp.com.au>
References: <56A91B6A.2060205@oracle.com> <CAKi4VA+MC=hXMQ2kHi4_Xv2w7qQcG443zj9+rKo_JKoSzgDvYQ@mail.gmail.com> <56AA98D6.7020305@oracle.com> <CAKi4VAKF-Ywm=VK4wzDdr-O0Fi8Gv8X--CQcJ4FFia0Gu1Xaeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-modules <linux-modules@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, David Airlie <airlied@linux.ie>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>,
	Samson Yeung <samson.yeung@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:58193 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbcA2Fyi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 00:54:38 -0500
In-Reply-To: <CAKi4VAKF-Ywm=VK4wzDdr-O0Fi8Gv8X--CQcJ4FFia0Gu1Xaeg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
> Hi!
>
> CC'ing Rusty and mailing lists

Thanks.

> Rusty and ohers: it looks like both CONFIG_CRC32 and
> CONFIG_CRYPTO_CRC32 can be compiled as module, and they generate
> modules with the same name, crc32.  Could that be fixed?

Gah.  Looks like it's been that way since at least 2014, too.

I think we could rename it to crypto_crc32, but I don't think it's the
only one.  Marco, I think depmod should probably FAIL if two modules
have the same name, which would at least find such problems.

(BTW is there a nice way to figure out if a config var is a tristate?  These
are only problematic if both CONFIG_ are tristate.)

Here's a hacky attempt to look for problems:

rusty@rusty-Lemur:~/devel/kernel/linux (master)$ KCONFIGS=`find * -name 'Kconfig*'`; for m in `find [b-z]* -name 'Makefile*'`; do sed -n 's,obj-\$(CONFIG.*+= \([a-z0-9_-]\+\.o\)$,'$m' \1,p' <$m | sort -u; done | sort -k 2 | uniq -D -f 1 | while read m obj; do fgrep -w $obj $m /dev/null; done | while read LINE; do conf=`echo $LINE | sed 's/.*\$(CONFIG_\([A-Z0-9_]*\).*/\1/'`; if grep -C2 "^config $conf\$" $KCONFIGS | fgrep -q tristate; then echo $LINE; fi; done

Here are the results (mildly filtered by me):

drivers/gpu/drm/i2c/Makefile:obj-$(CONFIG_DRM_I2C_ADV7511) += adv7511.o
drivers/media/i2c/Makefile:obj-$(CONFIG_VIDEO_ADV7511) += adv7511.o

drivers/media/platform/coda/Makefile:obj-$(CONFIG_VIDEO_CODA) += coda.o
fs/coda/Makefile:obj-$(CONFIG_CODA_FS) += coda.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_CONNECTOR_ANALOG_TV) += connector-analog-tv.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_CONNECTOR_ANALOG_TV) += connector-analog-tv.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_CONNECTOR_DVI) += connector-dvi.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_CONNECTOR_DVI) += connector-dvi.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_CONNECTOR_HDMI) += connector-hdmi.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_CONNECTOR_HDMI) += connector-hdmi.o

crypto/Makefile:obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
lib/Makefile:obj-$(CONFIG_CRC32) += crc32.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_ENCODER_OPA362) += encoder-opa362.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_ENCODER_OPA362) += encoder-opa362.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_ENCODER_TFP410) += encoder-tfp410.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_ENCODER_TFP410) += encoder-tfp410.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_ENCODER_TPD12S015) += encoder-tpd12s015.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_ENCODER_TPD12S015) += encoder-tpd12s015.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_DPI) += panel-dpi.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_DPI) += panel-dpi.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_DSI_CM) += panel-dsi-cm.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_DSI_CM) += panel-dsi-cm.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_LGPHILIPS_LB035Q02) += panel-lgphilips-lb035q02.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_LGPHILIPS_LB035Q02) += panel-lgphilips-lb035q02.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_NEC_NL8048HL11) += panel-nec-nl8048hl11.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_NEC_NL8048HL11) += panel-nec-nl8048hl11.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_SONY_ACX565AKM) += panel-sony-acx565akm.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_SONY_ACX565AKM) += panel-sony-acx565akm.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_TPO_TD028TTEC1) += panel-tpo-td028ttec1.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_TPO_TD028TTEC1) += panel-tpo-td028ttec1.o

drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o
drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP2_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o

drivers/mtd/onenand/Makefile:obj-$(CONFIG_MTD_ONENAND_SAMSUNG) += samsung.o
drivers/tty/serial/Makefile:obj-$(CONFIG_SERIAL_SAMSUNG) += samsung.o

sound/soc/codecs/Makefile:obj-$(CONFIG_SND_SOC_AC97_CODEC) += snd-soc-ac97.o
sound/soc/samsung/Makefile:obj-$(CONFIG_SND_SAMSUNG_AC97) += snd-soc-ac97.o

drivers/hwmon/Makefile:obj-$(CONFIG_SENSORS_VEXPRESS) += vexpress.o
drivers/regulator/Makefile:obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress.o

Can maintainers please tell me which of these are harmless?

Thanks!
Rusty.
