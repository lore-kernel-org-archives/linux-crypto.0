From: <lionel.debieve@st.com>
Subject: [PATCH v2 1/1] crypto: stm32/hash - Fix return issue on update
Date: Mon, 6 Nov 2017 23:41:52 +0100
Message-ID: <1510008112-1573-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:63743 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752508AbdKFWnQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 17:43:16 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lionel Debieve <lionel.debieve@st.com>

When data append reached the threshold for processing,
we must inform that processing is on going to wait before
managing the next request.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index c462be7..4ca4a26 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -895,7 +895,6 @@ static int stm32_hash_enqueue(struct ahash_request *req, unsigned int op)
 static int stm32_hash_update(struct ahash_request *req)
 {
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
-	int ret;
 
 	if (!req->nbytes || !(rctx->flags & HASH_FLAGS_CPU))
 		return 0;
@@ -909,12 +908,7 @@ static int stm32_hash_update(struct ahash_request *req)
 		return 0;
 	}
 
-	ret = stm32_hash_enqueue(req, HASH_OP_UPDATE);
-
-	if (rctx->flags & HASH_FLAGS_FINUP)
-		return ret;
-
-	return 0;
+	return stm32_hash_enqueue(req, HASH_OP_UPDATE);
 }
 
 static int stm32_hash_final(struct ahash_request *req)
-- 
2.7.4
