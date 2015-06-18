From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.1
Date: Thu, 18 Jun 2015 11:43:53 +0800
Message-ID: <20150618034353.GA27456@gondor.apana.org.au>
References: <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20141231033217.GA27261@gondor.apana.org.au>
 <20150107021737.GA25043@gondor.apana.org.au>
 <20150425080310.GA6873@gondor.apana.org.au>
 <20150505100621.GA8678@gondor.apana.org.au>
 <20150511055608.GA2055@gondor.apana.org.au>
 <20150520065441.GA8330@gondor.apana.org.au>
 <20150522040559.GA30475@gondor.apana.org.au>
 <20150526084351.GA7377@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54721 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbbFRDoB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 23:44:01 -0400
Content-Disposition: inline
In-Reply-To: <20150526084351.GA7377@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

1) Crash in caam hash due to uninitialised buffer lengths.
2) Alignment issue in caam RNG that may lead to non-random output.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Steve Cornelius (2):
      crypto: caam - improve initalization for context state saves
      crypto: caam - fix RNG buffer cache alignment

 drivers/crypto/caam/caamhash.c |    2 ++
 drivers/crypto/caam/caamrng.c  |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
