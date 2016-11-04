From: Sven Ebenfeld <sven.ebenfeld@gmail.com>
Subject: [PATCH] crypto: caam: do not register AES-XTS mode on LP units
Date: Sat,  5 Nov 2016 00:17:27 +0100
Message-ID: <1478301447-75861-1-git-send-email-sven.ebenfeld@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        horia.geanta@nxp.com, cata.vasile@nxp.com, sven.ebenfeld@gmail.com
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When using AES-XTS on a Wandboard, we receive a Mode error:
caam_jr 2102000.jr1: 20001311: CCB: desc idx 19: AES: Mode error.

Due to the Security Reference Manual, the Low Power AES units
of the i.MX6 do not support the XTS mode. Therefore we should
try to provide them them in the API.

Signed-off-by: Sven Ebenfeld <sven.ebenfeld@gmail.com>
---
 drivers/crypto/caam/caamalg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 156aad1..f5a63ba 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -4583,6 +4583,15 @@ static int __init caam_algapi_init(void)
 		if (!aes_inst && (alg_sel == OP_ALG_ALGSEL_AES))
 				continue;
 
+		/*
+		 * Check support for AES modes not available
+		 * on LP devices.
+		 */
+		if ((cha_vid & CHA_ID_LS_AES_MASK) == CHA_ID_LS_AES_LP)
+			if ((alg->class1_alg_type & OP_ALG_AAI_MASK) ==
+			     OP_ALG_AAI_XTS)
+				continue;
+
 		t_alg = caam_alg_alloc(alg);
 		if (IS_ERR(t_alg)) {
 			err = PTR_ERR(t_alg);
-- 
2.7.4
