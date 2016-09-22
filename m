From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] crypto: atmel-aes - erro when compiling with VERBOSE_DEBUG
 enable
Date: Thu, 22 Sep 2016 17:26:29 +0800
Message-ID: <20160922092629.GA5508@gondor.apana.org.au>
References: <1473779378.3556.20.camel@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, cyrille.pitchen@atmel.com
To: levent demir <levent.demir@inria.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35638 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbcIVJ0q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 05:26:46 -0400
Content-Disposition: inline
In-Reply-To: <1473779378.3556.20.camel@inria.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

levent demir <levent.demir@inria.fr> wrote:
> Hello, 
> 
> if you enable VERBOSE_DEBUG and compile you will have the following
> error : 
> 
> drivers/crypto/atmel-aes.c:323:5: error: too few arguments to function
> 'atmel_aes_reg_name'
>     atmel_aes_reg_name(offset, tmp));
>     ^
> include/linux/device.h:1306:41: note: in definition of macro 'dev_vdbg'
>   dev_printk(KERN_DEBUG, dev, format, ##arg); \
>                                         ^
> drivers/crypto/atmel-aes.c:205:20: note: declared here
> static const char *atmel_aes_reg_name(u32 offset, char *tmp, size_t sz)
> 
> Indeed, in atmel_aes_write function the call to atmel_aes_reg_name
> contains only two arguments instead of 3 : 
> 
> atmel_aes_reg_name(offset, tmp));
> 
> To fix it, one has to only add the size of tmp as third argument : 
> 
> atmel_aes_reg_name(offset, tmp, sizeof(tmp)));

Thanks for the patch.  In order to apply it, you need to fix the
white-space damage as well as add a sign-off.  For details please
refer to Documentation/SubmittingPatches.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
