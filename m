From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/2] crypto: sahara - Staticize local symbol
Date: Fri, 09 Aug 2013 16:57:48 +0900
Message-ID: <000801ce94d6$24377710$6ca66530$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	'Javier Martin' <javier.martin@vista-silicon.com>,
	Jingoo Han <jg1.han@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:19181 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967449Ab3HIH5u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 03:57:50 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR900B1L7GDQQA0@mailout2.samsung.com> for
 linux-crypto@vger.kernel.org; Fri, 09 Aug 2013 16:57:49 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This local symbol is used only in this file.
Fix the following sparse warnings:

drivers/crypto/sahara.c:420:6: warning: symbol 'sahara_watchdog' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/sahara.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index c3dc1c0..b076d81 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -417,7 +417,7 @@ static void sahara_aes_done_task(unsigned long data)
 	dev->req->base.complete(&dev->req->base, dev->error);
 }
 
-void sahara_watchdog(unsigned long data)
+static void sahara_watchdog(unsigned long data)
 {
 	struct sahara_dev *dev = (struct sahara_dev *)data;
 	unsigned int err = sahara_read(dev, SAHARA_REG_ERRSTATUS);
-- 
1.7.10.4
