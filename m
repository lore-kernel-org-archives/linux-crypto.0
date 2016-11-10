From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH 10/16] crypto: testmgr - Do not test internal algorithms
Date: Thu, 10 Nov 2016 09:32:33 -0200
Message-ID: <20161110113233.GE16556@gallifrey>
References: <20161101231648.GA15967@gondor.apana.org.au>
 <E1c1iKm-0004DQ-A4@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="maH1Gajj2nflutpK"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33776 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755040AbcKJLcj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2016 06:32:39 -0500
Received: by mail-qk0-f178.google.com with SMTP id x190so289857975qkb.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2016 03:32:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <E1c1iKm-0004DQ-A4@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--maH1Gajj2nflutpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I tested this patch and it's working fine.

--=20
Regards,
Marcelo

On Wed, Nov 02, 2016 at 07:19:12AM +0800, Herbert Xu wrote:
> Currently we manually filter out internal algorithms using a list
> in testmgr.  This is dangerous as internal algorithms cannot be
> safely used even by testmgr.  This patch ensures that they're never
> processed by testmgr at all.
>=20
> This patch also removes an obsolete bypass for nivciphers which
> no longer exist.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>=20
>  crypto/algboss.c |    8 --
>  crypto/testmgr.c |  153 +++---------------------------------------------=
-------
>  2 files changed, 11 insertions(+), 150 deletions(-)
>=20
> diff --git a/crypto/algboss.c b/crypto/algboss.c
> index 6e39d9c..ccb85e1 100644
> --- a/crypto/algboss.c
> +++ b/crypto/algboss.c
> @@ -247,12 +247,8 @@ static int cryptomgr_schedule_test(struct crypto_alg=
 *alg)
