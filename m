Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94197F7FC
	for <linux-crypto@vger.kernel.org>; Fri,  9 May 2025 20:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746823603; cv=none; b=LEffEX953Iik035HUtEVsKUSR5JkbratLzBggEJgm5EtmzcdKFGJ2ba+fNSPtsrVKddFcMiegaERA0B0Dfjfnxg3EuiEJk3x04WXq3GsqLJSuE8QleoLbW+g5DMBat76emfRUABY/E5z0aIWDJSVBa+UMCOwilF9XGGUN+zTquw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746823603; c=relaxed/simple;
	bh=cv5pHOybqOjKOfsjtzjxbJzj5b1KSSa2qmmPORVOZ/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=k809l5f6OkfJa9f9/2Bk/TO4sbt4U6t35jdxBIB+wWDOG6oLMzpiuXq/Q531kIx3gBSdcJp6N/cSoyM3nhZtPnhMgg3yshKHNfRv+PJ4H8XHqD7BFJdGlNlSAun3gr0rNH9VAqkDSoSW8owffnnw+ewaVVOKbIsge46tsVHYZRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RBfGmtIF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBfGmtIF"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so26541375e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 09 May 2025 13:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746823599; x=1747428399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hNr0EXmIyJRRmQcFzLZIXLNrBeAKmeZOt77oa7MbjsE=;
        b=RBfGmtIFXeDNl/FWIZYvfvSkRccec9/eVk12OfAtZHjbZr6uQpwiJ+gXqNsq+HIcVa
         qsodXO48clYW82hNzMsKYGPqgKo3Hvdc3tKNR/HnhVifeczQ8xyw7XXdclHTh13OdSVn
         SiH7jjICQZcjgng1gp96ikAAwnn0j2KJFNHduhyzAgrhRYlk4LypxtSh/TXVXEvaS0r5
         fxaJmocaqoA7iUy7hjsTaT8zNP+ndTPIBzuNlqoWk1JDFGCxA/cw/Aa7ixsrXuif3iiR
         FtErcEGmc+vEEHVb30+LPzU/B4QjNjfjoOMvETJeIKfvD8ASyeyrT0kircRv+D7eWoWf
         fnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746823599; x=1747428399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hNr0EXmIyJRRmQcFzLZIXLNrBeAKmeZOt77oa7MbjsE=;
        b=LaBVUYdaaTbKMTxceWNc4HcMXuBb5ifF/U8Yu044575C2gQrCxkdwiZ2G7eeABYzg+
         /o7CJF1XbJKqJs+NLm84Au1/9od8fj4y1WAR1LxpmZb8U2WGqYJZ+ftkijFN13N0owYv
         M1dO/OLmr5cMShqzPcR77Z8Ci3qtP/Axnb0CJyKstQbxbPJFG/LHiO2/YSz/k3r0Na+O
         2SeU9nTK3Jeu1fBLzFqXKoXRheumvQc5oJucmdTVQyPV86eCZmC8JvZKqkea4oDd3v3o
         AMc5PNbNr1C1y80BXjs1yX4xcRIklrf7+8fVZZhNYgJrBjUp+N7oY1MJq+FYHVW+IfQy
         2EDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuGbWfAU88cH0V9JKzXAwxa19EeA89w5AFfAV82KPosMyBsRN+rLo3wbbPSCr+yhxGcI6Oj9x+Le4vvHo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgi+3fgpV3inQazVN4fpnFVMFnT3bmsyaOt1P7+cEbhzREbEzK
	VV3aa03Z3i/8f9l+p4rSnxbjck40XHQDQDyFKh8VRG7qGpkjUd96
X-Gm-Gg: ASbGncsJfmGBegW0caVfjZ1qgOBzUtJtRDLvPqUDphZDe2ynWwo/Dq4OBda2O3c2yCT
	hK/j6CLqhPRN7K6WRfeJNS7BdNHvpkl1EYJt3BEHCWddz+k3+/F1D4fHF1Gp6oxrXm/kvRCIEoq
	udL6oDBjCSts1iK03I8qVMFvsSZp3z9DnPeRvvWJuFhMWc2wyUrMHjZa6LBLOPlTphdD0VO5LmG
	Fiytjo2ROxSzqvhycgnafK23hwpZFBwOA7e9TXRXfBVQ8rBQvIaOeWeD4S/7th+IdqBAun5xV4+
	Shjn9dpvCGRa+OhzlQTMWpqkmzbiBasxtz43f8B/bTuwnU2hrKscUahtYYn0Ze+d4b7AiUGiWi+
	JxVjXwce1xHW9uGUDCS1Yy787D1SoAeqoCP+uwai1UCkWXhV+Ww4JsjU=
