From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] crypto: pcompress.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:16:56 +0200
Message-ID: <1406384216-2186-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
 crypto/pcompress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index 7140fe7..f114720 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -53,7 +53,7 @@ static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rpcomp;
 
-	strncpy(rpcomp.type, "pcomp", sizeof(rpcomp.type));
+	strlcpy(rpcomp.type, "pcomp", sizeof(rpcomp.type));
 	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		    sizeof(struct crypto_report_comp), &rpcomp))
 		goto nla_put_failure;
-- 
1.7.10.4
