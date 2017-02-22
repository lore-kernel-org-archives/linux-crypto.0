From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: brcm: fix spelling mistake: "genereate" -> "generate"
Date: Wed, 22 Feb 2017 23:51:38 +0000
Message-ID: <20170222235138.8531-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Rice <rob.rice@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in pr_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/bcm/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index 0502f46..430c557 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -312,7 +312,7 @@ int do_shash(unsigned char *name, unsigned char *result,
 	}
 	rc = crypto_shash_final(&sdesc->shash, result);
 	if (rc)
-		pr_err("%s: Could not genereate %s hash", __func__, name);
+		pr_err("%s: Could not generate %s hash", __func__, name);
 
 do_shash_err:
 	crypto_free_shash(hash);
-- 
2.10.2
