From: Tony Lindgren <tony@atomide.com>
Subject: Re: Nokia N900: omap aes is broken
Date: Tue, 24 Feb 2015 09:25:12 -0800
Message-ID: <20150224172512.GC28244@atomide.com>
References: <201502181321.03774@pali>
 <201502182202.30272@pali>
 <201502182227.55488@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201502182227.55488@pali>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Pali Roh=C3=A1r <pali.rohar@gmail.com> [150218 16:03]:
> On Wednesday 18 February 2015 22:02:30 Pali Roh=C3=A1r wrote:
> > On Wednesday 18 February 2015 13:21:03 Pali Roh=C3=A1r wrote:
> > > Hello,
> > >=20
> > > I tried to test OMAP AES driver on Nokia N900 with special
> > > Nokia bootloader which enable L3 firewall for OMAP AES HW
> > > support.
> > >=20
> > > I modified arch/arm/boot/dts/omap34xx-hs.dtsi file and
> > > commented aes line which disable aes support in DT.
> > >=20
> > > Then I booted kernel and loaded omap-aes.ko module. And I
> > > got this output in dmesg:
> > >=20
> > > [    0.222930] platform 480c5000.aes: Cannot lookup hwmod
> > > 'aes' [   27.758148] omap-aes 480c5000.aes:
> > > _od_fail_runtime_resume: FIXME: missing hwmod/omap_dev info
> > > [   27.765960] omap-aes 480c5000.aes: omap_aes_probe: failed
> > > to get_sync(-19)
> > > [   29.257690] omap-aes 480c5000.aes: initialization failed.
> > >=20
> > > So it looks like some initialization data are missing for
> > > Nokia N900 (omap3430 device).
> > >=20
> > > Can somebody look at it? I have patched 2.6.28 kernel were
> > > omap aes support on this N900 device (with special
> > > bootloader) is working.
> > >=20
> > > Maybe some other data are missing in DT or in hwmod?
> >=20
> > dma channels are missing in DT. I applied this patch:
> >=20
> > diff --git a/arch/arm/boot/dts/omap3.dtsi
> > b/arch/arm/boot/dts/omap3.dtsi index 01b7111..473d460 100644
> > --- a/arch/arm/boot/dts/omap3.dtsi
> > +++ b/arch/arm/boot/dts/omap3.dtsi
> > @@ -92,6 +92,8 @@
> >  			ti,hwmods =3D "aes";
> >  			reg =3D <0x480c5000 0x50>;
> >  			interrupts =3D <0>;
> > +			dmas =3D <&sdma 65 &sdma 66>;
> > +			dma-names =3D "tx", "rx";
> >  		};
> >=20
> >  		prm: prm@48306000 {
> > @@ -550,6 +552,8 @@
> >  			ti,hwmods =3D "sham";
> >  			reg =3D <0x480c3000 0x64>;
> >  			interrupts =3D <49>;
> > +			dmas =3D <&sdma 96>;
> > +			dma-names =3D "rx";
> >  		};
> >=20
> >  		smartreflex_core: smartreflex@480cb000 {
> >=20
> >=20
> > and omap-aes driver was successfully loaded. now it is in
> > /proc/crypto
> >=20
> > I copied dma names and numbers from file
> > arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>=20
> And I also needed to apply this patch:
>=20
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/ma=
ch-omap2/omap_hwmod_3xxx_data.c
> index 11468ee..3281f30 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -3938,8 +3938,9 @@ int __init omap3xxx_hwmod_init(void)
>  	if (r < 0)
>  		return r;
> =20
> -	/* Register GP-only hwmod links. */
> -	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
> +//	/* Register GP-only hwmod links. */
> +//	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
> +	if (h_gp) {
>  		r =3D omap_hwmod_register_links(h_gp);
>  		if (r < 0)
>  			return r;
>=20
> aes hwmod is defined in GP-only hwmod...

Doesn't this depend on the bootloader version of n900 to work?

Regards,

Tony
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
