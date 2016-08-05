From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 2/7] crypto: img-hash - Fix hash request context
Date: Fri, 5 Aug 2016 14:00:15 +0100
Message-ID: <1470402020-10774-3-git-send-email-will.thomas@imgtec.com>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Will Thomas <will.thomas@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:33272 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686AbcHENIM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:12 -0400
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
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
index e5c941b..de2b86e 100644
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
