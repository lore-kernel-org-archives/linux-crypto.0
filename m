From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.4
Date: Mon, 28 Dec 2015 21:26:25 +0800
Message-ID: <20151228132625.GA31900@gondor.apana.org.au>
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

This push fixes a bug in the algif_skcipher interface that can
trigger a kernel WARN_ON from user-space.  It does so by using
the new skcipher interface which unlike the previous ablkcipher
does not need to create extra geniv objects which is what was
used to trigger the WARN_ON.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: algif_skcipher - Use new skcipher interface

 crypto/algif_skcipher.c |   61 +++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
