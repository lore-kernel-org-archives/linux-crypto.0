Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A302ECD13
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759324152; cv=none; b=lb0kahVwoHP92bqNPRGvXuwSwsG6Qujd8AJoS3vWCaOkdBz7fqfpfppKkkxyxWWmAag82ixIlR5gR2qe7VwlRWCq4DSvcQUNsDESJbmAisrzMMyTlOPZqHKz2pkRDNFTA6OywI5qCvnCmh4qCCZN1D1btptxQQY7/MszkS4tPIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759324152; c=relaxed/simple;
	bh=NZEIOIblbdawTCrxGt/Ero7Fwtqw3BTyIDWtF6I6nvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA7hBXpxaKhp6OHarbZtCuvqYyZKiuFXZPU4HDuxFxgHHcgizr6dB/YVMP23c6DW5m1hhU1AFLESAqvnznThFCqOOUEioq4hyf5O4ZvKoslDb+aLpXdVw3Q+d2YvUyuMCuZ47sH4X3UmnHKcMDCYjrTqBh6gYDSOiE1ECN72t2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hjwtrGq5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hjwtrGq5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759324150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gS6I9+pn+T6EshQ8kERlfqfUoiq0QQuAAxssnEC3ucQ=;
	b=hjwtrGq5gR4wVeghKNY4EoglXfX6LdkXYrcMWnV+UIMiAXi1+QulkRG+7bzMMDpaiM5U8/
	p/yUDX6Dlt02RDp/D8IUkGVaZOThA5Hrthx9KRpHhy9Sr+TcykxIO2OPYtw9Rr4i/KCSdj
	tqU5UXtb00ZkdUwVb51ltWFtnn5LBl4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-9ISZppLGP6KdkYM6WRj1Ow-1; Wed,
 01 Oct 2025 09:09:05 -0400
X-MC-Unique: 9ISZppLGP6KdkYM6WRj1Ow-1
X-Mimecast-MFC-AGG-ID: 9ISZppLGP6KdkYM6WRj1Ow_1759324143
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F16D118002C4;
	Wed,  1 Oct 2025 13:09:02 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B7C9195608E;
	Wed,  1 Oct 2025 13:08:59 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 2/5] arm64/sha3: Rename conflicting functions
Date: Wed,  1 Oct 2025 14:08:41 +0100
Message-ID: <20251001130846.2284946-3-dhowells@redhat.com>
In-Reply-To: <20251001130846.2284946-1-dhowells@redhat.com>
References: <20251001130846.2284946-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Rename the arm64 sha3_* functions to have an "arm64_" prefix to avoid
conflict with generic code.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Jason A. Donenfeld <Jason@zx2c4.com>
cc: Ard Biesheuvel <ardb@kernel.org>
cc: Catalin Marinas <catalin.marinas@arm.com>
cc: Will Deacon <will@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Stephan Mueller <smueller@chronox.de>
cc: linux-crypto@vger.kernel.org
cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/crypto/sha3-ce-glue.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index b4f1001046c9..426d8044535a 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -31,7 +31,7 @@ MODULE_ALIAS_CRYPTO("sha3-512");
 asmlinkage int sha3_ce_transform(u64 *st, const u8 *data, int blocks,
 				 int md_len);
 
-static int sha3_update(struct shash_desc *desc, const u8 *data,
+static int arm64_sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
@@ -55,8 +55,8 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 	return len;
 }
 
-static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
-		      u8 *out)
+static int arm64_sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
+			    u8 *out)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	struct crypto_shash *tfm = desc->tfm;
@@ -90,8 +90,8 @@ static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-224",
 	.base.cra_driver_name	= "sha3-224-ce",
@@ -102,8 +102,8 @@ static struct shash_alg algs[] = { {
 }, {
 	.digestsize		= SHA3_256_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-256",
 	.base.cra_driver_name	= "sha3-256-ce",
@@ -114,8 +114,8 @@ static struct shash_alg algs[] = { {
 }, {
 	.digestsize		= SHA3_384_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-384",
 	.base.cra_driver_name	= "sha3-384-ce",
@@ -126,8 +126,8 @@ static struct shash_alg algs[] = { {
 }, {
 	.digestsize		= SHA3_512_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
-	.update			= sha3_update,
-	.finup			= sha3_finup,
+	.update			= arm64_sha3_update,
+	.finup			= arm64_sha3_finup,
 	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-512",
 	.base.cra_driver_name	= "sha3-512-ce",

