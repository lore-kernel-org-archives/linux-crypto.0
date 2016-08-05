From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 1/7] crypto: img-hash - Fix null pointer exception
Date: Fri, 5 Aug 2016 14:00:14 +0100
Message-ID: <1470402020-10774-2-git-send-email-will.thomas@imgtec.com>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Will Thomas <will.thomas@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:30965 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662AbcHENIM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:12 -0400
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sporadic null pointer exceptions came from here. Fix them.

Signed-off-by: Will Thomas <will.thomas@imgtec.com>
Reviewed-by: James Hartley <james.hartley@imgtec.com>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 68e8aa9..e5c941b 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -361,7 +361,7 @@ static void img_hash_dma_task(unsigned long d)
 	size_t nbytes, bleft, wsend, len, tbc;
 	struct scatterlist tsg;
 
-	if (!ctx->sg)
+	if (!hdev->req || !ctx->sg)
 		return;
 
 	addr = sg_virt(ctx->sg);
-- 
2.1.4
