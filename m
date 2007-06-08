From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH/RFC] [Crypto] Check if ablkcipher->queue field is used.
Date: Fri, 8 Jun 2007 19:55:51 +0200
Message-ID: <20070608175551.GA8770@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51404 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762787AbXFHRzw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 13:55:52 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1Hwigh-0002rI-LF
	for linux-crypto@vger.kernel.org; Fri, 08 Jun 2007 19:55:51 +0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy's hifn driver and probably mine don't use ablkcipher->queue at all. 
The show method of ablkcipher will access this field without checking if it 
is valid.

Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Index: b/crypto/ablkcipher.c
===================================================================
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -91,8 +91,10 @@ static void crypto_ablkcipher_show(struc
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
 	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
-	seq_printf(m, "qlen         : %u\n", ablkcipher->queue->qlen);
-	seq_printf(m, "max qlen     : %u\n", ablkcipher->queue->max_qlen);
+	if (ablkcipher->queue) {
+		seq_printf(m, "qlen         : %u\n", ablkcipher->queue->qlen);
+		seq_printf(m, "max qlen     : %u\n", ablkcipher->queue->max_qlen);
+	}
 }
 
 const struct crypto_type crypto_ablkcipher_type = {
