From: Uri Simchoni <uri@jdland.co.il>
Subject: [PATCH 2/10] crypto mv_cesa : Remove compiler warning in mv_cesa
 driver
Date: Tue, 16 Mar 2010 16:43:58 +0200
Message-ID: <4B9F992E.4040300@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:33471 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966315Ab0CPOux (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Mar 2010 10:50:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove compiler warning

Signed-off-by: Uri Simchoni <uri@jdland.co.il>
---
diff -upr linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c 
linux-2.6.32.8_p2/drivers/crypto/mv_cesa.c
--- linux-2.6.32.8_p1/drivers/crypto/mv_cesa.c    2010-03-16 
08:59:12.074583163 +0200
+++ linux-2.6.32.8_p2/drivers/crypto/mv_cesa.c    2010-03-16 
09:04:01.860953458 +0200
@@ -178,6 +178,7 @@ static void mv_process_current_q(int fir
          op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
          break;
      case COP_AES_CBC:
+    default:
          op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_CBC;
          op.enc_iv = ENC_IV_POINT(SRAM_DATA_IV) |
              ENC_IV_BUF_POINT(SRAM_DATA_IV_BUF);

