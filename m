From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 16/17] crypto: talitos - SEC1 bugs on 0 data hash
Date: Thu,  5 Mar 2015 17:46:07 +0100 (CET)
Message-ID: <20150305164607.554531A242A@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SEC1 bugs on 0 data hash, so we submit an already padded block representing 0 data

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c  |  3 +++
 drivers/crypto/talitos1.c | 21 +++++++++++++++++++++
 drivers/crypto/talitos1.h |  4 ++++
 drivers/crypto/talitos2.h |  6 ++++++
 4 files changed, 34 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 112a25a..464338c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -817,6 +817,9 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	to_talitos_next_desc_clear(desc);
 
+	if (desc->ptr[3].len == 0)
+		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
+
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
diff --git a/drivers/crypto/talitos1.c b/drivers/crypto/talitos1.c
index c1a8e9e..1edaa68 100644
--- a/drivers/crypto/talitos1.c
+++ b/drivers/crypto/talitos1.c
@@ -174,3 +174,24 @@ void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 		talitos_init_device(dev);
 	}
 }
+
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
+			       (char *)padded_hash, 0, DMA_TO_DEVICE);
+}
diff --git a/drivers/crypto/talitos1.h b/drivers/crypto/talitos1.h
index f78d89d..a9e0619 100644
--- a/drivers/crypto/talitos1.h
+++ b/drivers/crypto/talitos1.h
@@ -277,6 +277,10 @@ static inline void ahash_process_chain(struct scatterlist *src, int nbytes,
 	}
 }
 
+extern void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
+			       struct talitos_edesc *edesc,
+			       struct talitos_ptr *ptr);
+
 #define DEF_TALITOS_DONE(name, ch_done_mask)				\
 static void talitos_done_##name(unsigned long data)			\
 {									\
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
index 2715c72..de0c8f4 100644
--- a/drivers/crypto/talitos2.h
+++ b/drivers/crypto/talitos2.h
@@ -266,6 +266,12 @@ static inline void ahash_process_chain(struct scatterlist *src, int nbytes,
 		req_ctx->psrc = src;
 }
 
+static inline void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
+			       struct talitos_edesc *edesc,
+			       struct talitos_ptr *ptr)
+{
+}
+
 #define DEF_TALITOS_DONE(name, ch_done_mask)				\
 static void talitos_done_##name(unsigned long data)			\
 {									\
-- 
2.1.0
