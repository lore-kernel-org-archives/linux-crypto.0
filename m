From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: x86: Remove duplicate define of SHA1_DIGEST_SIZE
Date: Thu, 29 Oct 2015 08:51:08 +0100
Message-ID: <20151029075108.GA25880@Red>
References: <1444850171-17931-1-git-send-email-clabbe.montjoie@gmail.com>
 <1445011498.14635.1.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ameenali023@gmail.com, bp@alien8.de, dan.carpenter@oracle.com,
	davem@davemloft.net, firogm@gmail.com, herbert@gondor.apana.org.au,
	hpa@zytor.com, mingo@redhat.com, minipli@googlemail.com,
	smueller@chronox.de, tglx@linutronix.de, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>, tglx@linutronix.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f193.google.com ([209.85.212.193]:34915 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbJ2HvN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Oct 2015 03:51:13 -0400
Content-Disposition: inline
In-Reply-To: <1445011498.14635.1.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 16, 2015 at 09:04:58AM -0700, Tim Chen wrote:
> On Wed, 2015-10-14 at 21:15 +0200, LABBE Corentin wrote:
> > The sha x86 crypto code use two define for the same thing:
> > NUM_SHA1_DIGEST_WORDS and SHA1_DIGEST_LENGTH
> > Replace them by SHA1_DIGEST_SIZE/4
> 
> Thanks.  Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
> > 
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> 

Hello

Thanks for your ack, but Thomas Gleixner in the same time NACK this patch.
Just in case I attach the new patch, for permit you to decide which one you prefer.

Regards

--8<--
>From 7439bc57d95de49a510c0eb5d328dec10a3c6689 Mon Sep 17 00:00:00 2001
From: LABBE Corentin <clabbe.montjoie@gmail.com>
Date: Wed, 14 Oct 2015 12:48:04 +0200
Subject: [PATCH] crypto: x86: Remove duplicate define of SHA1_DIGEST_SIZE

The sha x86 crypto code use two define for the same thing:
NUM_SHA1_DIGEST_WORDS and SHA1_DIGEST_LENGTH
Replace them by SHA1_DIGEST_SIZE/4

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c    | 2 +-
 arch/x86/crypto/sha-mb/sha_mb_ctx.h | 1 -
 arch/x86/crypto/sha-mb/sha_mb_mgr.h | 6 +++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index a841e97..6544ea7 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -104,7 +104,7 @@ static asmlinkage struct job_sha1* (*sha1_job_mgr_get_comp_job)(struct sha1_mb_m
 
 inline void sha1_init_digest(uint32_t *digest)
 {
-	static const uint32_t initial_digest[SHA1_DIGEST_LENGTH] = {SHA1_H0,
+	static const uint32_t initial_digest[SHA1_DIGEST_WORDS] = {SHA1_H0,
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
index 08ad1a9..b295e15 100644
--- a/arch/x86/crypto/sha-mb/sha_mb_mgr.h
+++ b/arch/x86/crypto/sha-mb/sha_mb_mgr.h
@@ -54,10 +54,10 @@
 #ifndef __SHA_MB_MGR_H
 #define __SHA_MB_MGR_H
 
-
+#include <crypto/sha.h>
 #include <linux/types.h>
 
-#define NUM_SHA1_DIGEST_WORDS 5
+#define SHA1_DIGEST_WORDS (SHA1_DIGEST_SIZE / sizeof(u32))
 
 enum job_sts {	STS_UNKNOWN = 0,
 		STS_BEING_PROCESSED = 1,
@@ -69,7 +69,7 @@ enum job_sts {	STS_UNKNOWN = 0,
 struct job_sha1 {
 	u8	*buffer;
 	u32	len;
-	u32	result_digest[NUM_SHA1_DIGEST_WORDS] __aligned(32);
+	u32	result_digest[SHA1_DIGEST_WORDS] __aligned(32);
 	enum	job_sts status;
 	void	*user_data;
 };
-- 
2.4.10
