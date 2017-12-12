From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 03/24] staging: ccree: amend hash func def for readability
Date: Tue, 12 Dec 2017 14:52:49 +0000
Message-ID: <1513090395-7938-4-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Func definitions in the hash implementation were did not adhere to
coding style. Fix them for better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 6bc42e4..a80279e 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -64,10 +64,8 @@ static const u64 sha512_init[] = {
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
 #endif
 
-static void cc_setup_xcbc(
-	struct ahash_request *areq,
-	struct cc_hw_desc desc[],
-	unsigned int *seq_size);
+static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
+			  unsigned int *seq_size);
 
 static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
 			  unsigned int *seq_size);
@@ -106,12 +104,9 @@ struct cc_hash_ctx {
 	bool is_hmac;
 };
 
-static void cc_set_desc(
-	struct ahash_req_ctx *areq_ctx,
-	struct cc_hash_ctx *ctx,
-	unsigned int flow_mode, struct cc_hw_desc desc[],
-	bool is_not_last_data,
-	unsigned int *seq_size);
+static void cc_set_desc(struct ahash_req_ctx *areq_ctx, struct cc_hash_ctx *ctx,
+			unsigned int flow_mode, struct cc_hw_desc desc[],
+			bool is_not_last_data, unsigned int *seq_size);
 
 static void cc_set_endianity(u32 mode, struct cc_hw_desc *desc)
 {
@@ -1971,9 +1966,8 @@ static struct cc_hash_template driver_hash[] = {
 
 };
 
-static struct cc_hash_alg *
-cc_alloc_hash_alg(struct cc_hash_template *template, struct device *dev,
-		  bool keyed)
+static struct cc_hash_alg *cc_alloc_hash_alg(struct cc_hash_template *template,
+					     struct device *dev, bool keyed)
 {
 	struct cc_hash_alg *t_crypto_alg;
 	struct crypto_alg *alg;
-- 
2.7.4
