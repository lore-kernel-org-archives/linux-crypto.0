From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v7 1/4] ARM: sun7i: dt: Add Security System to A20 SoC DTS
Date: Tue, 14 Apr 2015 13:50:47 +0200
Message-ID: <20150414115047.GB27280@lukather>
References: <1429010461-9243-1-git-send-email-clabbe.montjoie@gmail.com>
 <1429010461-9243-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org,
	joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429010461-9243-2-git-send-email-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 14, 2015 at 01:20:58PM +0200, LABBE Corentin wrote:
> The Security System is a hardware cryptographic accelerator that support
> AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> It could be found on many Allwinner SoC.
>=20
> This patch enable the Security System on the Allwinner A20 SoC Device-tre=
e.
>=20
> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index fdd1817..27b5701 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -679,6 +679,14 @@
>  			status =3D "disabled";
>  		};
> =20
> +		crypto: crypto-engine@01c15000 {
> +			compatible =3D "allwinner,sun7i-a20-crypto";
> +			reg =3D <0x01c15000 0x1000>;
> +			interrupts =3D <0 86 4>;

Please use the GIC's define here.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVLP8XAAoJEBx+YmzsjxAgGwsP/0v/0/HiIXQCFSvLMjitp4nn
3WK8HExsPIk0XVyRMHSsc2sJ7KyIdnENTDbIyXQ0bcfeo1Eh5Jq36QpFpE5WMCzj
ZJaRcbXYCs16dhXS01HeIFXxtOSV0otDycNuuDh31Y018KNDP2K74gZHwiQQXrIa
SfkVSc9NChQ+KHJD0btThmNwqERqYsFSC7jRGeYcALLbZGuZ2xUxalV6eerKPQqN
7ILK3ueUJDOhYe8zTnGYo6Fa191tr2sQ1yOKVITLLE6zMp3oDPlEzkA1TsXB2Vlj
CPqAI5zzYBYun1iQpeRuqqsL8aUk/B186AvUBG3eFDLjjobS+hyK19t5W/wUYMp0
eAuEG8IPxT+oveGabDfoiR1q0Nr/Bp/3lqoxbUqjREz7htfOEvIZoV+qX6Z/XAm4
pLbmjPkHPZiZKnklLVVx7aulmnV5IWmP5lXtS+rydz0Tk2WImB47MytbBw0W8IoY
cDRCoRlqTNAXvHAGyX4HSzHh2PPOrfuKz5fr3ChD3dE9HMeXWpW9m+9mC9BHTYuY
Tpuw4ONeQ5Cqpv9U8dbGEfqG2qoRRalX3V0nhnOMjr+vEB/AIBU1uOvaWDyxzCZM
Qc7ftmRRo3TS//gtEgKGccoVjcJLdG2kaRNmjNXaQJ6DqbBXZPvcdgSv1lkMDxDl
eoD/BFL7SG7+2KuwU1AG
=xmsO
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
