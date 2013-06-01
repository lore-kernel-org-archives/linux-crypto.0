From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] crypto: picoxcell - replace strict_strtoul() with kstrtoul()
Date: Sat, 01 Jun 2013 16:05:57 +0900
Message-ID: <000101ce5e96$774ca4a0$65e5ede0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Jamie Iles' <jamie@jamieiles.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3FAHF7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Jun 2013 03:05:59 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNP00AEED1YCVC0@mailout1.samsung.com> for
 linux-crypto@vger.kernel.org; Sat, 01 Jun 2013 16:05:58 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/picoxcell_crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index ac30724..888f7f4 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1298,7 +1298,7 @@ static ssize_t spacc_stat_irq_thresh_store(struct device *dev,
 	struct spacc_engine *engine = spacc_dev_to_engine(dev);
 	unsigned long thresh;
 
-	if (strict_strtoul(buf, 0, &thresh))
+	if (kstrtoul(buf, 0, &thresh))
 		return -EINVAL;
 
 	thresh = clamp(thresh, 1UL, engine->fifo_sz - 1);
-- 
1.7.10.4
