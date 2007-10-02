From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Tue, 2 Oct 2007 21:05:12 +0200
Message-ID: <20071002190512.GA8761@Chamillionaire.breakpoint.cc>
References: <20071002150013.GA6023@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60644 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756170AbXJBTFO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Oct 2007 15:05:14 -0400
Content-Disposition: inline
In-Reply-To: <20071002150013.GA6023@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-10-02 19:00:13 [+0400]:

>DES currently does not pass tcrypt's multipage test, since HIFN adapter 
>can not work with non-blocksize aligned chunks, although crypto alignmask 
>is set to 3, tcrypt provides a block of size 2 in its multipage test, 
>which fails.
I recalled now that I forgot to point this out. You set the align mask to
the block size of the algorithm but it is almost unused / useless.
Let me explain:
- it is ensured that the key you get (in the setkey function) is
  properly aligned. This doesn't matter in your case because you
  memcpy() the key away to your private struct.
- your private struct is pointer aligned (if I remember correctly). You
  memcpy() your key away so it looks like you don't need the ctx
  aligned according to your mask (but it would be possible :))
- the proper alignment of src, dst and the IV that you get is _not_
  ensured. This would be the case if you would develop a blkcipher and
  use blkcipher_walk_init(), blkcipher_walk_virt(), .... 

Now. If you pass your AES-tcrypt-test (where you need 16 bytes alignment)
than this is pure luck. If you really need aligned src,dst or the IV
than you have to do it by yourself :(

The alignment for blkcipher (crypto/blkcipher.c) is enforced via
- blkcipher_walk_first() by calling blkcipher_copy_iv() for the IV
- blkcipher_walk_next() (and later) for the src/dst addr

Herbert: maybe we should remove the alignment in tcrypt.h (and make it
unaligned on purpose) so we can test if the crypto API is enforcing the
required alignment properly as well as the HW drivers.

Sebastian
