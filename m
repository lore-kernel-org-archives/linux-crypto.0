Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2427C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 13:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A44E52133D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 13:51:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lAASYvx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfDKNvR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 09:51:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37133 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfDKNvR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 09:51:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id v14so6794787wmf.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 06:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3cTG+32X3hwLJuAUcOtOVdwPRqp+lk0Kw6TfocH7Y4E=;
        b=lAASYvx55zPCD5eIxCDQgotvWxK2FHIBBtmBt8lzuPN/b/hoVxi2cr6G7EZtat5dSZ
         4+jkYLcoMOvPb3bGH0Zht+uyNWPPDhjVokabUMPRP1IaSjc2FAi7BoQxALkyLEES2iWg
         RKQt6FT9TKU2nOTIDufWiRSHHCPoZuy3OhlVjk+Ukr2P674NkLVsu6qBsoGFoZnPuuHH
         AlR8zBq6uJSkA58CBQL/F9vCLsD3pg71v1DJIkeU3bWefWxQrGXwaZe5BtdGADS408bP
         3caW6AOig3Q/kdEEBrbNwMtoVI/IuQYueNwUp1Jy2rpxcRret5eeN4F7/6vaybn6+D5X
         g4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3cTG+32X3hwLJuAUcOtOVdwPRqp+lk0Kw6TfocH7Y4E=;
        b=OASmY1w4hzlsKVw2GxHKoNloPFPF5BOQG5RLzCFpexA9l6COA0CA0jQTJN9IoHM4pt
         oidMu5GtD3pjvD80B4lZ7V8KhuuT1vcY3xFm532Ph9qXcwWhIEkhNLTgKkgvtl9xjeKR
         bFYvdYPzjYyKZI5Z64wAet4v0KXXOURvT4SlAXtfSht59zwqPBxerIt29rcqvzf/iQgH
         2tWk8OZ8HiU47wixVEskes5yKY+MeCyUJ20cHX5qGmeYh1Tg39bBIF8q6JN0I7vSTaDY
         B4ObwY/0JMdJ9ZRfH1Scfvs5pbe/y0Nr/pdLnpB60KispcyVBJ6N8mdpCdRVl8/8pBOv
         cO4A==
X-Gm-Message-State: APjAAAWmw8DHE4Cpy+hV9D22l1YfvkpfRvRSnYya1NAp6gyuaL+F0T/7
        LcLyITI5RAsKeb+aJIxKszXzqkJl
X-Google-Smtp-Source: APXvYqzhRd7Fmc0/Cji3j2schLTFsWsHrYBToTpWrT/PIDzwdwdd8s/EgVkIOFM4yoZTBXmZi2jg8Q==
X-Received: by 2002:a1c:be0e:: with SMTP id o14mr6325362wmf.11.1554990675715;
        Thu, 11 Apr 2019 06:51:15 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n4sm37484918wrx.39.2019.04.11.06.51.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 06:51:15 -0700 (PDT)
Date:   Thu, 11 Apr 2019 15:51:13 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 22/24] crypto: sun4i-ss - Forbid 2-key 3DES in FIPS mode
Message-ID: <20190411135113.GB4876@Red>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
 <E1hEVQW-0006om-09@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hEVQW-0006om-09@gondobar>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 04:51:19PM +0800, Herbert Xu wrote:
> This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
>    
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> index 54fd714d53ca..06df336488fb 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -533,13 +533,12 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  			 unsigned int keylen)
>  {
>  	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
> -	struct sun4i_ss_ctx *ss = op->ss;
> +	int err;
> +
> +	err = des3_verify_key(tfm, key);
> +	if (unlikely(err))
> +		return err;
>  
> -	if (unlikely(keylen != 3 * DES_KEY_SIZE)) {
> -		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
> -		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> -		return -EINVAL;
> -	}
>  	op->keylen = keylen;
>  	memcpy(op->key, key, keylen);
>  	return 0;

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
