Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B119C0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjJYNQQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbjJYNQP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:16:15 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E2A116
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:16:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-40806e40fccso41276085e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698239771; x=1698844571; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZXCwd45Q7fpvglPRQknCe9BKp9NhHrIU/jzIDcWS7Ds=;
        b=llc/Rrb9vaKIXpm73hbXnUs7+5SVbRyQIiesaS8vhDHzKHSgcS3+e68Ym39OtH1My5
         boQxttkUUYIZRt+/59YIU/o8YqrSyHWldo9dTkgzUOSBOOTogZVqcp59DznjIDA38kn7
         zTTq6z8KP4H80W5GjVRu3Vn3DNG8Zm4d0oYImGsEiWypqJWQk3aJlvkk4mvp5iC8hyG9
         ZErdmSnJ8siPT4jfd5LJOsTM/2eJ52GxFxy/XTmBi78xWVyYyQdHQsm73cPI+H33JMcf
         U3om5AuP7MN1aB3rzMth1o21hjb7ThoAHbwBjk6IsZCO9N6yfRaeUWoJIRlBiWuLQ58N
         gPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239771; x=1698844571;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXCwd45Q7fpvglPRQknCe9BKp9NhHrIU/jzIDcWS7Ds=;
        b=nudgxQQBYZIJ+0IhZtu70eymPVwijR7dd88bL8aX7JN3R9cukzef/GB8INnWYBo18G
         wTr4rbtVjJLRGeqwa8fWUHv1YbqnvkAILc+icfV55xv7OCHMPaoxeCjpwLF8e4ZMqzGP
         lF8ujGLiABoG9/BMtq+QpIF6eLKrTQ2jTKY5AS26dOdS24tiNlNOoPqkHJkG3EgcnxBh
         MIE8zUlkpgYSsiTmRrGe2L5PghVK85kJu6MXgv99QNQRVJHesUtJJUwSZnEs9B4YR/cR
         oPvPy17vy34nD78YMEM4HDJFl5IpNPGciFdTgwJ/F9QJayi6kZHaIfDetBBLfk5YnIlJ
         MsYg==
X-Gm-Message-State: AOJu0YyMKjHdVmp+CIPhIPrR0G/Fjh+8fdIDNlQdi923Z3hYjJDgYUTT
        ikg0CD3WetDuKBBp4s0NSkKgQMAtaG8=
X-Google-Smtp-Source: AGHT+IFAleq4AW+ld7qHgQnSFpgwYqVJcDYE+DeGrSDm5/FcuC1As4gAOuSZyM+a+/QwclgqQAgPEg==
X-Received: by 2002:a05:600c:4593:b0:401:b504:b6a0 with SMTP id r19-20020a05600c459300b00401b504b6a0mr12119486wmo.3.1698239770917;
        Wed, 25 Oct 2023 06:16:10 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id n11-20020adffe0b000000b0032dbf26e7aesm12004874wrr.65.2023.10.25.06.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:16:10 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:16:09 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 03/30] crypto: sun8i-ce - remove unnecessary alignmask
 for ahashes
Message-ID: <ZTkVGT31dIBDvyPl@Red>
References: <20231022081100.123613-1-ebiggers@kernel.org>
 <20231022081100.123613-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231022081100.123613-4-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Sun, Oct 22, 2023 at 01:10:33AM -0700, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> The crypto API's support for alignmasks for ahash algorithms is nearly
> useless, as its only effect is to cause the API to align the key and
> result buffers.  The drivers that happen to be specifying an alignmask
> for ahash rarely actually need it.  When they do, it's easily fixable,
> especially considering that these buffers cannot be used for DMA.
> 
> In preparation for removing alignmask support from ahash, this patch
> makes the sun8i-ce driver no longer use it.  This driver didn't actually
> rely on it; it only writes to the result buffer in sun8i_ce_hash_run(),
> simply using memcpy().  And this driver only supports unkeyed hash
> algorithms, so the key buffer need not be considered.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index d4ccd5254280b..4362e60905b09 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -407,21 +407,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
>  		.import = sun8i_ce_hash_import,
>  		.init_tfm = sun8i_ce_hash_init_tfm,
>  		.exit_tfm = sun8i_ce_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = MD5_DIGEST_SIZE,
>  			.statesize = sizeof(struct md5_state),
>  			.base = {
>  				.cra_name = "md5",
>  				.cra_driver_name = "md5-sun8i-ce",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -441,21 +440,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
>  		.import = sun8i_ce_hash_import,
>  		.init_tfm = sun8i_ce_hash_init_tfm,
>  		.exit_tfm = sun8i_ce_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA1_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha1_state),
>  			.base = {
>  				.cra_name = "sha1",
>  				.cra_driver_name = "sha1-sun8i-ce",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA1_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -474,21 +472,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
>  		.import = sun8i_ce_hash_import,
>  		.init_tfm = sun8i_ce_hash_init_tfm,
>  		.exit_tfm = sun8i_ce_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA224_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha256_state),
>  			.base = {
>  				.cra_name = "sha224",
>  				.cra_driver_name = "sha224-sun8i-ce",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA224_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -507,21 +504,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
>  		.import = sun8i_ce_hash_import,
>  		.init_tfm = sun8i_ce_hash_init_tfm,
>  		.exit_tfm = sun8i_ce_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA256_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha256_state),
>  			.base = {
>  				.cra_name = "sha256",
>  				.cra_driver_name = "sha256-sun8i-ce",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA256_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -540,21 +536,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
>  		.import = sun8i_ce_hash_import,
>  		.init_tfm = sun8i_ce_hash_init_tfm,
>  		.exit_tfm = sun8i_ce_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA384_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha512_state),
>  			.base = {
>  				.cra_name = "sha384",
>  				.cra_driver_name = "sha384-sun8i-ce",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA384_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
>  				.cra_module = THIS_MODULE,
>  			}
>  		}
>  	},
>  	.alg.hash.op = {
> @@ -573,21 +568,20 @@ static struct sun8i_ce_alg_template ce_algs[] = {
>  		.import = sun8i_ce_hash_import,
>  		.init_tfm = sun8i_ce_hash_init_tfm,
>  		.exit_tfm = sun8i_ce_hash_exit_tfm,
>  		.halg = {
>  			.digestsize = SHA512_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha512_state),
>  			.base = {
>  				.cra_name = "sha512",
>  				.cra_driver_name = "sha512-sun8i-ce",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
>  					CRYPTO_ALG_ASYNC |
>  					CRYPTO_ALG_NEED_FALLBACK,
>  				.cra_blocksize = SHA512_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
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
