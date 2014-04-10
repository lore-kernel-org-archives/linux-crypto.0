From: Sonic Zhang <sonic.adi@gmail.com>
Subject: [PATCH 1/2] crypto: bfin_crc: ignore duplicated registration of the same algorithm
Date: Thu, 10 Apr 2014 16:40:58 +0800
Message-ID: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:46676
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964832AbaDJIiv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 04:38:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

in case of multiple crc devices are probed.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/crypto/bfin_crc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index cea3e8c..5f5f427 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -672,7 +672,7 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, crc);
 
 	ret = crypto_register_ahash(&algs);
-	if (ret) {
+	if (ret && ret != -EEXIST) {
 		spin_lock(&crc_list.lock);
 		list_del(&crc->list);
 		spin_unlock(&crc_list.lock);
-- 
1.8.2.3
