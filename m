From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 00/13] crypto: caam - fixes, clean-up
Date: Mon, 10 Jul 2017 08:40:26 +0300
Message-ID: <20170710054039.21555-1-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0068.outbound.protection.outlook.com ([104.47.38.68]:50176
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751148AbdGJFlI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 01:41:08 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[
Change log:
v1 -> v2
-patch 05/13 - add missing check in ablkcipher_giv_edesc_alloc(),
to make sure number of reserved S/G entries is not overflown
-patch 12/13 - fix author - replace my Freescale address with
corresponding NXP one
]

Hi,

Current patch set consists of:

Patches 1-4 fix some issues in caam/qi driver;
they should be sent to -stable.

Patches 5-7 also fix some problems in caam/qi driver, however these are
ARM-specific. Considering that caam/qi does not have support for ARM in
kernel v4.12 (lacking one dependency - Queue Manager), there's no need
to be applied on v4.12.y.

Patches 8-13 contain code clean-up.

Thanks,
Horia

Horia Geantă (11):
  crypto: caam/qi - fix typo in authenc alg driver name
  crypto: caam/qi - fix compilation with DEBUG enabled
  crypto: caam/qi - fix compilation with
    CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
  crypto: caam/qi - properly set IV after {en,de}crypt
  crypto: caam/qi - handle large number of S/Gs case
  crypto: caam/qi - fix AD length endianness in S/G entry
  crypto: caam/qi - explicitly set dma_ops
  crypto: caam/qi - remove unused header sg_sw_sec4.h
  crypto: caam/qi - lower driver verbosity
  crypto: caam - remove unused sg_to_sec4_sg_len()
  crypto: caam - clean-up in caam_init_rng()

Tudor Ambarus (2):
  crypto: caam - remove unused variables in caam_drv_private
  crypto: caam - fix condition for the jump over key(s) command

 drivers/crypto/caam/caamalg.c      | 66 +++++++++-----------------------------
 drivers/crypto/caam/caamalg_desc.c |  5 ++-
 drivers/crypto/caam/caamalg_qi.c   | 55 ++++++++++++++++++++++++++-----
 drivers/crypto/caam/caamrng.c      |  6 +---
 drivers/crypto/caam/ctrl.c         |  1 -
 drivers/crypto/caam/error.c        | 40 +++++++++++++++++++++++
 drivers/crypto/caam/error.h        |  4 +++
 drivers/crypto/caam/intern.h       |  3 --
 drivers/crypto/caam/qi.c           | 14 ++++----
 drivers/crypto/caam/qi.h           |  3 ++
 drivers/crypto/caam/sg_sw_sec4.h   | 15 ---------
 11 files changed, 118 insertions(+), 94 deletions(-)

-- 
2.12.0.264.gd6db3f216544
