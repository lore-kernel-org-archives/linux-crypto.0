From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: algif_aead - Switch to new AEAD interface
Date: Wed, 27 May 2015 12:10:03 +0200
Message-ID: <1517596.JekxWSB2Qc@tauon>
References: <20150527092441.GA27913@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58327 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbbE0KKM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 06:10:12 -0400
In-Reply-To: <20150527092441.GA27913@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Mai 2015, 17:24:41 schrieb Herbert Xu:

Hi Herbert,

>-
>-	if (ctx->enc) {
>-		/* round up output buffer to multiple of block size */
>-		outlen = ((used + bs - 1) / bs * bs);

Why wouldn't the round up for the output not be needed any more? If the caller 
provides input data that is not multiple of block sizes and the output buffer 
is also not multiple of block sizes, wouldn't an encrypt overstep boundaries?

>-		/* add the size needed for the auth tag to be created */
>-		outlen += as;
>-	} else {
>-		/* output data size is input without the authentication tag */
>-		outlen = used - as;
>-		/* round up output buffer to multiple of block size */
>-		outlen = ((outlen + bs - 1) / bs * bs);

Same here.

>-	}
>+	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);



Ciao
Stephan
