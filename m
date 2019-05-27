Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43521C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66DC2217F4
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 15:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="FTDLo57N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfE0PHZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 11:07:25 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:19411 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfE0PHY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 11:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1558969639;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=HDbz2s/GC0HU6ryOJE7XNrs5CHsl0E6flUFDZ87ZtYE=;
        b=FTDLo57Nvayzugq75wuCMq/LGRx7UmFleNEtdsA9ekvm3MbeE6EwQ122TjRlr9MMoV
        HJyZC+VXAK9SUpUKtj5HzB3nCVynxocyIRgnXOICABxYMA4J/1HYnmCbB7S4Dja839ME
        mrEl2QygSX3387cM5/Fp52X2/d2h2pgNxChTrs2heFjjfTe0HGl0yZbjTbyALS8XSRPR
        nDbRBdN2w8yhxnCJCFFUkgy+hA6740y6ax5Gg5ctTa053hsrrvweyGuZhzGH01W+xP9B
        1+Jxdfa60wpi+E+MvX3xnyI4DrCz5OEGpPMlQ6kixGSIkjlgjIGFUYYwGJ3UlDZOACcE
        lXpQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvSfTerW"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv4RF6sioy
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 27 May 2019 17:06:54 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
Subject: Re: [PATCH] crypto: xxhash - Implement xxhash support
Date:   Mon, 27 May 2019 17:06:53 +0200
Message-ID: <1582734.iyJbpUVI2p@tauon.chronox.de>
In-Reply-To: <20190527142810.31472-1-nborisov@suse.com>
References: <20190527142810.31472-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 27. Mai 2019, 16:28:10 CEST schrieb Nikolay Borisov:

Hi Nikolay,

> xxhash is currently implemented as a self-contained module in /lib.
> This patch enables that module to be used as part of the generic kernel
> crypto framework. It adds a simple wrapper to the 64bit version. I've
> also added a couple of simplistic test vectors to ensure I haven't
> screwed up anything doing the plumbing.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  crypto/Kconfig          |   8 +++
>  crypto/Makefile         |   1 +
>  crypto/testmgr.c        |   7 +++
>  crypto/testmgr.h        |  26 ++++++++++
>  crypto/xxhash_generic.c | 112 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 154 insertions(+)
>  create mode 100644 crypto/xxhash_generic.c
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index bbab6bf33519..c56cc450ffc0 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -665,6 +665,14 @@ config CRYPTO_CRC32_MIPS
>  	  instructions, when available.
> 
> 
> +config CRYPTO_XXHASH
> +	tristate "xxHash hash algorithm"
> +	select CRYPTO_HASH
> +	select XXHASH
> +	help
> +	  xxHash non-cryptographic hash algorithm. Extremely fast, working at
> +	  speeds close to RAM limits.
> +
>  config CRYPTO_CRCT10DIF
>  	tristate "CRCT10DIF algorithm"
>  	select CRYPTO_HASH
> diff --git a/crypto/Makefile b/crypto/Makefile
> index fb5bf2a3a666..4dc6c45d026e 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -135,6 +135,7 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
>  obj-$(CONFIG_CRYPTO_RNG2) += rng.o
>  obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
>  obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
> +obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o

Cosmetic question: why is the hash object added inbetween the block of RNG 
objects?

