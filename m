From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 15/17] crypto: talitos - SEC1 bugs on 0 data hash
Date: Fri, 17 Apr 2015 16:32:18 +0200 (CEST)
Message-ID: <20150417143218.110F81A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SEC1 bugs on 0 data hash, so we submit an already padded block representing 0 data

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dddf4b3..f1406d7b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1797,6 +1797,27 @@ static void ahash_done(struct device *dev,
 	areq->base.complete(&areq->base, err);
 }
 
+/*
+ * SEC1 doesn't like hashing of 0 sized message, so we do the padding
+ * ourself and submit a padded block
+ */
+void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
+			       struct talitos_edesc *edesc,
+			       struct talitos_ptr *ptr)
+{
+	static u8 padded_hash[64] = {
+		0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	};
+
+	pr_err_once("Bug in SEC1, padding ourself\n");
+	edesc->desc.hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
+	map_single_talitos_ptr(ctx->dev, ptr, sizeof(padded_hash),
+			       (char *)padded_hash, DMA_TO_DEVICE);
+}
+
 static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				struct ahash_request *areq, unsigned int length,
 				void (*callback) (struct device *dev,
@@ -1857,6 +1878,9 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
 
+	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
+		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
+
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
-- 
2.1.0
