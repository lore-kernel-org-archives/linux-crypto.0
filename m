From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] crypto: ccm - remove goto
Date: Tue, 13 Oct 2015 13:48:25 +0530
Message-ID: <1444724305-3235-1-git-send-email-sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33756 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbJMISd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 04:18:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Instead of using goto and jumping to a label and then returning from
there, lets return directly. The label out: is not used from anywhere
else in the code.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 crypto/ccm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index cc31ea4..daa7e6d 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -881,14 +881,13 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	if (err)
 		goto out_drop_alg;
 
-out:
 	return err;
 
 out_drop_alg:
 	crypto_drop_aead(spawn);
 out_free_inst:
 	kfree(inst);
-	goto out;
+	return err;
 }
 
 static struct crypto_template crypto_rfc4309_tmpl = {
-- 
1.9.1
