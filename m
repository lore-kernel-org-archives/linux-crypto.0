From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: brcm: fix spelling mistake: "fallbck" -> "fallback"
Date: Sun,  4 Jun 2017 19:29:20 +0100
Message-ID: <20170604182920.26389-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57840 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdFDS32 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 14:29:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in flow_log message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/bcm/cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 61393dc70b0b..9cfd36c1bcb6 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2639,7 +2639,7 @@ static int aead_need_fallback(struct aead_request *req)
 	    (spu->spu_type == SPU_TYPE_SPUM) &&
 	    (ctx->digestsize != 8) && (ctx->digestsize != 12) &&
 	    (ctx->digestsize != 16)) {
-		flow_log("%s() AES CCM needs fallbck for digest size %d\n",
+		flow_log("%s() AES CCM needs fallback for digest size %d\n",
 			 __func__, ctx->digestsize);
 		return 1;
 	}
-- 
2.11.0
