From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 11/13] crypto: chelsio - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:40:06 +0100
Message-ID: <1510228.QbVZYpGSn7@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55376 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933311AbdAJBmD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:03 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/crypto/chelsio/chcr_algo.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 2ed1e24..b3283c0 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2398,6 +2398,11 @@ static int chcr_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+	int err;
+
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
 
 	reqctx->verify = VERIFY_HW;
 
-- 
2.9.3
