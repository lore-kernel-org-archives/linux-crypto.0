From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_ahash_setkey
Date: Wed, 23 Nov 2011 18:07:22 +0800
Message-ID: <20111123100721.GA8774@gondor.apana.org.au>
References: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com> <20111123074456.GA7875@gondor.apana.org.au> <CALLzPKaSm9TncJc3932jxSYzp=krXRH_5wO5CFGDnCsDKvaLUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59493 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1KWKH0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Nov 2011 05:07:26 -0500
Content-Disposition: inline
In-Reply-To: <CALLzPKaSm9TncJc3932jxSYzp=krXRH_5wO5CFGDnCsDKvaLUQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 23, 2011 at 11:08:29AM +0200, Kasatkin, Dmitry wrote:
>
> Yes. I know that....
> Work queue also uses WQ_NON_REENTRANT, so it should not be any races,
> and it should be possible to call crypto_ahash_setkey() without any problems.
> 
> This problem happens on 64 bit kernel.
> It does not happen on my QEMU 32 bit kernel,
> 
> I will do some more tests...

Which particular hmac(sha1) implementation are you using?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
