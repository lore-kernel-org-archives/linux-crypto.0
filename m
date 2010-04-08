From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCHv2 2/10] crypto mv_cesa : Remove compiler warning in mv_cesa
 driver
Date: Thu, 08 Apr 2010 19:25:56 +0300
Message-ID: <4BBE0394.6040701@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:36867 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab0DHQ0J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Apr 2010 12:26:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove compiler warning

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c linux-2.6.32.8_p2/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c	2010-03-16 08:59:12.074583163 +0200
+++ linux-2.6.32.8_p2/drivers/crypto/mv_cesa.c	2010-03-16 09:04:01.860953458 +0200
@@ -178,6 +178,7 @@ static void mv_process_current_q(int fir
 		op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
 		break;
 	case COP_AES_CBC:
+	default:
 		op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
 		op.enc_iv = ENC_IV_POINT(SRAM_DATA_IV) |
 			ENC_IV_BUF_POINT(SRAM_DATA_IV_BUF);


