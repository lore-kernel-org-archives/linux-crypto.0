From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] crypto: Drop owner assignment from platform_driver
Date: Fri, 10 Jul 2015 14:46:16 +0900
Message-ID: <1436507176-27632-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8227 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbbGJFqU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 01:46:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

platform_driver does not need to set an owner because
platform_driver_register() will set it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

The coccinelle script which generated the patch was sent here:
http://www.spinics.net/lists/kernel/msg2029903.html
---
 drivers/crypto/marvell/cesa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 1c6f98dd88f4..0643e3366e33 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -533,7 +533,6 @@ static struct platform_driver marvell_cesa = {
 	.probe		= mv_cesa_probe,
 	.remove		= mv_cesa_remove,
 	.driver		= {
-		.owner	= THIS_MODULE,
 		.name	= "marvell-cesa",
 		.of_match_table = mv_cesa_of_match_table,
 	},
-- 
1.9.1
