Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A721C07545
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbjJYNQi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjJYNQh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:16:37 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28248131
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:16:35 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c50cf61f6dso87107011fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698239793; x=1698844593; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vjGsenftuNIg5rcrPO+zKEsmN7KPAaFnmuqNgVGfHTg=;
        b=K5jsTwx3fnjuMR417Cc+UbvisZ6zUKV/M966yQH+L4+IIFpB4no3v94dLBwy/DbLaB
         pImepWBOzPf593kS0NIDq6N1S+MgWg6J1KQyRluutjkCtPg64w1QaDLyPnFNz5YlowHu
         uhGNYCDmJzanckCKlKw7IlMNgn3TjBGwZC3tUtMldHt8zCVbJdq6UZiQ9A9VzbbE7pPi
         wQDxscFTKy80XqMWzWwTSouh4/qYJzAwjZyMlQJKOGZghCiSE3bYTgIa0mb7KYZ7VBXX
         JyFti4wrzTRob0Q4YV6IvobFDcUVeootU0MtKIHcw+fDqeEKPVy1JxVV/Ol9w0iooQh/
         hI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239793; x=1698844593;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vjGsenftuNIg5rcrPO+zKEsmN7KPAaFnmuqNgVGfHTg=;
        b=OKBkbIXv4gBJa0Ki3j2fWrxdfjrsEZwNLoPM74sfzGq7R/Yc9vDHoKION5P9rRcgCE
         xeUHQLDYCPgdofs82UD17/CyrgXJ5ybiRmF+5KQsEfwRxTRAFBqnatJMe9gx95WcbgjK
         y7KPsHJuSbxhOPf8xYzCssPjDKMQU49MsRjFYiwp4m28PKSKVbaXPjXJ+Q6WMbvHB4C/
         qGnxff5zVB8Y6BqfmMxx5eImmrJrkNeUS/6PFZHlgMt/gCFPZxFdsmNFu1N8Ykx/bBQW
         FN5rH38G4S79Anp0SQC0ZDkhsy1/8xckISFii3e6beIvSmXlvTWKDz/Cp/9SSprS2qfb
         qTtA==
X-Gm-Message-State: AOJu0YzY+fP6HQtHpcQEwhdElB18z0RfW/7GWW4f61LPchB6FG8vDuN0
        9ccubEEikiIxUmk7XOY2gso=
X-Google-Smtp-Source: AGHT+IG7endd6XysYFsPtu5CzYEFOw2YHDGPBuiaMqnikpq0IRB5TikPaLs9r63gdriiTd30HeQueA==
X-Received: by 2002:a2e:86c7:0:b0:2c5:1602:53f6 with SMTP id n7-20020a2e86c7000000b002c5160253f6mr10526014ljj.34.1698239793152;
        Wed, 25 Oct 2023 06:16:33 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id l8-20020a05600c1d0800b0040531f5c51asm14814596wms.5.2023.10.25.06.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:16:32 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:16:31 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 04/30] crypto: sun8i-ss - remove unnecessary alignmask
 for ahashes
Message-ID: <ZTkVLxc_bqw1jiT2@Red>
References: <20231022081100.123613-1-ebiggers@kernel.org>
 <20231022081100.123613-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231022081100.123613-5-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Sun, Oct 22, 2023 at 01:10:34AM -0700, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> The crypto API's support for alignmasks for ahash algorithms is nearly
> useless, as its only effect is to cause the API to align the key and
> result buffers.  The drivers that happen to be specifying an alignmask
> for ahash rarely actually need it.  When they do, it's easily fixable,
> especially considering that these buffers cannot be used for DMA.
> 
> In preparation for removing alignmask support from ahash, this patch
> makes the sun8i-ss driver no longer use it.  This driver didn't actually
> rely on it; it only writes to the result buffer in sun8i_ss_hash_run(),
> simply using memcpy().  And sun8i_ss_hmac_setkey() does not assume any
> alignment for the key buffer.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> index 4a9587285c04f..2532d2abc4f7e 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> @@ -315,21 +315,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
>  		.import = sun8i_ss_hash_import,
>  		.init_tfm = sun8i_ss_hash_init_tfm,
>  		.exit_tfm = sun8i_ss_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = MD5_DIGEST_SIZE,
>  			.statesize = sizeof(struct md5_state),
>  			.base = {
>  				.cra_name = "md5",
>  				.cra_driver_name = "md5-sun8i-ss",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -348,21 +347,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
>  		.import = sun8i_ss_hash_import,
>  		.init_tfm = sun8i_ss_hash_init_tfm,
>  		.exit_tfm = sun8i_ss_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA1_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha1_state),
>  			.base = {
>  				.cra_name = "sha1",
>  				.cra_driver_name = "sha1-sun8i-ss",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA1_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -381,21 +379,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
>  		.import = sun8i_ss_hash_import,
>  		.init_tfm = sun8i_ss_hash_init_tfm,
>  		.exit_tfm = sun8i_ss_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA224_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha256_state),
>  			.base = {
>  				.cra_name = "sha224",
>  				.cra_driver_name = "sha224-sun8i-ss",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA224_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -414,21 +411,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
>  		.import = sun8i_ss_hash_import,
>  		.init_tfm = sun8i_ss_hash_init_tfm,
>  		.exit_tfm = sun8i_ss_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA256_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha256_state),
>  			.base = {
>  				.cra_name = "sha256",
>  				.cra_driver_name = "sha256-sun8i-ss",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA256_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -448,21 +444,20 @@ static struct sun8i_ss_alg_template ss_algs[] = {
>  		.init_tfm = sun8i_ss_hash_init_tfm,
>  		.exit_tfm = sun8i_ss_hash_exit_tfm,
>  		.setkey = sun8i_ss_hmac_setkey,
>  		.halg = {
>  			.digestsize = SHA1_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha1_state),
>  			.base = {
>  				.cra_name = "hmac(sha1)",
>  				.cra_driver_name = "hmac-sha1-sun8i-ss",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA1_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> -- 
> 2.42.0
> 
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
