From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 7/9 v7] crypto:s5p-sss: validate iv before memcpy
Date: Mon, 17 Feb 2014 15:14:33 +0530
Message-ID: <1392630275-8667-8-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, davem@davemloft.net
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds code to validate "iv" buffer before trying to
memcpy the contents

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
CC: David S. Miller <davem@davemloft.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v6:
None

 drivers/crypto/s5p-sss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index fa21db5..7da1da4 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -380,7 +380,8 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 {
 	void __iomem *keystart;
 
-	memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+	if (iv)
+		memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
-- 
1.7.9.5
