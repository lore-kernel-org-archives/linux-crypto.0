Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726745AbfANXY6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 18:24:58 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH 4.4,3.18] crypto: cts - fix crash on short inputs
Date: Mon, 14 Jan 2019 15:21:45 -0800
Message-Id: <20190114232145.205845-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Hi Greg, please consider applying this to 4.4-stable and 3.18-stable.
It's a minimal fix for a bug that was fixed incidentally by a large
refactoring in v4.8.

>8------------------------------------------------------8<

In the CTS template, when the input length is <= one block cipher block
(e.g. <= 16 bytes for AES) pass the correct length to the underlying CBC
transform rather than one block.  This matches the upstream behavior and
makes the encryption/decryption operation correctly return -EINVAL when
1 <= nbytes < bsize or succeed when nbytes == 0, rather than crashing.

This was fixed upstream incidentally by a large refactoring,
commit 0605c41cc53c ("crypto: cts - Convert to skcipher").  But
syzkaller easily trips over this when running on older kernels, as it's
easily reachable via AF_ALG.  Therefore, this patch makes the minimal
fix for older kernels.

Cc: linux-crypto@vger.kernel.org
Fixes: 76cb9521795a ("[CRYPTO] cts: Add CTS mode required for Kerberos AES support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cts.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index e467ec0acf9f0..e65688d6a4caa 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -137,8 +137,8 @@ static int crypto_cts_encrypt(struct blkcipher_desc *desc,
 	lcldesc.info = desc->info;
 	lcldesc.flags = desc->flags;
 
-	if (tot_blocks == 1) {
-		err = crypto_blkcipher_encrypt_iv(&lcldesc, dst, src, bsize);
+	if (tot_blocks <= 1) {
+		err = crypto_blkcipher_encrypt_iv(&lcldesc, dst, src, nbytes);
 	} else if (nbytes <= bsize * 2) {
 		err = cts_cbc_encrypt(ctx, desc, dst, src, 0, nbytes);
 	} else {
@@ -232,8 +232,8 @@ static int crypto_cts_decrypt(struct blkcipher_desc *desc,
 	lcldesc.info = desc->info;
 	lcldesc.flags = desc->flags;
 
-	if (tot_blocks == 1) {
-		err = crypto_blkcipher_decrypt_iv(&lcldesc, dst, src, bsize);
+	if (tot_blocks <= 1) {
+		err = crypto_blkcipher_decrypt_iv(&lcldesc, dst, src, nbytes);
 	} else if (nbytes <= bsize * 2) {
 		err = cts_cbc_decrypt(ctx, desc, dst, src, 0, nbytes);
 	} else {
-- 
2.20.1.97.g81188d93c3-goog
