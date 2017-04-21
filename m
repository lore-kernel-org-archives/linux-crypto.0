From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Fri, 21 Apr 2017 11:29:35 +0200
Message-ID: <20170421092935.fszux3qg5hbwwobj@kwain>
References: <20170419071418.18995-1-antoine.tenart@free-electrons.com>
 <20170419071418.18995-3-antoine.tenart@free-electrons.com>
 <20170421073056.GA2041@Red>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rlx4itfg3m2piblj"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        robin.murphy@arm.com, oferh@marvell.com,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:39980 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034199AbdDUJ3u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 05:29:50 -0400
Content-Disposition: inline
In-Reply-To: <20170421073056.GA2041@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--rlx4itfg3m2piblj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Corentin,

On Fri, Apr 21, 2017 at 09:30:56AM +0200, Corentin Labbe wrote:
>=20
> I have some minor comment below

[=E2=80=A6]

> > +	/*
> > +	 * Result Descriptor Ring prepare
> > +	 */
>=20
> This is not preferred comment format for one line

Sure.

>=20
> [...]
>=20
> > +static int safexcel_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev =3D &pdev->dev;
> > +	struct resource *res;
> > +	struct safexcel_crypto_priv *priv;
> > +	int i, ret;
> > +
> > +	priv =3D devm_kzalloc(dev, sizeof(struct safexcel_crypto_priv),
> > +			    GFP_KERNEL);
>=20
> sizeof(priv) is preferred as asked by checkpatch
>=20
> [...]
> > +		ring_irq =3D devm_kzalloc(dev, sizeof(struct safexcel_ring_irq_data),
> > +					GFP_KERNEL);
>=20
> same comment here

Sure.

> [...]
> > +#define EIP197_ALG_ARC4				BIT(7)
> > +#define EIP197_ALG_AES_ECB			BIT(8)
> > +#define EIP197_ALG_AES_CBC			BIT(9)
> > +#define EIP197_ALG_AES_CTR_ICM			BIT(10)
> > +#define EIP197_ALG_AES_OFB			BIT(11)
> > +#define EIP197_ALG_AES_CFB			BIT(12)
> > +#define EIP197_ALG_DES_ECB			BIT(13)
> > +#define EIP197_ALG_DES_CBC			BIT(14)
> > +#define EIP197_ALG_DES_OFB			BIT(16)
> > +#define EIP197_ALG_DES_CFB			BIT(17)
> > +#define EIP197_ALG_3DES_ECB			BIT(18)
> > +#define EIP197_ALG_3DES_CBC			BIT(19)
> > +#define EIP197_ALG_3DES_OFB			BIT(21)
> > +#define EIP197_ALG_3DES_CFB			BIT(22)
> > +#define EIP197_ALG_MD5				BIT(24)
> > +#define EIP197_ALG_HMAC_MD5			BIT(25)
>=20
> Does MD5, DES and 3DES will be added later ?

They might be added yes. And as these bits describe a register used to
configure the engine it's nice to have a proper definition of what all
combinations do.

> [...]
> > +static const u8 sha1_zero_digest[SHA1_DIGEST_SIZE] =3D {
> > +	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d, 0x32, 0x55,
> > +	0xbf, 0xef, 0x95, 0x60, 0x18, 0x90, 0xaf, 0xd8, 0x07, 0x09,
> > +};
> > +
> > +static const u8 sha224_zero_digest[SHA224_DIGEST_SIZE] =3D {
> > +	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47, 0x61,
> > +	0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4, 0x15, 0xa2, 0xb0, 0x1f,
> > +	0x82, 0x8e, 0xa6, 0x2a, 0xc5, 0xb3, 0xe4, 0x2f
> > +};
> > +
> > +static const u8 sha256_zero_digest[SHA256_DIGEST_SIZE] =3D {
> > +	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14, 0x9a, 0xfb,
> > +	0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24, 0x27, 0xae, 0x41, 0xe4,
> > +	0x64, 0x9b, 0x93, 0x4c, 0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52,
> > +	0xb8, 0x55
> > +};
>=20
> Thoses structures are already defined in crypto (sha1_zero_message_hash, =
etc...)
> You can use it since you select SHAxxx in Kconfig

That's right, I'll use these definitions instead.

