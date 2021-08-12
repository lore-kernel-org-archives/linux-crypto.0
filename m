Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61457C4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 13:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30E7660FD7
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 13:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhHLOAL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:00:11 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:37284 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbhHLOAL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 10:00:11 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id E484A72C8FB;
        Thu, 12 Aug 2021 16:59:43 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 931454A46F1;
        Thu, 12 Aug 2021 16:59:43 +0300 (MSK)
Date:   Thu, 12 Aug 2021 16:59:43 +0300
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
Subject: Re: [PATCH 1/3] crypto: tcrypt - Fix the wrong position of return
 value test statement
Message-ID: <20210812135943.mnuce4252wp4xi52@altlinux.org>
References: <20210812131748.81620-1-tianjia.zhang@linux.alibaba.com>
 <20210812131748.81620-2-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210812131748.81620-2-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tianjia,

On Thu, Aug 12, 2021 at 09:17:46PM +0800, Tianjia Zhang wrote:
> The position of the return value test statement of crypto_aead_setkey()
> is wrong, adjust to make it work properly.

This commit message does not explain anything. It's nearly equivalent to
"fix".

> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  crypto/tcrypt.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index d73a42fdaa9b..73c97e085baf 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -612,6 +612,12 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
>  				}
>  			}
>  			ret = crypto_aead_setkey(tfm, key, *keysize);

Perhaps, you would say that return value of crypto_aead_setkey was lost.

> +			if (ret) {
> +				pr_err("setkey() failed flags=%x\n",
> +						crypto_aead_get_flags(tfm));
> +				goto out;
> +			}
> +
>  			ret = crypto_aead_setauthsize(tfm, authsize);

But, isn't now return value of crypto_aead_setauthsize is lost?

Thanks,

>  
>  			iv_len = crypto_aead_ivsize(tfm);
> @@ -622,15 +628,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
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
