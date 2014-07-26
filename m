From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] crypto: blkcipher.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:13:53 +0200
Message-ID: <1406384033-2007-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47882 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaGZOM1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Jul 2014 10:12:27 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so5389764wgh.32
        for <linux-crypto@vger.kernel.org>; Sat, 26 Jul 2014 07:12:26 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/blkcipher.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 0122bec..3cfd2c4 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -512,8 +512,8 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
+	strlcpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
-- 
1.7.10.4
