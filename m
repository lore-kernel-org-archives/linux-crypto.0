Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECA0C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5183E208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592328983;
	bh=nOOOW65oSsiGI9JHZ8r9JSIVhwhnVyVo7lW/X1wgbkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2NTSeoPNGeq0hfsWBMWrTJps7qJjuKkUVPZs6VhP4KqsOaNC7dFMYv7IGND4TWqKG
	 xLPsdKXzh+cRyNEuiDQx+244r2naD+sNWc/UnJuM0Y1MaZW2PW9KwtNSKQe281zozX
	 cAgOn2UOLpK670tcnVXFHspA95Jhzx1qRR0nlUHg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbgFPRgW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 13:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgFPRgW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 13:36:22 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71CD52078D;
        Tue, 16 Jun 2020 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592328981;
        bh=nOOOW65oSsiGI9JHZ8r9JSIVhwhnVyVo7lW/X1wgbkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pcMIyzy76eQ6NWbIJFiv9deGEHOkhopgx105LCk9GLPsso5fB2vYzvHJbaylXq2of
         ABqk7+wJ/RfTOL4ifLg6pZiGKkbO8eJRcxjIhKsia2xPOkkUrBNt2uc4BnKqHa0a0w
         /BFMLqJWCB0wj/7nuI1QDu6PRV4uk+lSDukO0ClE=
Date:   Tue, 16 Jun 2020 10:36:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/4] crypto: introduce
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200616173620.GA207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 16, 2020 at 11:01:31AM -0400, Mikulas Patocka wrote:
> Introduce a new flag CRYPTO_ALG_ALLOCATES_MEMORY and modify dm-crypt, so
> that it uses only drivers without this flag.
> 
> If the flag is set, then the crypto driver allocates memory in its request
> routine. Such drivers are not suitable for disk encryption because
> GFP_ATOMIC allocation can fail anytime (causing random I/O errors) and
> GFP_KERNEL allocation can recurse into the block layer, causing a
> deadlock.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Index: linux-2.6/include/linux/crypto.h
> ===================================================================
> --- linux-2.6.orig/include/linux/crypto.h
> +++ linux-2.6/include/linux/crypto.h
> @@ -97,9 +97,15 @@
>  #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
>  
>  /*
> + * The driver is allocating emmory in its encrypt or decrypt callback,
> + * so it should not be used to encrypt block devices.
> + */

"is allocating emmory" => "may allocate memory"

"so it should not be used to encrypt block devices" =>
"so it shouldn't be used in cases where memory allocation failures aren't
 acceptable, such as during block device encryption".

Also, which types of algorithms does this flag apply to?  E.g. if it applies to
hash algorithms too, it's not sufficient to say "encrypt or decrypt callback".

How about:

 /*
  * The driver may allocate memory during request processing, so it shouldn't be
  * used in cases where memory allocation failures aren't acceptable, such as
  * during block device encryption.
  */

> +#define CRYPTO_ALG_ALLOCATES_MEMORY	0x00008000
> +
> +/*
>   * Don't trigger module loading
>   */
> -#define CRYPTO_NOLOAD			0x00008000
> +#define CRYPTO_NOLOAD			0x00010000
>  
>  /*
>   * Transform masks and values (for crt_flags).
> Index: linux-2.6/drivers/md/dm-crypt.c
> ===================================================================

This would better belong as two separate patches: one to introduce
CRYPTO_ALG_ALLOCATES_MEMORY, and one to make dm-crypt use it.

> --- linux-2.6.orig/drivers/md/dm-crypt.c
> +++ linux-2.6/drivers/md/dm-crypt.c
> @@ -419,7 +419,7 @@ static int crypt_iv_lmk_ctr(struct crypt
>  		return -EINVAL;
>  	}
>  
> -	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
> +	lmk->hash_tfm = crypto_alloc_shash("md5", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
>  	if (IS_ERR(lmk->hash_tfm)) {
>  		ti->error = "Error initializing LMK hash";
>  		return PTR_ERR(lmk->hash_tfm);
> @@ -581,7 +581,7 @@ static int crypt_iv_tcw_ctr(struct crypt
>  		return -EINVAL;
>  	}
>  
> -	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
> +	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
>  	if (IS_ERR(tcw->crc32_tfm)) {
>  		ti->error = "Error initializing CRC32 in TCW";
>  		return PTR_ERR(tcw->crc32_tfm);
> @@ -768,7 +768,7 @@ static int crypt_iv_elephant_ctr(struct
>  	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
>  	int r;
>  
> -	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
> +	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
>  	if (IS_ERR(elephant->tfm)) {
>  		r = PTR_ERR(elephant->tfm);
>  		elephant->tfm = NULL;
> @@ -2088,7 +2088,7 @@ static int crypt_alloc_tfms_skcipher(str
>  		return -ENOMEM;
>  
>  	for (i = 0; i < cc->tfms_count; i++) {
> -		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
> +		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, CRYPTO_ALG_ALLOCATES_MEMORY);

Despite the recent relaxation in rules, the preferred length of a line is still
80 columns.

- Eric
