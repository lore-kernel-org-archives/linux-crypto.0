From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: testmgr - swith deflate test to pcomp
Date: Tue, 13 Jan 2009 16:59:45 +0100
Message-ID: <1231862386-11128-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47648 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753177AbZAMP7z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 10:59:55 -0500
In-Reply-To: <1231862386-11128-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change the tests for the "deflate" crypto module from the "comp" to the "pcomp"
test framework.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c |    4 ++--
 crypto/testmgr.h |   24 ++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index aad718f..f102796 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1404,9 +1404,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "deflate",
-		.test = alg_test_comp,
+		.test = alg_test_pcomp,
 		.suite = {
-			.comp = {
+			.pcomp = {
 				.comp = {
 					.vecs = deflate_comp_tv_template,
 					.count = DEFLATE_COMP_TEST_VECTORS
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 81b7eb0..8b98d2e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15,6 +15,7 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
+#include <linux/zlib.h>
 #include <crypto/compress.h>
 
 #define MAX_DIGEST_SIZE		64
@@ -8360,11 +8361,27 @@ struct pcomp_testvec {
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
+
+static const struct deflate_comp_params deflate_comp_params = {
+	.enable_comp		= 1,
+	.windowBits		= -11,
+	.level			= Z_DEFAULT_COMPRESSION,
+	.method			= Z_DEFLATED,
+	.memLevel		= MAX_MEM_LEVEL,
+	.strategy		= Z_DEFAULT_STRATEGY
+};
+
+static const struct deflate_comp_params deflate_decomp_params = {
+	.enable_decomp		= 1,
+	.windowBits		= -11,
+};
+
 #define DEFLATE_COMP_TEST_VECTORS 2
 #define DEFLATE_DECOMP_TEST_VECTORS 2
 
-static struct comp_testvec deflate_comp_tv_template[] = {
+static struct pcomp_testvec deflate_comp_tv_template[] = {
 	{
+		.params = &deflate_comp_params,
 		.inlen	= 70,
 		.outlen	= 38,
 		.input	= "Join us now and share the software "
@@ -8375,6 +8392,7 @@ static struct comp_testvec deflate_comp_tv_template[] = {
 			  "\x48\x55\x28\xce\x4f\x2b\x29\x07"
 			  "\x71\xbc\x08\x2b\x01\x00",
 	}, {
+		.params = &deflate_comp_params,
 		.inlen	= 191,
 		.outlen	= 122,
 		.input	= "This document describes a compression method based on the DEFLATE"
@@ -8399,8 +8417,9 @@ static struct comp_testvec deflate_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec deflate_decomp_tv_template[] = {
+static struct pcomp_testvec deflate_decomp_tv_template[] = {
 	{
+		.params = &deflate_decomp_params,
 		.inlen	= 122,
 		.outlen	= 191,
 		.input	= "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
@@ -8423,6 +8442,7 @@ static struct comp_testvec deflate_decomp_tv_template[] = {
 			"compression algorithm.  This document defines the application of "
 			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
 	}, {
+		.params = &deflate_decomp_params,
 		.inlen	= 38,
 		.outlen	= 70,
 		.input	= "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"
-- 
1.6.0.4

