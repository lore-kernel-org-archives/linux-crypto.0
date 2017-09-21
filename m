From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 4/6] crypto: talitos - fix AEAD test failures
Date: Thu, 21 Sep 2017 09:19:53 +0200 (CEST)
Message-ID: <f715a42e1a9ac3f3301d1b637c4cfdcf4ca8e744.1575825623.git.christophe.leroy@c-s.fr>
References: <cover.1575825623.git.christophe.leroy@c-s.fr>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:35630 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751676AbdIUHTz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 03:19:55 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 3xySfj29tTz9ttBX
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:41 +0200 (CEST)
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id rihMO8O2Jroq for <linux-crypto@vger.kernel.org>;
        Thu, 21 Sep 2017 09:19:41 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 3xySfj0h5nz9ttBK
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:41 +0200 (CEST)
In-Reply-To: <cover.1575825623.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AEAD tests fail when destination SG list has more than 1 element.

[    2.058752] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-aes-talitos
[    2.066965] 00000000: 53 69 6e 67 6c 65 20 62 6c 6f 63 6b 20 6d 73 67
00000010: c0 43 ff 74 c0 43 ff e0 de 83 d1 20 de 84 8e 54
00000020: de 83 d7 c4
[    2.082138] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-aes-talitos
[    2.090435] 00000000: 53 69 6e 67 6c 65 20 62 6c 6f 63 6b 20 6d 73 67
00000010: de 84 ea 58 c0 93 1a 24 de 84 e8 59 de 84 f1 20
00000020: 00 00 00 00
[    2.105721] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-3des-talitos
[    2.114259] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
00000080: c0 50 f1 ac c0 50 f3 38 c0 50 f3 94 c0 50 f5 30
00000090: c0 99 74 3c
[    2.166410] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-3des-talitos
[    2.174794] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
00000080: c0 50 f1 ac c0 50 f3 38 c0 50 f3 94 c0 50 f5 30
00000090: c0 99 74 3c
[    2.226486] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-talitos)
[    2.236459] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-talitos)
[    2.247196] alg: aead: Test 1 failed on encryption for authenc-hmac-sha224-cbc-3des-talitos
[    2.255555] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
00000080: c0 50 f1 ac c0 50 f3 38 c0 50 f3 94 c0 50 f5 30
00000090: c0 99 74 3c c0 96 e5 b8
[    2.309004] alg: aead: Test 1 failed on encryption for authenc-hmac-sha224-cbc-3des-talitos
[    2.317562] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
00000080: c0 50 f1 ac c0 50 f3 38 c0 50 f3 94 c0 50 f5 30
00000090: c0 99 74 3c c0 96 e5 b8
[    2.370710] alg: aead: Test 1 failed on encryption for authenc-hmac-sha256-cbc-aes-talitos
[    2.379177] 00000000: 53 69 6e 67 6c 65 20 62 6c 6f 63 6b 20 6d 73 67
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
[    2.397863] alg: aead: Test 1 failed on encryption for authenc-hmac-sha256-cbc-aes-talitos
[    2.406134] 00000000: 53 69 6e 67 6c 65 20 62 6c 6f 63 6b 20 6d 73 67
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
[    2.424789] alg: aead: Test 1 failed on encryption for authenc-hmac-sha256-cbc-3des-talitos
[    2.433491] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
00000080: c0 50 f1 ac c0 50 f3 38 c0 50 f3 94 c0 50 f5 30
00000090: c0 99 74 3c c0 96 e5 b8 c0 96 e9 20 c0 00 3d dc
[    2.488832] alg: aead: Test 1 failed on encryption for authenc-hmac-sha256-cbc-3des-talitos
[    2.497387] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
00000080: c0 50 f1 ac c0 50 f3 38 c0 50 f3 94 c0 50 f5 30
00000090: c0 99 74 3c c0 96 e5 b8 c0 96 e9 20 c0 00 3d dc

This patch fixes that.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dff88838dce7..cd8a37e60259 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1232,12 +1232,11 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			sg_link_tbl_len += authsize;
 	}
 
-	sg_count = talitos_sg_map(dev, areq->src, cryptlen, edesc,
-				  &desc->ptr[4], sg_count, areq->assoclen,
-				  tbl_off);
+	ret = talitos_sg_map(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
+			     sg_count, areq->assoclen, tbl_off);
 
-	if (sg_count > 1) {
-		tbl_off += sg_count;
+	if (ret > 1) {
+		tbl_off += ret;
 		sync_needed = true;
 	}
 
-- 
2.13.3
