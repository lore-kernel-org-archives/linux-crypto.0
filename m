From: David Gstir <david@sigma-star.at>
Subject: [PATCH 1/2] crypto: nx - Fix timing leak in GCM and CCM decryption
Date: Sun, 15 Nov 2015 17:14:41 +0100
Message-ID: <1447604082-1883-2-git-send-email-david@sigma-star.at>
References: <1447604082-1883-1-git-send-email-david@sigma-star.at>
Cc: herbert@gondor.apana.org.au, David Gstir <david@sigma-star.at>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45997 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbKOQQw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Nov 2015 11:16:52 -0500
In-Reply-To: <1447604082-1883-1-git-send-email-david@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using non-constant time memcmp() makes the verification of the authentication
tag in the decrypt path vulnerable to timing attacks. Fix this by using
crypto_memneq() instead.

Signed-off-by: David Gstir <david@sigma-star.at>
---
 drivers/crypto/nx/nx-aes-ccm.c | 2 +-
 drivers/crypto/nx/nx-aes-gcm.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 73ef49922788..7038f364acb5 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -409,7 +409,7 @@ static int ccm_nx_decrypt(struct aead_request   *req,
 		processed += to_process;
 	} while (processed < nbytes);
 
-	rc = memcmp(csbcpb->cpb.aes_ccm.out_pat_or_mac, priv->oauth_tag,
+	rc = crypto_memneq(csbcpb->cpb.aes_ccm.out_pat_or_mac, priv->oauth_tag,
 		    authsize) ? -EBADMSG : 0;
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index eee624f589b6..abd465f479c4 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -21,6 +21,7 @@
 
 #include <crypto/internal/aead.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -418,7 +419,7 @@ mac:
 			itag, req->src, req->assoclen + nbytes,
 			crypto_aead_authsize(crypto_aead_reqtfm(req)),
 			SCATTERWALK_FROM_SG);
-		rc = memcmp(itag, otag,
+		rc = crypto_memneq(itag, otag,
 			    crypto_aead_authsize(crypto_aead_reqtfm(req))) ?
 		     -EBADMSG : 0;
 	}
-- 
2.1.4
