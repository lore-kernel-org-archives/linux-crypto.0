From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: Duplicated module names
Date: Fri, 29 Jan 2016 09:04:19 +0200
Message-ID: <56AB0EF3.4050008@ti.com>
References: <56A91B6A.2060205@oracle.com>
 <CAKi4VA+MC=hXMQ2kHi4_Xv2w7qQcG443zj9+rKo_JKoSzgDvYQ@mail.gmail.com>
 <56AA98D6.7020305@oracle.com>
 <CAKi4VAKF-Ywm=VK4wzDdr-O0Fi8Gv8X--CQcJ4FFia0Gu1Xaeg@mail.gmail.com>
 <87h9hxrkvs.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="6qcmQRHVS7siKRRuSr63Qxoaocn8ABDxc"
Cc: linux-modules <linux-modules@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, David Airlie <airlied@linux.ie>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
	Lucas De Marchi <lucas.de.marchi@gmail.com>,
	Samson Yeung <samson.yeung@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51270 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbcA2HEg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 02:04:36 -0500
In-Reply-To: <87h9hxrkvs.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--6qcmQRHVS7siKRRuSr63Qxoaocn8ABDxc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 29/01/16 07:54, Rusty Russell wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>> Hi!
>>
>> CC'ing Rusty and mailing lists
>=20
> Thanks.
>=20
>> Rusty and ohers: it looks like both CONFIG_CRC32 and
>> CONFIG_CRYPTO_CRC32 can be compiled as module, and they generate
>> modules with the same name, crc32.  Could that be fixed?
>=20
> Gah.  Looks like it's been that way since at least 2014, too.
>=20
> I think we could rename it to crypto_crc32, but I don't think it's the
> only one.  Marco, I think depmod should probably FAIL if two modules
> have the same name, which would at least find such problems.
>=20
> (BTW is there a nice way to figure out if a config var is a tristate?  =
These
> are only problematic if both CONFIG_ are tristate.)
>=20
> Here's a hacky attempt to look for problems:
>=20
> rusty@rusty-Lemur:~/devel/kernel/linux (master)$ KCONFIGS=3D`find * -na=
me 'Kconfig*'`; for m in `find [b-z]* -name 'Makefile*'`; do sed -n 's,ob=
j-\$(CONFIG.*+=3D \([a-z0-9_-]\+\.o\)$,'$m' \1,p' <$m | sort -u; done | s=
ort -k 2 | uniq -D -f 1 | while read m obj; do fgrep -w $obj $m /dev/null=
; done | while read LINE; do conf=3D`echo $LINE | sed 's/.*\$(CONFIG_\([A=
-Z0-9_]*\).*/\1/'`; if grep -C2 "^config $conf\$" $KCONFIGS | fgrep -q tr=
istate; then echo $LINE; fi; done
>=20
> Here are the results (mildly filtered by me):
>=20
> drivers/gpu/drm/i2c/Makefile:obj-$(CONFIG_DRM_I2C_ADV7511) +=3D adv7511=
=2Eo
> drivers/media/i2c/Makefile:obj-$(CONFIG_VIDEO_ADV7511) +=3D adv7511.o
>=20
> drivers/media/platform/coda/Makefile:obj-$(CONFIG_VIDEO_CODA) +=3D coda=
=2Eo
> fs/coda/Makefile:obj-$(CONFIG_CODA_FS) +=3D coda.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_CONNECTO=
R_ANALOG_TV) +=3D connector-analog-tv.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_CONNECTOR_ANALOG_TV) +=3D connector-analog-tv.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_CONNECTO=
R_DVI) +=3D connector-dvi.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_CONNECTOR_DVI) +=3D connector-dvi.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_CONNECTO=
R_HDMI) +=3D connector-hdmi.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_CONNECTOR_HDMI) +=3D connector-hdmi.o
>=20
> crypto/Makefile:obj-$(CONFIG_CRYPTO_CRC32) +=3D crc32.o
> lib/Makefile:obj-$(CONFIG_CRC32) +=3D crc32.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_ENCODER_=
OPA362) +=3D encoder-opa362.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_ENCODER_OPA362) +=3D encoder-opa362.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_ENCODER_=
TFP410) +=3D encoder-tfp410.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_ENCODER_TFP410) +=3D encoder-tfp410.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_ENCODER_=
TPD12S015) +=3D encoder-tpd12s015.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_ENCODER_TPD12S015) +=3D encoder-tpd12s015.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_DP=
I) +=3D panel-dpi.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_DPI) +=3D panel-dpi.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_DS=
I_CM) +=3D panel-dsi-cm.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_DSI_CM) +=3D panel-dsi-cm.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_LG=
PHILIPS_LB035Q02) +=3D panel-lgphilips-lb035q02.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_LGPHILIPS_LB035Q02) +=3D panel-lgphilips-lb035q02.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_NE=
C_NL8048HL11) +=3D panel-nec-nl8048hl11.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_NEC_NL8048HL11) +=3D panel-nec-nl8048hl11.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_SH=
ARP_LS037V7DW01) +=3D panel-sharp-ls037v7dw01.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_SHARP_LS037V7DW01) +=3D panel-sharp-ls037v7dw01.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_SO=
NY_ACX565AKM) +=3D panel-sony-acx565akm.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_SONY_ACX565AKM) +=3D panel-sony-acx565akm.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_TP=
O_TD028TTEC1) +=3D panel-tpo-td028ttec1.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_TPO_TD028TTEC1) +=3D panel-tpo-td028ttec1.o
>=20
> drivers/gpu/drm/omapdrm/displays/Makefile:obj-$(CONFIG_DISPLAY_PANEL_TP=
O_TD043MTEA1) +=3D panel-tpo-td043mtea1.o
> drivers/video/fbdev/omap2/omapfb/displays/Makefile:obj-$(CONFIG_FB_OMAP=
2_PANEL_TPO_TD043MTEA1) +=3D panel-tpo-td043mtea1.o
>=20
> drivers/mtd/onenand/Makefile:obj-$(CONFIG_MTD_ONENAND_SAMSUNG) +=3D sam=
sung.o
> drivers/tty/serial/Makefile:obj-$(CONFIG_SERIAL_SAMSUNG) +=3D samsung.o=

