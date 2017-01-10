From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 08/13] crypto: ixp4xx - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:39:11 +0100
Message-ID: <1486098.dczbARNFtz@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55384 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933311AbdAJBmH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:07 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/crypto/ixp4xx_crypto.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 7868765..20a5bd8 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1178,6 +1178,12 @@ static int aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 static int aead_encrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	return aead_perform(req, 1, req->assoclen, req->cryptlen, req->iv);
 }
 
-- 
2.9.3