>  	memcpy(param->alg, alg->cra_name, sizeof(param->alg));
>  	type =3D alg->cra_flags;
> =20
> -	/* This piece of crap needs to disappear into per-type test hooks. */
> -	if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
> -	      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
> -	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D
> -	     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
> -					 alg->cra_ablkcipher.ivsize))
> +	/* Do not test internal algorithms. */
> +	if (type & CRYPTO_ALG_INTERNAL)
>  		type |=3D CRYPTO_ALG_TESTED;
> =20
>  	param->type =3D type;
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index ded50b6..6ac4696 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1625,7 +1625,7 @@ static int alg_test_aead(const struct alg_test_desc=
 *desc, const char *driver,
>  	struct crypto_aead *tfm;
>  	int err =3D 0;
> =20
> -	tfm =3D crypto_alloc_aead(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	tfm =3D crypto_alloc_aead(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
>  		       "%ld\n", driver, PTR_ERR(tfm));
> @@ -1654,7 +1654,7 @@ static int alg_test_cipher(const struct alg_test_de=
sc *desc,
>  	struct crypto_cipher *tfm;
>  	int err =3D 0;
> =20
> -	tfm =3D crypto_alloc_cipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	tfm =3D crypto_alloc_cipher(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		printk(KERN_ERR "alg: cipher: Failed to load transform for "
>  		       "%s: %ld\n", driver, PTR_ERR(tfm));
> @@ -1683,7 +1683,7 @@ static int alg_test_skcipher(const struct alg_test_=
desc *desc,
>  	struct crypto_skcipher *tfm;
>  	int err =3D 0;
> =20
> -	tfm =3D crypto_alloc_skcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	tfm =3D crypto_alloc_skcipher(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
>  		       "%s: %ld\n", driver, PTR_ERR(tfm));
> @@ -1750,7 +1750,7 @@ static int alg_test_hash(const struct alg_test_desc=
 *desc, const char *driver,
>  	struct crypto_ahash *tfm;
>  	int err;
> =20
> -	tfm =3D crypto_alloc_ahash(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	tfm =3D crypto_alloc_ahash(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
>  		       "%ld\n", driver, PTR_ERR(tfm));
> @@ -1778,7 +1778,7 @@ static int alg_test_crc32c(const struct alg_test_de=
sc *desc,
>  	if (err)
>  		goto out;
> =20
> -	tfm =3D crypto_alloc_shash(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	tfm =3D crypto_alloc_shash(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
>  		       "%ld\n", driver, PTR_ERR(tfm));
> @@ -1820,7 +1820,7 @@ static int alg_test_cprng(const struct alg_test_des=
c *desc, const char *driver,
>  	struct crypto_rng *rng;
>  	int err;
> =20
> -	rng =3D crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	rng =3D crypto_alloc_rng(driver, type, mask);
>  	if (IS_ERR(rng)) {
>  		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
>  		       "%ld\n", driver, PTR_ERR(rng));
> @@ -1847,7 +1847,7 @@ static int drbg_cavs_test(struct drbg_testvec *test=
, int pr,
>  	if (!buf)
>  		return -ENOMEM;
> =20
> -	drng =3D crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	drng =3D crypto_alloc_rng(driver, type, mask);
>  	if (IS_ERR(drng)) {
>  		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
>  		       "%s\n", driver);
> @@ -2041,7 +2041,7 @@ static int alg_test_kpp(const struct alg_test_desc =
*desc, const char *driver,
>  	struct crypto_kpp *tfm;
>  	int err =3D 0;
> =20
> -	tfm =3D crypto_alloc_kpp(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	tfm =3D crypto_alloc_kpp(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		pr_err("alg: kpp: Failed to load tfm for %s: %ld\n",
>  		       driver, PTR_ERR(tfm));
> @@ -2200,7 +2200,7 @@ static int alg_test_akcipher(const struct alg_test_=
desc *desc,
>  	struct crypto_akcipher *tfm;
>  	int err =3D 0;
> =20
> -	tfm =3D crypto_alloc_akcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
> +	tfm =3D crypto_alloc_akcipher(driver, type, mask);
>  	if (IS_ERR(tfm)) {
>  		pr_err("alg: akcipher: Failed to load tfm for %s: %ld\n",
>  		       driver, PTR_ERR(tfm));
> @@ -2223,88 +2223,6 @@ static int alg_test_null(const struct alg_test_des=
c *desc,
>  /* Please keep this list sorted by algorithm name. */
>  static const struct alg_test_desc alg_test_descs[] =3D {
>  	{
> -		.alg =3D "__cbc-cast5-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__cbc-cast6-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__cbc-serpent-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__cbc-serpent-avx2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__cbc-serpent-sse2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__cbc-twofish-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-aes-aesni",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
> -		.alg =3D "__driver-cbc-camellia-aesni",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-camellia-aesni-avx2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-cast5-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-cast6-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-serpent-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-serpent-avx2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-serpent-sse2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-cbc-twofish-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-aes-aesni",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
> -		.alg =3D "__driver-ecb-camellia-aesni",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-camellia-aesni-avx2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-cast5-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-cast6-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-serpent-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-serpent-avx2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-serpent-sse2",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-ecb-twofish-avx",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "__driver-gcm-aes-aesni",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
> -		.alg =3D "__ghash-pclmulqdqni",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
>  		.alg =3D "ansi_cprng",
>  		.test =3D alg_test_cprng,
>  		.suite =3D {
> @@ -2791,55 +2709,6 @@ static int alg_test_null(const struct alg_test_des=
c *desc,
>  			}
>  		}
>  	}, {
> -		.alg =3D "cryptd(__driver-cbc-aes-aesni)",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
> -		.alg =3D "cryptd(__driver-cbc-camellia-aesni)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-cbc-camellia-aesni-avx2)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-cbc-serpent-avx2)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-aes-aesni)",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-camellia-aesni)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-camellia-aesni-avx2)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-cast5-avx)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-cast6-avx)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-serpent-avx)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-serpent-avx2)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-serpent-sse2)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-ecb-twofish-avx)",
> -		.test =3D alg_test_null,
> -	}, {
> -		.alg =3D "cryptd(__driver-gcm-aes-aesni)",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
> -		.alg =3D "cryptd(__ghash-pclmulqdqni)",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
>  		.alg =3D "ctr(aes)",
>  		.test =3D alg_test_skcipher,
>  		.fips_allowed =3D 1,
> @@ -3166,10 +3035,6 @@ static int alg_test_null(const struct alg_test_des=
c *desc,
>  		.fips_allowed =3D 1,
>  		.test =3D alg_test_null,
>  	}, {
> -		.alg =3D "ecb(__aes-aesni)",
> -		.test =3D alg_test_null,
> -		.fips_allowed =3D 1,
> -	}, {
>  		.alg =3D "ecb(aes)",
>  		.test =3D alg_test_skcipher,
>  		.fips_allowed =3D 1,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--maH1Gajj2nflutpK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYJFrRAAoJEM8aS8c01e1HcrwH+wWpRi3Lmzz9zuIRJBryXJb1
yXFblPIWr2v35WOSIkoF6gnknfmLt9bdpFyXq8/YkO5lnVTI3GxUvAzxX1sYpwS6
W/QSzwZL+GnqRMoe1S3QpN1/Q80wkk8mSUrk9YjZ477jGrMDSv7fVsTGnRq7+WUg
lUMBsVRDjVsBnCDj7I9Zjnu6qyWjfDAxfzvJWPNvJWtb6nLLbMQPLjWTbt8/wjh8
pN3X2gEvwOkrPwkcB7F4Q7/7Me2xfjQwQvxd5sUHatcl2dmpChnQ62DvcSI04U+k
ckPEqxjugXFQdTr9dsXuNE9iYh0W+0f/wJJlD998IgretGK+lu7KF7CBtjqXf5U=
=cNa2
-----END PGP SIGNATURE-----

--maH1Gajj2nflutpK--
