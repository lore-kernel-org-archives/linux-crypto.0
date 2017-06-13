From: Colin King <colin.king@canonical.com>
Subject: [PATCH][crypto-next] crypto: omap-aes: fix spelling mistake "Encryptio" -> "Encryption"
Date: Tue, 13 Jun 2017 09:46:47 +0100
Message-ID: <20170613084647.20500-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in pr_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/omap-aes-gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 521a310ea699..7d4f8a4be6d8 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -214,7 +214,7 @@ static int do_encrypt_iv(struct aead_request *req, u32 *tag, u32 *iv)
 		}
 		/* fall through */
 	default:
-		pr_err("Encryptio of IV failed for GCM mode");
+		pr_err("Encryption of IV failed for GCM mode");
 		break;
 	}
 
-- 
2.11.0
