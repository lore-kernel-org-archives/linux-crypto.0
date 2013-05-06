From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/2] crypto: mv_cesa: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:48:41 +0900
Message-ID: <002501ce4a0c$994cc010$cbe64030$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Phil Sutter' <phil.sutter@viprinet.com>,
	'Andrew Lunn' <andrew@lunn.ch>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:43893 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3EFDsm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 May 2013 23:48:42 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMC006V4YKYO6A0@mailout2.samsung.com> for
 linux-crypto@vger.kernel.org; Mon, 06 May 2013 12:48:41 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/mv_cesa.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index ce6290e..3374a3e 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1146,7 +1146,6 @@ err_unmap_reg:
 err:
 	kfree(cp);
 	cpg = NULL;
-	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
-- 
1.7.2.5
