From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/2] crypto: s5p-sss: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:49:28 +0900
Message-ID: <002601ce4a0c$b59fe120$20dfa360$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	Jingoo Han <jg1.han@samsung.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38756 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3EFDta (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 May 2013 23:49:30 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMC009NVYM9ZA90@mailout4.samsung.com> for
 linux-crypto@vger.kernel.org; Mon, 06 May 2013 12:49:29 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/s5p-sss.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 4b31432..cf149b1 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -647,7 +647,6 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	clk_disable(pdata->clk);
 
 	s5p_dev = NULL;
-	platform_set_drvdata(pdev, NULL);
 
 	return err;
 }
@@ -668,7 +667,6 @@ static int s5p_aes_remove(struct platform_device *pdev)
 	clk_disable(pdata->clk);
 
 	s5p_dev = NULL;
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5
