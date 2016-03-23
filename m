From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v2 1/3] crypto: scatterwak - Add scatterwalk_sg_copychunks
Date: Wed, 23 Mar 2016 17:05:37 +0200
Message-ID: <1458745539-1252-2-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458745539-1252-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tadeusz.struk@intel.com>, <linux-crypto@vger.kernel.org>,
	<smueller@chronox.de>, <horia.geanta@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0074.outbound.protection.outlook.com ([65.55.169.74]:6615
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753113AbcCWPFs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2016 11:05:48 -0400
In-Reply-To: <1458745539-1252-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the function scatterwalk_sg_copychunks which writes
a chunk of data from a scatterwalk to another scatterwalk.
It will be used by caam driver to remove the leading zeros of RSA's
algorithm output.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/scatterwalk.c         | 26 ++++++++++++++++++++++++++
 include/crypto/scatterwalk.h |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index ea5815c..bc3222d 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -125,6 +125,32 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 }
 EXPORT_SYMBOL_GPL(scatterwalk_map_and_copy);
 
+void scatterwalk_sg_copychunks(struct scatter_walk *dest,
+			       struct scatter_walk *src, size_t nbytes)
+{
+	for (;;) {
+		unsigned int len_this_page = scatterwalk_pagelen(dest);
+		u8 *vaddr;
+
+		if (len_this_page > nbytes)
+			len_this_page = nbytes;
+
+		vaddr = scatterwalk_map(dest);
+		scatterwalk_copychunks(vaddr, src, len_this_page, 0);
+		scatterwalk_unmap(vaddr);
+
+		scatterwalk_advance(dest, len_this_page);
+
+		if (nbytes == len_this_page)
+			break;
+
+		nbytes -= len_this_page;
+
+		scatterwalk_pagedone(dest, 0, 1);
+	}
+}
+EXPORT_SYMBOL_GPL(scatterwalk_sg_copychunks);
+
 int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes)
 {
 	int offset = 0, n = 0;
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 35f99b6..8b799c5 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -86,6 +86,8 @@ static inline void scatterwalk_unmap(void *vaddr)
 void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg);
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
+void scatterwalk_sg_copychunks(struct scatter_walk *dest,
+			       struct scatter_walk *src, size_t nbytes);
 void *scatterwalk_map(struct scatter_walk *walk);
 void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 
-- 
1.8.3.1
