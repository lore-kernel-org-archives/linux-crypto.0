From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: Nokia N900: omap aes is broken
Date: Wed, 18 Feb 2015 22:27:55 +0100
Message-ID: <201502182227.55488@pali>
References: <201502181321.03774@pali> <201502182202.30272@pali>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5040808.K7SYyACmmY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201502182202.30272@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart5040808.K7SYyACmmY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 February 2015 22:02:30 Pali Roh=C3=A1r wrote:
> On Wednesday 18 February 2015 13:21:03 Pali Roh=C3=A1r wrote:
> > Hello,
> >=20
> > I tried to test OMAP AES driver on Nokia N900 with special
> > Nokia bootloader which enable L3 firewall for OMAP AES HW
> > support.
> >=20
> > I modified arch/arm/boot/dts/omap34xx-hs.dtsi file and
> > commented aes line which disable aes support in DT.
> >=20
> > Then I booted kernel and loaded omap-aes.ko module. And I
> > got this output in dmesg:
> >=20
> > [    0.222930] platform 480c5000.aes: Cannot lookup hwmod
> > 'aes' [   27.758148] omap-aes 480c5000.aes:
> > _od_fail_runtime_resume: FIXME: missing hwmod/omap_dev info
> > [   27.765960] omap-aes 480c5000.aes: omap_aes_probe: failed
> > to get_sync(-19)
> > [   29.257690] omap-aes 480c5000.aes: initialization failed.
> >=20
> > So it looks like some initialization data are missing for
> > Nokia N900 (omap3430 device).
> >=20
> > Can somebody look at it? I have patched 2.6.28 kernel were
> > omap aes support on this N900 device (with special
> > bootloader) is working.
> >=20
> > Maybe some other data are missing in DT or in hwmod?
>=20
> dma channels are missing in DT. I applied this patch:
>=20
> diff --git a/arch/arm/boot/dts/omap3.dtsi
> b/arch/arm/boot/dts/omap3.dtsi index 01b7111..473d460 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -92,6 +92,8 @@
>  			ti,hwmods =3D "aes";
>  			reg =3D <0x480c5000 0x50>;
>  			interrupts =3D <0>;
> +			dmas =3D <&sdma 65 &sdma 66>;
> +			dma-names =3D "tx", "rx";
>  		};
>=20
>  		prm: prm@48306000 {
> @@ -550,6 +552,8 @@
>  			ti,hwmods =3D "sham";
>  			reg =3D <0x480c3000 0x64>;
>  			interrupts =3D <49>;
> +			dmas =3D <&sdma 96>;
> +			dma-names =3D "rx";
>  		};
>=20
>  		smartreflex_core: smartreflex@480cb000 {
>=20
>=20
> and omap-aes driver was successfully loaded. now it is in
> /proc/crypto
>=20
> I copied dma names and numbers from file
> arch/arm/mach-omap2/omap_hwmod_3xxx_data.c

And I also needed to apply this patch:

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-oma=
p2/omap_hwmod_3xxx_data.c
index 11468ee..3281f30 100644
=2D-- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3938,8 +3938,9 @@ int __init omap3xxx_hwmod_init(void)
 	if (r < 0)
 		return r;
=20
=2D	/* Register GP-only hwmod links. */
=2D	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
+//	/* Register GP-only hwmod links. */
+//	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
+	if (h_gp) {
 		r =3D omap_hwmod_register_links(h_gp);
 		if (r < 0)
 			return r;

aes hwmod is defined in GP-only hwmod...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5040808.K7SYyACmmY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTlA9sACgkQi/DJPQPkQ1JMtgCgipcsgU4UkbgWfVx1z0ZvelGu
ZkwAn00AaVHhIjCeGJEOyt4uMcOCGwAt
=GQ2c
-----END PGP SIGNATURE-----

--nextPart5040808.K7SYyACmmY--
