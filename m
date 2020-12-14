Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB6FC2BB48
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 16:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DAB322583
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 16:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbgLNQGW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:06:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440057AbgLNQFn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 11:05:43 -0500
From:   matthias.bgg@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     mpm@selenic.com, herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, f.fainelli@gmail.com
Cc:     linux-kernel@vger.kernel.org, Julia.Lawall@inria.fr,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 1/2] hwrng: iproc-rng200: Fix disable of the block.
Date:   Mon, 14 Dec 2020 17:04:53 +0100
Message-Id: <20201214160454.22769-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

When trying to disable the block we bitwise or the control
register with value zero. This will leave the block always turned on.
Fix this by setting the corresponding bit to zero.

Fixes: c83d45d5685f ("hwrng: iproc-rng200 - Add Broadcom IPROC RNG driver")
Signed-off-by: Matthias Brugger <mbrugger@suse.com>
---

 drivers/char/hw_random/iproc-rng200.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 01583faf9893..e106ce3c0146 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -28,7 +28,6 @@
 #define RNG_CTRL_OFFSET					0x00
 #define RNG_CTRL_RNG_RBGEN_MASK				0x00001FFF
 #define RNG_CTRL_RNG_RBGEN_ENABLE			0x00000001
-#define RNG_CTRL_RNG_RBGEN_DISABLE			0x00000000
 
 #define RNG_SOFT_RESET_OFFSET				0x04
 #define RNG_SOFT_RESET					0x00000001
@@ -61,7 +60,7 @@ static void iproc_rng200_restart(void __iomem *rng_base)
 	/* Disable RBG */
 	val = ioread32(rng_base + RNG_CTRL_OFFSET);
 	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
-	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
+	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
 	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
 
 	/* Clear all interrupt status */
@@ -174,7 +173,7 @@ static void iproc_rng200_cleanup(struct hwrng *rng)
 	/* Disable RNG hardware */
 	val = ioread32(priv->base + RNG_CTRL_OFFSET);
 	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
-	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
+	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
 	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
 }
 
-- 
2.29.2

