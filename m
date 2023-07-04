Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F362DC001B0
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 17:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjGDRd5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 13:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjGDRdx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 13:33:53 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4C710D9;
        Tue,  4 Jul 2023 10:33:52 -0700 (PDT)
Received: from ipservice-092-217-072-126.092.217.pools.vodafone-ip.de ([92.217.72.126] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qGjuP-0000yT-52; Tue, 04 Jul 2023 19:33:49 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Joshua Henderson <joshua.henderson@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 3/4] hwrng: pic32 - remove unused defines
Date:   Tue,  4 Jul 2023 19:32:02 +0200
Message-Id: <20230704173203.70706-4-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230704173203.70706-1-martin@kaiser.cx>
References: <20230704173203.70706-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove some unused defines and fix the indentation.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/pic32-rng.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/pic32-rng.c b/drivers/char/hw_random/pic32-rng.c
index e04a054e8930..c1b3f5915f03 100644
--- a/drivers/char/hw_random/pic32-rng.c
+++ b/drivers/char/hw_random/pic32-rng.c
@@ -19,19 +19,12 @@
 #include <linux/slab.h>
 
 #define RNGCON		0x04
-#define  TRNGEN		BIT(8)
-#define  PRNGEN		BIT(9)
-#define  PRNGCONT	BIT(10)
-#define  TRNGMOD	BIT(11)
-#define  SEEDLOAD	BIT(12)
-#define RNGPOLY1	0x08
-#define RNGPOLY2	0x0C
-#define RNGNUMGEN1	0x10
-#define RNGNUMGEN2	0x14
+#define TRNGEN		BIT(8)
+#define TRNGMOD		BIT(11)
 #define RNGSEED1	0x18
 #define RNGSEED2	0x1C
 #define RNGRCNT		0x20
-#define  RCNT_MASK	0x7F
+#define RCNT_MASK	0x7F
 
 struct pic32_rng {
 	void __iomem	*base;
-- 
2.30.2

