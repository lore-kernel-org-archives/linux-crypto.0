Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011F2C2D0C8
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 04:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E73206E6
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 04:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577767525;
	bh=aNPKrs1MrKWnad0t5lCe4/D45Ki3qaMQ9FddngBznME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ovmJn1S6XQWvSgQwwfqZEAkKfmzNtiASeINaehlet0swnlave2OXZu7j1A/2K7vh8
	 6jjnrz0/Erm4uv9rP9jkuDCKL2s/n2WZKQrTV7sGO7a1PBx9D8K3Izb65q4HzhmMEv
	 cUyrApoJb5DVtqFit7K8q7EjQOPewTBqlkkRNaeY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfLaEpZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 23:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfLaEpY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 23:45:24 -0500
Received: from zzz.localdomain (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E4C206D9;
        Tue, 31 Dec 2019 04:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577767524;
        bh=aNPKrs1MrKWnad0t5lCe4/D45Ki3qaMQ9FddngBznME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=igAKWOTO4J35UOoF3dxZuVpQ+rxp2nf2NI3Eh2hRuMySWOyTcltOL8uzZxmk40sgB
         MVGw+rE8sirERcg4TB0xtN4z9VrwLAa9usGmGh5UAivet7D/55oR1c3Vg6FXkSHxaz
         2jWSlCxfYcENPWkYfgTCzrqlmd5oJrf1hindNzIA=
Date:   Mon, 30 Dec 2019 22:45:22 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Subject: Re: [PATCH 3/8] crypto: atmel-sha - fix error handling when setting
 hmac key
Message-ID: <20191231044522.GC180988@zzz.localdomain>
References: <20191231031938.241705-1-ebiggers@kernel.org>
 <20191231031938.241705-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231031938.241705-4-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[+Cc the people with Cc tags in the patch, who I accidentally didn't Cc...
 Original message was
 https://lkml.kernel.org/linux-crypto/20191231031938.241705-4-ebiggers@kernel.org/]

On Mon, Dec 30, 2019 at 09:19:33PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> HMAC keys can be of any length, and atmel_sha_hmac_key_set() can only
> fail due to -ENOMEM.  But atmel_sha_hmac_setkey() incorrectly treated
> any error as a "bad key length" error.  Fix it to correctly propagate
> the -ENOMEM error code and not set any tfm result flags.
> 
> Fixes: 81d8750b2b59 ("crypto: atmel-sha - add support to hmac(shaX)")
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/atmel-sha.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
> index e8e4200c1ab3..d3bcd14201c2 100644
> --- a/drivers/crypto/atmel-sha.c
> +++ b/drivers/crypto/atmel-sha.c
> @@ -1853,12 +1853,7 @@ static int atmel_sha_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  {
>  	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
>  
> -	if (atmel_sha_hmac_key_set(&hmac->hkey, key, keylen)) {
> -		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> +	return atmel_sha_hmac_key_set(&hmac->hkey, key, keylen);
>  }
>  
>  static int atmel_sha_hmac_init(struct ahash_request *req)
> -- 
> 2.24.1
> 