>=20
> sound/soc/codecs/Makefile:obj-$(CONFIG_SND_SOC_AC97_CODEC) +=3D snd-soc=
-ac97.o
> sound/soc/samsung/Makefile:obj-$(CONFIG_SND_SAMSUNG_AC97) +=3D snd-soc-=
ac97.o
>=20
> drivers/hwmon/Makefile:obj-$(CONFIG_SENSORS_VEXPRESS) +=3D vexpress.o
> drivers/regulator/Makefile:obj-$(CONFIG_REGULATOR_VEXPRESS) +=3D vexpre=
ss.o
>=20
> Can maintainers please tell me which of these are harmless?

The duplicates under drivers/gpu/drm/omapdrm/ and
drivers/video/fbdev/omap2/ are (hopefully) harmless, as the DRM driver
and the fbdev driver are mutually exclusive.

 Tomi


--6qcmQRHVS7siKRRuSr63Qxoaocn8ABDxc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqw7zAAoJEPo9qoy8lh71InwP/0jYaH4P2vJQamAOIYgc+GJG
ppr7rwVa0AUH+9lVcLVSgov5qip/te1vu7wiVc3/I6QgG3VOz8mGoz3fRRidVPqD
/fAIXMT/81tSTBF0TanUlM60WoB1UMdRSSo31fa3W/N7oVzey+EDs0cXKh55DmLi
naMJkkHg/3yAlmaOLU7H7HlTcBuPO2iGxOq03VqJHGqHZ83JHdqGppIXUHpQRAMQ
21NfXqXcqqVNOJs7kOLVDSxVn8HWnM33wU11SrtU534cyYsDQuRDoBw0xVkpql/Y
bOyi0sAMrUj+p9pTehXM3NjW+vU53YxVRFjeesVcDD00QgcsTuSoeI9d9oFwIasM
PPzW4ARoGMslOu6YCjHkt3rlLdK+Afqo5f6bt7Ag+zqHCHP2+bhb9/QAXdP1Xj++
X3woMX7cc5Snfdt5nGAmidY8eu9NxhouOnNZzavjSo2wr1lmnuCX1Daman1GFxg8
6ij2tnqiSHK2Kplgh6BW2y021u+y0La4+YmpDQUchPe5S6wQIia1c/vgmRGCEvP0
o+wkIbTuDISKuFXa48BCWAitSmt4UFwNDDkIJ4wF8KGUFuZl2WEMZYZ/3n7lVo1O
fpRRJjtJLKnT/y10XZiP6ISaBSH0FLw132IqOob16M/QeQT7zN4CcqR9S2CilzzG
/JbaInPws4eOSJwQsDH1
=frg5
-----END PGP SIGNATURE-----

--6qcmQRHVS7siKRRuSr63Qxoaocn8ABDxc--
