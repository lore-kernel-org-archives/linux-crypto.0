From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH 2/6] crypto: img-hash - Fix hash request context
Date: Mon, 11 Jul 2016 10:33:32 +0100
Message-ID: <1468229616-3888-3-git-send-email-will.thomas@imgtec.com>
References: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Will Thomas <will.thomas@imgtec.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:65064 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbcGKJeN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 05:34:13 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Forcepoint Email with ESMTPS id 197832A660BAD
	for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2016 10:34:08 +0100 (IST)
In-Reply-To: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move 0 length buffer to end of structure to stop overwriting
fallback request data. This doesn't cause a bug itself as the
buffer is never used alongside the fallback but should be
changed.

Signed-off-by: Will Thomas <will.thomas@imgtec.com>
Reviewed-by: James Hartley <james.hartley@imgtec.com>
---
 drivers/crypto/img-hash.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index a5f270b..7fa6aa4 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -102,8 +102,10 @@ struct img_hash_request_ctx {
 	unsigned long		op;
 
 	size_t			bufcnt;
-	u8 buffer[0] __aligned(sizeof(u32));
 	struct ahash_request	fallback_req;
+
+	/* Zero length buffer must remain last member of struct */
+	u8 buffer[0] __aligned(sizeof(u32));
 };
 
 struct img_hash_ctx {
-- 
2.1.4
