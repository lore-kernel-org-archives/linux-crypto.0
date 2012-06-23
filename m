From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 00/20] crypto: caam - driver updates
Date: Fri, 22 Jun 2012 19:42:34 -0500
Message-ID: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:51003
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756648Ab2FWAo4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:44:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following updates bring the upstream CAAM driver mostly up to date wrt
Freescale's SDK 1.2 release:

patch 1 is a cosmetic fix

patch 2 is a mapping size fix

patches 3-5 are protocol descriptor generation updates (not currently used
in the kernel driver, but these header files are shared with other projects in
the SDK; hope that's ok).

patches 6-9 refactor code in preparation for ahash and hwrng support; and
patch 7 removes the job ring registration interface in favour of user-managed
selection and sharing of rings (see caam_rng_init, which simply chooses
job ring 0 for all its operations).

patches 10-12 add ahash support (keyed and unkeyed)

patch 13 adds hwrng support

patches 14-15 add support for the SEC v5.x series, which most notably gets a
new RNG (tested on P5040 h/w)

patches 16-20 contain various performance improvements

There are two patches remaining in the SDK that I'm holding off for now,
as I believe they need more testing: use NAPI instead of tasklet, and
set descriptor sharing type to SERIAL.

Since the ahash support patch is quite large, and I have no way of telling
if it'll make the list, I've pushed the entire patchseries to a git tree based
on Herbert's cryptodev tree:

  git://git.freescale.com/crypto/cryptodev.git master

So if a patch doesn't make it, please fetch it from the tree in order to
review (or suggest an alternative method of submitting these large changes).

Thanks to everyone that contributed to this patchseries,

Cheers,

Kim

Hemant Agrawal (1):
  crypto: caam - add PDB (Protocol Descriptor Block) definitions

Kim Phillips (10):
  crypto: caam - remove line continuations from
    ablkcipher_append_src_dst
  crypto: caam - fix input job ring element dma mapping size
  crypto: caam - fix descriptor length adjustments for protocol
    descriptors
  crypto: caam - assign 40-bit masks on SEC v5.0 and above
  crypto: caam - add support for SEC v5.x RNG4
  crypto: caam - disable IRQ coalescing by default
  crypto: caam - use non-irq versions of spinlocks for job rings
  crypto: caam - only query h/w in job ring dequeue path
  crypto: caam - consolidate memory barriers from job ring en/dequeue
  crypto: caam - one tasklet per job ring

Yashpal Dutta (1):
  crypto: caam - fix start index for Protocol shared descriptors

Yuan Kang (8):
  crypto: caam - support external seq in/out lengths
  crypto: caam - remove jr register/deregister
  crypto: caam - refactor key_gen, sg
  crypto: caam - link_tbl rename
  crypto: caam - ahash hmac support
  crypto: caam - unkeyed ahash support
  crypto: caam - chaining support
  crypto: caam - hwrng support

 drivers/crypto/caam/Kconfig       |   30 +-
 drivers/crypto/caam/Makefile      |    4 +-
 drivers/crypto/caam/caamalg.c     |  572 ++++-------
 drivers/crypto/caam/caamhash.c    | 1878 +++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/caamrng.c     |  309 ++++++
 drivers/crypto/caam/compat.h      |    2 +
 drivers/crypto/caam/ctrl.c        |  138 ++-
 drivers/crypto/caam/desc.h        |   31 +-
 drivers/crypto/caam/desc_constr.h |   57 +-
 drivers/crypto/caam/error.c       |   44 +-
 drivers/crypto/caam/intern.h      |    6 +-
 drivers/crypto/caam/jr.c          |   80 +-
 drivers/crypto/caam/key_gen.c     |  122 +++
 drivers/crypto/caam/key_gen.h     |   17 +
 drivers/crypto/caam/pdb.h         |  401 ++++++++
 drivers/crypto/caam/regs.h        |   32 +-
 drivers/crypto/caam/sg_sw_sec4.h  |  156 +++
 17 files changed, 3415 insertions(+), 464 deletions(-)
 create mode 100644 drivers/crypto/caam/caamhash.c
 create mode 100644 drivers/crypto/caam/caamrng.c
 create mode 100644 drivers/crypto/caam/key_gen.c
 create mode 100644 drivers/crypto/caam/key_gen.h
 create mode 100644 drivers/crypto/caam/pdb.h
 create mode 100644 drivers/crypto/caam/sg_sw_sec4.h

-- 
1.7.11.1
