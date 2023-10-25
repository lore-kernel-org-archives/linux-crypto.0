Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FCAC25B47
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjJYNP7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbjJYNP6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:15:58 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60771B5
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:15:54 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4083f61312eso45983235e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698239753; x=1698844553; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cV1PUHJZjuWLXGMUIbBqZOhzu0saUfvOrAWTEIJ/hMU=;
        b=Uvhb5hONJdomhOqxyHGXGd45WeN7xVzYsp6PxdKeT3kBWR5950yEMw+kGeojnZo2rq
         HrnXrPqkfzZVZ/RDFAkKRKjcD1VgxCh3gQ2+LIwBLOMjK0IS89bTzU/WCvPnZVYdteyv
         n0TV0jOiB2th6h0x+lxyhyiabwI1wdkM26nI4Ur+WdzISKfhXQeDvqSh1FdESjgBRImN
         AV8j3X3xizOke7wmoi/pGhnLnqvLZYsBfAqozYF0UbPU8Kq5x5PPw0UvHObmF5YB0TNF
         jDOBdimjoY0G8OnALn5+BF2fH1oHJDpQdOgaj1ZRuyU5hOMvRNhS/qbflw/ALu9JYQVp
         J6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239753; x=1698844553;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cV1PUHJZjuWLXGMUIbBqZOhzu0saUfvOrAWTEIJ/hMU=;
        b=lz+HrU9iNXQ795kI++0ba/atZ7CHyHiBKmf2BSq+wqDx7ZwDNwB70HUTPjZ64+u5Ck
         DVsV4wde6KPQGhTYA/y1F0UD56325lopJC4v+Qe/7bSNB0JJSedKdDEDfTCk+sRHCnPE
         y/3VEfEUYCNBN4h5IISvL50wVGOWp5UztLC0ACifEpP4X4txmeY1zK0b49kDlvCpjgFm
         RmMoH8LgzH1d+9m1KYWqXn6A7DndbXVyk6G7G/K+dgif5/nLsWx2kk4l/J1n+mnJQyve
         uaL1dMS4yns3GGyKadBlcpwqPpsUouo8cSKcs4dexd1YfIV8I6uDnVkwTbnh/s967O6R
         l7SA==
X-Gm-Message-State: AOJu0YxVAIJYo0yHw6zKcovCwJo/abSFXSyioAzssm+4++bhG01j0w/l
        GHMSqhXPdZ2Fi1tE27bA3tA=
X-Google-Smtp-Source: AGHT+IEkdxnwGvTxRvrPYVrUBKxR+k4gN+wCD8ewY84WVda7Q6rVO8Qv1ZHwJEOq1BXVdvEfupdIng==
X-Received: by 2002:a5d:6892:0:b0:32d:8b21:40fc with SMTP id h18-20020a5d6892000000b0032d8b2140fcmr12008724wru.9.1698239752799;
        Wed, 25 Oct 2023 06:15:52 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id t14-20020a5d534e000000b0032710f5584fsm12023765wrv.25.2023.10.25.06.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:15:52 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:15:51 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 02/30] crypto: sun4i-ss - remove unnecessary alignmask
 for ahashes
Message-ID: <ZTkVB8KLSQFu7TxN@Red>
References: <20231022081100.123613-1-ebiggers@kernel.org>
 <20231022081100.123613-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231022081100.123613-3-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Sun, Oct 22, 2023 at 01:10:32AM -0700, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> The crypto API's support for alignmasks for ahash algorithms is nearly
> useless, as its only effect is to cause the API to align the key and
> result buffers.  The drivers that happen to be specifying an alignmask
> for ahash rarely actually need it.  When they do, it's easily fixable,
> especially considering that these buffers cannot be used for DMA.
> 
> In preparation for removing alignmask support from ahash, this patch
> makes the sun4i-ss driver no longer use it.  This driver didn't actually
> rely on it; it only writes to the result buffer in sun4i_hash(), already
> using the unaligned access helpers.  And this driver only supports
> unkeyed hash algorithms, so the key buffer need not be considered.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> index 3bcfcfc370842..e23a020a64628 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> @@ -42,21 +42,20 @@ static struct sun4i_ss_alg_template ss_algs[] = {
>  		.digest = sun4i_hash_digest,
>  		.export = sun4i_hash_export_md5,
>  		.import = sun4i_hash_import_md5,
>  		.halg = {
>  			.digestsize = MD5_DIGEST_SIZE,
>  			.statesize = sizeof(struct md5_state),
>  			.base = {
>  				.cra_name = "md5",
>  				.cra_driver_name = "md5-sun4i-ss",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
>  				.cra_module = THIS_MODULE,
>  				.cra_init = sun4i_hash_crainit,
>  				.cra_exit = sun4i_hash_craexit,
>  			}
>  		}
>  	}
>  },
>  {       .type = CRYPTO_ALG_TYPE_AHASH,
> @@ -69,21 +68,20 @@ static struct sun4i_ss_alg_template ss_algs[] = {
>  		.digest = sun4i_hash_digest,
>  		.export = sun4i_hash_export_sha1,
>  		.import = sun4i_hash_import_sha1,
>  		.halg = {
>  			.digestsize = SHA1_DIGEST_SIZE,
>  			.statesize = sizeof(struct sha1_state),
>  			.base = {
>  				.cra_name = "sha1",
>  				.cra_driver_name = "sha1-sun4i-ss",
>  				.cra_priority = 300,
> -				.cra_alignmask = 3,
>  				.cra_blocksize = SHA1_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
>  				.cra_module = THIS_MODULE,
>  				.cra_init = sun4i_hash_crainit,
>  				.cra_exit = sun4i_hash_craexit,
>  			}
>  		}
>  	}
>  },
>  {       .type = CRYPTO_ALG_TYPE_SKCIPHER,
> -- 
> 2.42.0
> 
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
