From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: x86: Remove duplicate define of SHA1_DIGEST_SIZE
Date: Wed, 14 Oct 2015 21:15:51 +0200
Message-ID: <1444850171-17931-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: ameenali023@gmail.com, bp@alien8.de, clabbe.montjoie@gmail.com,
	dan.carpenter@oracle.com, davem@davemloft.net, firogm@gmail.com,
	herbert@gondor.apana.org.au, hpa@zytor.com, mingo@redhat.com,
	minipli@googlemail.com, smueller@chronox.de, tglx@linutronix.de,
	tim.c.chen@linux.intel.com, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38413 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbJNTQi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 15:16:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sha x86 crypto code use two define for the same thing:
NUM_SHA1_DIGEST_WORDS and SHA1_DIGEST_LENGTH
Replace them by SHA1_DIGEST_SIZE/4

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c    | 2 +-
 arch/x86/crypto/sha-mb/sha_mb_ctx.h | 1 -
 arch/x86/crypto/sha-mb/sha_mb_mgr.h | 6 ++----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index a841e97..791cbfa 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -104,7 +104,7 @@ static asmlinkage struct job_sha1* (*sha1_job_mgr_get_comp_job)(struct sha1_mb_m
 
 inline void sha1_init_digest(uint32_t *digest)
 {
-	static const uint32_t initial_digest[SHA1_DIGEST_LENGTH] = {SHA1_H0,
+	static const uint32_t initial_digest[SHA1_DIGEST_SIZE / 4] = {SHA1_H0,
 					SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 };
 	memcpy(digest, initial_digest, sizeof(initial_digest));
 }
diff --git a/arch/x86/crypto/sha-mb/sha_mb_ctx.h b/arch/x86/crypto/sha-mb/sha_mb_ctx.h
index e36069d..9fd36eb5 100644
--- a/arch/x86/crypto/sha-mb/sha_mb_ctx.h
+++ b/arch/x86/crypto/sha-mb/sha_mb_ctx.h
@@ -94,7 +94,6 @@ enum hash_ctx_error {
 
 
 /* Hash Constants and Typedefs */
-#define SHA1_DIGEST_LENGTH          5
 #define SHA1_LOG2_BLOCK_SIZE        6
 
 #define SHA1_PADLENGTHFIELD_SIZE    8
diff --git a/arch/x86/crypto/sha-mb/sha_mb_mgr.h b/arch/x86/crypto/sha-mb/sha_mb_mgr.h
index 08ad1a9..3ff337c 100644
--- a/arch/x86/crypto/sha-mb/sha_mb_mgr.h
+++ b/arch/x86/crypto/sha-mb/sha_mb_mgr.h
@@ -54,11 +54,9 @@
 #ifndef __SHA_MB_MGR_H
 #define __SHA_MB_MGR_H
 
-
+#include <crypto/sha.h>
 #include <linux/types.h>
 
-#define NUM_SHA1_DIGEST_WORDS 5
-
 enum job_sts {	STS_UNKNOWN = 0,
 		STS_BEING_PROCESSED = 1,
 		STS_COMPLETED = 2,
@@ -69,7 +67,7 @@ enum job_sts {	STS_UNKNOWN = 0,
 struct job_sha1 {
 	u8	*buffer;
 	u32	len;
-	u32	result_digest[NUM_SHA1_DIGEST_WORDS] __aligned(32);
+	u32	result_digest[SHA1_DIGEST_SIZE / 4] __aligned(32);
 	enum	job_sts status;
 	void	*user_data;
 };
-- 
2.4.9
