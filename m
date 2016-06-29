From: zengzhaoxiu@163.com
Subject: [patch V4 30/31] crypto: use parity_long in sahara.c
Date: Wed, 29 Jun 2016 23:18:31 +0800
Message-ID: <1467213511-40311-1-git-send-email-zengzhaoxiu@163.com>
References: <1462958683-26142-1-git-send-email-zengzhaoxiu@163.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462958683-26142-1-git-send-email-zengzhaoxiu@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>

Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
---
 drivers/crypto/sahara.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index c3f3d89..5c44a15 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -783,7 +783,7 @@ static u32 sahara_sha_init_hdr(struct sahara_dev *dev,
 	if (rctx->last)
 		hdr |= SAHARA_HDR_MDHA_PDATA;
 
-	if (hweight_long(hdr) % 2 == 0)
+	if (!parity_long(hdr))
 		hdr |= SAHARA_HDR_PARITY_BIT;
 
 	return hdr;
-- 
2.7.4
