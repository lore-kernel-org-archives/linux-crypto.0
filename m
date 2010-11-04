From: Phil Sutter <phil@nwl.cc>
Subject: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Thu,  4 Nov 2010 18:50:36 +0100
Message-ID: <1288893036-31704-1-git-send-email-phil@nwl.cc>
Cc: Chuck Ebbert <cebbert@redhat.com>, Nico Erfurth <ne@erfurth.eu>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.169.95]:45447 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0KDSAz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 14:00:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using cryptodev-linux with it's zero-copy functionality, one is mighty
enough to pass various misaligned/mis-sized buffers unmodified to the
engine's driver, which occured to be an easy way to break padlock
equipped machines:

On one hand, the original code is broken in padlock_xcrypt_cbc(): when
passing the "initial" bytes to xcryptcbc, 'count' is incorrectly used as
length. This may trigger prefetch-related issues, but will definitely
lead to data corruption as xcryptcbc is called again afterwards,
altering (count - initial) * AES_BLOCK_SIZE bytes after the end of
'output' in memory.

Another problem occurs when passing non-64byte aligned buffers, which
leads to memory corruption in userspace (running applications crash
randomly). This problem is too subtile for me to have more than vague
assumptions about it's origin. Anyways, this patch fixes them:

Instead of handling the "odd" bytes (i.e., the remainder when dividing
into prefetch blocks of 64bytes) at the beginning, go for them in the
end, copying the data out if prefetching would run beyond the page
boundary.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Nico Erfurth <ne@erfurth.eu>
---
 drivers/crypto/padlock-aes.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2e992bc..b3f3382 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -260,19 +260,14 @@ static inline void padlock_xcrypt_ecb(const u8 *input, u8 *output, void *key,
 {
 	u32 initial = count & (ecb_fetch_blocks - 1);
 
-	if (count < ecb_fetch_blocks) {
-		ecb_crypt(input, output, key, control_word, count);
-		return;
-	}
-
-	if (initial)
+	if (count > initial) {
 		asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
 			      : "+S"(input), "+D"(output)
-			      : "d"(control_word), "b"(key), "c"(initial));
+			      : "d"(control_word), "b"(key), "c"(count - initial));
+	}
 
-	asm volatile (".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
-		      : "+S"(input), "+D"(output)
-		      : "d"(control_word), "b"(key), "c"(count - initial));
+	if (initial)
+		ecb_crypt(input, output, key, control_word, initial);
 }
 
 static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
@@ -280,17 +275,15 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 {
 	u32 initial = count & (cbc_fetch_blocks - 1);
 
-	if (count < cbc_fetch_blocks)
-		return cbc_crypt(input, output, key, iv, control_word, count);
-
-	if (initial)
+	if (count > initial) {
 		asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 			      : "+S" (input), "+D" (output), "+a" (iv)
-			      : "d" (control_word), "b" (key), "c" (count));
+			      : "d" (control_word), "b" (key), "c" (count - initial));
+	}
+
+	if (initial)
+		return cbc_crypt(input, output, key, iv, control_word, initial);
 
-	asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
-		      : "+S" (input), "+D" (output), "+a" (iv)
-		      : "d" (control_word), "b" (key), "c" (count-initial));
 	return iv;
 }
 
-- 
1.7.3.2
