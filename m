From: James Hogan <jhogan@kernel.org>
Subject: Re: [PATCH v3 2/3] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Thu, 15 Feb 2018 23:31:45 +0000
Message-ID: <20180215233145.GA16654@saruman>
References: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
 <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
 <20180215222214.GB49445@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Cc: linux-mips@linux-mips.org,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163785AbeBOXbu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 18:31:50 -0500
Content-Disposition: inline
In-Reply-To: <20180215222214.GB49445@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Feb 15, 2018 at 02:22:14PM -0800, Eric Biggers wrote:
> On Fri, Feb 09, 2018 at 10:11:06PM +0000, James Hogan wrote:
> > +static struct shash_alg crc32_alg = {
> > +	.digestsize		=	CHKSUM_DIGEST_SIZE,
> > +	.setkey			=	chksum_setkey,
> > +	.init			=	chksum_init,
> > +	.update			=	chksum_update,
> > +	.final			=	chksum_final,
> > +	.finup			=	chksum_finup,
> > +	.digest			=	chksum_digest,
> > +	.descsize		=	sizeof(struct chksum_desc_ctx),
> > +	.base			=	{
> > +		.cra_name		=	"crc32",
> > +		.cra_driver_name	=	"crc32-mips-hw",
> > +		.cra_priority		=	300,
> > +		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
> > +		.cra_alignmask		=	0,
> > +		.cra_ctxsize		=	sizeof(struct chksum_ctx),
> > +		.cra_module		=	THIS_MODULE,
> > +		.cra_init		=	chksum_cra_init,
> > +	}
> > +};
> > +
> > +
> > +static struct shash_alg crc32c_alg = {
> > +       .digestsize             =       CHKSUM_DIGEST_SIZE,
> > +       .setkey                 =       chksum_setkey,
> > +       .init                   =       chksum_init,
> > +       .update                 =       chksumc_update,
> > +       .final                  =       chksumc_final,
> > +       .finup                  =       chksumc_finup,
> > +       .digest                 =       chksumc_digest,
> > +       .descsize               =       sizeof(struct chksum_desc_ctx),
> > +       .base                   =       {
> > +               .cra_name               =       "crc32c",
> > +               .cra_driver_name        =       "crc32c-mips-hw",
> > +               .cra_priority           =       300,
> > +               .cra_blocksize          =       CHKSUM_BLOCK_SIZE,
> > +               .cra_alignmask          =       0,
> > +               .cra_ctxsize            =       sizeof(struct chksum_ctx),
> > +               .cra_module             =       THIS_MODULE,
> > +               .cra_init               =       chksum_cra_init,
> > +       }
> > +};
>
> Does this actually work on the latest kernel?  Now hash algorithms must have
> CRYPTO_ALG_OPTIONAL_KEY in .cra_flags if they have a .setkey method but don't
> require it to be called, otherwise the crypto API will think it's a keyed hash
> and not allow it to be used without a key.  I had to add this flag to the other
> CRC32 and CRC32C algorithms (commit a208fa8f33031).  One of the CRC32C test
> vectors even doesn't set a key so it should be causing the self-tests to fail
> for "crc32c-mips-hw".  (We should add such a test vector for CRC32 too, though.)

Thanks Eric. It does indeed fail now with:

alg: hash: digest failed on test 1 for crc32c-mips-hw: ret=161

I'll squash in the following change:

diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
index 8d4122f37fa5..7d1d2425746f 100644
--- a/arch/mips/crypto/crc32-mips.c
+++ b/arch/mips/crypto/crc32-mips.c
@@ -284,6 +284,7 @@ static struct shash_alg crc32_alg = {
 		.cra_name		=	"crc32",
 		.cra_driver_name	=	"crc32-mips-hw",
 		.cra_priority		=	300,
+		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
 		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
 		.cra_alignmask		=	0,
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),
@@ -305,6 +306,7 @@ static struct shash_alg crc32c_alg = {
 		.cra_name		=	"crc32c",
 		.cra_driver_name	=	"crc32c-mips-hw",
 		.cra_priority		=	300,
+		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
 		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
 		.cra_alignmask		=	0,
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),

Cheers
James

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlqGGGAACgkQbAtpk944
dnqIQw//bTQTMx7BrgSikOzffHvEjPS+MiyStEnhRNHpa7tApIV5uxeBBRiQJvmd
UMmoTes11+pLzI4Io+i2uncp3d67SSsigNVuO7UpkNs+/R1xXlTugCNB0JA8zrMv
7CjkEiOEskkqg+7U+U/q0qAgpifHfSAYuY/4a44P9RZMejogYovHczcaEqmP2s6t
RHgDnJ1QcYSboWOv15gRFc4EK0kp5NCZj+IL7xoLHM7/vQn1d/0tAhtxb88tw1Ms
amqSWS84PGVcITyY8LQ9uK0T8gGSir+NsaNStVt3giy1krFZFqMrZ3t4/UaF66if
Ctk3kVuVy+fdpuhVkv4+uDwFim6zxMJrfoHFaqERTd7Cvfkfqvgvz6ILMkcVwzsj
OuIg8kzpzx5Xl506rjxs4ot/75eOOH5STSdi2AZsSWT/Ye2VfGr74KXPiOCjGiGt
fHto4mDZDIwRTcYQFonoSmv4m7qDyCoaf+DWhnFROx+EapU1D4sajT7FEg14zomg
g/n212FtzMCPNaWUWGZUMvmwZUGWPi488e4M8nY0+DlKJfh7MzA6AJohYUv7KQQC
u2gB5V+Xo2qoFwXjGhrhFmNnZCbENa7UpPX9gFNmbO/4MYZt6ZbVKvcBrE/kptyz
UWBZ4xfJREmWbowZmcRv0UnXm25SEj2rj6NsTmcbJda9fmlUnWs=
=JNC3
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
