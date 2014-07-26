From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] crypto: aead.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:10:49 +0200
Message-ID: <1406383849-1843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/aead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 547491e..249ab07 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -117,8 +117,8 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 	struct crypto_report_aead raead;
 	struct aead_alg *aead = &alg->cra_aead;
 
-	strncpy(raead.type, "aead", sizeof(raead.type));
-	strncpy(raead.geniv, aead->geniv ?: "<built-in>", sizeof(raead.geniv));
+	strlcpy(raead.type, "aead", sizeof(raead.type));
+	strlcpy(raead.geniv, aead->geniv ?: "<built-in>", sizeof(raead.geniv));
 
 	raead.blocksize = alg->cra_blocksize;
 	raead.maxauthsize = aead->maxauthsize;
@@ -202,8 +202,8 @@ static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
 	struct crypto_report_aead raead;
 	struct aead_alg *aead = &alg->cra_aead;
 
-	strncpy(raead.type, "nivaead", sizeof(raead.type));
-	strncpy(raead.geniv, aead->geniv, sizeof(raead.geniv));
+	strlcpy(raead.type, "nivaead", sizeof(raead.type));
+	strlcpy(raead.geniv, aead->geniv, sizeof(raead.geniv));
 
 	raead.blocksize = alg->cra_blocksize;
 	raead.maxauthsize = aead->maxauthsize;
-- 
1.7.10.4
