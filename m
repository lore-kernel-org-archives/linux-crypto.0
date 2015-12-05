From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.4
Date: Sat, 5 Dec 2015 09:04:25 +0800
Message-ID: <20151205010425.GA21859@gondor.apana.org.au>
References: <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
 <20151026110247.GA20464@gondor.apana.org.au>
 <20151111070818.GA22344@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151111070818.GA22344@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a couple of crypto drivers that were using memcmp
to verify authentication tags.  They now use crypto_memneq instead.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


David Gstir (2):
      crypto: nx - Fix timing leak in GCM and CCM decryption
      crypto: talitos - Fix timing leak in ESP ICV verification

 drivers/crypto/nx/nx-aes-ccm.c |    2 +-
 drivers/crypto/nx/nx-aes-gcm.c |    3 ++-
 drivers/crypto/talitos.c       |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
