From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 08/10] ARM: dts: n900: Enable omap sham and include
 directly omap34xx.dtsi
Date: Sat, 28 Feb 2015 17:44:13 +0100
Message-ID: <20150228164413.GF4978@amd>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-9-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424958600-18881-9-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2015-02-26 14:49:58, Pali Roh=E1r wrote:
> This patch moves content of file omap34xx-hs.dtsi into omap3-n900.dts=
 and enable
> omap sham support (omap HW support for SHA + MD5). After testing both=
 omap hwmod
> and omap-sham.ko drivers it looks like signed Nokia X-Loader enable L=
3 firewall
> for omap sham. There is no kernel crash with both official bootloader=
 and crypto
> enable bootloader. So we can safely enable sham code.
>=20

> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>

Acked-by: Pavel	 Machek <pavel@ucw.cz>


> +/*
> + * Default secure signed bootloader (Nokia X-Loader) does not enable=
 L3 firewall
> + * for omap AES HW crypto support. When linux kernel try to access m=
emory of AES

                                      When Linux Kernel tries...

> + * blocks then kernel receive "Unhandled fault: external abort on no=
n-linefetch"
            , the kernel receives
	   =20
> + * and crash. Until somebody fix omap-aes.c and omap_hwmod_3xxx_data=
=2Ec code (no

      and crashes. Until somebody fixes
     =20
> + * crash anymore) omap AES support will be disabled for all Nokia N9=
00 devices.
> + * There is "unofficial" version of bootloader which enables AES in =
L3 firewall
                                                                       =
   firewall,
									 =20
> + * but it is not widely used and to prevent kernel crash rather AES =
is disabled.
> + * There is also no runtime detection code if AES is disabled in L3 =
firewall...
> + */
> +&aes {
> +	status =3D "disabled";
> +};
> +
>  / {
>  	model =3D "Nokia N900";
>  	compatible =3D "nokia,omap3-n900", "ti,omap3430", "ti,omap3";

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
