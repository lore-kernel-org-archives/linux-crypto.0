From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 13/13] crypto: qat - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:41:20 +0100
Message-ID: <5666255.48FiNLI70R@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55368 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932893AbdAJBmA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:00 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 20f35df..6576328 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -865,6 +865,10 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	uint8_t *iv = areq->iv;
 	int ret, ctr = 0;
 
+	ret = crypto_aead_copy_ad(areq);
+	if (ret)
+		return ret;
+
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
 		return ret;
-- 
2.9.3
