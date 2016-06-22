From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 02/27] crypto: omap-sham: change queue size from 1 to 10
Date: Wed, 22 Jun 2016 16:23:35 +0300
Message-ID: <1466601840-18486-3-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41088 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbcFVNZK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:10 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change crypto queue size from 1 to 10 for omap SHA driver. This should
allow clients to enqueue requests more effectively to avoid serializing
whole crypto sequences, giving extra performance.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8831613..2b0a1bd 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -175,7 +175,7 @@ struct omap_sham_ctx {
 	struct omap_sham_hmac_ctx base[0];
 };
 
-#define OMAP_SHAM_QUEUE_LENGTH	1
+#define OMAP_SHAM_QUEUE_LENGTH	10
 
 struct omap_sham_algs_info {
 	struct ahash_alg	*algs_list;
-- 
1.9.1
