Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50736 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729844AbfAONni (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 08:43:38 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Hadar Gat <hadar.gat@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] crypto: ccree: add error message
Date: Tue, 15 Jan 2019 15:43:12 +0200
Message-Id: <20190115134318.28712-3-gilad@benyossef.com>
In-Reply-To: <20190115134318.28712-1-gilad@benyossef.com>
References: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Hadar Gat <hadar.gat@arm.com>

Add error message in case of too many mlli entries.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 32d2df36ced2..237a87a57830 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -156,8 +156,11 @@ static int cc_render_buff_to_mlli(struct device *dev, dma_addr_t buff_dma,
 
 	/* Verify there is no memory overflow*/
 	new_nents = (*curr_nents + buff_size / CC_MAX_MLLI_ENTRY_SIZE + 1);
-	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES)
+	if (new_nents > MAX_NUM_OF_TOTAL_MLLI_ENTRIES) {
+		dev_err(dev, "Too many mlli entries. current %d max %d\n",
+			new_nents, MAX_NUM_OF_TOTAL_MLLI_ENTRIES);
 		return -ENOMEM;
+	}
 
 	/*handle buffer longer than 64 kbytes */
 	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE) {
-- 
2.20.1
