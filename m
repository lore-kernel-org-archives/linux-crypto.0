From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Problem with key sizes
Date: Sat, 17 Mar 2007 15:12:17 +1100
Message-ID: <E1HSQHB-0000Sn-00@gondolin.me.apana.org.au>
References: <20070316152347.GE13744@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: linux-crypto@ml.breakpoint.cc (Sebastian Siewior)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4847 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753730AbXCQEMU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Mar 2007 00:12:20 -0400
In-Reply-To: <20070316152347.GE13744@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> 
> I have a little problem with the min|max keysize: /proc/crypto:
> 
> name         : aes
> driver       : aes-special
> module       : aes2
> priority     : 150
> refcnt       : 1
> type         : cipher
> blocksize    : 16
> min keysize  : 24
> max keysize  : 32
> 
> name         : aes
> driver       : aes-generic
> module       : aes
> priority     : 100
> refcnt       : 1
> type         : cipher
> blocksize    : 16
> min keysize  : 16
> max keysize  : 32
> 
> 16bit key are not supported by the -special algo, only by the -generic
> driver. My understanding of this was if someone needs 16bit keys
> aes-generic id used and for 24 and 32 bit long keys the -special driver.
> Unfortunately crypto_alloc_blkcipher() does not care about the min|max
> keysize field.
> I thing the main problem here is that the crypto api knows nothing about
> the key size until crypto_blkcipher_setkey() what is probably too late.
> Is it possible to modify the api to something like OpenSSL's
> aes-128-cbc (or cbc(aes(128)) in our case :) ) ?

What exactly is the aes-special algorithm and where can I find a copy?

Yes key length support is missing as far as algorithm selection
is concerned.  I haven't worried too much about it because there
hasn't been that many algorithms needing this.

So my question is how hard is it to make aes-special support 16-bit keys?
 
> I have a question regarding the git tree: Which one is valid?
> MAINTAINERS says .../git/herbert/crypto-2.6.git but once I clone it,
> there is .git directory in it (with 151MB but no source code).
> ./git/herbert/cryptodev-2.6.git on the other has source inside.

crypto-2.6.git is the tree that is usually the tree that has been
already submitted upstream.  cryptodev-2.6.git is the tree which
will be submitted the next time the merge window opens.

If you find no source code after the clone all you have to do is check
them out with 'git-checkout-index -a'.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
