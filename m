From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Mon, 23 Jan 2017 21:10:12 +0800
Message-ID: <20170123131012.GB17598@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <1704568.lHqrOxcchT@positron.chronox.de>
 <20170113113324.GA24021@gondor.apana.org.au>
 <2829634.RJknVxGPvY@positron.chronox.de>
 <20170113113906.GA24096@gondor.apana.org.au>
 <2a4fab23-3ea7-a0f7-7c30-55d301f51ec9@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35139 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750714AbdAWNKn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 08:10:43 -0500
Content-Disposition: inline
In-Reply-To: <2a4fab23-3ea7-a0f7-7c30-55d301f51ec9@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 20, 2017 at 06:07:04PM +0100, Cyrille Pitchen wrote:
> Hi all,
> 
> Le 13/01/2017 à 12:39, Herbert Xu a écrit :
> > On Fri, Jan 13, 2017 at 12:36:56PM +0100, Stephan Müller wrote:
> >>
> >> I thought I understood that you would not want to see it in any 
> >> implementation. But, ok, if you want to leave it.
> > 
> > If you remove it from authenc then authenc will be broken.
> > 
> 
> Hence if the copy of the associated data is needed in the crypto/authenc.c
> driver, then I should also keep this copy in the drivers/crypto/atmel-aes.c
> for authenc(hmac(shaX),cbc-aes) algorithms [1], shouldn't I?
> 
> If so, should I keep the current not optimized implementation of
> atmel_aes_authenc_copy_assoc() or try to use the code extracted by Stephan
> from crypto/authenc.c using the null cipher as proposed in this thread?
> 
> As said earlier in this thread, copying the associated data is not a so big
> deal when compared to the main crypto processing.

Please just ignore this for now.  We have not decided to require
the copying of the AAD in the kernel API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
