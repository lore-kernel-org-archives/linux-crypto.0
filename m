From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH 05/12] crypto: caam - Change kmalloc to kzalloc to avoid residual data
Date: Wed, 29 Jul 2015 20:58:22 -0700
Message-ID: <1438228709-27650-6-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:9600
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074AbbG3EOR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 00:14:17 -0400
In-Reply-To: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since fields must be ORed in to operate correctly using any order of
operations, changed allocations of the combination of extended
descriptor structs + hardware scatterlists to use kzalloc() instead
of kmalloc(), so as to ensure that residue data would not be ORed in
with the correct data.

Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 20 ++++++++++----------
 drivers/crypto/caam/caamhash.c | 25 ++++++++++++-------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3c50a50..33b6861 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2482,8 +2482,8 @@ static struct aead_edesc *old_aead_edesc_alloc(struct aead_request *req,
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
@@ -2585,8 +2585,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(struct aead_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
@@ -2921,8 +2921,8 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
@@ -3094,8 +3094,8 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 			sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ablkcipher_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
@@ -3273,8 +3273,8 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 			sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(*edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 9622a81..2361beb 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -807,7 +807,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+		edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN +
 				sec4_sg_bytes, GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
@@ -918,8 +918,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 	sec4_sg_bytes = (1 + (buflen ? 1 : 0)) * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1005,8 +1005,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1091,8 +1091,8 @@ static int ahash_digest(struct ahash_request *req)
 	sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + sec4_sg_bytes +
-			DESC_JOB_IO_LEN, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes + DESC_JOB_IO_LEN,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1165,8 +1165,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	int sh_len;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN,
-			GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1245,7 +1244,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+		edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN +
 				sec4_sg_bytes, GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
@@ -1353,8 +1352,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return -ENOMEM;
@@ -1448,7 +1447,7 @@ static int ahash_update_first(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+		edesc = kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN +
 				sec4_sg_bytes, GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
-- 
2.1.4
