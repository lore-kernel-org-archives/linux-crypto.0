From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH 1/6] crypto: img-hash - Fix null pointer exception
Date: Mon, 11 Jul 2016 10:33:31 +0100
Message-ID: <1468229616-3888-2-git-send-email-will.thomas@imgtec.com>
References: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Will Thomas <will.thomas@imgtec.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:32634 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcGKJeW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 05:34:22 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Forcepoint Email with ESMTPS id 653EEE89C5F27
	for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2016 10:34:08 +0100 (IST)
In-Reply-To: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sporadic null pointer exceptions came from here. Fix them.

Signed-off-by: Will Thomas <will.thomas@imgtec.com>
Reviewed-by: James Hartley <james.hartley@imgtec.com>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 68e8aa9..a5f270b 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -361,7 +361,7 @@ static void img_hash_dma_task(unsigned long d)
 	size_t nbytes, bleft, wsend, len, tbc;
 	struct scatterlist tsg;
 
-	if (!ctx->sg)
+	if (!ctx || !ctx->sg)
 		return;
 
 	addr = sg_virt(ctx->sg);
-- 
2.1.4
