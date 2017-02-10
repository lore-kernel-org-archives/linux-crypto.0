From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 00/12] crypto: caam - fixes
Date: Fri, 10 Feb 2017 14:07:13 +0200
Message-ID: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "Cristian Stoica" <cristian.stoica@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0080.outbound.protection.outlook.com ([104.47.34.80]:30688
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752040AbdBJMHp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:07:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This batch consists mostly of DMA API related fixes and simplifications.

Since no no arch calls:
dma_debug_add_bus(&platform_bus_type);
DMA API debugging does not have the chance to report leaks when modules
are removed.

I am not sure why dma_debug_add_bus() is not used for the platform bus,
however when I did that for testing purposes, I could notice quite a few
problems in caam driver.

Thanks,
Horia

Horia Geantă (11):
  crypto: caam - don't include unneeded headers
  crypto: caam - check return code of dma_set_mask_and_coherent()
  crypto: caam - fix HW S/G in ablkcipher_giv_edesc_alloc()
  crypto: caam - check sg_count() return value
  crypto: caam - replace sg_count() with sg_nents_for_len()
  crypto: caam - use dma_map_sg() return code
  crypto: caam - don't dma_map key for hash algorithms
  crypto: caam - fix DMA API leaks for multiple setkey() calls
  crypto: caam - fix error path for ctx_dma mapping failure
  crypto: caam - abstract ahash request double buffering
  crypto: caam - fix state buffer DMA (un)mapping

Tudor Ambarus (1):
  crypto: caam - fix JR IO mapping if one fails

 drivers/crypto/caam/caamalg.c    | 589 ++++++++++++++++-----------------------
 drivers/crypto/caam/caamhash.c   | 268 +++++++++---------
 drivers/crypto/caam/ctrl.c       |  33 ++-
 drivers/crypto/caam/error.c      |   2 -
 drivers/crypto/caam/jr.c         |  19 +-
 drivers/crypto/caam/sg_sw_sec4.h |  11 -
 6 files changed, 407 insertions(+), 515 deletions(-)

-- 
2.4.4
