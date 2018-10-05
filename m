From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.19
Date: Fri, 5 Oct 2018 10:08:30 +0800
Message-ID: <20181005020830.sy6xjsbdvtdqrtxr@gondor.apana.org.au>
References: <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20180919062201.ov5o4vljvholgsed@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180919062201.ov5o4vljvholgsed@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Greg: 

This push fixes the following issues:

- Out-of-bound stack access in qat.
- Illegal schedule in mxs-dcp.
- Memory corruption in chelsio.
- Incorrect pointer computation in caam.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Harsh Jain (1):
      crypto: chelsio - Fix memory corruption in DMA Mapped buffers.

Horia Geantă (1):
      crypto: caam/jr - fix ablkcipher_edesc pointer arithmetic

Leonard Crestez (1):
      crypto: mxs-dcp - Fix wait logic on chan threads

Waiman Long (1):
      crypto: qat - Fix KASAN stack-out-of-bounds bug in adf_probe()

 drivers/crypto/caam/caamalg.c               |  8 ++---
 drivers/crypto/chelsio/chcr_algo.c          | 32 +++++++++++------
 drivers/crypto/chelsio/chcr_crypto.h        |  2 ++
 drivers/crypto/mxs-dcp.c                    | 53 ++++++++++++++++-------------
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      |  6 ++--
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    |  6 ++--
 drivers/crypto/qat/qat_c62x/adf_drv.c       |  6 ++--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     |  6 ++--
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   |  6 ++--
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c |  6 ++--
 10 files changed, 76 insertions(+), 55 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
