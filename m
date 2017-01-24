From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v2 0/2 ] Bug Fixes for 4.10
Date: Tue, 24 Jan 2017 10:34:31 +0530
Message-ID: <cover.1485233822.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:19557 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdAXFFK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2017 00:05:10 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series includes critical bug fixes

Atul Gupta (2):
  crypto:chcr- Fix panic on dma_unmap_sg
  crypto:chcr- Check device is allocated before use

 drivers/crypto/chelsio/chcr_algo.c   | 49 +++++++++++++++++++-----------------
 drivers/crypto/chelsio/chcr_core.c   | 18 ++++++-------
 drivers/crypto/chelsio/chcr_crypto.h |  3 +++
 3 files changed, 37 insertions(+), 33 deletions(-)

-- 
1.8.2.3
