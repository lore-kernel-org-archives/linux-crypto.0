Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbeLFVAe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Dec 2018 16:00:34 -0500
Received: from ebiggers.mtv.corp.google.com (unknown [104.132.1.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F02D5205C9
        for <linux-crypto@vger.kernel.org>; Thu,  6 Dec 2018 21:00:33 +0000 (UTC)
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: xchacha20 - fix comments for test vectors
Date: Thu,  6 Dec 2018 13:00:08 -0800
Message-Id: <20181206210008.188975-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The kernel's ChaCha20 uses the RFC7539 convention of the nonce being 12
bytes rather than 8, so actually I only appended 12 random bytes (not
16) to its test vectors to form 24-byte nonces for the XChaCha20 test
vectors.  The other 4 bytes were just from zero-padding the stream
position to 8 bytes.  Fix the comments above the test vectors.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 357cf4cbcbb1c..e8f47d7b92cdd 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -32281,8 +32281,9 @@ static const struct cipher_testvec xchacha20_tv_template[] = {
 			  "\x57\x78\x8e\x6f\xae\x90\xfc\x31"
 			  "\x09\x7c\xfc",
 		.len	= 91,
-	}, { /* Taken from the ChaCha20 test vectors, appended 16 random bytes
-		to nonce, and recomputed the ciphertext with libsodium */
+	}, { /* Taken from the ChaCha20 test vectors, appended 12 random bytes
+		to the nonce, zero-padded the stream position from 4 to 8 bytes,
+		and recomputed the ciphertext using libsodium's XChaCha20 */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -32309,8 +32310,7 @@ static const struct cipher_testvec xchacha20_tv_template[] = {
 			  "\x03\xdc\xf8\x2b\xc1\xe1\x75\x67"
 			  "\x23\x7b\xe6\xfc\xd4\x03\x86\x54",
 		.len	= 64,
-	}, { /* Taken from the ChaCha20 test vectors, appended 16 random bytes
-		to nonce, and recomputed the ciphertext with libsodium */
+	}, { /* Derived from a ChaCha20 test vector, via the process above */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -32419,8 +32419,7 @@ static const struct cipher_testvec xchacha20_tv_template[] = {
 		.np	= 3,
 		.tap	= { 375 - 20, 4, 16 },
 
-	}, { /* Taken from the ChaCha20 test vectors, appended 16 random bytes
-		to nonce, and recomputed the ciphertext with libsodium */
+	}, { /* Derived from a ChaCha20 test vector, via the process above */
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
 			  "\xf3\x33\x88\x86\x04\xf6\xb5\xf0"
 			  "\x47\x39\x17\xc1\x40\x2b\x80\x09"
@@ -32463,8 +32462,7 @@ static const struct cipher_testvec xchacha20_tv_template[] = {
 			  "\x65\x03\xfa\x45\xf7\x9e\x53\x7a"
 			  "\x99\xf1\x82\x25\x4f\x8d\x07",
 		.len	= 127,
-	}, { /* Taken from the ChaCha20 test vectors, appended 16 random bytes
-		to nonce, and recomputed the ciphertext with libsodium */
+	}, { /* Derived from a ChaCha20 test vector, via the process above */
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
 			  "\xf3\x33\x88\x86\x04\xf6\xb5\xf0"
 			  "\x47\x39\x17\xc1\x40\x2b\x80\x09"
-- 
2.20.0.rc2.403.gdbc3b29805-goog
