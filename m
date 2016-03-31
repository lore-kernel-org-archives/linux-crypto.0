From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: cipher implementations allowed to sleep?
Date: Thu, 31 Mar 2016 17:21:06 +0800
Message-ID: <20160331092106.GA28538@gondor.apana.org.au>
References: <8342050.C1sDSzNQxT@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36336 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbcCaJVL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Mar 2016 05:21:11 -0400
Content-Disposition: inline
In-Reply-To: <8342050.C1sDSzNQxT@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 31, 2016 at 11:18:48AM +0200, Stephan Mueller wrote:
> Hi Herbert,
> 
> is it allowed that cipher implementations sleep? The driver of my question is 
> whether I can use spin_lock_irqsave() as a lock around a cipher operation.
> 
> The cipher operations in question are hashing, HMACing and symmetric ciphers.

Whether they can sleep is controlled by the MAY_SLEEP flag.

Of course, even if they can't sleep, if you invoke an async op
then it may return -EINPROGRESS and continue the processing in
the background.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
