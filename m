From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 14:19:36 +0800
Message-ID: <20170112061936.GA10325@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59551 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750698AbdALGTq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 01:19:46 -0500
Content-Disposition: inline
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 10, 2017 at 02:36:21AM +0100, Stephan Müller wrote:
> 
> to all driver maintainers: the patches I added are compile tested, but
> I do not have the hardware to verify the code. May I ask the respective
> hardware maintainers to verify that the code is appropriate and works
> as intended? Thanks a lot.
> 
> Herbert, this is my proprosal for our discussion around copying the
> AAD for algif_aead. Instead of adding the code to algif_aead and wait
> until it transpires to all cipher implementations, I thought it would
> be more helpful to fix all cipher implementations.

I think it's too much churn.  Let's get the algif_aead code fixed
up first, and then pursue this later.

BTW, why are you only doing the copy for encryption?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
