Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46435 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbeJTHKC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 03:10:02 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] crypto: fix cfb mode decryption
Date: Sat, 20 Oct 2018 02:01:52 +0300
Message-Id: <20181019230153.28201-1-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_cfb_decrypt_segment() incorrectly XOR'ed generated keystream with
IV, rather than with data stream, resulting in incorrect decryption.
Test vectors will be added in the next patch.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: stable@vger.kernel.org
---
 crypto/cfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/cfb.c b/crypto/cfb.c
index a0d68c09e1b9..fd4e8500e121 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct skcipher_walk *walk,
 
 	do {
 		crypto_cfb_encrypt_one(tfm, iv, dst);
-		crypto_xor(dst, iv, bsize);
+		crypto_xor(dst, src, bsize);
 		iv = src;
 
 		src += bsize;
-- 
2.19.1
