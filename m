Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62025C5DF60
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 17:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C69C217F5
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572976330;
	bh=p+VFQmkLqCjORwfUsYuCrte2jE7w7TTv8ecEBf5sFgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QBj3FxBq4uuQ9Lka82fbGF4mBoy9u3dk6+9SobcfPwRiY4XW2qeNR9BWoYgGmZYmA
	 Qwur0Ue/GC0IfBTqQt6SHXPrechimsOj35c8TKmyskfHXnPJQBeyDlnvWogg8J4CKR
	 /PuYQaUaMaInwPIeNmfnYGAlx6vUjhHmcVbFqK6o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390551AbfKERwJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 12:52:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390346AbfKERwJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 12:52:09 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB1D20650;
        Tue,  5 Nov 2019 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572976328;
        bh=p+VFQmkLqCjORwfUsYuCrte2jE7w7TTv8ecEBf5sFgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=srDrOLLXcIW6gCW3oXZrBlGEV0CAfb6hz8wpyF0zB5fkJqfSCDq2F9LY03JnvrEgx
         sDKT1bZHpr+8iPIcCDylMkS5Vjsl3QY6li8oE5yiTXO3826kwQscMV2WbszT6NetJc
         2zDNDw1mHVRc2B9RyDRzO7q/kW8GqO0b+ok9/poo=
Date:   Tue, 5 Nov 2019 09:52:06 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 28/29] crypto: remove deprecated and unused ablkcipher
 support
Message-ID: <20191105175206.GD757@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ardb@kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
References: <20191105132826.1838-1-ardb@kernel.org>
 <20191105132826.1838-29-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105132826.1838-29-ardb@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 05, 2019 at 02:28:25PM +0100, Ard Biesheuvel wrote:
> Now that all users of the deprecated ablkcipher interface have been
> moved to the skcipher interface, ablkcipher is no longer used and
> can be removed.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

Thanks for doing this!

A couple ideas for future cleanups below (which, if done, should go in separate
patches rather than in this big one):

> @@ -786,9 +683,6 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
>  	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
>  	struct skcipher_alg *alg = crypto_skcipher_alg(skcipher);
>  
> -	if (tfm->__crt_alg->cra_type == &crypto_ablkcipher_type)
> -		return crypto_init_skcipher_ops_ablkcipher(tfm);
> -
>  	skcipher->setkey = skcipher_setkey;
>  	skcipher->encrypt = alg->encrypt;
>  	skcipher->decrypt = alg->decrypt;
>	skcipher->ivsize = alg->ivsize;
>	skcipher->keysize = alg->max_keysize;

Since a crypto_skcipher will now always be paired with a skcipher_alg (rather
than an blkcipher or ablkcipher algorithm), we could remove the 'encrypt',
'decrypt', 'ivsize', and 'keysize' fields of crypto_skcipher, and instead always
get them from the skcipher_alg.

> @@ -182,27 +171,18 @@ static inline u32 skcipher_request_flags(struct skcipher_request *req)
>  static inline unsigned int crypto_skcipher_alg_min_keysize(
>  	struct skcipher_alg *alg)
>  {
> -	if (alg->base.cra_ablkcipher.encrypt)
> -		return alg->base.cra_ablkcipher.min_keysize;
> -
>  	return alg->min_keysize;
>  }
>  
>  static inline unsigned int crypto_skcipher_alg_max_keysize(
>  	struct skcipher_alg *alg)
>  {
> -	if (alg->base.cra_ablkcipher.encrypt)
> -		return alg->base.cra_ablkcipher.max_keysize;
> -
>  	return alg->max_keysize;
>  }
>  
>  static inline unsigned int crypto_skcipher_alg_walksize(
>  	struct skcipher_alg *alg)
>  {
> -	if (alg->base.cra_ablkcipher.encrypt)
> -		return alg->base.cra_blocksize;
> -
>  	return alg->walksize;
>  }
>  
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 8c5a31e810da..b4655d91661f 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -241,9 +241,6 @@ static inline struct skcipher_alg *crypto_skcipher_alg(
>  
>  static inline unsigned int crypto_skcipher_alg_ivsize(struct skcipher_alg *alg)
>  {
> -	if (alg->base.cra_ablkcipher.encrypt)
> -		return alg->base.cra_ablkcipher.ivsize;
> -
>  	return alg->ivsize;
>  }
>  
> @@ -286,9 +283,6 @@ static inline unsigned int crypto_skcipher_blocksize(
>  static inline unsigned int crypto_skcipher_alg_chunksize(
>  	struct skcipher_alg *alg)
>  {
> -	if (alg->base.cra_ablkcipher.encrypt)
> -		return alg->base.cra_blocksize;
> -
>  	return alg->chunksize;
>  }

Now that these helpers are trivial, they could be removed and we could just
dereference the struct skcipher_alg directly.

- Eric
