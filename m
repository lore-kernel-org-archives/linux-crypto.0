Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E12C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 20:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD722054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 20:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="SURmVZ86"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbfHEUAx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 16:00:53 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:12231 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfHEUAx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 16:00:53 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 462TCg5rBbz9ty2B;
        Mon,  5 Aug 2019 22:00:47 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=SURmVZ86; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id g9geWnIk7yUW; Mon,  5 Aug 2019 22:00:47 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 462TCg4g8rz9ty26;
        Mon,  5 Aug 2019 22:00:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1565035247; bh=rwMfEg/bO0WFaZBML2KPkLXU25VS1HK0tM4ZHGyTba8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SURmVZ86Xzt7rfSr5dvqWCmhTXzo0XOWhZA6lCrS1Dz8c5vbfp4rjBhcM1OPsOk++
         sr25OfHGONW6KD/xe4N/A9OO5OlBoiL5hnXNmIsAZU48jqZD/BXSIiE1av4zD0oNHz
         iqAYm+Nzte5oxy9ksGOgbBTGe15bpYRM7BLtybo0=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CC0DC8B7D1;
        Mon,  5 Aug 2019 22:00:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id rnxZG8YdvVpZ; Mon,  5 Aug 2019 22:00:47 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 722098B7B7;
        Mon,  5 Aug 2019 22:00:47 +0200 (CEST)
Subject: Re: [PATCH v4 23/30] crypto: talitos/des - switch to new verification
 routines
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
 <20190805170037.31330-24-ard.biesheuvel@linaro.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <bb4e8b45-93cc-e849-bd1b-60660da85c21@c-s.fr>
Date:   Mon, 5 Aug 2019 22:00:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805170037.31330-24-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 05/08/2019 à 19:00, Ard Biesheuvel a écrit :
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

> ---
>   drivers/crypto/talitos.c | 34 ++++----------------
>   1 file changed, 7 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index c9d686a0e805..890cf52007f2 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -30,7 +30,7 @@
>   
>   #include <crypto/algapi.h>
>   #include <crypto/aes.h>
> -#include <crypto/des.h>
> +#include <crypto/internal/des.h>
>   #include <crypto/sha.h>
>   #include <crypto/md5.h>
>   #include <crypto/internal/aead.h>
> @@ -939,12 +939,9 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
>   	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
>   		goto badkey;
>   
> -	flags = crypto_aead_get_flags(authenc);
> -	err = __des3_verify_key(&flags, keys.enckey);
> -	if (unlikely(err)) {
> -		crypto_aead_set_flags(authenc, flags);
> +	err = crypto_des3_ede_verify_key(crypto_aead_tfm(authenc), keys.enckey);
> +	if (err)
>   		goto out;
> -	}
>   
>   	if (ctx->keylen)
>   		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
> @@ -1517,32 +1514,15 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
>   static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
>   				 const u8 *key, unsigned int keylen)
>   {
> -	u32 tmp[DES_EXPKEY_WORDS];
> -
> -	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
> -		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
> -	    !des_ekey(tmp, key)) {
> -		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_WEAK_KEY);
> -		return -EINVAL;
> -	}
> -
> -	return ablkcipher_setkey(cipher, key, keylen);
> +	return crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
> +	       ablkcipher_setkey(cipher, key, keylen);
>   }
>   
>   static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
>   				  const u8 *key, unsigned int keylen)
>   {
> -	u32 flags;
> -	int err;
> -
> -	flags = crypto_ablkcipher_get_flags(cipher);
> -	err = __des3_verify_key(&flags, key);
> -	if (unlikely(err)) {
> -		crypto_ablkcipher_set_flags(cipher, flags);
> -		return err;
> -	}
> -
> -	return ablkcipher_setkey(cipher, key, keylen);
> +	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
> +	       ablkcipher_setkey(cipher, key, keylen);
>   }
>   
>   static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
> 
