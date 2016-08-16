From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.8
Date: Tue, 16 Aug 2016 16:48:58 +0800
Message-ID: <20160816084858.GA26480@gondor.apana.org.au>
References: <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160513055902.GA13595@gondor.apana.org.au>
 <20160520084105.GA3959@gondor.apana.org.au>
 <20160627062819.GA6284@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160627062819.GA6284@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes the following issue:

- Missing ULL suffixes for 64-bit constants in sha3.
- Two caam AEAD regressions.
- Bogus setkey hooks in non-hmac caam hashes.
- Missing kbuild dependency for powerpc crc32c.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Geert Uytterhoeven (1):
      crypto: sha3 - Add missing ULL suffixes for 64-bit constants

Horia Geantă (2):
      crypto: caam - fix echainiv(authenc) encrypt shared descriptor
      crypto: caam - defer aead_set_sh_desc in case of zero authsize

Michael Ellerman (1):
      crypto: powerpc - CRYPT_CRC32C_VPMSUM should depend on ALTIVEC

Russell King (1):
      crypto: caam - fix non-hmac hashes

 crypto/Kconfig                 |    2 +-
 crypto/sha3_generic.c          |   16 ++++++++--------
 drivers/crypto/caam/caamalg.c  |   13 ++++++++-----
 drivers/crypto/caam/caamhash.c |    1 +
 4 files changed, 18 insertions(+), 14 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
