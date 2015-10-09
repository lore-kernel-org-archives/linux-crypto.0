From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: ensure algif_hash does not pass a zero-sized
 state
Date: Fri, 9 Oct 2015 18:34:28 +0800
Message-ID: <20151009103428.GA1410@gondor.apana.org.au>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <E1ZkUvo-0004QO-U8@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38219 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbbJIKel (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 06:34:41 -0400
Content-Disposition: inline
In-Reply-To: <E1ZkUvo-0004QO-U8@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 09, 2015 at 11:29:44AM +0100, Russell King wrote:
> If the algorithm passed a zero statesize, do not pass a valid pointer
> into the export/import functions.  Passing a valid pointer covers up
> bugs in driver code which then go on to smash the kernel stack.
> Instead, pass NULL, which will cause any attempt to write to the
> pointer to fail.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

The state size should never be zero for a hash algorithm.  Having
a zero state means that the hash output must always be identical.
Such an algorithm would be quite useless.

So how about adding a check upon hash registration to verify that
the state size is greater than zero? The place to do it would be
shash_prepare_alg and ahash_prepare_alg.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
