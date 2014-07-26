From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] crypto: ablkcipher.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:09:17 +0200
Message-ID: <1406383757-1753-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64151 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaGZOHw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Jul 2014 10:07:52 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so5344463wgg.7
        for <linux-crypto@vger.kernel.org>; Sat, 26 Jul 2014 07:07:50 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/ablkcipher.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 40886c4..e446eef 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -384,8 +384,8 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
+	strlcpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
@@ -465,8 +465,8 @@ static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
+	strlcpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
-- 
1.7.10.4
