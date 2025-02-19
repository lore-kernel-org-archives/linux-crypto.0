Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA997214A73;
	Wed, 19 Feb 2025 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739990887; cv=none; b=aelPUdm+CZ7COUm7Kx0BgJ+W5pTyVIjt5FeiGLKJVuSAvDqIdvvQa93C65DkuR/KyEDqe4xvy5rwWn6BYi5xlIOUTxK2ZP24gryelRRENcnyw0imdctQI0t9niz6PrL+gcb66BNCLW8Lt28LsT+hi20KnNhmJugqt5zfV8kSpUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739990887; c=relaxed/simple;
	bh=jTRT9sRs1feag0TsJMyT+H3VLuwGKl4/WGWUSbb5QzY=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hGEhME0erj5l+fwQw7O/df5D9oblKFVQw0hwm+CV/wn/1EV80ZxTLiKSDEiWrvHzSem/YPJNLBOmY9G+Df0osOetmSTDI6bmiYo2xskrbI8FLxdtpzIcT1zTnsVIQ7jIBe6M85WDUlumtRd2wQM5HKZcfpGCNlcLaPosCUwoeGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ZSngVkVt; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ZSngVkVt"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 51JIlxJx1901483
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 12:47:59 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1739990879;
	bh=9eC/m6gR8EQFlC+NiWtCR6k5N3/28z787tR15wvZnOI=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=ZSngVkVtp1bcevY4sge9WRBvJ5cfeqi2bRvraLRg8bi6VEg2CNRAm/drMjRWQrMZp
	 kAiP2iTTEURW3hI47/S0N+JGzGPA7/DM67QiWwvJdMqGHwIHR3GPHmJnoubc2dJcAC
	 /dacx9dv0GTw0g2P7q+plMBlJLS1xCmwdm0jT1qA=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 51JIlxef008180
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Feb 2025 12:47:59 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 19
 Feb 2025 12:47:58 -0600
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 19 Feb 2025 12:47:59 -0600
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 51JIlwHZ016265;
	Wed, 19 Feb 2025 12:47:58 -0600
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, T Pratham <t-pratham@ti.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Vignesh
 Raghavendra" <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 2/2] crypto: ti: Add support for MD5 in DTHE V2
 Hashing Engine driver
In-Reply-To: <20250218104943.2304730-3-t-pratham@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-3-t-pratham@ti.com>
Date: Thu, 20 Feb 2025 00:17:57 +0530
Message-ID: <87o6yx6aaq.fsf@kamlesh.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

T Pratham <t-pratham@ti.com> writes:

