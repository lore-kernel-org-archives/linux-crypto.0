From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 10/10] ARM: dts: Remove files omap34xx-hs.dtsi and
 omap36xx-hs.dtsi
Date: Sat, 28 Feb 2015 17:45:08 +0100
Message-ID: <20150228164508.GH4978@amd>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-11-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
	Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Paul Walmsley <paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Nishanth Menon <nm-l0cyMroinI0@public.gmane.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>,
	Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424958600-18881-11-git-send-email-pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2015-02-26 14:50:00, Pali Roh=E1r wrote:
> These files are not used by any DTS file anymore.
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Pavel	 Machek <pavel-+ZI9xUNit7I@public.gmane.org>

> ---
>  arch/arm/boot/dts/omap34xx-hs.dtsi |   12 ------------
>  arch/arm/boot/dts/omap36xx-hs.dtsi |   12 ------------
>  2 files changed, 24 deletions(-)
>  delete mode 100644 arch/arm/boot/dts/omap34xx-hs.dtsi
>  delete mode 100644 arch/arm/boot/dts/omap36xx-hs.dtsi
>=20
> diff --git a/arch/arm/boot/dts/omap34xx-hs.dtsi b/arch/arm/boot/dts/o=
map34xx-hs.dtsi
> deleted file mode 100644
> index d4be302..0000000
> --- a/arch/arm/boot/dts/omap34xx-hs.dtsi
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -/* Disabled modules for secure omaps */
> -
> -#include "omap34xx.dtsi"
> -
> -/* Secure omaps have some devices inaccessible depending on the firm=
ware */
> -&aes {
> -	status =3D "disabled";
> -};
> -
> -&sham {
> -	status =3D "disabled";
> -};
> diff --git a/arch/arm/boot/dts/omap36xx-hs.dtsi b/arch/arm/boot/dts/o=
map36xx-hs.dtsi
> deleted file mode 100644
> index e93ff8d..0000000
> --- a/arch/arm/boot/dts/omap36xx-hs.dtsi
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -/* Disabled modules for secure omaps */
> -
> -#include "omap36xx.dtsi"
> -
> -/* Secure omaps have some devices inaccessible depending on the firm=
ware */
> -&aes {
> -	status =3D "disabled";
> -};
> -
> -&sham {
> -	status =3D "disabled";
> -};

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
