From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.2
Date: Mon, 13 Jul 2015 12:08:58 +0800
Message-ID: <20150713040858.GA7160@gondor.apana.org.au>
References: <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150630135135.GA24621@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150630135135.GA24621@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a duplicate dma_unmap_sg call in omap-des and
reentrancy bugs in the powerpc nx driver which may cause bogus
output or worse memory corruption.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: nx - Fix reentrancy bugs

Vutla, Lokesh (1):
      crypto: omap-des - Fix unmapping of dma channels

 drivers/crypto/nx/nx-aes-ccm.c  |    6 ++--
 drivers/crypto/nx/nx-aes-ctr.c  |    7 ++--
 drivers/crypto/nx/nx-aes-gcm.c  |   17 ++++++----
 drivers/crypto/nx/nx-aes-xcbc.c |   70 ++++++++++++++++++++++++---------------
 drivers/crypto/nx/nx-sha256.c   |   43 +++++++++++++-----------
 drivers/crypto/nx/nx-sha512.c   |   44 +++++++++++++-----------
 drivers/crypto/nx/nx.c          |    3 ++
 drivers/crypto/nx/nx.h          |   14 ++++++--
 drivers/crypto/omap-des.c       |    3 --
 9 files changed, 125 insertions(+), 82 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
