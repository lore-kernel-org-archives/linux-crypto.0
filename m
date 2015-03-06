From: <yanjiang.jin@windriver.com>
Subject: [V3 PATCH 0/2]  fix some CAAM warnings.
Date: Fri, 6 Mar 2015 10:34:40 +0800
Message-ID: <1425609282-16568-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <ruchika.gupta@freescale.com>, <cristian.stoica@freescale.com>,
	<NiteshNarayanLal@freescale.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jinyanjiang@gmail.com>
To: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:62329 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbCFCe4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 21:34:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yanjiang Jin <yanjiang.jin@windriver.com>

Hi,

This patch series fix some CAAM compile and runtime warnings.

I have tested this on fsl-p5020ds board using upstream 4.0.0-rc2 with the below configs:

CONFIG_DMA_API_DEBUG=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set

Change log:
v3:

0001-crypto-caamhash-fix-uninitialized-edesc-sec4_sg_byte.patch is same as before.

For 0002-crypto-caam_rng-fix-rng_unmap_ctx-s-DMA_UNMAP-size-p.patch
1. Fix an alignment issue;
2. update DESC_RNG_LEN to (4 * CAAM_CMD_SZ).

Abandon the v2 patch 0001-crypto-caam-fix-some-compile-warnings.patch.

Yanjiang Jin (2):
  crypto: caamhash: - fix uninitialized edesc->sec4_sg_bytes field
  crypto: caam_rng: fix rng_unmap_ctx's DMA_UNMAP size problem

 drivers/crypto/caam/caamhash.c | 1 +
 drivers/crypto/caam/caamrng.c  | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
1.9.1
