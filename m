Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F7F347514
	for <linux-crypto@vger.kernel.org>; Sat, 30 May 2026 10:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780136463; cv=none; b=sIDxC7god3aMRBfW2IMrBaUbE8jHSo2oXHS7kgjOE8FqZFtNjm3Ht015dbdSHtALE+5zSleAHJStECcKYJH3LoiE551HBFItIdGldJsl2Rr5xpsoM3As8RvDlvr9C3V3LZXj9GPX71kpbY6Z33CDRBjv2ItpHHDE5cMDbfDQWFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780136463; c=relaxed/simple;
	bh=G2H4VNnDUs5XUueZIobtvk1uyhhGiN6Mm5vbC5DlGM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBpf24b1Wnu3aBZEVks0d8s8oB4LjAvUaNYItxlWdSAq8DSERuzXEihrdJfXnzPyqm5UhDmPvGGq+0Ew0brYWDBdoBlfmeiM0Pu84o/TVcCh9+WvpulRGAjZ+HTBTqB26All6KWtHqIXmWKfaY5b5jNuU9xH8igBoSyIwo+F8+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XyPbnE30; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XyPbnE30"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45ee5cdbd28so1609935f8f.1
        for <linux-crypto@vger.kernel.org>; Sat, 30 May 2026 03:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780136460; x=1780741260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/5iL54slSEG9uXbaeaKITPpQk2F01eVqtxgSPAEZYv4=;
        b=XyPbnE308yKf+/W+OJNXG7RZ2ByBWrQx9lJ95q13gQb6Tqd0jsdIMIEpBh/zbXwaC9
         uBMhm2LrFk+BTvgJgE8k/Ga9HzCOlmEi+MAR9uARl1VAdHWmRmvpB5TqJKEQhqGOrvn8
         ozdj+QD48u99Rr5RkobY7xP/35m00fM2Hwn8o2reGIkWRLMo4vX2nz3plc/l6q+az0ym
         RWjNWeHI4ywFslqg520cjGMBWcAg7TqXreloRCmAUgJR03klkauviWPbzlgJlZ3eJ8G/
         J7cLYq9JUxNoUwl/ukv673QmcFNbXYBIJ2B8pg7AAprp8fomiwqDYkRFdfmDKteZp7MD
         lpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780136460; x=1780741260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5iL54slSEG9uXbaeaKITPpQk2F01eVqtxgSPAEZYv4=;
        b=jhgJ2OYGoVAkk/UZd0nQ2cV8M24xElE2mPcqcEWdImF+0Fe+AN+7KO+p7ra6iCZ9pF
         ydnTU000mS21oU2D+4JZmWsM4RYWS9wXSZtsZ8VvUS7yTE9L/AatLaJVTbdlvQMxQ3Xu
         Qy2V5xKzs48nQ+ZaLC8K5pBEiuJZEk4rkInnguX2aRc/EkaUeawGxx+WHX9jh4Cixg7p
         GbX5iNLBezWb5FZhJk7Hc6l1SgGTZp8PD8fZEf34vsxj9Al/t3ZlmdeX8K/7LyzZXLuA
         1te7wJi6fJHlvZ9t55i1TQs/wq5NlTDA1xXqIlJkIWu03UTs/YF7XYcTKiLVBunOJbct
         /I7g==
X-Forwarded-Encrypted: i=1; AFNElJ9za3fJtO0Ktquy0PHRGwY3w7fQozf2sgeZE3KBTIh8l8SLDQteIZBE60qXF924ALhtd4R95RQOKicrmfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YydktnQPVGQQnEeh7ghoUUbcGBhOGlpDKqXTgcOvZvckpOOMlQA
	407XxMMS8wUcgeWTiTWRpss/7IPJM7rsNS6Sscqu61AAKrS8ivpYsnMS
