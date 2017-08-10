From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v8 1/4] crypto: AF_ALG -- add sign/verify API
Date: Thu, 10 Aug 2017 15:03:39 +0200
Message-ID: <5164071.4MUeWmsg9v@tauon.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <1701667.ajpEH4uy8Y@positron.chronox.de> <45021398-1ff4-77af-2fea-92a02b4a33c4@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58466 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752729AbdHJNDl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 09:03:41 -0400
In-Reply-To: <45021398-1ff4-77af-2fea-92a02b4a33c4@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 10. August 2017, 14:49:39 CEST schrieb Tudor Ambarus:

Hi Tudor,

thanks for reviewing

> > 
> > -		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
> > -				 crypto_aead_decrypt(&areq->cra_u.aead_req);
> > -	} else {
> > +	} else
> 
> Unbalanced braces around else statement.

Is there a style requirement for that? checkpatch.pl does not complain. I 
thought that one liners in a conditional should not have braces?

> > -	ctx->enc = 0;
> > +	ctx->op = 0;
> 
> This implies decryption. Should we change the value of ALG_OP_DECRYPT?

ALG_OP_DECRYPT is a user space interface, so we cannot change it.

Do you see harm in leaving it as is? Note, I did not want to introduce 
functional changes that have no bearing on the addition of the sign/verify 
API. If you think this is problematic, I would like to add another patch that 
is dedicated to fix this.

> > -		err = ctx->enc ?
> > -			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
> > -			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
> > -	} else {
> > +	} else
> 
> Unbalanced braces around else statement.

Same as above.

Thanks a lot!

Ciao
Stephan
