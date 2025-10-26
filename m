Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCA6244667;
	Sun, 26 Oct 2025 05:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457984; cv=none; b=iHoixrO20QcCt672yE2FQ8SmzucG0KkS0cZ4o/RDJn/uYcae7tI3RIOqZnvDbOxrsbhtij4DHxg0WjAIrS/JPd+GL+fz95E97CLIHKeW9/iKhodx0wT7Enad+tJXpoqD0dpLLs6F38jkSypLcSIhWubc18Z0ym6nSaYMRrQgDgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457984; c=relaxed/simple;
	bh=rqo1U7wEhsUB8CdH4qk8hnOmmNikMjvUrW83FPZiVAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSufykOVmq0udJqoXh+TP+ZEmUbVxizjfM5S3XZKfgvji+5S7JGqobdoljDzGyb8D0xVdQZNzHWUpgMuQwx7PZMYvBYwiYvNvSJSTcARrx8673sfW+g4rGLeScdzAYrfaPVGwBHR4nhYKO0tsEZmYNxIXLa17XyQn8R5jr8yOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVTq6Mmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVTq6Mmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E20C4CEF7;
	Sun, 26 Oct 2025 05:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457983;
	bh=rqo1U7wEhsUB8CdH4qk8hnOmmNikMjvUrW83FPZiVAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVTq6Mmi474WJoE5Nj8BFZshsSmt1hahi/B3fYgTDipMpnXO3uXdegxKIf8GWTlWY
	 9tHTh2KfdMvnAPdMgyCKweIVaFM/efr+s0yc4Sh930Et2Kk3L98m6HpxgOZQgRnLJi
	 F5XVycbAWvsgG71nnZAKDz43xkcFTX2c3XgzrT/YjH1fTdHGhaY4weHZIVVrDfOf2z
	 /65ke7kp3/BLU4AvTS/W8tp7wiJNnq+wpM1RJQUB8xlr4tIPKL8FI4XDRzsgWCFuJ7
	 BoKqSWY3Elv2R1/UnpJVZCIlwWZ6nFZxCo78HPchNRXJBKRWMyFD59LkefTnyeaY5n
	 k/AoxxuoVLSVw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/15] crypto: s390/sha3 - Rename conflicting functions
Date: Sat, 25 Oct 2025 22:50:18 -0700
Message-ID: <20251026055032.1413733-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

Rename the s390 sha3_*_init() functions to have an "s390_" prefix to
avoid a name conflict with the upcoming SHA-3 library functions.

Note: this code will be superseded later.  This commit simply keeps the
kernel building for the initial introduction of the library.

Signed-off-by: David Howells <dhowells@redhat.com>
[EB: dropped unnecessary rename of import and export functions, and
     improved commit message]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/s390/crypto/sha3_256_s390.c | 10 +++++-----
 arch/s390/crypto/sha3_512_s390.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
index 03bb4f4bab701..7415d56649a52 100644
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
@@ -77,11 +77,11 @@ static int sha3_224_import(struct shash_desc *desc, const void *in)
 	return 0;
 }
 
 static struct shash_alg sha3_256_alg = {
 	.digestsize	=	SHA3_256_DIGEST_SIZE,	   /* = 32 */
-	.init		=	sha3_256_init,
+	.init		=	s390_sha3_256_init,
 	.update		=	s390_sha_update_blocks,
 	.finup		=	s390_sha_finup,
 	.export		=	sha3_256_export,
 	.import		=	sha3_256_import,
 	.descsize	=	S390_SHA_CTX_SIZE,
@@ -94,22 +94,22 @@ static struct shash_alg sha3_256_alg = {
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
 	.export		=	sha3_256_export, /* same as for 256 */
 	.import		=	sha3_224_import, /* function code different! */
 	.descsize	=	S390_SHA_CTX_SIZE,
diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
index a5c9690eecb19..ff6ee55844005 100644
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
@@ -76,11 +76,11 @@ static int sha3_384_import(struct shash_desc *desc, const void *in)
 	return 0;
 }
 
 static struct shash_alg sha3_512_alg = {
 	.digestsize	=	SHA3_512_DIGEST_SIZE,
-	.init		=	sha3_512_init,
+	.init		=	s390_sha3_512_init,
 	.update		=	s390_sha_update_blocks,
 	.finup		=	s390_sha_finup,
 	.export		=	sha3_512_export,
 	.import		=	sha3_512_import,
 	.descsize	=	S390_SHA_CTX_SIZE,
@@ -95,22 +95,22 @@ static struct shash_alg sha3_512_alg = {
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
 	.export		=	sha3_512_export, /* same as for 512 */
 	.import		=	sha3_384_import, /* function code different! */
 	.descsize	=	S390_SHA_CTX_SIZE,
-- 
2.51.1.dirty

