From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 4/4] hwrng: bcm2835: Read as much data as available
Date: Mon, 23 May 2016 19:21:00 -0700
Message-ID: <87k2ik2o37.fsf@eliezer.anholt.net>
References: <1464020451-16520-1-git-send-email-yendapally.reddy@broadcom.com> <1464020451-16520-5-git-send-email-yendapally.reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: devicetree@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com,
	linux-crypto@vger.kernel.org,
	Yendapally Reddy Dhananjaya Reddy
	<yendapally.reddy@broadcom.com>
To: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Lee Jones <lee@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Jon Mason <jonmason@broadcom.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Pankaj Dev <pankaj.dev@st.com>,
	Richard Weinberger <richard@nod.at>, noltari@gmail.com,
	Joshua Henderson <joshua.henderson@microchip.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464020451-16520-5-git-send-email-yendapally.reddy@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
writes:

> Read the requested number of data from the fifo
>
> Signed-off-by: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadc=
om.com>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_rando=
m/bcm2835-rng.c
> index b1e8b78..9bbdc07 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -43,6 +43,8 @@ static int bcm2835_rng_read(struct hwrng *rng, void *bu=
f, size_t max,
>  			       bool wait)
>  {
>  	void __iomem *rng_base =3D (void __iomem *)rng->priv;
> +	u32 max_words =3D max/sizeof(u32);

Style fix: Binary operators get a space on each side, so
"max / sizeof(u32);"

> @@ -50,8 +52,14 @@ static int bcm2835_rng_read(struct hwrng *rng, void *b=
uf, size_t max,
>  		cpu_relax();
>  	}
>=20=20
> -	*(u32 *)buf =3D __raw_readl(rng_base + RNG_DATA);
> -	return sizeof(u32);
> +	num_words =3D (readl(rng_base + RNG_STATUS) >> 24);

Optional cleanup: here and in the return statement, drop the extra
parenthesis.

Functionality-wise, this patch looks great to me, and should make the
driver more efficient.  With at least the binary operators change done,
it will be:

Reviewed-by: Eric Anholt <eric@anholt.net>

Thanks!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXQ7qNAAoJELXWKTbR/J7oJAoQAJwz5fT/lVxOs8Qt2XRrmVNk
UZFz6J/hqv5h3n+54KR5PZ8bD3xbX4iv26EdLiWmuMjuc/Mpubsv4R9TDtewA5jy
tjDGX9UT97HnMqnZTqIct8RcxONNb2WNwKBQcO5539zWmYNhg6/ifLbSyJ2AxiZv
fQNwx6OWc5iZroujFeIPjWvMUN10MQHfT+JOWOIW82Xm8olZwb2Bx8kpJCgV3taO
cmVGUc3/pu9c6wNMeXd/n0h4evKbHUTM/+pbJIR9Cpt1xIXJ6I0rUxasIaN8WOQH
4BaxLgpFabWm5BfIJ77w9yMd+u2FXjOjKXml248cfJIt5KMCNrv7TecxYYUwHqeD
uFLo77dm0ChBsCaUSPdoe4IlVAZKF/4cEQN3sx+4XJnJRqc49Ok1kUYxw/Vb7lVu
ibNrXtt/8o7AP70zoCzRIbv8VMbR9ZQBWIB5Ydjo+sb2m6/M/H0qRNvuiWP9m6P/
XMBzlreKCMpLJwB8xsX9/UOpLEe21J8VuOgqdLB50+mM6TCcjZ3sysH2Q+E0/QnU
QIxzVyxl480K9bsa+jfY6wp1JxDXWj9a6bSd6Eu+DaeSAQ/m3ghs8l+fdgw9C1zj
vWT2FTYd71WLGAXZoJUIhjDxs8HJcVGkphBNr+pz3pIOL5hkF4j1HP6qbdFcDQc6
+Zx2GR+8YDV5fq1MnY6U
=JoWZ
-----END PGP SIGNATURE-----
--=-=-=--
