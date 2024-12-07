Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE959155C82
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=F6mEgmilZ4SQmB6zplyQHAWz4irmhyf/OMrQqcl14uYr5r8Fgc4E1Aome54B1XDCSBMglfRgnhjAFOvEPP17yUwrDvlIx0MKSDGWfx9uqRQ85PYYgLMOV+fKK24aolTm3Cau4Ca0+ae3gt4FF2MXG/fnahtaFHCwbqs3jYY7MKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=6/TQ3vOptxxMUN/+0bpc2eXcGnHqvxGx0hNgF0cctl0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8G7pTOZGlKSTsOBJf15yqoHQR0+HBJP2GRZ6guAwC8gYyQD7bneU58/cJhA3T+/CTyqYafCBtsffL1xw/X6XP9bX3H8BHUCCClX8dYe+2O/UDvlh+1sr+pbaVhLrkaPkbxedsVbQnRMc9oDMvdOMhOqvs5XLWZExO90YQ2hgSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmCK2WRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmCK2WRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F78C4CEDC
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601513;
	bh=6/TQ3vOptxxMUN/+0bpc2eXcGnHqvxGx0hNgF0cctl0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LmCK2WRenVPIuVpMO7uXrSa7rod1P7YOBTSiC/Ls5OQhAvalIDssuk3psROlrERU9
	 OE80NJmMGEd6I8tmK8L8CO7iwenkwskz7dMLM8KrDX/5i4d8NT5itfD5ZzdIwabvkm
	 DfhphOjF1RnHKP59/jXCqpVg1cTt4NEio6j/8yObOt/Q7sykwpHHPZqYpcvuJlXrAm
	 GF7PAjmsuaX1AivhV5+91aWnzuxP6STDc10S0uitDg+7+LmpBihgnOrjQTIiC91pA9
	 3P2Z/lzDeyuRCbyEdJKfjvYIUSL4eFRr29672GtLmn+lq2wJpYHT4TKs+5a/YLtBwb
	 KrToc2EXI/Rog==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 6/8] crypto: x86 - remove assignments of 0 to cra_alignmask
Date: Sat,  7 Dec 2024 11:57:50 -0800
Message-ID: <20241207195752.87654-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241207195752.87654-1-ebiggers@kernel.org>
References: <20241207195752.87654-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Struct fields are zero by default, so these lines of code have no
effect.  Remove them to reduce the number of matches that are found when
grepping for cra_alignmask.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-glue.c | 1 -
 arch/x86/crypto/blowfish_glue.c       | 1 -
 arch/x86/crypto/camellia_glue.c       | 1 -
 arch/x86/crypto/des3_ede_glue.c       | 1 -
 arch/x86/crypto/twofish_glue.c        | 1 -
 5 files changed, 5 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index c19d8e3d96a35..01fa568dc5fc4 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -238,11 +238,10 @@ static struct aead_alg crypto_aegis128_aesni_alg = {
 	.base = {
 		.cra_flags = CRYPTO_ALG_INTERNAL,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct aegis_ctx) +
 			       __alignof__(struct aegis_ctx),
-		.cra_alignmask = 0,
 		.cra_priority = 400,
 
 		.cra_name = "__aegis128",
 		.cra_driver_name = "__aegis128-aesni",
 
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 552f2df0643f2..26c5f2ee5d103 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -92,11 +92,10 @@ static struct crypto_alg bf_cipher_alg = {
 	.cra_driver_name	= "blowfish-asm",
 	.cra_priority		= 200,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= BF_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct bf_ctx),
-	.cra_alignmask		= 0,
 	.cra_module		= THIS_MODULE,
 	.cra_u = {
 		.cipher = {
 			.cia_min_keysize	= BF_MIN_KEY_SIZE,
 			.cia_max_keysize	= BF_MAX_KEY_SIZE,
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index f110708c8038c..3bd37d6641216 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1311,11 +1311,10 @@ static struct crypto_alg camellia_cipher_alg = {
 	.cra_driver_name	= "camellia-asm",
 	.cra_priority		= 200,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_ctx),
-	.cra_alignmask		= 0,
 	.cra_module		= THIS_MODULE,
 	.cra_u			= {
 		.cipher = {
 			.cia_min_keysize = CAMELLIA_MIN_KEY_SIZE,
 			.cia_max_keysize = CAMELLIA_MAX_KEY_SIZE,
diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index abb8b1fe123b4..e88439d3828ea 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -289,11 +289,10 @@ static struct crypto_alg des3_ede_cipher = {
 	.cra_driver_name	= "des3_ede-asm",
 	.cra_priority		= 200,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct des3_ede_x86_ctx),
-	.cra_alignmask		= 0,
 	.cra_module		= THIS_MODULE,
 	.cra_u = {
 		.cipher = {
 			.cia_min_keysize	= DES3_EDE_KEY_SIZE,
 			.cia_max_keysize	= DES3_EDE_KEY_SIZE,
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index 0614beece2793..4c67184dc573e 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -66,11 +66,10 @@ static struct crypto_alg alg = {
 	.cra_driver_name	=	"twofish-asm",
 	.cra_priority		=	200,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	TF_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct twofish_ctx),
-	.cra_alignmask		=	0,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	TF_MIN_KEY_SIZE,
 			.cia_max_keysize	=	TF_MAX_KEY_SIZE,
-- 
2.47.1

