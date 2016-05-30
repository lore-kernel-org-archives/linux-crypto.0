From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.7
Date: Mon, 30 May 2016 14:31:43 +0800
Message-ID: <20160530063143.GA4494@gondor.apana.org.au>
References: <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160513055902.GA13595@gondor.apana.org.au>
 <20160520084105.GA3959@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49274 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbcE3Gby (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 May 2016 02:31:54 -0400
Content-Disposition: inline
In-Reply-To: <20160520084105.GA3959@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Missing selection in public_key that may result in a build failure.
- Potential crash in error path in omap-sham.
- ccp AES XTS bug that affects requests larger than 4096.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Arnd Bergmann (1):
      crypto: public_key: select CRYPTO_AKCIPHER

Dan Carpenter (1):
      crypto: omap-sham - potential Oops on error in probe

Tom Lendacky (1):
      crypto: ccp - Fix AES XTS error for request sizes above 4096

 crypto/asymmetric_keys/Kconfig          |    1 +
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   17 ++++++++++++-----
 drivers/crypto/omap-sham.c              |    2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
