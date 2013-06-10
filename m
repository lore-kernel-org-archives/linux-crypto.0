From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 3.10
Date: Mon, 10 Jun 2013 17:05:44 +0800
Message-ID: <20130610090544.GA13465@gondor.apana.org.au>
References: <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20130528055229.GA23937@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:41828 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751910Ab3FJJFu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Jun 2013 05:05:50 -0400
Content-Disposition: inline
In-Reply-To: <20130528055229.GA23937@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a build problem in sahara and temporarily disables
two new optimisations because of performance regressions until a
permanent fix is ready.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Arnd Bergmann (1):
      crypto: sahara - fix building as module

Jussi Kivilinna (2):
      crypto: twofish - disable AVX2 implementation
      crypto: blowfish - disable AVX2 implementation

 crypto/Kconfig          |    2 ++
 drivers/crypto/sahara.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
