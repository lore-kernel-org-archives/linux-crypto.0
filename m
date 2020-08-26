Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D098C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 419C5208E4
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIzcJauX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgHZNYq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 09:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgHZNYp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 09:24:45 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CECC061574;
        Wed, 26 Aug 2020 06:24:44 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k20so1753791wmi.5;
        Wed, 26 Aug 2020 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KzstNuDLEgCqMhPzfbUI0ChLkjuGrPj7EWJxjD5ej3s=;
        b=aIzcJauXxLxWhF6r1s3rboD6nalp/PGjCJWEq3AMaA6EFkGQ/hBCeAf7lArmkCHsla
         G/I26tLIyMHEvT69xDMo6l92lRjaN9chguVZvrI4gfv/nCRo2WgHJxO31tUb43kkVlQ/
         i6+mNrYTcQ069BsfTIOl6YQKfyKZguXzLugN6PZuBYzGpBsBzLHBZcjO0HAWLJzf0wdt
         oUrvJntuevR9sboZRbbAzeNaRhDfzD/k1HOBENl7Wf1k8rz2LpAMVN7cefFSsHkbanBk
         PbPXEm3+ZDkDaOiQWXhO01FkXrrS6ExN5ib5rnDKFOxqj0OQCU0cMkWXozH9vC5GQX7q
         Z1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KzstNuDLEgCqMhPzfbUI0ChLkjuGrPj7EWJxjD5ej3s=;
        b=cHUKmNUtx3G6DFfYhvrz8rCb+u/yugw7NBl5GkJ5IF1NQMspy7C/F/UPswZ1nwtDNO
         ObVbt8jFI1Z/6Xbldu0GzSRAleF/lg+45oT32+l2/Pq5k3nMrSi9aVtEq5x2dVKdK4MK
         HH1rEqOhisKMnKd4nJY5XpDkxQia+UwQ57jtw/88KTQx73wL1RKmCr125OHER0INCOJw
         pUVwYKyzSGUjFfB/RwlqrM4IJtGilC3RlvUCI7eFDdV8MuH1nh3ic1VFvu+tr4HbzCAy
         VCQ+9AdM4ibtojP18SfyHl1K7NDK9ZxeVMVcvxyZMfgb/4yjrWzT2mNAWLNhlnyVyVFt
         JUSA==
X-Gm-Message-State: AOAM532H/mfQ9iEzML5BeE+tMHe3I7AGW5AMRE3dKds+IoGD+w1tNA73
        bbJxyyJsJhA+a1f3au/Yre0=
X-Google-Smtp-Source: ABdhPJyaX1z0Ru8id7CJwP3LuX70u1FzjSHOqSYSDUIUnMrnkdOi3aOZzdDP1qLogeXE5CR9jRBKZg==
X-Received: by 2002:a7b:ca4e:: with SMTP id m14mr6032901wml.17.1598448283018;
        Wed, 26 Aug 2020 06:24:43 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id l1sm6642625wrb.12.2020.08.26.06.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:24:42 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:24:40 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: amlogic - use kfree_sensitive()
Message-ID: <20200826132440.GA13819@Red>
References: <20200826131657.398090-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826131657.398090-1-efremov@linux.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 26, 2020 at 04:16:57PM +0300, Denis Efremov wrote:
> Use kfree_sensitive() instead of open-coding it.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> index d93210726697..f3dca456d9f8 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> @@ -341,8 +341,7 @@ void meson_cipher_exit(struct crypto_tfm *tfm)
>  	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
>  
>  	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> +		kfree_sensitive(op->key);
>  	}
>  	crypto_free_skcipher(op->fallback_tfm);
>  }
> @@ -368,8 +367,7 @@ int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  		return -EINVAL;
>  	}
>  	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> +		kfree_sensitive(op->key);
>  	}
>  	op->keylen = keylen;
>  	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
> -- 

So the {} are no longer necessary.
Same for the "if (op->key)" test since kfree handle NULL.

Thanks
