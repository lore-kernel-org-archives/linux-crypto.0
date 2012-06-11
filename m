From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.5
Date: Mon, 11 Jun 2012 22:00:27 +0900
Message-ID: <20120611130027.GA6407@gondor.apana.org.au>
References: <20100716022648.GA28219@gondor.apana.org.au>
 <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120322012046.GA8854@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59093 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286Ab2FKNAg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jun 2012 09:00:36 -0400
Content-Disposition: inline
In-Reply-To: <20120322012046.GA8854@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes an unaligned fault on x86-32 with aesni-intel
and an RNG failure with atmel-rng (repeated bits).


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Mathias Krause (1):
      crypto: aesni-intel - fix unaligned cbc decrypt for x86-32

Peter Korsgaard (1):
      hwrng: atmel-rng - fix race condition leading to repeated bits

 arch/x86/crypto/aesni-intel_asm.S  |    6 ++++--
 drivers/char/hw_random/atmel-rng.c |    7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
