From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 03/13] crypto: ccm_generic - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:37:31 +0100
Message-ID: <3106714.54gSvA7YRm@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55400 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941473AbdAJBmP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:15 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/ccm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 26b924d..e2b6d3d 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -358,6 +358,10 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 	if (err)
 		return err;
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	err = crypto_ccm_auth(req, sg_next(pctx->src), cryptlen);
 	if (err)
 		return err;
@@ -749,9 +753,15 @@ static struct aead_request *crypto_rfc4309_crypt(struct aead_request *req)
 
 static int crypto_rfc4309_encrypt(struct aead_request *req)
 {
+	int err;
+
 	if (req->assoclen != 16 && req->assoclen != 20)
 		return -EINVAL;
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	req = crypto_rfc4309_crypt(req);
 
 	return crypto_aead_encrypt(req);
-- 
2.9.3
