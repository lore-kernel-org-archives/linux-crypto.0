From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] crypto: only call put_page used pages
Date: Sat, 10 Sep 2016 05:48:25 +0200
Message-ID: <2628379.YzI4m1aTC1@positron.chronox.de>
References: <2637498.CLV37KecV5@positron.chronox.de> <2555546.QkgIzR2raW@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47914 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbcIJDsa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2016 23:48:30 -0400
In-Reply-To: <2555546.QkgIzR2raW@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Changes v2: use sg_page(sg) only once

---8<---

For asynchronous operation, SGs are allocated without a page mapped to
them. If the SGL is freed, the code must only call put_page for an SG if
there was a page assigned to it in the first place.

This fixes a kernel crash when using io_submit with more than one iocb.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 28556fc..d7acb73 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -86,8 +86,13 @@ static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
 	}
 	sgl = sreq->tsg;
 	n = sg_nents(sgl);
-	for_each_sg(sgl, sg, n, i)
-		put_page(sg_page(sg));
+	for_each_sg(sgl, sg, n, i) {
+		struct page *page = sg_page(sg);
+
+		/* some SGs may not have a page mapped */
+		if (page_ref_count(page))
+			put_page(page);
+	}
 
 	kfree(sreq->tsg);
 }
-- 
2.7.4
