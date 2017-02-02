From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 4.10 aesni-intel no longer having lrw/ablk_helper dependencies?
Date: Thu, 2 Feb 2017 13:14:11 +0800
Message-ID: <20170202051411.GB4349@gondor.apana.org.au>
References: <201701292231.59656.a.miskiewicz@gmail.com>
 <201701301742.35626.arekm@maven.pl>
 <20170201141739.GD32415@gondor.apana.org.au>
 <201702011708.03940.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55253 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750953AbdBBGAC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 01:00:02 -0500
Content-Disposition: inline
In-Reply-To: <201702011708.03940.arekm@maven.pl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 01, 2017 at 05:08:03PM +0100, Arkadiusz Miśkiewicz wrote:
> 
> q: Will later loading of pcbc (so intel-aseni loaded from initrd, no pcbc 
> available, rootfs gets mounted; pcbc is loaded) enable its "functionality" for 
> intel-aesni just like it would be available at intel-aesni load time ?

No it won't but it's no big deal as pcbc(aes) isn't actually used
anywhere so it's really just an example of using fpu.  AFAIK pcbc
is only ever used with fcrypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
