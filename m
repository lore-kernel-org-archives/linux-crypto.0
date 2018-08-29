From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.19
Date: Wed, 29 Aug 2018 11:33:53 +0800
Message-ID: <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
References: <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Check for the right CPU feature bit in sm4-ce on arm64.
- Fix scatterwalk WARN_ON in aes-gcm-ce on arm64.
- Fix unaligned fault in aesni on x86.
- Fix potential NULL pointer dereference on exit in chtls.
- Fix DMA mapping direction for RSA in caam.
- Fix error path return value for xts setkey in caam.
- Fix address endianness when DMA unmapping in caam.
- Fix sleep-in-atomic in vmx.
- Fix command corruption when queue is full in cavium/nitrox.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (2):
      crypto: arm64/sm4-ce - check for the right CPU feature bit
      crypto: arm64/aes-gcm-ce - fix scatterwalk API violation

Dave Watson (1):
      crypto: aesni - Use unaligned loads from gcm_context_data

Ganesh Goudar (1):
      crypto: chtls - fix null dereference chtls_free_uld()

Horia Geantă (3):
      crypto: caam/jr - fix descriptor DMA unmapping
      crypto: caam/qi - fix error path in xts setkey
      crypto: caam - fix DMA mapping direction for RSA forms 2 & 3

Ondrej Mosnacek (1):
      crypto: vmx - Fix sleep-in-atomic bugs

Srikanth Jampala (1):
      crypto: cavium/nitrox - fix for command corruption in queue full case with backlog submissions.

 arch/arm64/crypto/ghash-ce-glue.c            |   29 ++++++++---
 arch/arm64/crypto/sm4-ce-glue.c              |    2 +-
 arch/x86/crypto/aesni-intel_asm.S            |   66 +++++++++++++-------------
 drivers/crypto/caam/caamalg_qi.c             |    6 +--
 drivers/crypto/caam/caampkc.c                |   20 ++++----
 drivers/crypto/caam/jr.c                     |    3 +-
 drivers/crypto/cavium/nitrox/nitrox_dev.h    |    3 +-
 drivers/crypto/cavium/nitrox/nitrox_lib.c    |    1 +
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c |   57 ++++++++++++----------
 drivers/crypto/chelsio/chtls/chtls.h         |    5 ++
 drivers/crypto/chelsio/chtls/chtls_main.c    |    7 ++-
 drivers/crypto/vmx/aes_cbc.c                 |   30 ++++++------
 drivers/crypto/vmx/aes_xts.c                 |   21 +++++---
 13 files changed, 144 insertions(+), 106 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
