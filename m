Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2CB2EC564
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759324148; cv=none; b=jUQKUwqV/CUTcNu2ShjgEmuJnvwTErhcKhFU+bf/Jb7d+9sZGONgrBjnoYP5gSU6Tn0s3k7qNhXu3FKTSDo5zBAMchaWLXqEzCJXYCIJwtIUqFKlfJSi/iaMIftWAEWC/xmz6FDES0jEbH0vmsYAQQjkG5/I1Ms2mLPbJRy9WgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759324148; c=relaxed/simple;
	bh=pu/Wq7yaIyvBO3zNXz8Gt3QQ0JYmGbu8ebJVzjfJJbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJbX5aRm/p7BvcGS9qb1tIo2fF/AW7zt4LrqyNw90yPPNdtu5t3WTDTSKqqAeavBVRozqWf5SYQrEqesCblT9VAWRVtOKiyjjP4eyNmnUgXkvYCsvxbpTfN4dX0falM7/IC9kyXLpXzSO8pDLGC4BUBTBga1bvT0tYVPbt6QWbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PoTf8J3Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PoTf8J3Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759324145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IzFlPAZDLxRFUBTmQm4fHS0TbV7GeZRfH8gzkTO+hL0=;
	b=PoTf8J3YHM+7XXZdjcLiCBiFPHvD7ZR8SewxLVoqfmDAur8SIhCoqDlNZNTw2iyyUNOnwP
	oqoPT25XC5FkYGS96TvedBDSOZO3+0E5L+LvY2Q4V9LOge8dSSK1PniUSQSNkSDYbomWDH
	JB3LF90nCDfPth6vUt8jIhmcrpkyDEE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-q8ldn25gNvCfKULXigaMKg-1; Wed,
 01 Oct 2025 09:09:00 -0400
X-MC-Unique: q8ldn25gNvCfKULXigaMKg-1
X-Mimecast-MFC-AGG-ID: q8ldn25gNvCfKULXigaMKg_1759324138
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11E411800576;
	Wed,  1 Oct 2025 13:08:58 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E25E719560B4;
	Wed,  1 Oct 2025 13:08:54 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH v4 1/5] s390/sha3: Rename conflicting functions
Date: Wed,  1 Oct 2025 14:08:40 +0100
Message-ID: <20251001130846.2284946-2-dhowells@redhat.com>
In-Reply-To: <20251001130846.2284946-1-dhowells@redhat.com>
References: <20251001130846.2284946-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Rename the s390 sha3_* functions to have an "s390_" prefix to avoid
conflict with generic code.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-By: Harald Freudenberger <freude@linux.ibm.com>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Jason A. Donenfeld <Jason@zx2c4.com>
cc: Ard Biesheuvel <ardb@kernel.org>
cc: Holger Dengler <dengler@linux.ibm.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Stephan Mueller <smueller@chronox.de>
cc: linux-crypto@vger.kernel.org
cc: linux-s390@vger.kernel.org
---
 arch/s390/crypto/sha3_256_s390.c | 26 +++++++++++++-------------
 arch/s390/crypto/sha3_512_s390.c | 26 +++++++++++++-------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
index 03bb4f4bab70..fd5ecae60a57 100644
--- a/arch/s390/crypto/sha3_256_s390.c
+++ b/arch/s390/crypto/sha3_256_s390.c
@@ -19,7 +19,7 @@
 
 #include "sha.h"
 
-static int sha3_256_init(struct shash_desc *desc)
+static int s390_sha3_256_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
@@ -32,7 +32,7 @@ static int sha3_256_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int sha3_256_export(struct shash_desc *desc, void *out)
+static int s390_sha3_256_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
@@ -50,7 +50,7 @@ static int sha3_256_export(struct shash_desc *desc, void *out)
 	return 0;
 }
 
-static int sha3_256_import(struct shash_desc *desc, const void *in)
+static int s390_sha3_256_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
@@ -68,22 +68,22 @@ static int sha3_256_import(struct shash_desc *desc, const void *in)
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
@@ -96,22 +96,22 @@ static struct shash_alg sha3_256_alg = {
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
diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
index a5c9690eecb1..f4b52a3a0433 100644
--- a/arch/s390/crypto/sha3_512_s390.c
+++ b/arch/s390/crypto/sha3_512_s390.c
@@ -18,7 +18,7 @@
 
 #include "sha.h"
 
-static int sha3_512_init(struct shash_desc *desc)
+static int s390_sha3_512_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 
@@ -31,7 +31,7 @@ static int sha3_512_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int sha3_512_export(struct shash_desc *desc, void *out)
+static int s390_sha3_512_export(struct shash_desc *desc, void *out)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
@@ -49,7 +49,7 @@ static int sha3_512_export(struct shash_desc *desc, void *out)
 	return 0;
 }
 
-static int sha3_512_import(struct shash_desc *desc, const void *in)
+static int s390_sha3_512_import(struct shash_desc *desc, const void *in)
 {
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	union {
@@ -67,22 +67,22 @@ static int sha3_512_import(struct shash_desc *desc, const void *in)
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
@@ -97,22 +97,22 @@ static struct shash_alg sha3_512_alg = {
 
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

