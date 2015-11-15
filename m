From: David Gstir <david@sigma-star.at>
Subject: [PATCH 2/2] crypto: talitos - Fix timing leak in ESP ICV verification
Date: Sun, 15 Nov 2015 17:14:42 +0100
Message-ID: <1447604082-1883-3-git-send-email-david@sigma-star.at>
References: <1447604082-1883-1-git-send-email-david@sigma-star.at>
Cc: herbert@gondor.apana.org.au, David Gstir <david@sigma-star.at>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45998 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbbKOQQx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Nov 2015 11:16:53 -0500
In-Reply-To: <1447604082-1883-1-git-send-email-david@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using non-constant time memcmp() makes the verification of the authentication
tag in the decrypt path vulnerable to timing attacks. Fix this by using
crypto_memneq() instead.

Signed-off-by: David Gstir <david@sigma-star.at>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 46f531e19ccf..b6f9f42e2985 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -977,7 +977,7 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 		} else
 			oicv = (char *)&edesc->link_tbl[0];
 
-		err = memcmp(oicv, icv, authsize) ? -EBADMSG : 0;
+		err = crypto_memneq(oicv, icv, authsize) ? -EBADMSG : 0;
 	}
 
 	kfree(edesc);
-- 
2.1.4
