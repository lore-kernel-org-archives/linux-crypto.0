From: Sven Ebenfeld <sven.ebenfeld@gmail.com>
Subject: [PATCH v2] crypto: caam: do not register AES-XTS mode on LP units
Date: Mon,  7 Nov 2016 18:51:34 +0100
Message-ID: <1478541094-73173-1-git-send-email-sven.ebenfeld@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        cata.vasile@nxp.com, Sven Ebenfeld <sven.ebenfeld@gmail.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, horia.geanta@nxp.com
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When using AES-XTS on a Wandboard, we receive a Mode error:
caam_jr 2102000.jr1: 20001311: CCB: desc idx 19: AES: Mode error.

According to the Security Reference Manual, the Low Power AES units
of the i.MX6 do not support the XTS mode. Therefore we must not
register XTS implementations in the Crypto API.

Signed-off-by: Sven Ebenfeld <sven.ebenfeld@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Cc: <stable@vger.kernel.org> # 4.4+
Fixes: c6415a6016bf "crypto: caam - add support for acipher xts(aes)"

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
