From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: obscure state information on free
Date: Thu, 14 Aug 2008 08:21:37 -0400
Message-ID: <20080814122137.GA10969@hmsendeavour.rdu.redhat.com>
References: <20080811202607.GA11527@hmsreliant.think-freely.org> <20080814115137.GA5721@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3071 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbYHNMV7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2008 08:21:59 -0400
Content-Disposition: inline
In-Reply-To: <20080814115137.GA5721@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 14, 2008 at 09:51:38PM +1000, Herbert Xu wrote:
> On Mon, Aug 11, 2008 at 04:26:07PM -0400, Neil Horman wrote:
> > Patch to obscure state information on free in prng code.  Keeps prying eyes from
> > sifting through your trash :)
> 
> Thanks Neil.  I've merged this with the original patch and made
> some small changes on the API side, such as adding a reset helper
> and adding a krng that just uses get_random_bytes.
> 
> Here is the final result against cryptodev-2.6.  Let me know if
> you're OK with it and I'll push it out.
> 
> Cheers,


Looks great to me.  Thanks Herbert!

Best
Neil

> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 776f90d..15823a6 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -38,6 +38,10 @@ config CRYPTO_HASH
>  	tristate
>  	select CRYPTO_ALGAPI
>  
> +config CRYPTO_RNG
> +	tristate
> +	select CRYPTO_ALGAPI
> +
>  config CRYPTO_MANAGER
>  	tristate "Cryptographic algorithm manager"
>  	select CRYPTO_AEAD
> @@ -681,6 +685,18 @@ config CRYPTO_LZO
>  	help
>  	  This is the LZO algorithm.
>  
> +comment "Random Number Generation"
> +
> +config CRYPTO_ANSI_CPRNG
> +	tristate "Pseudo Random Number Generation for Cryptographic modules"
> +	select CRYPTO_AES
> +	select CRYPTO_CTR
> +	select CRYPTO_RNG
> +	help
> +	  This option enables the generic pseudo random number generator
> +	  for cryptographic modules.  Uses the Algorithm specified in
> +	  ANSI X9.31 A.2.4
> +
>  source "drivers/crypto/Kconfig"
>  
>  endif	# if CRYPTO
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 59ab500..a14ed7d 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -24,6 +24,8 @@ obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
>  
>  cryptomgr-objs := algboss.o testmgr.o
>  
> +rng-objs := rngapi.o krng.o
> +
>  obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
>  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
>  obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
> @@ -71,7 +73,8 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
>  obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
>  obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o
>  obj-$(CONFIG_CRYPTO_LZO) += lzo.o
> -
> +obj-$(CONFIG_CRYPTO_RNG) += rng.o
> +obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
>  obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
>  
>  #
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> new file mode 100644
> index 0000000..c20642e
> --- /dev/null
> +++ b/crypto/ansi_cprng.c
> @@ -0,0 +1,417 @@
> +/*
> + * PRNG: Pseudo Random Number Generator
> + *       Based on NIST Recommended PRNG From ANSI X9.31 Appendix A.2.4 using
> + *       AES 128 cipher
> + *
> + *  (C) Neil Horman <nhorman@tuxdriver.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the
> + *  Free Software Foundation; either version 2 of the License, or (at your
> + *  any later version.
> + *
> + *
> + */
> +
> +#include <crypto/internal/rng.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/string.h>
> +
> +#include "internal.h"
> +
> +#define DEFAULT_PRNG_KEY "0123456789abcdef"
> +#define DEFAULT_PRNG_KSZ 16
> +#define DEFAULT_BLK_SZ 16
> +#define DEFAULT_V_SEED "zaybxcwdveuftgsh"
> +
> +/*
> + * Flags for the prng_context flags field
> + */
> +
> +#define PRNG_FIXED_SIZE 0x1
> +#define PRNG_NEED_RESET 0x2
> +
> +/*
> + * Note: DT is our counter value
> + * 	 I is our intermediate value
> + *	 V is our seed vector
> + * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
> + * for implementation details
> + */
> +
> +
> +struct prng_context {
> +	spinlock_t prng_lock;
> +	unsigned char rand_data[DEFAULT_BLK_SZ];
> +	unsigned char last_rand_data[DEFAULT_BLK_SZ];
> +	unsigned char DT[DEFAULT_BLK_SZ];
> +	unsigned char I[DEFAULT_BLK_SZ];
> +	unsigned char V[DEFAULT_BLK_SZ];
> +	u32 rand_data_valid;
> +	struct crypto_cipher *tfm;
> +	u32 flags;
> +};
> +
> +static int dbg;
> +
> +static void hexdump(char *note, unsigned char *buf, unsigned int len)
> +{
> +	if (dbg) {
> +		printk(KERN_CRIT "%s", note);
> +		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
> +				16, 1,
> +				buf, len, false);
> +	}
> +}
> +
> +#define dbgprint(format, args...) do {\
> +if (dbg)\
> +	printk(format, ##args);\
> +} while (0)
> +
> +static void xor_vectors(unsigned char *in1, unsigned char *in2,
> +			unsigned char *out, unsigned int size)
> +{
> +	int i;
> +
> +	for (i = 0; i < size; i++)
> +		out[i] = in1[i] ^ in2[i];
> +
> +}
> +/*
> + * Returns DEFAULT_BLK_SZ bytes of random data per call
> + * returns 0 if generation succeded, <0 if something went wrong
> + */
> +static int _get_more_prng_bytes(struct prng_context *ctx)
> +{
> +	int i;
> +	unsigned char tmp[DEFAULT_BLK_SZ];
> +	unsigned char *output = NULL;
> +
> +
> +	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
> +		ctx);
> +
> +	hexdump("Input DT: ", ctx->DT, DEFAULT_BLK_SZ);
> +	hexdump("Input I: ", ctx->I, DEFAULT_BLK_SZ);
> +	hexdump("Input V: ", ctx->V, DEFAULT_BLK_SZ);
> +
> +	/*
> +	 * This algorithm is a 3 stage state machine
> +	 */
> +	for (i = 0; i < 3; i++) {
> +
> +		switch (i) {
> +		case 0:
> +			/*
> +			 * Start by encrypting the counter value
> +			 * This gives us an intermediate value I
> +			 */
> +			memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
> +			output = ctx->I;
> +			hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
> +			break;
> +		case 1:
> +
> +			/*
> +			 * Next xor I with our secret vector V
> +			 * encrypt that result to obtain our
> +			 * pseudo random data which we output
> +			 */
> +			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
> +			hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
> +			output = ctx->rand_data;
> +			break;
> +		case 2:
> +			/*
> +			 * First check that we didn't produce the same
> +			 * random data that we did last time around through this
> +			 */
> +			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
> +					DEFAULT_BLK_SZ)) {
> +				printk(KERN_ERR
> +					"ctx %p Failed repetition check!\n",
> +					ctx);
> +				ctx->flags |= PRNG_NEED_RESET;
> +				return -EINVAL;
> +			}
> +			memcpy(ctx->last_rand_data, ctx->rand_data,
> +				DEFAULT_BLK_SZ);
> +
> +			/*
> +			 * Lastly xor the random data with I
> +			 * and encrypt that to obtain a new secret vector V
> +			 */
> +			xor_vectors(ctx->rand_data, ctx->I, tmp,
> +				DEFAULT_BLK_SZ);
> +			output = ctx->V;
> +			hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
> +			break;
> +		}
> +
> +
> +		/* do the encryption */
> +		crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
> +
> +	}
> +
> +	/*
> +	 * Now update our DT value
> +	 */
> +	for (i = 0; i < DEFAULT_BLK_SZ; i++) {
> +		ctx->DT[i] += 1;
> +		if (ctx->DT[i] != 0)
> +			break;
> +	}
> +
> +	dbgprint("Returning new block for context %p\n", ctx);
> +	ctx->rand_data_valid = 0;
> +
> +	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
> +	hexdump("Output I: ", ctx->I, DEFAULT_BLK_SZ);
> +	hexdump("Output V: ", ctx->V, DEFAULT_BLK_SZ);
> +	hexdump("New Random Data: ", ctx->rand_data, DEFAULT_BLK_SZ);
> +
> +	return 0;
> +}
> +
> +/* Our exported functions */
> +static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
> +{
> +	unsigned long flags;
> +	unsigned char *ptr = buf;
> +	unsigned int byte_count = (unsigned int)nbytes;
> +	int err;
> +
> +
> +	if (nbytes < 0)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&ctx->prng_lock, flags);
> +
> +	err = -EINVAL;
> +	if (ctx->flags & PRNG_NEED_RESET)
> +		goto done;
> +
> +	/*
> +	 * If the FIXED_SIZE flag is on, only return whole blocks of
> +	 * pseudo random data
> +	 */
> +	err = -EINVAL;
> +	if (ctx->flags & PRNG_FIXED_SIZE) {
> +		if (nbytes < DEFAULT_BLK_SZ)
> +			goto done;
> +		byte_count = DEFAULT_BLK_SZ;
> +	}
> +
> +	err = byte_count;
> +
> +	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
> +		byte_count, ctx);
> +
> +
> +remainder:
> +	if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
> +		if (_get_more_prng_bytes(ctx) < 0) {
> +			memset(buf, 0, nbytes);
> +			err = -EINVAL;
> +			goto done;
> +		}
> +	}
> +
> +	/*
> +	 * Copy up to the next whole block size
> +	 */
> +	if (byte_count < DEFAULT_BLK_SZ) {
> +		for (; ctx->rand_data_valid < DEFAULT_BLK_SZ;
> +			ctx->rand_data_valid++) {
> +			*ptr = ctx->rand_data[ctx->rand_data_valid];
> +			ptr++;
> +			byte_count--;
> +			if (byte_count == 0)
> +				goto done;
> +		}
> +	}
> +
> +	/*
> +	 * Now copy whole blocks
> +	 */
> +	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
> +		if (_get_more_prng_bytes(ctx) < 0) {
> +			memset(buf, 0, nbytes);
> +			err = -EINVAL;
> +			goto done;
> +		}
> +		memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
> +		ctx->rand_data_valid += DEFAULT_BLK_SZ;
> +		ptr += DEFAULT_BLK_SZ;
> +	}
> +
> +	/*
> +	 * Now copy any extra partial data
> +	 */
> +	if (byte_count)
> +		goto remainder;
> +
> +done:
> +	spin_unlock_irqrestore(&ctx->prng_lock, flags);
> +	dbgprint(KERN_CRIT "returning %d from get_prng_bytes in context %p\n",
> +		err, ctx);
> +	return err;
> +}
> +
> +static void free_prng_context(struct prng_context *ctx)
> +{
> +	crypto_free_cipher(ctx->tfm);
> +}
> +
> +static int reset_prng_context(struct prng_context *ctx,
> +			      unsigned char *key, size_t klen,
> +			      unsigned char *V, unsigned char *DT)
> +{
> +	int ret;
> +	int rc = -EINVAL;
> +	unsigned char *prng_key;
> +
> +	spin_lock(&ctx->prng_lock);
> +	ctx->flags |= PRNG_NEED_RESET;
> +
> +	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
> +
> +	if (!key)
> +		klen = DEFAULT_PRNG_KSZ;
> +
> +	if (V)
> +		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
> +	else
> +		memcpy(ctx->V, DEFAULT_V_SEED, DEFAULT_BLK_SZ);
> +
> +	if (DT)
> +		memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
> +	else
> +		memset(ctx->DT, 0, DEFAULT_BLK_SZ);
> +
> +	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
> +	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
> +
> +	if (ctx->tfm)
> +		crypto_free_cipher(ctx->tfm);
> +
> +	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
> +	if (IS_ERR(ctx->tfm)) {
> +		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
> +			ctx);
> +		ctx->tfm = NULL;
> +		goto out;
> +	}
> +
> +	ctx->rand_data_valid = DEFAULT_BLK_SZ;
> +
> +	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
> +	if (ret) {
> +		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
> +			crypto_cipher_get_flags(ctx->tfm));
> +		crypto_free_cipher(ctx->tfm);
> +		goto out;
> +	}
> +
> +	rc = 0;
> +	ctx->flags &= ~PRNG_NEED_RESET;
> +out:
> +	spin_unlock(&ctx->prng_lock);
> +
> +	return rc;
> +
> +}
> +
> +static int cprng_init(struct crypto_tfm *tfm)
> +{
> +	struct prng_context *ctx = crypto_tfm_ctx(tfm);
> +
> +	spin_lock_init(&ctx->prng_lock);
> +
> +	return reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL);
> +}
> +
> +static void cprng_exit(struct crypto_tfm *tfm)
> +{
> +	free_prng_context(crypto_tfm_ctx(tfm));
> +}
> +
> +static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
> +			    unsigned int dlen)
> +{
> +	struct prng_context *prng = crypto_rng_ctx(tfm);
> +
> +	return get_prng_bytes(rdata, dlen, prng);
> +}
> +
> +static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
> +{
> +	struct prng_context *prng = crypto_rng_ctx(tfm);
> +	u8 *key = seed + DEFAULT_PRNG_KSZ;
> +
> +	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
> +		return -EINVAL;
> +
> +	reset_prng_context(prng, key, DEFAULT_PRNG_KSZ, seed, NULL);
> +
> +	if (prng->flags & PRNG_NEED_RESET)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static struct crypto_alg rng_alg = {
> +	.cra_name		= "stdrng",
> +	.cra_driver_name	= "ansi_cprng",
> +	.cra_priority		= 100,
> +	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
> +	.cra_ctxsize		= sizeof(struct prng_context),
> +	.cra_type		= &crypto_rng_type,
> +	.cra_module		= THIS_MODULE,
> +	.cra_list		= LIST_HEAD_INIT(rng_alg.cra_list),
> +	.cra_init		= cprng_init,
> +	.cra_exit		= cprng_exit,
> +	.cra_u			= {
> +		.rng = {
> +			.rng_make_random	= cprng_get_random,
> +			.rng_reset		= cprng_reset,
> +			.seedsize = DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ,
> +		}
> +	}
> +};
> +
> +
> +/* Module initalization */
> +static int __init prng_mod_init(void)
> +{
> +	int ret = 0;
> +
> +	if (fips_enabled)
> +		rng_alg.cra_priority += 200;
> +
> +	ret = crypto_register_alg(&rng_alg);
> +
> +	if (ret)
> +		goto out;
> +out:
> +	return 0;
> +}
> +
> +static void __exit prng_mod_fini(void)
> +{
> +	crypto_unregister_alg(&rng_alg);
> +	return;
> +}
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Software Pseudo Random Number Generator");
> +MODULE_AUTHOR("Neil Horman <nhorman@tuxdriver.com>");
> +module_param(dbg, int, 0);
> +MODULE_PARM_DESC(dbg, "Boolean to enable debugging (0/1 == off/on)");
> +module_init(prng_mod_init);
> +module_exit(prng_mod_fini);
> +MODULE_ALIAS("stdrng");
> diff --git a/crypto/krng.c b/crypto/krng.c
> new file mode 100644
> index 0000000..8ef62a9
> --- /dev/null
> +++ b/crypto/krng.c
> @@ -0,0 +1,66 @@
> +/*
> + * RNG implementation using standard kernel RNG.
> + *
> + * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * any later version.
> + *
> + */
> +
> +#include <crypto/internal/rng.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/random.h>
> +
> +static int krng_get_random(struct crypto_rng *tfm, u8 *rdata, unsigned int dlen)
> +{
> +	get_random_bytes(rdata, dlen);
> +	return 0;
> +}
> +
> +static int krng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
> +{
> +	return 0;
> +}
> +
> +static struct crypto_alg krng_alg = {
> +	.cra_name		= "stdrng",
> +	.cra_driver_name	= "krng",
> +	.cra_priority		= 200,
> +	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
> +	.cra_ctxsize		= 0,
> +	.cra_type		= &crypto_rng_type,
> +	.cra_module		= THIS_MODULE,
> +	.cra_list		= LIST_HEAD_INIT(krng_alg.cra_list),
> +	.cra_u			= {
> +		.rng = {
> +			.rng_make_random	= krng_get_random,
> +			.rng_reset		= krng_reset,
> +			.seedsize		= 0,
> +		}
> +	}
> +};
> +
> +
> +/* Module initalization */
> +static int __init krng_mod_init(void)
> +{
> +	return crypto_register_alg(&krng_alg);
> +}
> +
> +static void __exit krng_mod_fini(void)
> +{
> +	crypto_unregister_alg(&krng_alg);
> +	return;
> +}
> +
> +module_init(krng_mod_init);
> +module_exit(krng_mod_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Random Number Generator API");
> +MODULE_ALIAS("stdrng");
> diff --git a/crypto/rngapi.c b/crypto/rngapi.c
> new file mode 100644
> index 0000000..ea57697
> --- /dev/null
> +++ b/crypto/rngapi.c
> @@ -0,0 +1,74 @@
> +/*
> + * Cryptographic API.
> + *
> + * RNG operations.
> + *
> + * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +
> +#include <crypto/internal/rng.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/random.h>
> +#include <linux/seq_file.h>
> +#include <linux/string.h>
> +
> +static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
> +{
> +	u8 *buf = NULL;
> +	int err;
> +
> +	if (!seed && slen) {
> +		buf = kmalloc(slen, GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;
> +
> +		get_random_bytes(buf, slen);
> +		seed = buf;
> +	}
> +
> +	err = crypto_rng_crt(tfm)->rng_reset(tfm, seed, slen);
> +
> +	kfree(buf);
> +	return err;
> +}
> +
> +static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
> +{
> +	struct rng_alg *alg = &tfm->__crt_alg->cra_rng;
> +	struct rng_tfm *ops = &tfm->crt_rng;
> +
> +	ops->rng_gen_random = alg->rng_make_random;
> +	ops->rng_reset = rngapi_reset;
> +
> +	return 0;
> +}
> +
> +static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
> +	__attribute__ ((unused));
> +static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
> +{
> +	seq_printf(m, "type         : rng\n");
> +	seq_printf(m, "seedsize     : %u\n", alg->cra_rng.seedsize);
> +}
> +
> +static unsigned int crypto_rng_ctxsize(struct crypto_alg *alg, u32 type,
> +				       u32 mask)
> +{
> +	return alg->cra_ctxsize;
> +}
> +
> +const struct crypto_type crypto_rng_type = {
> +	.ctxsize = crypto_rng_ctxsize,
> +	.init = crypto_init_rng_ops,
> +#ifdef CONFIG_PROC_FS
> +	.show = crypto_rng_show,
> +#endif
> +};
> +EXPORT_SYMBOL_GPL(crypto_rng_type);
> diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
> new file mode 100644
> index 0000000..8969733
> --- /dev/null
> +++ b/include/crypto/internal/rng.h
> @@ -0,0 +1,26 @@
> +/*
> + * RNG: Random Number Generator  algorithms under the crypto API
> + *
> + * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +
> +#ifndef _CRYPTO_INTERNAL_RNG_H
> +#define _CRYPTO_INTERNAL_RNG_H
> +
> +#include <crypto/algapi.h>
> +#include <crypto/rng.h>
> +
> +extern const struct crypto_type crypto_rng_type;
> +
> +static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
> +{
> +	return crypto_tfm_ctx(&tfm->base);
> +}
> +
> +#endif
> diff --git a/include/crypto/rng.h b/include/crypto/rng.h
> new file mode 100644
> index 0000000..7a33c63
> --- /dev/null
> +++ b/include/crypto/rng.h
> @@ -0,0 +1,70 @@
> +/*
> + * RNG: Random Number Generator  algorithms under the crypto API
> + *
> + * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +
> +#ifndef _CRYPTO_RNG_H
> +#define _CRYPTO_RNG_H
> +
> +#include <linux/crypto.h>
> +
> +static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
> +{
> +	return (struct crypto_rng *)tfm;
> +}
> +
> +static inline struct crypto_rng *crypto_alloc_rng(const char *alg_name)
> +{
> +	u32 type, mask;
> +
> +	mask = CRYPTO_ALG_TYPE_MASK;
> +	type = CRYPTO_ALG_TYPE_RNG;
> +
> +	return __crypto_rng_cast(crypto_alloc_base(alg_name, type, mask));
> +}
> +
> +static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
> +{
> +	return &tfm->base;
> +}
> +
> +static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
> +{
> +	return &crypto_rng_tfm(tfm)->__crt_alg->cra_rng;
> +}
> +
> +static inline struct rng_tfm *crypto_rng_crt(struct crypto_rng *tfm)
> +{
> +	return &crypto_rng_tfm(tfm)->crt_rng;
> +}
> +
> +static inline void crypto_free_rng(struct crypto_rng *tfm)
> +{
> +	crypto_free_tfm(crypto_rng_tfm(tfm));
> +}
> +
> +static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
> +				       u8 *rdata, unsigned int dlen)
> +{
> +	return crypto_rng_crt(tfm)->rng_gen_random(tfm, rdata, dlen);
> +}
> +
> +static inline int crypto_rng_reset(struct crypto_rng *tfm,
> +				   u8 *seed, unsigned int slen)
> +{
> +	return crypto_rng_crt(tfm)->rng_reset(tfm, seed, slen);
> +}
> +
> +static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
> +{
> +	return crypto_rng_alg(tfm)->seedsize;
> +}
> +
> +#endif
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 81d994a..3d2317e 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -38,6 +38,7 @@
>  #define CRYPTO_ALG_TYPE_DIGEST		0x00000008
>  #define CRYPTO_ALG_TYPE_HASH		0x00000009
>  #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
> +#define CRYPTO_ALG_TYPE_RNG		0x0000000c
>  
>  #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
>  #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
> @@ -113,6 +114,7 @@ struct crypto_aead;
>  struct crypto_blkcipher;
>  struct crypto_hash;
>  struct crypto_ahash;
> +struct crypto_rng;
>  struct crypto_tfm;
>  struct crypto_type;
>  struct aead_givcrypt_request;
> @@ -298,6 +300,15 @@ struct compress_alg {
>  			      unsigned int slen, u8 *dst, unsigned int *dlen);
>  };
>  
> +struct rng_alg {
> +	int (*rng_make_random)(struct crypto_rng *tfm, u8 *rdata,
> +			       unsigned int dlen);
> +	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
> +
> +	unsigned int seedsize;
> +};
> +
> +
>  #define cra_ablkcipher	cra_u.ablkcipher
>  #define cra_aead	cra_u.aead
>  #define cra_blkcipher	cra_u.blkcipher
> @@ -306,6 +317,7 @@ struct compress_alg {
>  #define cra_hash	cra_u.hash
>  #define cra_ahash	cra_u.ahash
>  #define cra_compress	cra_u.compress
> +#define cra_rng		cra_u.rng
>  
>  struct crypto_alg {
>  	struct list_head cra_list;
> @@ -333,6 +345,7 @@ struct crypto_alg {
>  		struct hash_alg hash;
>  		struct ahash_alg ahash;
>  		struct compress_alg compress;
> +		struct rng_alg rng;
>  	} cra_u;
>  
>  	int (*cra_init)(struct crypto_tfm *tfm);
> @@ -438,6 +451,12 @@ struct compress_tfm {
>  	                      u8 *dst, unsigned int *dlen);
>  };
>  
> +struct rng_tfm {
> +	int (*rng_gen_random)(struct crypto_rng *tfm, u8 *rdata,
> +			      unsigned int dlen);
> +	int (*rng_reset)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
> +};
> +
>  #define crt_ablkcipher	crt_u.ablkcipher
>  #define crt_aead	crt_u.aead
>  #define crt_blkcipher	crt_u.blkcipher
> @@ -445,6 +464,7 @@ struct compress_tfm {
>  #define crt_hash	crt_u.hash
>  #define crt_ahash	crt_u.ahash
>  #define crt_compress	crt_u.compress
> +#define crt_rng		crt_u.rng
>  
>  struct crypto_tfm {
>  
> @@ -458,6 +478,7 @@ struct crypto_tfm {
>  		struct hash_tfm hash;
>  		struct ahash_tfm ahash;
>  		struct compress_tfm compress;
> +		struct rng_tfm rng;
>  	} crt_u;
>  	
>  	struct crypto_alg *__crt_alg;
> @@ -489,6 +510,10 @@ struct crypto_hash {
>  	struct crypto_tfm base;
>  };
>  
> +struct crypto_rng {
> +	struct crypto_tfm base;
> +};
> +
>  enum {
>  	CRYPTOA_UNSPEC,
>  	CRYPTOA_ALG,

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
