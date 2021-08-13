Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33E1C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB2AD6104F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbhHMJD4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 05:03:56 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:55968 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238823AbhHMJDz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 05:03:55 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id D879D72C8FB;
        Fri, 13 Aug 2021 12:03:27 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id B63664A46F2;
        Fri, 13 Aug 2021 12:03:27 +0300 (MSK)
Date:   Fri, 13 Aug 2021 12:03:27 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Subject: Re: [PATCH v2 1/3] crypto: tcrypt - Fix missing return value check
Message-ID: <20210813090327.g6x5gi2hoale5kjg@altlinux.org>
References: <20210813075508.98854-1-tianjia.zhang@linux.alibaba.com>
 <20210813075508.98854-2-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210813075508.98854-2-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 13, 2021 at 03:55:06PM +0800, Tianjia Zhang wrote:
> There are several places where the return value check of crypto_aead_setkey
> and crypto_aead_setauthsize were lost. It is necessary to add these checks.
> 
> At the same time, move the crypto_aead_setauthsize() call out of the loop,
> and only need to call it once after load transform.
> 
> Fixee: 53f52d7aecb4 ("crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in tcrypt test suite")
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Thanks,

> ---
>  crypto/tcrypt.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index d73a42fdaa9b..170102e92f7d 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -290,6 +290,11 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
>  	}
>  
>  	ret = crypto_aead_setauthsize(tfm, authsize);
> +	if (ret) {
> +		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
> +		       ret);
> +		goto out_free_tfm;
> +	}
>  
>  	for (i = 0; i < num_mb; ++i)
>  		if (testmgr_alloc_buf(data[i].xbuf)) {
> @@ -315,7 +320,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
>  	for (i = 0; i < num_mb; ++i) {
>  		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
>  		if (!data[i].req) {
> -			pr_err("alg: skcipher: Failed to allocate request for %s\n",
> +			pr_err("alg: aead: Failed to allocate request for %s\n",
>  			       algo);
>  			while (i--)
>  				aead_request_free(data[i].req);
> @@ -567,13 +572,19 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
>  	sgout = &sg[9];
>  
>  	tfm = crypto_alloc_aead(algo, 0, 0);
> -
>  	if (IS_ERR(tfm)) {
>  		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
>  		       PTR_ERR(tfm));
>  		goto out_notfm;
>  	}
>  
> +	ret = crypto_aead_setauthsize(tfm, authsize);
> +	if (ret) {
> +		pr_err("alg: aead: Failed to setauthsize for %s: %d\n", algo,
> +		       ret);
> +		goto out_noreq;
> +	}
> +
>  	crypto_init_wait(&wait);
>  	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
>  			get_driver_name(crypto_aead, tfm), e);
> @@ -611,8 +622,13 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
>  					break;
>  				}
>  			}
> +
>  			ret = crypto_aead_setkey(tfm, key, *keysize);
> -			ret = crypto_aead_setauthsize(tfm, authsize);
> +			if (ret) {
> +				pr_err("setkey() failed flags=%x: %d\n",
> +					crypto_aead_get_flags(tfm), ret);
> +				goto out;
> +			}
>  
>  			iv_len = crypto_aead_ivsize(tfm);
>  			if (iv_len)
> @@ -622,15 +638,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
>  			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
>  					i, *keysize * 8, bs);
>  
> -
>  			memset(tvmem[0], 0xff, PAGE_SIZE);
>  
> -			if (ret) {
> -				pr_err("setkey() failed flags=%x\n",
> -						crypto_aead_get_flags(tfm));
> -				goto out;
> -			}
> -
>  			sg_init_aead(sg, xbuf, bs + (enc ? 0 : authsize),
>  				     assoc, aad_size);
>  
> -- 
> 2.19.1.3.ge56e4f7
