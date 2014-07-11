From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 00/10] CAAM - DMA API fixes
Date: Fri, 11 Jul 2014 15:34:45 +0300
Message-ID: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:48258
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751493AbaGKMfs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 08:35:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Enabling DMA-API debugging reveals quite a lot of problems in CAAM module.
Patches below fix them - tested on P3041DS QorIQ platform. Please apply.

(I haven't seen any crashes so far, thus patches are based on cryptodev -
not on crypto - and I'm not queueing them to -stable.)

Thanks,
Horia

Horia Geanta (10):
  crypto: testmgr - avoid DMA mapping from text, rodata, stack
  crypto: caam - set coherent_dma_mask
  crypto: caam - fix typo in dma_mapping_error
  crypto: caam - fix "failed to check map error" DMA warnings
  crypto: caam - fix DMA unmapping error in hash_digest_key
  crypto: caam - fix DMA direction mismatch in ahash_done_ctx_dst
  crypto: caam - fix DMA direction mismatch in ahash_done_ctx_src
  crypto: caam - fix uninitialized S/G table size in ahash_digest
  crypto: caam - fix uninitialized edesc->dst_dma field
  crypto: caam - fix uninitialized state->buf_dma field

 crypto/testmgr.c               |  57 +++++++++++++++++---
 crypto/testmgr.h               |   2 +-
 drivers/crypto/caam/caamalg.c  |  36 +++++++++++--
 drivers/crypto/caam/caamhash.c | 118 ++++++++++++++++++++++++++++++++++-------
 drivers/crypto/caam/caamrng.c  |  51 ++++++++++++++----
 drivers/crypto/caam/ctrl.c     |   6 +--
 drivers/crypto/caam/jr.c       |   6 +--
 7 files changed, 228 insertions(+), 48 deletions(-)

-- 
1.8.3.1