>  obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
>  CFLAGS_jitterentropy.o = -O0
>  jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 8386038d67c7..322e906b6b6a 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3879,6 +3879,13 @@ static const struct alg_test_desc alg_test_descs[] =
> { .alg = "xts512(paes)",
>  		.test = alg_test_null,
>  		.fips_allowed = 1,
> +	}, {
> +		.alg = "xxhash64",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,

Why is this intended to be allowed in FIPS mode? This does not seem to be a 
FIPS approved cipher.

> +		.suite = {
> +			.hash = __VECS(xxhash64_tv_template)
> +		}
>  	}, {
>  		.alg = "zlib-deflate",
>  		.test = alg_test_comp,
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index d18a37629f05..8e0a9385ee5d 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -33218,6 +33218,32 @@ static const struct hash_testvec
> crc32c_tv_template[] = { }
>  };
> 
> +static const struct hash_testvec xxhash64_tv_template[] = {

Could you please add a note where these vectors come from?

> +	{
> +		.psize = 0,
> +		.digest = "\x99\xe9\xd8\x51\x37\xdb\x46\xef",
> +	},
> +	{
> +		.plaintext = "abcdefg",
> +		.psize = 7,
> +		.digest = "\x2d\x82\x02\x29\x0e\x94\x60\x18",
> +	},
> +	{
> +		.plaintext = "0123456789abcdef0123456789abcdef0123456789"
> +			     "abcdef0123456789abcdef",
> +		.psize = 64,
> +		.digest = "\x85\x2f\xfe\x60\x47\xac\xf3\x1a",
> +	},
> +	{
> +		.key = "\xd2\x02\x96\x49\x00\x00\x00\x00",
> +		.ksize = 8,
> +		.plaintext = "0123456789abcdef0123456789abcdef0123456789"
> +			     "abcdef0123456789abcdef",
> +		.psize = 64,
> +		.digest = "\xab\xea\xc2\x48\x1a\x80\x4e\x7b",
> +	},
> +};
> +
>  static const struct comp_testvec lz4_comp_tv_template[] = {
>  	{
>  		.inlen	= 255,
> diff --git a/crypto/xxhash_generic.c b/crypto/xxhash_generic.c
> new file mode 100644
> index 000000000000..aedaabe55d45
> --- /dev/null
> +++ b/crypto/xxhash_generic.c
> @@ -0,0 +1,112 @@

What about adding the license information compliant with SPDX?

> +#include <crypto/internal/hash.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/xxhash.h>
> +
> +#define XXHASH_BLOCK_SIZE	1
> +#define XXHASH64_DIGEST_SIZE	8
> +
> +struct xxhash64_crypto_ctx {
> +	u64 seed;
> +};
> +
> +struct xxhash64_desc_ctx {
> +	struct xxh64_state xxhstate;
> +	u64 seed;
> +};
> +
> +static int xxhash64_init(struct shash_desc *desc)
> +{
> +	struct xxhash64_crypto_ctx *cctx = crypto_shash_ctx(desc->tfm);
> +	struct xxhash64_desc_ctx *dctx = shash_desc_ctx(desc);
> +
> +	dctx->seed = cctx->seed;
> +	xxh64_reset(&dctx->xxhstate, dctx->seed);
> +
> +	return 0;
> +}
> +
> +static int xxhash64_setkey(struct crypto_shash *tfm, const u8 *key,
> +			 unsigned int keylen)
> +{
> +	struct xxhash64_crypto_ctx *ctx = crypto_shash_ctx(tfm);
> +
> +	if (keylen != sizeof(ctx->seed)) {
> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -EINVAL;
> +	}
> +	ctx->seed = *(u64 *)key;
> +	return 0;
> +}
> +
> +static int xxhash64_update(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length)
> +{
> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
> +
> +	xxh64_update(&ctx->xxhstate, data, length);
> +
> +	return 0;
> +}
> +
> +static int xxhash64_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
> +
> +	*(u64 *)out = xxh64_digest(&ctx->xxhstate);
> +
> +	return 0;
> +}
> +
> +static int xxhash64_finup(struct shash_desc *desc, const u8 *data,
> +			unsigned int len, u8 *out)
> +{
> +	xxhash64_update(desc, data, len);
> +	xxhash64_final(desc, out);
> +
> +	return 0;
> +}
> +
> +static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length, u8 *out)
> +{
> +	return xxhash64_finup(desc, data, length, out);
> +}
> +
> +static struct shash_alg alg = {
> +	.digestsize		=	XXHASH64_DIGEST_SIZE,
> +	.setkey			= xxhash64_setkey,
> +	.init		=	xxhash64_init,
> +	.update		=	xxhash64_update,
> +	.final		=	xxhash64_final,
> +	.finup		=	xxhash64_finup,
> +	.digest		=	xxhash64_digest,
> +	.descsize		=	sizeof(struct xxhash64_desc_ctx),
> +	.base			=	{
> +		.cra_name		=	"xxhash64",
> +		.cra_driver_name	=	"xxhash64-generic",
> +		.cra_priority		=	100,
> +		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
> +		.cra_blocksize		=	XXHASH_BLOCK_SIZE,
> +		.cra_ctxsize		=	sizeof(struct 
xxhash64_crypto_ctx),
> +		.cra_module		=	THIS_MODULE,
> +	}
> +};
> +
> +static int __init xxhash_mod_init(void)
> +{
> +	return crypto_register_shash(&alg);
> +}
> +
> +static void __exit xxhash_mod_fini(void)
> +{
> +	crypto_unregister_shash(&alg);
> +}
> +
> +module_init(xxhash_mod_init);
> +module_exit(xxhash_mod_fini);
> +
> +MODULE_AUTHOR("Nikolay Borisov <nborisov@suse.com>");
> +MODULE_DESCRIPTION("xxhash  calculations wrapper for lib/xxhash.c");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_CRYPTO("xxhash-generic");



Ciao
Stephan


