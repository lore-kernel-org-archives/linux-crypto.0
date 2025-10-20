Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B18191F9C;
	Mon, 20 Oct 2025 00:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921612; cv=none; b=URITJsuWDWVxsAMrNWcPIyKk8dPyuWbt5xeleJsCxxsA/8fB35GU558uXPeT5n3xJCsLBMKGeTHsr3ACWw0rSI2g8qijMG08Yl/EvtFy5P/vo+8Xl5OuQUCFVs+nb8NWEbzVD9LsiwhML2W22+Xe1Li9IyarALKylrYpPScHIRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921612; c=relaxed/simple;
	bh=Y9Gh5NX+Xkq+eNV4N4mdP/PaI0Z1KJcE1oP/YqXj9K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkYS2+DWF8m4bsvIGz44JXDs0H2j4A9J0UgpKpkCtTfx5bUa9+F38yUD39n1y59C/fFEN28dooYV3xoJ/EqkIq9Wy0/wvcjl008j7Cfa1Wfo14iM97b36P5X1wgTdepCgZ7xE7mgrFIDFwstfGKMD7Pr/3gS65fgxpzrV9SHTT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBOZRs3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBOZRs3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3551C4AF09;
	Mon, 20 Oct 2025 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921612;
	bh=Y9Gh5NX+Xkq+eNV4N4mdP/PaI0Z1KJcE1oP/YqXj9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBOZRs3E1gzSfg8V/39IG+n9ZwkE5r4um/mONt1VG59Z72gZiYvq58iD3U056ONN/
	 LwL4JQiL/xjwShE9dXDUeVVnBtzcldXunITVcYU7JHlEnq3e5gfhkCTcW0XRCDqeU9
	 3KWzvkRHwhRJgNEdHkIuAUIlw2vDAJx/LEOH6ll6Yt5vihODVzZ10/EQoHCUbLfhrT
	 2a6yW9jP9qh7CdRObBczszygoV2l8BLngr9suXD7wCO2Etb5xjftdzzgWa0trwrZ1Q
	 BS710aDApMwShoFhhbz5sCc1JglsWK+VXhd4oftKW/pvzVNFMv1qdC35132kgxboJ6
	 u9DBQ7edEzpmg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 01/17] s390/sha3: Rename conflicting functions
Date: Sun, 19 Oct 2025 17:50:22 -0700
Message-ID: <20251020005038.661542-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

Rename the s390 sha3_* functions to have an "s390_" prefix to avoid
conflict with generic code.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-By: Harald Freudenberger <freude@linux.ibm.com>
cc: Eric Biggers <ebiggers@kernel.org>
cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
cc: Ard Biesheuvel <ardb@kernel.org>
cc: Holger Dengler <dengler@linux.ibm.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Stephan Mueller <smueller@chronox.de>
cc: linux-crypto@vger.kernel.org
cc: linux-s390@vger.kernel.org
Link: https://lore.kernel.org/r/20251017144311.817771-2-dhowells@redhat.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/s390/crypto/sha3_256_s390.c | 26 +++++++++++++-------------
 arch/s390/crypto/sha3_512_s390.c | 26 +++++++++++++-------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
index 03bb4f4bab701..fd5ecae60a572 100644
--- a/arch/s390/crypto/sha3_256_s390.c
+++ b/arch/s390/crypto/sha3_256_s390.c
@@ -17,11 +17,11 @@
 #include <linux/module.h>
 #include <linux/string.h>
 
 #include "sha.h"
 
-static int sha3_256_init(struct shash_desc *desc)
+static int s390_sha3_256_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
 	sctx->first_message_part = test_facility(86);
 	if (!sctx->first_message_part)
@@ -30,11 +30,11 @@ static int sha3_256_init(struct shash_desc *desc)
 	sctx->func = CPACF_KIMD_SHA3_256;
 
 	return 0;
 }
 
-static int sha3_256_export(struct shash_desc *desc, void *out)
+static int s390_sha3_256_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
 		u8 *u8;
 		u64 *u64;
@@ -48,11 +48,11 @@ static int sha3_256_export(struct shash_desc *desc, void *out)
 	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
 		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
 	return 0;
 }
 
-static int sha3_256_import(struct shash_desc *desc, const void *in)
+static int s390_sha3_256_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
 		const u8 *u8;
 		const u64 *u64;
@@ -66,26 +66,26 @@ static int sha3_256_import(struct shash_desc *desc, const void *in)
 	sctx->func = CPACF_KIMD_SHA3_256;
 
 	return 0;
 }
 
