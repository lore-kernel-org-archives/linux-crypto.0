From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt - Add debug prints
Date: Mon, 23 Jan 2017 22:59:09 +0800
Message-ID: <20170123145909.GD20806@gondor.apana.org.au>
References: <1484747645-17463-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: Rabin Vincent <rabin.vincent@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50007 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751237AbdAWO7U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:59:20 -0500
Content-Disposition: inline
In-Reply-To: <1484747645-17463-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2017 at 02:54:05PM +0100, Rabin Vincent wrote:
> From: Rabin Vincent <rabinv@axis.com>
> 
> tcrypt is very tight-lipped when it succeeds, but a bit more feedback
> would be useful when developing or debugging crypto drivers, especially
> since even a successful run ends with the module failing to insert. Add
> a couple of debug prints, which can be enabled with dynamic debug:
> 
> Before:
> 
>  # insmod tcrypt.ko mode=10
>  insmod: can't insert 'tcrypt.ko': Resource temporarily unavailable
> 
> After:
> 
>  # insmod tcrypt.ko mode=10 dyndbg
>  tcrypt: testing ecb(aes)
>  tcrypt: testing cbc(aes)
>  tcrypt: testing lrw(aes)
>  tcrypt: testing xts(aes)
>  tcrypt: testing ctr(aes)
>  tcrypt: testing rfc3686(ctr(aes))
>  tcrypt: all tests passed
>  insmod: can't insert 'tcrypt.ko': Resource temporarily unavailable
> 
> Signed-off-by: Rabin Vincent <rabinv@axis.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
