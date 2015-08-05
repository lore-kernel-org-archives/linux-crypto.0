From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 05/14] crypto: caam - Change kmalloc to kzalloc to avoid residual data
Date: Wed, 5 Aug 2015 11:28:39 -0700
Message-ID: <1438799328-10757-6-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0148.outbound.protection.outlook.com ([157.56.111.148]:26115
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753140AbbHESoU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:44:20 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
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
 drivers/crypto/caam/caamalg.c  | 12 ++++++------
 drivers/crypto/caam/caamhash.c | 25 ++++++++++++-------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b09c171..3d1ca08 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2199,8 +2199,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(struct aead_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
@@ -2503,8 +2503,8 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 			sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ablkcipher_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
+	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
+			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
@@ -2682,8 +2682,8 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
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
