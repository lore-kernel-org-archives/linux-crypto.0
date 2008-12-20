From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Sat, 20 Dec 2008 14:21:59 +1100
Message-ID: <20081220032159.GA15615@gondor.apana.org.au>
References: <20081219202603.GA31265@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51563 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbYLTDWD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Dec 2008 22:22:03 -0500
Content-Disposition: inline
In-Reply-To: <20081219202603.GA31265@lst.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 19, 2008 at 08:26:03PM +0000, Christoph Hellwig wrote:
> On my new thinkpad with a Intel Core2 Duo T9600 I reproducibly get
> this message during boot:
> 
> [    0.657034] alg: cipher: Test 1 failed on encryption for aes-asm
> [    0.657111] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 

The correct output should be

		.result = "\x69\xc4\xe0\xd8\x6a\x7b\x04\x30"
			  "\xd8\xcd\xb7\x80\x70\xb4\xc5\x5a",

> I'd assume it's not a hardware but, so my the assembly code doesn't
> like the debian toolchain?  It's
> 
> 	binutils 2.18.1~cvs20080103-7
> 	gcc 4.3.2-1
> 
> (all the Debian package versions)

Weird.  I've got exactly the same versions as you, using yesterday's
Linus git tree, and it works just fine on a Core 2 Quad Q6600.  From
/proc/crypto after boot:

name         : aes
driver       : aes-asm
module       : aes_x86_64
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : aes
driver       : aes-generic
module       : aes_generic
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

Are you in 64-bit mode or legacy mode? I'm in 64.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
