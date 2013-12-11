From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH cryptodev] crypto: arch - use crypto_memneq instead of memcmp
Date: Wed, 11 Dec 2013 11:28:59 +0100
Message-ID: <1386757739-32564-1-git-send-email-dborkman@redhat.com>
Cc: linux-crypto@vger.kernel.org, James Yonan <james@openvpn.net>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3LKK3M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Dec 2013 05:29:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace remaining occurences (just as we did in crypto/) under arch/*/crypto/
that make use of memcmp() for comparing keys or authentication tags for
usage with crypto_memneq(). It can simply be used as a drop-in replacement
for the normal memcmp().

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: James Yonan <james@openvpn.net>
---
 arch/s390/crypto/des_s390.c        | 6 +++---
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index bcca01c..200f2a1 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -237,9 +237,9 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
 
-	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
-	    memcmp(&key[DES_KEY_SIZE], &key[DES_KEY_SIZE * 2],
-		   DES_KEY_SIZE)) &&
+	if (!(crypto_memneq(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
+	    crypto_memneq(&key[DES_KEY_SIZE], &key[DES_KEY_SIZE * 2],
+			  DES_KEY_SIZE)) &&
 	    (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 835488b..aba34b8 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1001,7 +1001,7 @@ static int __driver_rfc4106_decrypt(struct aead_request *req)
 		authTag, auth_tag_len);
 
 	/* Compare generated tag with passed in tag. */
-	retval = memcmp(src + tempCipherLen, authTag, auth_tag_len) ?
+	retval = crypto_memneq(src + tempCipherLen, authTag, auth_tag_len) ?
 		-EBADMSG : 0;
 
 	if (one_entry_in_sg) {
-- 
1.8.3.1
