From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/2] crypto: caam - defer aead_set_sh_desc in case of zero authsize
Date: Thu, 4 Aug 2016 20:02:47 +0300
Message-ID: <1470330167-31534-3-git-send-email-horia.geanta@nxp.com>
References: <1470330167-31534-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0072.outbound.protection.outlook.com ([104.47.42.72]:8352
	"EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758682AbcHDRgr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 13:36:47 -0400
In-Reply-To: <1470330167-31534-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To be able to generate shared descriptors for AEAD, the authentication size
needs to be known. However, there is no imposed order of calling .setkey,
.setauthsize callbacks.

Thus, in case authentication size is not known at .setkey time, defer it
until .setauthsize is called.

The authsize != 0 check was incorrectly removed when converting the driver
to the new AEAD interface.

Cc: <stable@vger.kernel.org> # 4.3+
Fixes: 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e356005a7212..6dc597126b79 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -441,6 +441,9 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
+	if (!ctx->authsize)
+		return 0;
+
 	/* NULL encryption / decryption */
 	if (!ctx->enckeylen)
 		return aead_null_set_sh_desc(aead);
-- 
2.4.4
