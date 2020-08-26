Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698C9C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDD9214F1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHTMKcDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgHZN12 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 09:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgHZN1R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 09:27:17 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0F6C061574
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 06:27:16 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id s13so1744352wmh.4
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 06:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mwi869cLwhFTmjSB6jbhW5eMJAjGCSc6RefBdVaSqGY=;
        b=NHTMKcDcaTK5xWIR2to8WGIINFOEljxs4FlslunhBeYFZoUDFxup/CBWAY8lNvaJq0
         gIbNLojxGNnAg/PrnQkDaaOkR7X5tWH9Yu0uiJLZ07xtMZV+9/MEvb1hr3WcRhvfhdZ0
         8NwIgFcKLi6GqLZYT6L5rjFLZ439WqD/G08Mx49vyKho8+Qotv1E4yuCrmKtPOEjNsTz
         cqRsro1AMHTi2gKguEgDunj4XkqrUnW4DVED3vFFDhstZt0/0kL8tWgA2hz+9TpzgHAU
         O4NWOormsx6CeZGIyRnc4rbylbWhPWVqw3knl/CJ/hC2TxDX0vAqXPrwLa/7GAMvydI9
         JvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mwi869cLwhFTmjSB6jbhW5eMJAjGCSc6RefBdVaSqGY=;
        b=hFm26gvzDkn2XlmUtRmDQTHN/j8ifrfGOlUPSpc3BkGIzqTDzqBUGuWQRacsOVqBP4
         kONQbG8Ae89E81X/wQfVDUUykxC5XDZfLuUooYSf/Mefue5fhuBZfCDrLqwLwVTXkmwy
         2V3YEzo2xQUTdpPJOcLVW2dJ4LBX7oBLIb2pu8FCpL4Ws9PEv+UNCxeUoeixmvuNOnak
         fAquYyeTd/TYuvDFuZElcKak3l7R2aTQRoZjMXEGOOwFQxlf/A6R9Tr3WaUnauRO2lvW
         Gw9g5PwSg8vl9RU+/G/aqX5YfLH032r/fju1+QHl5EhfsSnwWhbSejG0WNWgnwz3tdfy
         EPow==
X-Gm-Message-State: AOAM531NtIuei4ODYHbEIBln1AmlB7kxz+ueCz8l5bLPz/p2bat6TQpq
        Lr/LQbJV7Yc2prnskI/gyQfgxuRM5ko=
X-Google-Smtp-Source: ABdhPJw0wILOm4ehRmc9Eo78FYz27qM09S/y38+CWBxstEmwkJTBpj2JYtqt/d7xXZ3jpjHTFKVfvA==
X-Received: by 2002:a05:600c:2117:: with SMTP id u23mr7377471wml.41.1598448435330;
        Wed, 26 Aug 2020 06:27:15 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id q11sm5806918wrw.61.2020.08.26.06.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:27:14 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:27:13 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: sun8i-ss - use kfree_sensitive()
Message-ID: <20200826132713.GB13819@Red>
References: <20200826132451.398651-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826132451.398651-1-efremov@linux.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 26, 2020 at 04:24:51PM +0300, Denis Efremov wrote:
> Use kfree_sensitive() instead of open-coding it.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> index 7b39b4495571..49d89b31eb6b 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> @@ -369,8 +369,7 @@ void sun8i_ss_cipher_exit(struct crypto_tfm *tfm)
>  	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
>  
>  	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> +		kfree_sensitive(op->key);
>  	}
>  	crypto_free_skcipher(op->fallback_tfm);
>  	pm_runtime_put_sync(op->ss->dev);
> @@ -394,8 +393,7 @@ int sun8i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  		return -EINVAL;
>  	}
>  	if (op->key) {
> -		memzero_explicit(op->key, op->keylen);
> -		kfree(op->key);
> +		kfree_sensitive(op->key);
>  	}
>  	op->keylen = keylen;
>  	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
> @@ -420,8 +418,7 @@ int sun8i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  	}
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

Same comment than for your crypto/amlogic patch.
Please remove the "if (op->key)"

Regards
