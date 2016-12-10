From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.9
Date: Sat, 10 Dec 2016 14:01:07 +0800
Message-ID: <20161210060107.GA28083@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161205063754.GA9408@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161205063754.GA9408@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes the following issues:

- Fix pointer size when caam is used with AArch64 boot loader on
  AArch32 kernel.
- Fix ahash state corruption in marvell driver.
- Fix buggy algif_aed tag handling.
- Prevent mcryptd from being used with incompatible algorithms
  which can cause crashes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Horia Geantă (1):
      crypto: caam - fix pointer size for AArch64 boot loader, AArch32 kernel

Romain Perier (2):
      crypto: marvell - Don't copy hash operation twice into the SRAM
      crypto: marvell - Don't corrupt state of an STD req for re-stepped ahash

Stephan Mueller (2):
      crypto: algif_aead - fix AEAD tag memory handling
      crypto: algif_aead - fix uninitialized variable warning

tim (1):
      crypto: mcryptd - Check mcryptd algorithm compatibility

 crypto/algif_aead.c           |   59 ++++++++++++++++++++++++++---------------
 crypto/mcryptd.c              |   19 ++++++++-----
 drivers/crypto/caam/ctrl.c    |    5 ++--
 drivers/crypto/marvell/hash.c |   11 ++++----
 4 files changed, 57 insertions(+), 37 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
