From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 6/8] omap-sham: hash-in-progress is stored in hw format
Date: Fri, 19 Nov 2010 16:04:27 +0200
Message-ID: <998b89448c54eb104ad961a174551b1d7d933e24.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hash-in-progress is now stored in hw format.
Only on final call, hash is converted to correct format.
Speedup copy procedure and will allow to use OMAP burst mode.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 85d6277..c8d30eb 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -204,24 +204,35 @@ static void omap_sham_copy_hash(struct ahash_request *req, int out)
 	u32 *hash = (u32 *)ctx->digest;
 	int i;
 
+	/* MD5 is almost unused. So copy sha1 size to reduce code */
+	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++) {
+		if (out)
+			hash[i] = omap_sham_read(ctx->dd,
+						SHA_REG_DIGEST(i));
+		else
+			omap_sham_write(ctx->dd,
+					SHA_REG_DIGEST(i), hash[i]);
+	}
+}
+
+static void omap_sham_copy_ready_hash(struct ahash_request *req)
+{
+	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
+	u32 *in = (u32 *)ctx->digest;
+	u32 *hash = (u32 *)req->result;
+	int i;
+
+	if (!hash)
+		return;
+
 	if (likely(ctx->flags & FLAGS_SHA1)) {
 		/* SHA1 results are in big endian */
 		for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++)
-			if (out)
-				hash[i] = be32_to_cpu(omap_sham_read(ctx->dd,
-							SHA_REG_DIGEST(i)));
-			else
-				omap_sham_write(ctx->dd, SHA_REG_DIGEST(i),
-							cpu_to_be32(hash[i]));
+			hash[i] = be32_to_cpu(in[i]);
 	} else {
 		/* MD5 results are in little endian */
 		for (i = 0; i < MD5_DIGEST_SIZE / sizeof(u32); i++)
-			if (out)
-				hash[i] = le32_to_cpu(omap_sham_read(ctx->dd,
-							SHA_REG_DIGEST(i)));
-			else
-				omap_sham_write(ctx->dd, SHA_REG_DIGEST(i),
-							cpu_to_le32(hash[i]));
+			hash[i] = le32_to_cpu(in[i]);
 	}
 }
 
@@ -474,8 +485,7 @@ static void omap_sham_cleanup(struct ahash_request *req)
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (ctx->digcnt)
-		memcpy(req->result, ctx->digest, (ctx->flags & FLAGS_SHA1) ?
-				SHA1_DIGEST_SIZE : MD5_DIGEST_SIZE);
+		omap_sham_copy_ready_hash(req);
 
 	dev_dbg(dd->dev, "digcnt: %d, bufcnt: %d\n", ctx->digcnt, ctx->bufcnt);
 }
-- 
1.7.0.4

