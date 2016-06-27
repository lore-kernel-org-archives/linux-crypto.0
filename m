From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.7
Date: Mon, 27 Jun 2016 14:28:19 +0800
Message-ID: <20160627062819.GA6284@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160520084105.GA3959@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes the following issue:

- Missing length check for user-space GETALG request.
- Bogus memmove length in ux500 driver.
- Incorrect priority setting for vmx driver.
- Incorrect ABI selection for vmx driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Anton Blanchard (2):
      crypto: vmx - Fix ABI detection
      crypto: vmx - Increase priority of aes-cbc cipher

Linus Walleij (1):
      crypto: ux500 - memmove the right size

Mathias Krause (1):
      crypto: user - re-add size check for CRYPTO_MSG_GETALG

 crypto/crypto_user.c                  |    1 +
 drivers/crypto/ux500/hash/hash_core.c |    4 ++--
 drivers/crypto/vmx/aes_cbc.c          |    2 +-
 drivers/crypto/vmx/aes_ctr.c          |    2 +-
 drivers/crypto/vmx/ppc-xlate.pl       |    2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
