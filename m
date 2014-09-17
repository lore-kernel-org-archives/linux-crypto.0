From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: v3.17-rc5: alg: skcipher: Test 4 failed on encryption for
 ctr-aes-aesni
Date: Wed, 17 Sep 2014 19:29:11 +0800
Message-ID: <20140917112911.GA2129@gondor.apana.org.au>
References: <87sijti8kh.fsf@kima.orebokech.com>
 <87fvfr2v3w.fsf@kima.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Mathias Krause <minipli@googlemail.com>
To: Romain Francoise <romain@orebokech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56997 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaIQL3S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Sep 2014 07:29:18 -0400
Content-Disposition: inline
In-Reply-To: <87fvfr2v3w.fsf@kima.orebokech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 16, 2014 at 10:01:07PM +0200, Romain Francoise wrote:
> On Mon, Sep 15, 2014 at 10:36:46AM +0200, Romain Francoise wrote:
> > I upgraded from v3.16 to v3.17-rc5 and the ctr-aes-aesni encryption test
> > fails, which makes my IPsec tunnels unhappy (see trace below). Before I
> > start bisecting (2cddcc7df8fd3 is probably my first guess), is this
> > already known?
> 
> > Sep 15 08:07:56 silenus kernel: [   35.137145] alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni [...]
> 
> Update: reverting 2cddcc7df8 ("crypto: aes - AES CTR x86_64 "by8" AVX
> optimization") fixes this. This machine is Sandy Bridge (Core i7-2600),
> and the problem doesn't seem to occur with the exact same kernel image
> on Ivy Bridge (Xeon E3-1240v2).

Thanks for bisecting.  If we can't fix this quickly then we should
just revert it for now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
