From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.6
Date: Mon, 25 Apr 2016 19:12:06 +0800
Message-ID: <20160425111206.GA10009@gondor.apana.org.au>
References: <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160330091150.GA17143@gondor.apana.org.au>
 <20160414062535.GA19807@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42848 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbcDYLM0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 07:12:26 -0400
Content-Disposition: inline
In-Reply-To: <20160414062535.GA19807@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a couple of regressions in the talitos driver
that were introduced back in 4.3.  The first bug causes a crash
when the driver's AEAD functionality is used while the second
bug prevents its AEAD feature from working once you get past the
first bug.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Horia Geant? (1):
      crypto: talitos - fix AEAD tcrypt tests

Jonas Eymann (1):
      crypto: talitos - fix crash in talitos_cra_init()

 drivers/crypto/talitos.c |   87 ++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 30 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
