From: <yanjiang.jin@windriver.com>
Subject: [PATCH 0/3] fix some CAAM warnings.
Date: Tue, 3 Mar 2015 14:50:50 +0800
Message-ID: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:56799 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbbCCGvJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 01:51:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yanjiang Jin <yanjiang.jin@windriver.com>

Hi,

This patch series  fix some CAAM compile and runtime warnings.
The patches 0001 and 0002 are same as V1.

I have tested this on fsl-p5020ds board using upstream 4.0.0-rc1+ with the below configs:

CONFIG_DMA_API_DEBUG=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set

Change log:
v2:

Abandon the v1 patch 0003-crypto-caamhash-add-two-missed-dma_mapping_error.patch.
Replace the v1 patch 0004-crypto-caamhash-replace-kmalloc-with-kzalloc.patch with the new
patch 0003-crypto-caamhash-fix-uninitialized-edesc-sec4_sg_byte.patch.

Yanjiang Jin (3):
  crypto: caam: fix some compile warnings
  crypto: caam_rng: fix rng_unmap_ctx's DMA_UNMAP size problem
  crypto: caamhash: - fix uninitialized edesc->sec4_sg_bytes field

 drivers/crypto/caam/caamhash.c   | 1 +
 drivers/crypto/caam/caamrng.c    | 4 ++--
 drivers/crypto/caam/sg_sw_sec4.h | 8 ++++----
 3 files changed, 7 insertions(+), 6 deletions(-)

-- 
1.9.1
