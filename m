From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH] crypto: testmgr - mark ctr(des3_ede) as fips_allowed
Date: Mon, 20 Mar 2017 17:28:05 -0300
Message-ID: <1490041685-25947-1-git-send-email-marcelo.cerri@canonical.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Stephan Muller <stephan.mueller@atsec.com>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

3DES is missing the fips_allowed flag for CTR mode.

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
---
 crypto/testmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 89f1dd1f4b13..cd075c7d8ee1 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2645,6 +2645,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ctr(des3_ede)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = __VECS(des3_ede_ctr_enc_tv_template),
-- 
2.7.4
