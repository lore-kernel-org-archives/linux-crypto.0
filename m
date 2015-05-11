From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 2/4] Revert "crypto: talitos - convert to use be16_add_cpu()"
Date: Mon, 11 May 2015 20:04:49 +0300
Message-ID: <1431363889-2706-1-git-send-email-horia.geanta@freescale.com>
References: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0127.outbound.protection.outlook.com ([65.55.169.127]:53432
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751407AbbEKRgw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 13:36:52 -0400
In-Reply-To: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit 7291a932c6e27d9768e374e9d648086636daf61c.

The conversion to be16_add_cpu() is incorrect in case cryptlen is
negative due to premature (i.e. before addition / subtraction)
implicit conversion of cryptlen (int -> u16) leading to sign loss.

Cc: <stable@vger.kernel.org> # 3.10+
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 2c2ec0e0c145..6b19b3dca616 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1083,7 +1083,8 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 		sg_count--;
 		link_tbl_ptr--;
 	}
-	be16_add_cpu(&link_tbl_ptr->len, cryptlen);
+	link_tbl_ptr->len = cpu_to_be16(be16_to_cpu(link_tbl_ptr->len)
+					+ cryptlen);
 
 	/* tag end of link table */
 	link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-- 
1.8.3.1
