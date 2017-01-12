From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 23:39:24 +0800
Message-ID: <20170112153924.GA16347@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <6428553.skGSKSKcYl@tauon.atsec.com>
 <20170112152710.GA16222@gondor.apana.org.au>
 <2819680.QEYfZCVF62@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52863 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750933AbdALPjd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:39:33 -0500
Content-Disposition: inline
In-Reply-To: <2819680.QEYfZCVF62@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 04:34:39PM +0100, Stephan Müller wrote:
>
> We would only be able to remove it if all AEAD implementations are converted. 
> But for the conversion time, we do face that issue.

It doesn't matter.  Nobody in the kernel uses that.  In fact I
wonder whether we should even do it for the kernel API.  We only
need it for the user-space API because it goes through read/write.

> Are you suggesting that the entire data in the src SGL is first copied to the 
> dst SGL by algif_aead? If yes, that still requires significant src/dst SGL 
> tinkering as we have the tag -- the src SGL for encrypt does not have the tag 
> space where the dst SGL for encrypt is required to have the tag size. This is 
> vice versa for the decryption operation.

It's really only a problem for decryption.  In that case you can
extend the dst SG list to include the tag.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
