Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCA5C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 805B921775
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dquuv/Vo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgHZNg2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 09:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgHZNgZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 09:36:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6447FC061574
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 06:36:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h15so1817698wrt.12
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 06:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qkwmqsb9KNID3kuoDaGDi9EOhJccN3wgQwnGBmSQOw4=;
        b=Dquuv/Vo7kS5gDZVKUxpsTfJuw8OVOczL99h9XKp66W7hGDoEqT+FsEeLQNhi9NYjK
         hmF58k+rCtuNL2bK7D0MZZ5Nfar/9OTs4VTLpRIY3gaBNJCvO/A9MCp0D5p0O9Kpoy3n
         6SCIj9hXene3CVppJb8RPa+5vKAB+1itsVfNgwBrsl24/Z6j5bXISUVXzP1FQKSzLJM3
         dDrNU/xTBDLCa+mSwG5aQOORDuYKqXowVEwRgUXiTcWh1E/lZuBKx1UYtzssXwIBFZ5x
         KsgmWMh/1htY8IaRsh0sDi40PDXu5nTyVg1xQEoRUqJw0emdQZq0SzBb5ey15dsio8Vz
         rGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qkwmqsb9KNID3kuoDaGDi9EOhJccN3wgQwnGBmSQOw4=;
        b=QnIUjNnaUypFTC33NtsnH7Pq2z8vKHI4HOupqHHXdnfGU3EoSog88dzDSOTrcmsFHt
         iFSB9g1wYI4X2x6Wc/w5+HNm4IMSqzAJJSG5QFndgtvxzFi4LY+0ALxLF63PVtH27Vly
         ycrfdvNAXcVU4ndibO3J+ejxm5qvxZETAfjXsYOJyyPATmb3wEZ+a4DcX7SgkJKjKNMa
         EZPBf1SKE4TBE4JjxY5soWofaGNG8cKcQqDaGc5UHA6d9npzrQI6I4ueZEsuRlRwuCoS
         q7tutL38noH5aCubH0TEO3jJ76zv6Tpg8r7aA9yu4Kbgnj/v84+GhiZ7ki5j5VqeJFdn
         quAg==
X-Gm-Message-State: AOAM533es0EBJtsVdS7p94s569ss0b7ZTQbQd5VLt9txnmY87bhL6SUU
        FF9gXSt2IfWTZTNlFK1GtvM=
X-Google-Smtp-Source: ABdhPJxC3WOPBFAgIgVFrUfz5nsT/43xg1JrVGJbYpERKSpTH0kcnX4zO+TPzUV8fDD34r3q4GGAbQ==
X-Received: by 2002:adf:e9cb:: with SMTP id l11mr11630667wrn.379.1598448984075;
        Wed, 26 Aug 2020 06:36:24 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id f16sm5893730wrw.67.2020.08.26.06.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:36:23 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:36:21 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: sun8i-ce - use kfree_sensitive()
Message-ID: <20200826133621.GC13819@Red>
References: <20200826132537.398778-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826132537.398778-1-efremov@linux.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 26, 2020 at 04:25:37PM +0300, Denis Efremov wrote:
> Use kfree_sensitive() instead of open-coding it.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index b4d5fea27d20..970084463dbb 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -367,8 +367,7 @@ void sun8i_ce_cipher_exit(struct crypto_tfm *tfm)
>  	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
>  
>  	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> +		kfree_sensitive(op->key);
>  	}
>  	crypto_free_skcipher(op->fallback_tfm);
>  	pm_runtime_put_sync_suspend(op->ce->dev);
> @@ -392,8 +391,7 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  		return -EINVAL;
>  	}
>  	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> +		kfree_sensitive(op->key);
>  	}
>  	op->keylen = keylen;
>  	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
> @@ -417,8 +415,7 @@ int sun8i_ce_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  		return err;
>  
>  	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> +		kfree_sensitive(op->key);
>  	}
>  	op->keylen = keylen;
>  	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
> -- 
> 2.26.2
> 

Hello

Same problem than amlogic and sun8i-ss.
Please remove if (op->key)

Regards
