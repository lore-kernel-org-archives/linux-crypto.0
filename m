From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 06/13] crypto: talitos - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:38:26 +0100
Message-ID: <3113222.IBgeSqlAuS@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55392 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933311AbdAJBmL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:11 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/crypto/talitos.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0bba6a1..6a6e343 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1429,6 +1429,11 @@ static int aead_encrypt(struct aead_request *req)
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct talitos_edesc *edesc;
+	int err;
+
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, req->iv, 0, true);
-- 
2.9.3