> [...]
> > +static int safexcel_hmac_init_pad(struct ahash_request *areq,
> > +				  unsigned int blocksize, const u8 *key,
> > +				  unsigned int keylen, u8 *ipad, u8 *opad)
> > +{
> > +	struct safexcel_ahash_result result;
> > +	struct scatterlist sg;
> > +	int ret, i;
> > +	u8 *keydup;
> > +
> > +	if (keylen <=3D blocksize) {
> > +		memcpy(ipad, key, keylen);
> > +	} else {
> > +		keydup =3D kmemdup(key, keylen, GFP_KERNEL);
> > +		if (!keydup)
> > +			return -ENOMEM;
> > +
> > +		ahash_request_set_callback(areq, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +					   safexcel_ahash_complete, &result);
> > +		sg_init_one(&sg, keydup, keylen);
> > +		ahash_request_set_crypt(areq, &sg, ipad, keylen);
> > +		init_completion(&result.completion);
> > +
> > +		ret =3D crypto_ahash_digest(areq);
> > +		if (ret =3D=3D -EINPROGRESS) {
> > +			wait_for_completion_interruptible(&result.completion);
> > +			ret =3D result.error;
> > +		}
> > +
> > +		/* Avoid leaking */
> > +		memset(keydup, 0, keylen);
>=20
> It is safer to use memzero_explicit

Good to know, I'll update.

> > +		kfree(keydup);
> > +
> > +		if (ret)
> > +			return ret;
> > +
> > +		keylen =3D crypto_ahash_digestsize(crypto_ahash_reqtfm(areq));
> > +	}
> > +
> > +	memset(ipad + keylen, 0, blocksize - keylen);
> > +	memcpy(opad, ipad, blocksize);
> > +
> > +	for (i =3D 0; i < blocksize; i++) {
> > +		ipad[i] ^=3D 0x36;
> > +		opad[i] ^=3D 0x5c;
>=20
> What are these constant ?

They are defined in the HMAC RFC, as ipad and opad values. See
https://www.ietf.org/rfc/rfc2104.txt.

> [...]
> > +static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u=
8 *key,
> > +				     unsigned int keylen)
> > +{
> > +	struct safexcel_ahash_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tf=
m));
> > +	struct safexcel_ahash_export_state istate, ostate;
> > +	int ret, i;
> > +
> > +	ret =3D safexcel_hmac_setkey("safexcel-sha1", key, keylen, &istate, &=
ostate);
>=20
> Perhaps you could use the algname instead of "safexcel-sha1"

No we can't (as of now), because using the SHA implementation of this
driver for partial hashes require special treatments (which we do).

> > +	if (ret)
> > +		return ret;
> > +
> > +	memcpy(ctx->ipad, &istate.state, SHA1_DIGEST_SIZE);
> > +	memcpy(ctx->opad, &ostate.state, SHA1_DIGEST_SIZE);
>=20
> Perhaps you could the digest_size from alg_template

Well, this HMAC setkey function is dedicated to SHA1 for other reasons
than only this digest size. So why bother retrieving something which we
know is already fixed?

> [...]
> > +struct safexcel_alg_template safexcel_alg_sha256 =3D {
> > +	.type =3D SAFEXCEL_ALG_TYPE_AHASH,
> > +	.alg.ahash =3D {
> > +		.init =3D safexcel_sha256_init,
> > +		.update =3D safexcel_ahash_update,
> > +		.final =3D safexcel_ahash_final,
> > +		.finup =3D safexcel_ahash_finup,
> > +		.digest =3D safexcel_sha256_digest,
> > +		.export =3D safexcel_ahash_export,
> > +		.import =3D safexcel_ahash_import,
> > +		.halg =3D {
> > +			.digestsize =3D SHA256_DIGEST_SIZE,
> > +			.statesize =3D sizeof(struct safexcel_ahash_export_state),
> > +			.base =3D {
> > +				.cra_name =3D "sha256",
> > +				.cra_driver_name =3D "safexcel-sha256",
> > +				.cra_priority =3D 300,
> > +				.cra_flags =3D CRYPTO_ALG_ASYNC |
> > +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>=20
> Why do use CRYPTO_ALG_KERN_DRIVER_ONLY ?

See http://lxr.free-electrons.com/source/include/linux/crypto.h#L97.

Thanks,
Antoine

--=20
Antoine T=C3=A9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--rlx4itfg3m2piblj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY+dD/AAoJEFxNi8it27zYx4MP/R5eOF8KqzFzkErQpFDtT755
I3xejxbRdOi3yw2zcR+OxkH+Cj0qWcR39IMaKilpt20XQWAtAxVC8zd3a/T328Do
lzlQPUmmNYzYhzJlTDn8/7VBBTXclAAzq5UsaMf+lrM6RqQNee2otd6ruNQ7E8bY
nJColBef47a6QsE2P0i3gXyQD7aCdzPGrGPwj7HMna+TH+n+AnAWADM8y6/+hiAz
KiDy97+mEtHhGW1Na+9llgR0anCMtb4HkNRbHpcmQHxX1gNKt+ZT5uRafE7XCXHg
oMVAkNGjQ1MDcgBqwUeuYPaj0fZImHgKdB5J/Y86urNpUxbG+llTM4upRWL9+4zu
xmoWM8RLKc1cb/W+VPgs5fux6Qu7g5+GIInFNm2r13hQRO0jABb/pNxZWTAxkSq1
iHKfXGZ90VHLRLgd/qWyRbnm6uDynU+cKgrsX89nXC+qiacPMoIvXAPl8FB5Qryd
6dXeXgdwtCDaNVAk5Onnj7AfB2R/gl2sUw/3Ma+TTR6wYqlfldNglTHi/+qqINPt
2UYkVcXv2gQEtVwmFo/h3potSO4AevgAOmat6bZ+06LWUnTTHZF87OYPws3h4dr/
aRkbyLE7l9jAZtchLEPgXOiUyOrynKsaAk8wufvTHbpdNIH0fNPG4LAJTpdmwehR
q9AeMjxG/M/vZNHV6LH4
=rQ7o
-----END PGP SIGNATURE-----

--rlx4itfg3m2piblj--
