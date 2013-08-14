From: jmlatten@linux.vnet.ibm.com
Subject: [PATCH] crypto:nx - fix nx-aes-gcm verification
Date: Wed, 14 Aug 2013 17:17:57 -0500
Message-ID: <520c0215.kHFgBNcJQfAPXpv3%jmlatten@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [32.97.110.51] ([32.97.110.51]:45862 "HELO oc8377654763.ibm.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1758395Ab3HNWZa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Aug 2013 18:25:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a bug in the nx-aes-gcm implementation.
Corrected the code so that the authtag is always verified after
decrypting and not just when there is associated data included.
Also, corrected the code to retrieve the input authtag from src
instead of dst. 

Reviewed-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Signed-off-by: Joy Latten <jmlatten@linux.vnet.ibm.com>

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 6cca6c3..eb851bb 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -243,11 +243,11 @@ static int gcm_aes_nx_crypt(struct aead_request *req, int enc)
 				 req->dst, nbytes,
 				 crypto_aead_authsize(crypto_aead_reqtfm(req)),
 				 SCATTERWALK_TO_SG);
-	} else if (req->assoclen) {
+	} else {
 		u8 *itag = nx_ctx->priv.gcm.iauth_tag;
 		u8 *otag = csbcpb->cpb.aes_gcm.out_pat_or_mac;
 
-		scatterwalk_map_and_copy(itag, req->dst, nbytes,
+		scatterwalk_map_and_copy(itag, req->src, nbytes,
 				 crypto_aead_authsize(crypto_aead_reqtfm(req)),
 				 SCATTERWALK_FROM_SG);
 		rc = memcmp(itag, otag,
