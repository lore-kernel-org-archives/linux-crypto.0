Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBA1C0651F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 15:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD62021852
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 15:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfGDPiT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 11:38:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59377 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfGDPiS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 11:38:18 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hj3oF-0004wg-Hd; Thu, 04 Jul 2019 17:38:07 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/7] crypto: ux500: Use spinlock_t instead of struct spinlock
Date:   Thu,  4 Jul 2019 17:37:57 +0200
Message-Id: <20190704153803.12739-2-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704153803.12739-1-bigeasy@linutronix.de>
References: <20190704153803.12739-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For spinlocks the type spinlock_t should be used instead of "struct
spinlock".

Use spinlock_t for spinlock's definition.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/crypto/ux500/cryp/cryp.h     | 4 ++--
 drivers/crypto/ux500/hash/hash_alg.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp.h b/drivers/crypto/ux500/cryp/cryp.h
index bd89504e81678..8da7f87b339b4 100644
--- a/drivers/crypto/ux500/cryp/cryp.h
+++ b/drivers/crypto/ux500/cryp/cryp.h
@@ -241,12 +241,12 @@ struct cryp_device_data {
 	struct clk *clk;
 	struct regulator *pwr_regulator;
 	int power_status;
-	struct spinlock ctx_lock;
+	spinlock_t ctx_lock;
 	struct cryp_ctx *current_ctx;
 	struct klist_node list_node;
 	struct cryp_dma dma;
 	bool power_state;
-	struct spinlock power_state_spinlock;
+	spinlock_t power_state_spinlock;
 	bool restore_dev_ctx;
 };
 
diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index ab2bd00c1c365..7c9bcc15125ff 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -366,10 +366,10 @@ struct hash_device_data {
 	phys_addr_t             phybase;
 	struct klist_node	list_node;
 	struct device		*dev;
-	struct spinlock		ctx_lock;
+	spinlock_t		ctx_lock;
 	struct hash_ctx		*current_ctx;
 	bool			power_state;
-	struct spinlock		power_state_lock;
+	spinlock_t		power_state_lock;
 	struct regulator	*regulator;
 	struct clk		*clk;
 	bool			restore_dev_state;
-- 
2.20.1