> Add support for MD5 algorithm of the hashing engine of DTHE V2 crypto
> accelerator driver.
>
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  drivers/crypto/ti/Kconfig  |  1 +
>  drivers/crypto/ti/dthev2.c | 56 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
>
> diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
> index 39d9d8cb6b78..ab4da73dffc4 100644
> --- a/drivers/crypto/ti/Kconfig
> +++ b/drivers/crypto/ti/Kconfig
> @@ -6,6 +6,7 @@ config CRYPTO_DEV_TI_DTHE_V2
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_SHA256
>  	select CRYPTO_SHA512
> +	select CRYPTO_MD5
>  	help
>  	  This enables support for the TI DTHE V2 hw crypto accelerator
>  	  which can be found on TI K3 SOCs. Selecting this enables use
> diff --git a/drivers/crypto/ti/dthev2.c b/drivers/crypto/ti/dthev2.c
> index d5ed0f4621f5..ff2d5ef47c2a 100644
> --- a/drivers/crypto/ti/dthev2.c
> +++ b/drivers/crypto/ti/dthev2.c
> @@ -25,6 +25,7 @@
>  #include <crypto/internal/aead.h>
>  #include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
> +#include <crypto/md5.h>
>  #include <crypto/sha2.h>
>  
>  #include <linux/delay.h>
> @@ -363,6 +364,25 @@ static int dthe_sha224_cra_init(struct crypto_tfm *tfm)
>  	return 0;
>  }
>  
> +static int dthe_md5_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
> +
> +	if (!dev_data)
> +		return -ENODEV;
> +
> +	ctx->ctx_info.hash_ctx = kzalloc(sizeof(*ctx->ctx_info.hash_ctx), GFP_KERNEL);
> +	if (!ctx->ctx_info.hash_ctx)
> +		return -ENOMEM;
> +
> +	ctx->ctx_info.hash_ctx->mode = DTHE_HASH_MD5;
> +	ctx->ctx_info.hash_ctx->block_size = MD5_BLOCK_WORDS * 4;
Assign a meaningful macro
> +	ctx->ctx_info.hash_ctx->digest_size = MD5_DIGEST_SIZE;
> +	ctx->ctx_info.hash_ctx->phash_size = MD5_DIGEST_SIZE;
> +	return 0;
> +}
> +
>  static void dthe_hash_cra_exit(struct crypto_tfm *tfm)
>  {
>  	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> @@ -602,6 +622,8 @@ static int dthe_hash_update(struct ahash_request *req)
>  				memcpy(sctx->phash, sha256_zero_message_hash, sctx->digest_size);
>  			else if (sctx->mode == DTHE_HASH_SHA224)
>  				memcpy(sctx->phash, sha224_zero_message_hash, sctx->digest_size);
> +			else if (sctx->mode == DTHE_HASH_MD5)
> +				memcpy(sctx->phash, md5_zero_message_hash, sctx->digest_size);
>  		}
>  
>  		return 0;
> @@ -736,6 +758,8 @@ static int dthe_hash_final(struct ahash_request *req)
>  			memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
>  		else if (sctx->mode == DTHE_HASH_SHA224)
>  			memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
> +		else if (sctx->mode == DTHE_HASH_MD5)
> +			memcpy(req->result, md5_zero_message_hash, sctx->digest_size);
>  	}
>  
>  	memcpy(req->result, sctx->phash, sctx->digest_size);
> @@ -774,6 +798,8 @@ static int dthe_hash_finup(struct ahash_request *req)
>  				memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
>  			else if (sctx->mode == DTHE_HASH_SHA224)
>  				memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
> +			else if (sctx->mode == DTHE_HASH_MD5)
> +				memcpy(req->result, md5_zero_message_hash, sctx->digest_size);
>  		}
>  		return 0;
>  	}
> @@ -870,6 +896,8 @@ static int dthe_hash_digest(struct ahash_request *req)
>  			memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
>  		else if (sctx->mode == DTHE_HASH_SHA224)
>  			memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
> +		else if (sctx->mode == DTHE_HASH_MD5)
> +			memcpy(req->result, md5_zero_message_hash,
>  	sctx->digest_size);
Better to use Switch as it will give more readability and
mainitainability. As number of cases are 5 with this patch, both will
probably give same performance.

Kamlesh

>  		return 0;
>  	}
>  
> @@ -1366,6 +1394,34 @@ static struct ahash_alg hash_algs[] = {
>  			}
>  		}
>  	},
> +	{
> +		.init	= dthe_hash_init,
> +		.update	= dthe_hash_update,
> +		.final	= dthe_hash_final,
> +		.finup	= dthe_hash_finup,
> +		.digest	= dthe_hash_digest,
> +		.export = dthe_hash_export,
> +		.import = dthe_hash_import,
> +		.halg	= {
> +			.digestsize = MD5_DIGEST_SIZE,
> +			.statesize = sizeof(struct dthe_hash_ctx),
> +			.base = {
> +				.cra_name	 = "md5",
> +				.cra_driver_name = "md5-dthe_v2",
> +				.cra_priority	 = 400,
> +				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
> +						   CRYPTO_ALG_ASYNC |
> +						   CRYPTO_ALG_OPTIONAL_KEY |
> +						   CRYPTO_ALG_KERN_DRIVER_ONLY |
> +						   CRYPTO_ALG_ALLOCATES_MEMORY,
> +				.cra_blocksize	 = MD5_BLOCK_WORDS * 4,
> +				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
> +				.cra_module	 = THIS_MODULE,
> +				.cra_init	 = dthe_md5_cra_init,
> +				.cra_exit	 = dthe_hash_cra_exit,
> +			}
> +		}
> +	},
>  };
>  
>  static struct skcipher_alg cipher_algs[] = {
> -- 
> 2.34.1
