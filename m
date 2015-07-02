From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 06/10] crypto: omap-aes: gcm: Handle inputs properly
Date: Thu, 2 Jul 2015 03:04:55 -0500
Message-ID: <20150702080455.GF4033@saruman.tx.rr.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-7-git-send-email-lokeshvutla@ti.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lIrNkN/7tmsD/ALM"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43041 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbbGBIFF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 04:05:05 -0400
Content-Disposition: inline
In-Reply-To: <1435814320-30347-7-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--lIrNkN/7tmsD/ALM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2015 at 10:48:36AM +0530, Lokesh Vutla wrote:
> Its not necessary that assoc data and plain text is passed always.
> Add these checks before processing the input.
>=20
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

why can't this be combined with patch which added GCM in the first
place ?

> ---
>  drivers/crypto/omap-aes-gcm.c |   26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
> index 1be9d91..72815af 100644
> --- a/drivers/crypto/omap-aes-gcm.c
> +++ b/drivers/crypto/omap-aes-gcm.c
> @@ -87,7 +87,7 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_de=
v *dd,
>  				     struct aead_request *req)
>  {
>  	void *buf_in;
> -	int alen, clen;
> +	int alen, clen, nsg;
>  	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
>  	unsigned int authlen =3D crypto_aead_authsize(aead);
>  	u32 dec =3D !(dd->flags & FLAGS_ENCRYPT);
> @@ -97,12 +97,18 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_=
dev *dd,
> =20
>  	dd->sgs_copied =3D 0;
> =20
> -	sg_init_table(dd->in_sgl, 2);
> -	buf_in =3D sg_virt(req->assoc);
> -	sg_set_buf(dd->in_sgl, buf_in, alen);
> +	nsg =3D 1 + !!(req->assoclen && req->cryptlen);
> =20
> -	buf_in =3D sg_virt(req->src);
> -	sg_set_buf(&dd->in_sgl[1], buf_in, clen);
> +	sg_init_table(dd->in_sgl, nsg);
> +	if (req->assoclen) {
> +		buf_in =3D sg_virt(req->assoc);
> +		sg_set_buf(dd->in_sgl, buf_in, alen);
> +	}
> +
> +	if (req->cryptlen) {
> +		buf_in =3D sg_virt(req->src);
> +		sg_set_buf(&dd->in_sgl[nsg - 1], buf_in, clen);
> +	}
> =20
>  	dd->in_sg =3D dd->in_sgl;
>  	dd->total =3D clen;
> @@ -258,6 +264,8 @@ static int omap_aes_gcm_crypt(struct aead_request *re=
q, unsigned long mode)
>  {
>  	struct omap_aes_ctx *ctx =3D crypto_aead_ctx(crypto_aead_reqtfm(req));
>  	struct omap_aes_reqctx *rctx =3D aead_request_ctx(req);
> +	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
> +	unsigned int authlen =3D crypto_aead_authsize(aead);
>  	struct omap_aes_dev *dd;
>  	__be32 counter =3D cpu_to_be32(1);
>  	int err;
> @@ -270,6 +278,12 @@ static int omap_aes_gcm_crypt(struct aead_request *r=
eq, unsigned long mode)
>  	if (err)
>  		return err;
> =20
> +	if (req->assoclen + req->cryptlen =3D=3D 0) {
> +		scatterwalk_map_and_copy(ctx->auth_tag, req->dst, 0, authlen,
> +					 1);
> +		return 0;
> +	}
> +
>  	dd =3D omap_aes_find_dev(ctx);
>  	if (!dd)
>  		return -ENODEV;
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--lIrNkN/7tmsD/ALM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVlPCnAAoJEIaOsuA1yqREKVUP/25BDA+Uq5d3h9KQMMh0D7qW
kIABxpNwlXWrTtOsM5ZpMQOSnhZAv/i9/44SWo3goLuPuPU63dWM28GVEMRLSgi+
MYKnrzqhDvwMY0R65Xiw9IDttHW/Xs78krfN458g14OKC7CMVcWshHNCn3JFk7j/
ZKlzkvbclR6mHkwi7fUmOyqsJnXMNh/3bdt58H2bEP3ALQzSefuTooe+6dJKMR6t
SRRYQrd3jZggKTP3bFNozhtEKRqp/0N2EkUwS97Uih7JcP2tgVCEzCbzg2tjwmzJ
5BjAw0Xe6V5yKbkrmggO/i+wggbg5gZKBFjwqyHnAhCGbjr70vaSyhKFRMr+l4T+
xPD3tl+hFyBto1UMnupHAu5jZpw2Sxd8haaASXehYlI4qUkqUR+FyoYdLui3E/3y
5jzgW+PHFU1vq2ESD959cNmjU8mtNR/EikDSwtFCrwOWYMDxptXCmqVm9tYpiAW6
SFMjYHhrLfnQY9YF33FsfVQp4Z2R5mbYtJPTzAiGlnRkAIaCF1IAtrlGPzghI6yB
OigVXSAfafxxISqCpvghNl+V4Dn1UU7nK1ZK9WbZcaFmT/QZsHvE47blkSOFW55L
aZ2a479dG/xgRSJlBAASUKdgMcL2TR5r2GFdnlXdpksJVYo1NrpZ3VPbKi0wPDHh
UCIXsO3QyXIX1G4Hw55Z
=IGyL
-----END PGP SIGNATURE-----

--lIrNkN/7tmsD/ALM--
