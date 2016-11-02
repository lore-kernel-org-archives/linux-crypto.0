From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: talitos: fix spelling mistake
Date: Tue,  1 Nov 2016 20:14:04 -0600
Message-ID: <20161102021404.32050-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "pointeur" to "pointer"
in dev_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0418a2f..0bba6a1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -590,7 +590,7 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS_CCPSR_LO_MDTE)
 			dev_err(dev, "master data transfer error\n");
 		if (v_lo & TALITOS_CCPSR_LO_SGDLZ)
-			dev_err(dev, is_sec1 ? "pointeur not complete error\n"
+			dev_err(dev, is_sec1 ? "pointer not complete error\n"
 					     : "s/g data length zero error\n");
 		if (v_lo & TALITOS_CCPSR_LO_FPZ)
 			dev_err(dev, is_sec1 ? "parity error\n"
-- 
2.9.3
