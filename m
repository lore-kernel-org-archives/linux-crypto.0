From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 06/10] mv_cesa: refactor copy_src_to_buf()
Date: Thu,  5 May 2011 15:29:02 +0200
Message-ID: <1304602146-5918-6-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:36771 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EENkD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:40:03 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The main goal was to have it not do anything when a zero len parameter
was being passed (which could lead to a null pointer dereference, as in
this case p->src_sg is null, either). Using the min() macro, the lower
part of the loop gets simpler, too.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index fb3f1e3..de09303 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -187,9 +187,9 @@ static void copy_src_to_buf(struct req_progress *p, char *dbuf, int len)
 {
 	int ret;
 	void *sbuf;
-	int copied = 0;
+	int copy_len;
 
-	while (1) {
+	while (len) {
 		if (!p->sg_src_left) {
 			ret = sg_miter_next(&p->src_sg_it);
 			BUG_ON(!ret);
@@ -199,19 +199,14 @@ static void copy_src_to_buf(struct req_progress *p, char *dbuf, int len)
 
 		sbuf = p->src_sg_it.addr + p->src_start;
 
-		if (p->sg_src_left <= len - copied) {
-			memcpy(dbuf + copied, sbuf, p->sg_src_left);
-			copied += p->sg_src_left;
-			p->sg_src_left = 0;
-			if (copied >= len)
-				break;
-		} else {
-			int copy_len = len - copied;
-			memcpy(dbuf + copied, sbuf, copy_len);
-			p->src_start += copy_len;
-			p->sg_src_left -= copy_len;
-			break;
-		}
+		copy_len = min(p->sg_src_left, len);
+		memcpy(dbuf, sbuf, copy_len);
+
+		p->src_start += copy_len;
+		p->sg_src_left -= copy_len;
+
+		len -= copy_len;
+		dbuf += copy_len;
 	}
 }
 
-- 
1.7.4.1
