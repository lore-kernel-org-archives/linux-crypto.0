From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 02/13] crypto: crypto4xx: fix off-by-one AES-OFB
Date: Wed,  4 Oct 2017 01:00:06 +0200
Message-ID: <797afe0175f10d30c33ce84a0bcc814ff95767e8.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:51502 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXAV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:21 -0400
Received: by mail-wm0-f41.google.com with SMTP id f4so11743537wme.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:20 -0700 (PDT)
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I used aes-cbc as a template for ofb. But sadly I forgot
to update set_key method to crypto4xx_setkey_aes_ofb().

this was caught by the testmgr:
alg: skcipher: Test 1 failed (invalid result) on encr. for ofb-aes-ppc4xx
00000000: 76 49 ab ac 81 19 b2 46 ce e9 8e 9b 12 e9 19 7d
00000010: 50 86 cb 9b 50 72 19 ee 95 db 11 3a 91 76 78 b2
00000020: 73 be d6 b8 e3 c1 74 3b 71 16 e6 9e 22 22 95 16
00000030: 3f f1 ca a1 68 1f ac 09 12 0e ca 30 75 86 e1 a7

With the correct set_key method, the aes-ofb cipher passes the test.

name         : ofb(aes)
driver       : ofb-aes-ppc4xx
module       : crypto4xx
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 773e5faebc47..cb45365166ae 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1148,7 +1148,7 @@ struct crypto4xx_alg_common crypto4xx_alg[] = {
 				.min_keysize	= AES_MIN_KEY_SIZE,
 				.max_keysize	= AES_MAX_KEY_SIZE,
 				.ivsize		= AES_IV_SIZE,
-				.setkey		= crypto4xx_setkey_aes_cbc,
+				.setkey		= crypto4xx_setkey_aes_ofb,
 				.encrypt	= crypto4xx_encrypt,
 				.decrypt	= crypto4xx_decrypt,
 			}
-- 
2.14.2