X-Google-Smtp-Source: AGHT+IENF8mcjbuheWSgPIBx06Tguev8VFToke9ZmtS7Gj8OCzIrNUI60Pil3JhSBavFmTSkS7ek3w==
X-Received: by 2002:a05:600c:1da8:b0:43c:fb95:c76f with SMTP id 5b1f17b1804b1-442d6d1f997mr45946205e9.9.1746823598577;
        Fri, 09 May 2025 13:46:38 -0700 (PDT)
Received: from shift.daheim (p200300d5ff34db0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff34:db00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3aeb26sm84117245e9.29.2025.05.09.13.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 13:46:38 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.98.2)
	(envelope-from <chunkeey@gmail.com>)
	id 1uDUZn-00000000LRk-2otA;
	Fri, 09 May 2025 22:46:36 +0200
Message-ID: <40e95c9f-b6a0-4e55-a75a-2f4c1e507910@gmail.com>
Date: Fri, 9 May 2025 22:46:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: crypto4xx - Remove ahash-related code
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <aBhlgbCmoVou4DI6@gondor.apana.org.au>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <aBhlgbCmoVou4DI6@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 9:15 AM, Herbert Xu wrote:
> The hash implementation in crypto4xx has been disabled since 2009.
> As nobody has tried to fix this remove all the dead code.

Yeah, not only that... but it was very incomplete. I still have a patchset
for sha1+sha256 but back in 2019, 2020 when I was fixing aes, there was
basically no application that benifited from using the offload over what
the software crypto functions already provided.

Cheers,
Christian Lamparter

> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>   drivers/crypto/amcc/crypto4xx_alg.c  | 106 ---------------------------
>   drivers/crypto/amcc/crypto4xx_core.c |  43 +----------
>   drivers/crypto/amcc/crypto4xx_core.h |   7 --
>   3 files changed, 1 insertion(+), 155 deletions(-)
> 
> diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
> index 289750f34ccf..38e8a61e9166 100644
> --- a/drivers/crypto/amcc/crypto4xx_alg.c
> +++ b/drivers/crypto/amcc/crypto4xx_alg.c
> @@ -12,9 +12,6 @@
>   #include <linux/interrupt.h>
>   #include <linux/spinlock_types.h>
>   #include <linux/scatterlist.h>
> -#include <linux/crypto.h>
> -#include <linux/hash.h>
> -#include <crypto/internal/hash.h>
>   #include <linux/dma-mapping.h>
>   #include <crypto/algapi.h>
>   #include <crypto/aead.h>
> @@ -602,106 +599,3 @@ int crypto4xx_decrypt_aes_gcm(struct aead_request *req)
>   {
>   	return crypto4xx_crypt_aes_gcm(req, true);
>   }
> -
> -/*
> - * HASH SHA1 Functions
> - */
> -static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
> -				   unsigned int sa_len,
> -				   unsigned char ha,
> -				   unsigned char hm)
> -{
> -	struct crypto_alg *alg = tfm->__crt_alg;
> -	struct crypto4xx_alg *my_alg;
> -	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
> -	struct dynamic_sa_hash160 *sa;
> -	int rc;
> -
> -	my_alg = container_of(__crypto_ahash_alg(alg), struct crypto4xx_alg,
> -			      alg.u.hash);
> -	ctx->dev   = my_alg->dev;
> -
> -	/* Create SA */
> -	if (ctx->sa_in || ctx->sa_out)
> -		crypto4xx_free_sa(ctx);
> -
> -	rc = crypto4xx_alloc_sa(ctx, sa_len);
> -	if (rc)
> -		return rc;
> -
> -	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> -				 sizeof(struct crypto4xx_ctx));
> -	sa = (struct dynamic_sa_hash160 *)ctx->sa_in;
> -	set_dynamic_sa_command_0(&sa->ctrl, SA_SAVE_HASH, SA_NOT_SAVE_IV,
> -				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
> -				 SA_NO_HEADER_PROC, ha, SA_CIPHER_ALG_NULL,
> -				 SA_PAD_TYPE_ZERO, SA_OP_GROUP_BASIC,
> -				 SA_OPCODE_HASH, DIR_INBOUND);
> -	set_dynamic_sa_command_1(&sa->ctrl, 0, SA_HASH_MODE_HASH,
> -				 CRYPTO_FEEDBACK_MODE_NO_FB, SA_EXTENDED_SN_OFF,
> -				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
> -				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
> -				 SA_NOT_COPY_HDR);
> -	/* Need to zero hash digest in SA */
> -	memset(sa->inner_digest, 0, sizeof(sa->inner_digest));
> -	memset(sa->outer_digest, 0, sizeof(sa->outer_digest));
> -
> -	return 0;
> -}
> -
> -int crypto4xx_hash_init(struct ahash_request *req)
> -{
> -	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> -	int ds;
> -	struct dynamic_sa_ctl *sa;
> -
> -	sa = ctx->sa_in;
> -	ds = crypto_ahash_digestsize(
> -			__crypto_ahash_cast(req->base.tfm));
> -	sa->sa_command_0.bf.digest_len = ds >> 2;
> -	sa->sa_command_0.bf.load_hash_state = SA_LOAD_HASH_FROM_SA;
> -
> -	return 0;
> -}
> -
> -int crypto4xx_hash_update(struct ahash_request *req)
> -{
> -	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
> -	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> -	struct scatterlist dst;
> -	unsigned int ds = crypto_ahash_digestsize(ahash);
> -
> -	sg_init_one(&dst, req->result, ds);
> -
> -	return crypto4xx_build_pd(&req->base, ctx, req->src, &dst,
> -				  req->nbytes, NULL, 0, ctx->sa_in,
> -				  ctx->sa_len, 0, NULL);
> -}
> -
> -int crypto4xx_hash_final(struct ahash_request *req)
> -{
> -	return 0;
> -}
> -
> -int crypto4xx_hash_digest(struct ahash_request *req)
> -{
> -	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
> -	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
> -	struct scatterlist dst;
> -	unsigned int ds = crypto_ahash_digestsize(ahash);
> -
> -	sg_init_one(&dst, req->result, ds);
> -
> -	return crypto4xx_build_pd(&req->base, ctx, req->src, &dst,
> -				  req->nbytes, NULL, 0, ctx->sa_in,
> -				  ctx->sa_len, 0, NULL);
> -}
> -
> -/*
> - * SHA1 Algorithm
> - */
> -int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm)
> -{
> -	return crypto4xx_hash_alg_init(tfm, SA_HASH160_LEN, SA_HASH_ALG_SHA1,
> -				       SA_HASH_MODE_HASH);
> -}
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index c77d06ddb1ec..8cdc66d520c9 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -485,18 +485,6 @@ static void crypto4xx_copy_pkt_to_dst(struct crypto4xx_device *dev,
>   	}
>   }
>   
> -static void crypto4xx_copy_digest_to_dst(void *dst,
> -					struct pd_uinfo *pd_uinfo,
> -					struct crypto4xx_ctx *ctx)
> -{
> -	struct dynamic_sa_ctl *sa = (struct dynamic_sa_ctl *) ctx->sa_in;
> -
> -	if (sa->sa_command_0.bf.hash_alg == SA_HASH_ALG_SHA1) {
> -		memcpy(dst, pd_uinfo->sr_va->save_digest,
> -		       SA_HASH_ALG_SHA1_DIGEST_SIZE);
> -	}
> -}
> -
>   static void crypto4xx_ret_sg_desc(struct crypto4xx_device *dev,
>   				  struct pd_uinfo *pd_uinfo)
>   {
> @@ -549,23 +537,6 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
>   	skcipher_request_complete(req, 0);
>   }
>   
> -static void crypto4xx_ahash_done(struct crypto4xx_device *dev,
> -				struct pd_uinfo *pd_uinfo)
> -{
> -	struct crypto4xx_ctx *ctx;
> -	struct ahash_request *ahash_req;
> -
> -	ahash_req = ahash_request_cast(pd_uinfo->async_req);
> -	ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(ahash_req));
> -
> -	crypto4xx_copy_digest_to_dst(ahash_req->result, pd_uinfo, ctx);
> -	crypto4xx_ret_sg_desc(dev, pd_uinfo);
> -
> -	if (pd_uinfo->state & PD_ENTRY_BUSY)
> -		ahash_request_complete(ahash_req, -EINPROGRESS);
> -	ahash_request_complete(ahash_req, 0);
> -}
> -
>   static void crypto4xx_aead_done(struct crypto4xx_device *dev,
>   				struct pd_uinfo *pd_uinfo,
>   				struct ce_pd *pd)
> @@ -642,9 +613,6 @@ static void crypto4xx_pd_done(struct crypto4xx_device *dev, u32 idx)
>   	case CRYPTO_ALG_TYPE_AEAD:
>   		crypto4xx_aead_done(dev, pd_uinfo, pd);
>   		break;
> -	case CRYPTO_ALG_TYPE_AHASH:
> -		crypto4xx_ahash_done(dev, pd_uinfo);
> -		break;
>   	}
>   }
>   
> @@ -912,8 +880,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
>   	}
>   
>   	pd->pd_ctl.w = PD_CTL_HOST_READY |
> -		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) ||
> -		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> +		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>   			PD_CTL_HASH_FINAL : 0);
>   	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
>   	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
> @@ -1019,10 +986,6 @@ static int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
>   			rc = crypto_register_aead(&alg->alg.u.aead);
>   			break;
>   
> -		case CRYPTO_ALG_TYPE_AHASH:
> -			rc = crypto_register_ahash(&alg->alg.u.hash);
> -			break;
> -
>   		case CRYPTO_ALG_TYPE_RNG:
>   			rc = crypto_register_rng(&alg->alg.u.rng);
>   			break;
> @@ -1048,10 +1011,6 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
>   	list_for_each_entry_safe(alg, tmp, &sec_dev->alg_list, entry) {
>   		list_del(&alg->entry);
>   		switch (alg->alg.type) {
> -		case CRYPTO_ALG_TYPE_AHASH:
> -			crypto_unregister_ahash(&alg->alg.u.hash);
> -			break;
> -
>   		case CRYPTO_ALG_TYPE_AEAD:
>   			crypto_unregister_aead(&alg->alg.u.aead);
>   			break;
> diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
> index 9c56c7ac6e4c..ee36630c670f 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.h
> +++ b/drivers/crypto/amcc/crypto4xx_core.h
> @@ -16,7 +16,6 @@
>   #include <linux/ratelimit.h>
>   #include <linux/mutex.h>
>   #include <linux/scatterlist.h>
> -#include <crypto/internal/hash.h>
>   #include <crypto/internal/aead.h>
>   #include <crypto/internal/rng.h>
>   #include <crypto/internal/skcipher.h>
> @@ -135,7 +134,6 @@ struct crypto4xx_alg_common {
>   	u32 type;
>   	union {
>   		struct skcipher_alg cipher;
> -		struct ahash_alg hash;
>   		struct aead_alg aead;
>   		struct rng_alg rng;
>   	} u;
> @@ -183,11 +181,6 @@ int crypto4xx_encrypt_noiv_block(struct skcipher_request *req);
>   int crypto4xx_decrypt_noiv_block(struct skcipher_request *req);
>   int crypto4xx_rfc3686_encrypt(struct skcipher_request *req);
>   int crypto4xx_rfc3686_decrypt(struct skcipher_request *req);
> -int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
> -int crypto4xx_hash_digest(struct ahash_request *req);
> -int crypto4xx_hash_final(struct ahash_request *req);
> -int crypto4xx_hash_update(struct ahash_request *req);
> -int crypto4xx_hash_init(struct ahash_request *req);
>   
>   /*
>    * Note: Only use this function to copy items that is word aligned.

