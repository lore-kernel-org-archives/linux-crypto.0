From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: GCM: cra_name == cra_driver_name
Date: Tue, 26 Jan 2016 19:13:52 +0800
Message-ID: <20160126111352.GB21069@gondor.apana.org.au>
References: <4642565.JLlnFcM15x@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37576 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556AbcAZLN4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 06:13:56 -0500
Content-Disposition: inline
In-Reply-To: <4642565.JLlnFcM15x@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 25, 2016 at 10:48:38PM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> with the current cryptodev tree, when I call a compound AEAD cipher with 
> cra_driver_name for the first time, this cra_driver_name gets registered also 
> as cra_name. Note, using other compound ciphers (like HMAC or symmetric 
> ciphers), I do not see that error.
> 
> With that registering, I am not able to resolve the cipher with usual common 
> cra_name.
> 
> Note, when I initialized an AEAD cipher with a cra_name, then all works as it 
> used to be.

Is this a new problem? I thought it always worked like this.

I was going to fix it to generate a proper cra_name after I'm
done with the skcipher conversion.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