-static int sha3_224_import(struct shash_desc *desc, const void *in)
+static int s390_sha3_224_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	sha3_256_import(desc, in);
+	s390_sha3_256_import(desc, in);
 	sctx->func = CPACF_KIMD_SHA3_224;
 	return 0;
 }
 
 static struct shash_alg sha3_256_alg = {
 	.digestsize	=	SHA3_256_DIGEST_SIZE,	   /* = 32 */
-	.init		=	sha3_256_init,
+	.init		=	s390_sha3_256_init,
 	.update		=	s390_sha_update_blocks,
 	.finup		=	s390_sha_finup,
-	.export		=	sha3_256_export,
-	.import		=	sha3_256_import,
+	.export		=	s390_sha3_256_export,
+	.import		=	s390_sha3_256_import,
 	.descsize	=	S390_SHA_CTX_SIZE,
 	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-256",
 		.cra_driver_name =	"sha3-256-s390",
@@ -94,26 +94,26 @@ static struct shash_alg sha3_256_alg = {
 		.cra_blocksize	 =	SHA3_256_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
 };
 
-static int sha3_224_init(struct shash_desc *desc)
+static int s390_sha3_224_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	sha3_256_init(desc);
+	s390_sha3_256_init(desc);
 	sctx->func = CPACF_KIMD_SHA3_224;
 	return 0;
 }
 
 static struct shash_alg sha3_224_alg = {
 	.digestsize	=	SHA3_224_DIGEST_SIZE,
-	.init		=	sha3_224_init,
+	.init		=	s390_sha3_224_init,
 	.update		=	s390_sha_update_blocks,
 	.finup		=	s390_sha_finup,
-	.export		=	sha3_256_export, /* same as for 256 */
-	.import		=	sha3_224_import, /* function code different! */
+	.export		=	s390_sha3_256_export, /* same as for 256 */
+	.import		=	s390_sha3_224_import, /* function code different! */
 	.descsize	=	S390_SHA_CTX_SIZE,
 	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-224",
 		.cra_driver_name =	"sha3-224-s390",
diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
index a5c9690eecb19..f4b52a3a04339 100644
--- a/arch/s390/crypto/sha3_512_s390.c
+++ b/arch/s390/crypto/sha3_512_s390.c
@@ -16,11 +16,11 @@
 #include <linux/module.h>
 #include <linux/string.h>
 
 #include "sha.h"
 
-static int sha3_512_init(struct shash_desc *desc)
+static int s390_sha3_512_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
 	sctx->first_message_part = test_facility(86);
 	if (!sctx->first_message_part)
@@ -29,11 +29,11 @@ static int sha3_512_init(struct shash_desc *desc)
 	sctx->func = CPACF_KIMD_SHA3_512;
 
 	return 0;
 }
 
-static int sha3_512_export(struct shash_desc *desc, void *out)
+static int s390_sha3_512_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
 		u8 *u8;
 		u64 *u64;
@@ -47,11 +47,11 @@ static int sha3_512_export(struct shash_desc *desc, void *out)
 	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
 		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
 	return 0;
 }
 
-static int sha3_512_import(struct shash_desc *desc, const void *in)
+static int s390_sha3_512_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
 		const u8 *u8;
 		const u64 *u64;
@@ -65,26 +65,26 @@ static int sha3_512_import(struct shash_desc *desc, const void *in)
 	sctx->func = CPACF_KIMD_SHA3_512;
 
 	return 0;
 }
 
-static int sha3_384_import(struct shash_desc *desc, const void *in)
+static int s390_sha3_384_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	sha3_512_import(desc, in);
+	s390_sha3_512_import(desc, in);
 	sctx->func = CPACF_KIMD_SHA3_384;
 	return 0;
 }
 
 static struct shash_alg sha3_512_alg = {
 	.digestsize	=	SHA3_512_DIGEST_SIZE,
-	.init		=	sha3_512_init,
+	.init		=	s390_sha3_512_init,
 	.update		=	s390_sha_update_blocks,
 	.finup		=	s390_sha_finup,
-	.export		=	sha3_512_export,
-	.import		=	sha3_512_import,
+	.export		=	s390_sha3_512_export,
+	.import		=	s390_sha3_512_import,
 	.descsize	=	S390_SHA_CTX_SIZE,
 	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-512",
 		.cra_driver_name =	"sha3-512-s390",
@@ -95,26 +95,26 @@ static struct shash_alg sha3_512_alg = {
 	}
 };
 
 MODULE_ALIAS_CRYPTO("sha3-512");
 
-static int sha3_384_init(struct shash_desc *desc)
+static int s390_sha3_384_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
-	sha3_512_init(desc);
+	s390_sha3_512_init(desc);
 	sctx->func = CPACF_KIMD_SHA3_384;
 	return 0;
 }
 
 static struct shash_alg sha3_384_alg = {
 	.digestsize	=	SHA3_384_DIGEST_SIZE,
-	.init		=	sha3_384_init,
+	.init		=	s390_sha3_384_init,
 	.update		=	s390_sha_update_blocks,
 	.finup		=	s390_sha_finup,
-	.export		=	sha3_512_export, /* same as for 512 */
-	.import		=	sha3_384_import, /* function code different! */
+	.export		=	s390_sha3_512_export, /* same as for 512 */
+	.import		=	s390_sha3_384_import, /* function code different! */
 	.descsize	=	S390_SHA_CTX_SIZE,
 	.statesize	=	SHA3_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"sha3-384",
 		.cra_driver_name =	"sha3-384-s390",
-- 
2.51.1.dirty

