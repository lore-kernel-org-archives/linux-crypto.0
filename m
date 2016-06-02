From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] DRBG: which shall be default?
Date: Thu, 2 Jun 2016 17:42:11 +0800
Message-ID: <20160602094211.GA16489@gondor.apana.org.au>
References: <1664837.3VbqQRUZed@positron.chronox.de>
 <1972759.dI50hI8gdY@tauon.atsec.com>
 <20160602084012.GC15226@gondor.apana.org.au>
 <3243059.jE1At2qco9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38431 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbcFBJmT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 05:42:19 -0400
Content-Disposition: inline
In-Reply-To: <3243059.jE1At2qco9@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 11:31:22AM +0200, Stephan Mueller wrote:
>
> The skcipher API, however, wants to encrypt an entire input data stream. That 
> means the skcipher API requires the length of the input data stream to 
> generate an equally sized output data stream. But that is not what we have 
> here -- there is no input data. I.e. the skcipher API invokes the CTR mode for 
> the stream cipher and performs the final XOR of the CTR stream with the input 
> data.

Just use an input stream of zeros.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
