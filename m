From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH 09/10] crypto: scatterwalk - export scatterwalk_pagedone
Date: Fri, 18 Mar 2016 20:32:06 +0200
Message-ID: <1458325927-14737-9-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0069.outbound.protection.outlook.com ([65.55.169.69]:53003
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753610AbcCRScc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 14:32:32 -0400
In-Reply-To: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Used in caam driver. Export the symbol since the caam driver
can be built as a module.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/scatterwalk.c         | 5 +++--
 include/crypto/scatterwalk.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index bc3222d..03d34f9 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -47,8 +47,8 @@ void *scatterwalk_map(struct scatter_walk *walk)
 }
 EXPORT_SYMBOL_GPL(scatterwalk_map);
 
-static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
-				 unsigned int more)
+void scatterwalk_pagedone(struct scatter_walk *walk, int out,
+			  unsigned int more)
 {
 	if (out) {
 		struct page *page;
@@ -69,6 +69,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 			scatterwalk_start(walk, sg_next(walk->sg));
 	}
 }
+EXPORT_SYMBOL_GPL(scatterwalk_pagedone);
 
 void scatterwalk_done(struct scatter_walk *walk, int out, int more)
 {
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 8b799c5..6535a20 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -89,6 +89,8 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 void scatterwalk_sg_copychunks(struct scatter_walk *dest,
 			       struct scatter_walk *src, size_t nbytes);
 void *scatterwalk_map(struct scatter_walk *walk);
+void scatterwalk_pagedone(struct scatter_walk *walk, int out,
+			  unsigned int more);
 void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
-- 
1.8.3.1