X-Gm-Gg: Acq92OHnn5x4vKbEgqJnQhcbnERph7KxGECS2Ee7vxRp/I0GbynbJ8H5CadlWhqfBrS
	zeUSwxAq47MX6ZRcuCW8Ejf4ldKI6HMBuBOb46hs0F3NVPXUJ1FXofmscmAsb79BQkVp/zHsZ++
	G5B8xj6+SpoExYh58RmvNwnsfqNk2w/bOklxUeJ18lk7409v//I0/vzrjJa4An08PKZZisCcOPi
	jXd33zJcvWChHcYMcGFWHW1J9cK8p1JLJ1Waf28LO1tIEVNUHAIqLVNJP7YV7UvUt0W/Wsi1bjV
	pnw09aDN0rkFE6GvQrT3v23dIJKgHZvjZFMP52jlG/cEbtVVf9gpGnzpWViaSy2h9/q/uzZoJcA
	vxGCTj/5OKKd+pB/PrWTb9Bn5JsXaMLlwZzQO40QGXkZ9k/ksTjObOwwR30DzT9gf0A3gfdY+A3
	rf6AP6kXxBiC4yU8W/OOgh3H3EFAYq+A4ATyOWONMGUs0BDElpA2m/4J+COqV+ftTujK/hAdlSd
	CAO4fmDBQtkBXsxCbHBHwWYxW/1eJvxXKMeDhots4k=
X-Received: by 2002:a05:600c:8b5b:b0:490:9dc3:3483 with SMTP id 5b1f17b1804b1-490a2a02a43mr41843095e9.2.1780136459593;
        Sat, 30 May 2026 03:20:59 -0700 (PDT)
Received: from shift (p200300d5ff07e00050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff07:e000:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c104920sm32015845e9.21.2026.05.30.03.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 03:20:58 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.99.3)
	(envelope-from <chunkeey@gmail.com>)
	id 1wTGjX-000000002mX-1Lcb;
	Sat, 30 May 2026 12:20:57 +0200
Message-ID: <e0b3cfc2-c6da-46d4-9dec-027dafaba74e@gmail.com>
Date: Sat, 30 May 2026 12:20:57 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: crypto4xx - Remove insecure and unused rng_alg
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260529220430.34135-1-ebiggers@kernel.org>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260529220430.34135-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

On 5/30/26 12:04 AM, Eric Biggers wrote:
> Remove crypto4xx_rng, as it is insecure and unused:
> 
> - It has only a 64-bit security strength, which is highly inadequate.
>    This can be seen by the fact that crypto4xx_hw_init() seeds it with
>    only 64 bits of entropy, and the fact that the original commit
>    mentions that it implements ANSI X9.17 Annex C.

Yes, that "ANSI X9.17 Annex C" comes from the datasheet for the PRNG.

>    Another issue was that this driver didn't implement the crypto_rng API
>    correctly, as crypto4xx_prng_generate() didn't return 0 on success.

Oh! Hmm, I think I copied that "return amount;" from another driver that
had it implemented? But I'm not sure, this was sooo long ago. That said,
if this never worked...

> - No user of this code is known.  It's usable only theoretically via the
>    "rng" algorithm type of AF_ALG.  But userspace actually just uses the
>    actual Linux RNG (/dev/random etc) instead.  And rng_algs don't
>    contribute entropy to the actual Linux RNG either.  (This may have
>    been confused with hwrng, which does contribute entropy.)

... and it's completely redundant: Sure!

