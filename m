From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: crypto4xx: rename ce_ring_contol to ce_ring_control
Date: Fri, 21 Apr 2017 12:13:49 +0100
Message-ID: <20170421111349.4060-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52131 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034350AbdDULNz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 07:13:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial spelling mistake, missing r, rename to ce_ring_control

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/amcc/crypto4xx_core.c    | 2 +-
 drivers/crypto/amcc/crypto4xx_reg_def.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index d10b4ae5e0da..fdc83a2281ca 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -50,7 +50,7 @@
 static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 {
 	union ce_ring_size ring_size;
-	union ce_ring_contol ring_ctrl;
+	union ce_ring_control ring_ctrl;
 	union ce_part_ring_size part_ring_size;
 	union ce_io_threshold io_threshold;
 	u32 rand_num;
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index 46fe57c8f6eb..279b8725559f 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -180,7 +180,7 @@ union ce_ring_size {
 } __attribute__((packed));
 
 #define CRYPTO4XX_RING_CONTROL_OFFSET		0x54
-union ce_ring_contol {
+union ce_ring_control {
 	struct {
 		u32 continuous:1;
 		u32 rsv:5;
-- 
2.11.0
