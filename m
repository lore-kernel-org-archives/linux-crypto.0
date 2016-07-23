From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.7
Date: Sat, 23 Jul 2016 11:10:57 +0800
Message-ID: <20160723031057.GA25061@gondor.apana.org.au>
References: <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160513055902.GA13595@gondor.apana.org.au>
 <20160520084105.GA3959@gondor.apana.org.au>
 <20160722033900.GA16972@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160722033900.GA16972@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a sporadic build failure in the qat driver as well
as a memory corruption bug in rsa-pkcs1pad.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: rsa-pkcs1pad - fix rsa-pkcs1pad request struct

Jan Stancek (1):
      crypto: qat - make qat_asym_algs.o depend on asn1 headers

 crypto/rsa-pkcs1pad.c                  |    4 ++--
 drivers/crypto/qat/qat_common/Makefile |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
