From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] crypto: rng.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:18:28 +0200
Message-ID: <1406384308-2269-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index e0a25c2..c3d4fb3 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -65,7 +65,7 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_rng rrng;
 
-	strncpy(rrng.type, "rng", sizeof(rrng.type));
+	strlcpy(rrng.type, "rng", sizeof(rrng.type));
 
 	rrng.seedsize = alg->cra_rng.seedsize;
 
-- 
1.7.10.4
