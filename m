From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Wed, 28 Jan 2015 11:56:40 +1100
Message-ID: <20150128005640.GA12143@gondor.apana.org.au>
References: <54C826EC.8050103@imgtec.com>
 <54C82D69.9070200@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Bresticker <abrestic@chromium.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
	linux-crypto@vger.kernel.org
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44340 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbbA1A4u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2015 19:56:50 -0500
Content-Disposition: inline
In-Reply-To: <54C82D69.9070200@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2015 at 12:29:29AM +0000, James Hartley wrote:
> 
> - If it is mandatory to impement a fallback driver (because the
> potential users of the framework would not know only digest is
> supported?)

Yes it is mandatory.
 
> If I need to implement fallback drivers, would the Niagra2 SPU
> driver be a good reference
> http://lxr.free-electrons.com/source/drivers/crypto/n2_core.c ?

Yes it's a good example.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
