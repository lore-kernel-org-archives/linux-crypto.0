From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt speed: fix filter for aead algorithms
Date: Sat, 28 Feb 2015 22:13:23 +1300
Message-ID: <20150228091323.GB6187@gondor.apana.org.au>
References: <1422971988-21517-1-git-send-email-cristian.stoica@freescale.com>
 <20150227092503.GA27831@gondor.apana.org.au>
 <54F0518C.1040801@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54400 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbB1JN1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 04:13:27 -0500
Content-Disposition: inline
In-Reply-To: <54F0518C.1040801@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 27, 2015 at 01:14:20PM +0200, Cristian Stoica wrote:
> Hi Herbert,
> 
> On 02/27/2015 11:25 AM, Herbert Xu wrote:
> > On Tue, Feb 03, 2015 at 03:59:48PM +0200, Cristian Stoica wrote:
> >> test_aead_speed is written for sync algorithms without specifically
> [...]
> > Please fix it to test asynchronously instead.
> 
> Thanks for review.
> 
> I think that a fix for async aead requires a different test function as
> is the case with test_cipher_speed/test_acipher_speed and also with
> test_hash_speed/test_ahash_speed.
> 
> But I see a issue here with the current async tests:
> 
> int test_acipher_cycles(...)
> {
>   for (i = 0; i < 8; i++) {
>     [...]
>     ret = do_one_acipher_op(req, crypto_ablkcipher_encrypt(req));
>     [...]
>   }
> }
> 
> and in do_one_acipher_op we wait for completion of
> crypto_ablkcipher_encrypt:
> 
> if (ret == -EINPROGRESS || ret == -EBUSY) {
> 	struct tcrypt_result *tr = req->base.data;
> 	ret = wait_for_completion_interruptible(&tr->completion);
> }
> 
> Doesn't this defeat the purpose of async execution?

We're trying to measure the minimum amount of time it takes
for the implementation to handle one request so waiting for
completion makes sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