just in case, this counts for anything, but as the person that added it in the
first place:

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> Fixes: d072bfa48853 ("crypto: crypto4xx - add prng crypto support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   drivers/crypto/Kconfig                  |  1 -
>   drivers/crypto/amcc/crypto4xx_core.c    | 88 -------------------------
>   drivers/crypto/amcc/crypto4xx_core.h    |  4 --
>   drivers/crypto/amcc/crypto4xx_reg_def.h | 11 ----
>   4 files changed, 104 deletions(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 3449b3c9c6ad..5dab813a9f74 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -299,11 +299,10 @@ config CRYPTO_DEV_PPC4XX
>   	select CRYPTO_AES
>   	select CRYPTO_LIB_AES
>   	select CRYPTO_CCM
>   	select CRYPTO_CTR
>   	select CRYPTO_GCM
> -	select CRYPTO_RNG
>   	select CRYPTO_SKCIPHER
>   	help
>   	  This option allows you to have support for AMCC crypto acceleration.
>   
>   config HW_RANDOM_PPC4XX
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index b7b6c97d2147..68c5ff7a85b4 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -29,15 +29,13 @@
>   #include <crypto/aead.h>
>   #include <crypto/aes.h>
>   #include <crypto/ctr.h>
>   #include <crypto/gcm.h>
>   #include <crypto/sha1.h>
> -#include <crypto/rng.h>
>   #include <crypto/scatterwalk.h>
>   #include <crypto/skcipher.h>
>   #include <crypto/internal/aead.h>
> -#include <crypto/internal/rng.h>
>   #include <crypto/internal/skcipher.h>
>   #include "crypto4xx_reg_def.h"
>   #include "crypto4xx_core.h"
>   #include "crypto4xx_sa.h"
>   #include "crypto4xx_trng.h"
> @@ -983,14 +981,10 @@ static int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
>   		switch (alg->alg.type) {
>   		case CRYPTO_ALG_TYPE_AEAD:
>   			rc = crypto_register_aead(&alg->alg.u.aead);
>   			break;
>   
> -		case CRYPTO_ALG_TYPE_RNG:
> -			rc = crypto_register_rng(&alg->alg.u.rng);
> -			break;
> -
>   		default:
>   			rc = crypto_register_skcipher(&alg->alg.u.cipher);
>   			break;
>   		}
>   
> @@ -1012,14 +1006,10 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
>   		switch (alg->alg.type) {
>   		case CRYPTO_ALG_TYPE_AEAD:
>   			crypto_unregister_aead(&alg->alg.u.aead);
>   			break;
>   
> -		case CRYPTO_ALG_TYPE_RNG:
> -			crypto_unregister_rng(&alg->alg.u.rng);
> -			break;
> -
>   		default:
>   			crypto_unregister_skcipher(&alg->alg.u.cipher);
>   		}
>   		kfree(alg);
>   	}
> @@ -1074,73 +1064,10 @@ static irqreturn_t crypto4xx_ce_interrupt_handler_revb(int irq, void *data)
>   {
>   	return crypto4xx_interrupt_handler(irq, data, PPC4XX_INTERRUPT_CLR |
>   		PPC4XX_TMO_ERR_INT);
>   }
>   
> -static int ppc4xx_prng_data_read(struct crypto4xx_device *dev,
> -				 u8 *data, unsigned int max)
> -{
> -	unsigned int i, curr = 0;
> -	u32 val[2];
> -
> -	do {
> -		/* trigger PRN generation */
> -		writel(PPC4XX_PRNG_CTRL_AUTO_EN,
> -		       dev->ce_base + CRYPTO4XX_PRNG_CTRL);
> -
> -		for (i = 0; i < 1024; i++) {
> -			/* usually 19 iterations are enough */
> -			if ((readl(dev->ce_base + CRYPTO4XX_PRNG_STAT) &
> -			     CRYPTO4XX_PRNG_STAT_BUSY))
> -				continue;
> -
> -			val[0] = readl_be(dev->ce_base + CRYPTO4XX_PRNG_RES_0);
> -			val[1] = readl_be(dev->ce_base + CRYPTO4XX_PRNG_RES_1);
> -			break;
> -		}
> -		if (i == 1024)
> -			return -ETIMEDOUT;
> -
> -		if ((max - curr) >= 8) {
> -			memcpy(data, &val, 8);
> -			data += 8;
> -			curr += 8;
> -		} else {
> -			/* copy only remaining bytes */
> -			memcpy(data, &val, max - curr);
> -			break;
> -		}
> -	} while (curr < max);
> -
> -	return curr;
> -}
> -
> -static int crypto4xx_prng_generate(struct crypto_rng *tfm,
> -				   const u8 *src, unsigned int slen,
> -				   u8 *dstn, unsigned int dlen)
> -{
> -	struct rng_alg *alg = crypto_rng_alg(tfm);
> -	struct crypto4xx_alg *amcc_alg;
> -	struct crypto4xx_device *dev;
> -	int ret;
> -
> -	amcc_alg = container_of(alg, struct crypto4xx_alg, alg.u.rng);
> -	dev = amcc_alg->dev;
> -
> -	mutex_lock(&dev->core_dev->rng_lock);
> -	ret = ppc4xx_prng_data_read(dev, dstn, dlen);
> -	mutex_unlock(&dev->core_dev->rng_lock);
> -	return ret;
> -}
> -
> -
> -static int crypto4xx_prng_seed(struct crypto_rng *tfm, const u8 *seed,
> -			unsigned int slen)
> -{
> -	return 0;
> -}
> -
>   /*
>    * Supported Crypto Algorithms
>    */
>   static struct crypto4xx_alg_common crypto4xx_alg[] = {
>   	/* Crypto AES modes */
> @@ -1266,22 +1193,10 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
>   			.cra_blocksize	= 1,
>   			.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
>   			.cra_module	= THIS_MODULE,
>   		},
>   	} },
> -	{ .type = CRYPTO_ALG_TYPE_RNG, .u.rng = {
> -		.base = {
> -			.cra_name		= "stdrng",
> -			.cra_driver_name        = "crypto4xx_rng",
> -			.cra_priority		= 300,
> -			.cra_ctxsize		= 0,
> -			.cra_module		= THIS_MODULE,
> -		},
> -		.generate               = crypto4xx_prng_generate,
> -		.seed                   = crypto4xx_prng_seed,
> -		.seedsize               = 0,
> -	} },
>   };
>   
>   /*
>    * Module Initialization Routine
>    */
> @@ -1351,13 +1266,10 @@ static int crypto4xx_probe(struct platform_device *ofdev)
>   	}
>   
>   	core_dev->dev->core_dev = core_dev;
>   	core_dev->dev->is_revb = is_revb;
>   	core_dev->device = dev;
> -	rc = devm_mutex_init(&ofdev->dev, &core_dev->rng_lock);
> -	if (rc)
> -		return rc;
>   	spin_lock_init(&core_dev->lock);
>   	INIT_LIST_HEAD(&core_dev->dev->alg_list);
>   	ratelimit_default_init(&core_dev->dev->aead_ratelimit);
>   	rc = crypto4xx_build_sdr(core_dev->dev);
>   	if (rc)
> diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
> index ee36630c670f..3a028aec3f0c 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.h
> +++ b/drivers/crypto/amcc/crypto4xx_core.h
> @@ -12,14 +12,12 @@
>   
>   #ifndef __CRYPTO4XX_CORE_H__
>   #define __CRYPTO4XX_CORE_H__
>   
>   #include <linux/ratelimit.h>
> -#include <linux/mutex.h>
>   #include <linux/scatterlist.h>
>   #include <crypto/internal/aead.h>
> -#include <crypto/internal/rng.h>
>   #include <crypto/internal/skcipher.h>
>   #include "crypto4xx_reg_def.h"
>   #include "crypto4xx_sa.h"
>   
>   #define PPC460SX_SDR0_SRST                      0x201
> @@ -109,11 +107,10 @@ struct crypto4xx_core_device {
>   	struct hwrng *trng;
>   	u32 int_status;
>   	u32 irq;
>   	struct tasklet_struct tasklet;
>   	spinlock_t lock;
> -	struct mutex rng_lock;
>   };
>   
>   struct crypto4xx_ctx {
>   	struct crypto4xx_device *dev;
>   	struct dynamic_sa_ctl *sa_in;
> @@ -133,11 +130,10 @@ struct crypto4xx_aead_reqctx {
>   struct crypto4xx_alg_common {
>   	u32 type;
>   	union {
>   		struct skcipher_alg cipher;
>   		struct aead_alg aead;
> -		struct rng_alg rng;
>   	} u;
>   };
>   
>   struct crypto4xx_alg {
>   	struct list_head  entry;
> diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
> index 1038061224da..73d626308a84 100644
> --- a/drivers/crypto/amcc/crypto4xx_reg_def.h
> +++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
> @@ -88,24 +88,13 @@
>   
>   #define CRYPTO4XX_DMA_CFG	        	0x000600d4
>   #define CRYPTO4XX_BYTE_ORDER_CFG 		0x000600d8
>   #define CRYPTO4XX_ENDIAN_CFG			0x000600d8
>   
> -#define CRYPTO4XX_PRNG_STAT			0x00070000
> -#define CRYPTO4XX_PRNG_STAT_BUSY		0x1
>   #define CRYPTO4XX_PRNG_CTRL			0x00070004
>   #define CRYPTO4XX_PRNG_SEED_L			0x00070008
>   #define CRYPTO4XX_PRNG_SEED_H			0x0007000c
> -
> -#define CRYPTO4XX_PRNG_RES_0			0x00070020
> -#define CRYPTO4XX_PRNG_RES_1			0x00070024
> -#define CRYPTO4XX_PRNG_RES_2			0x00070028
> -#define CRYPTO4XX_PRNG_RES_3			0x0007002C
> -
> -#define CRYPTO4XX_PRNG_LFSR_L			0x00070030
> -#define CRYPTO4XX_PRNG_LFSR_H			0x00070034
> -

Hmm, don't think these defines will hurt anyone? As these are part of the hardware spec.
Or do you forsee a future where AI-Agents will sent patches hallucinating that it "fixed"
the issue which readds it? I have no idea.

>   /*
>    * Initialize CRYPTO ENGINE registers, and memory bases.
>    */
>   #define PPC4XX_PDR_POLL				0x3ff
>   #define PPC4XX_OUTPUT_THRESHOLD			2


Cheers,
Christian
