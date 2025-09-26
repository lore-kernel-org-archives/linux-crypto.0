Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B2E2192E4
	for <linux-crypto@vger.kernel.org>; Fri, 26 Sep 2025 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758896460; cv=none; b=ux70eAJLRHvoPpm2i0V4az8U092iJCOAB4LM4Nxu6nbPbA0QLci8KidXB0IfBqfL2Y4hl1zdtoz84qv1PuX5ZkRryvbtXBBAnlcv+8tG3H9nHrDIavOBdpHuXk+xwYT5dUBgSRSpAfgmMB8vOXerUtxGFyf6QQjFVJoBKH1FXMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758896460; c=relaxed/simple;
	bh=kqqGOhpz0a/MgJMid5qITPh41468A2ybGVrDemtdS4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaXDBx+sTWwWcxLrj9mSPpZGXQvtooD1xEbd6j265q9g+uNw+kvGjQjWvvFkHyIjKtX62rtKdp6ZiOTwlSzHVrk6HvTNwhmN+FtF5N0EQWhtLGow174qJW6wVXZaHZnmomMxDF/07b8nWw2tXOgED2pgSqzwR4ntlUzT/HtxZaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SYSI4V1T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SYSI4V1T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758896457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yV37y+MHgEeU8QeaEoc7GtsZWjYLys4curv5++kbhTw=;
	b=SYSI4V1TYRoO/y2aHWK8IfX9ovhBouTluEo4kfUg+yDYjnIyZChnwQUXI+YeYFhI0F1nyO
	JA+Z0yPwg8he7O4VEWVmEBDScoYhCvqEiGp2CFRfAqP4j1H1l4U5qI6BvyzsBofzHZBmBi
	yp4PspyPSY5xr21FrkCKMypaI5k29HI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-P1B5m6TmMwasNz--h5L-dA-1; Fri,
 26 Sep 2025 10:20:45 -0400
X-MC-Unique: P1B5m6TmMwasNz--h5L-dA-1
X-Mimecast-MFC-AGG-ID: P1B5m6TmMwasNz--h5L-dA_1758896436
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3E42180057E;
	Fri, 26 Sep 2025 14:20:36 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.155])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D86E1800982;
	Fri, 26 Sep 2025 14:20:34 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: 
Cc: David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/8] crypto/sha3: Add SHAKE128/256 support
Date: Fri, 26 Sep 2025 15:19:50 +0100
Message-ID: <20250926141959.1272455-8-dhowells@redhat.com>
In-Reply-To: <20250926141959.1272455-1-dhowells@redhat.com>
References: <20250926141959.1272455-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

SHAKE128/256 'digest' algos need to be available for the ML-DSA pre-digest,
which is a selectable algorithm and need to be available through the same
API as, say, SHA3-512 and SHA512 both.  Resqueezability (probably) isn't
required for this and they'll produce the default number of bytes as the
digest size.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Jason A. Donenfeld <Jason@zx2c4.com>
cc: Ard Biesheuvel <ardb@kernel.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Stephan Mueller <smueller@chronox.de>
cc: linux-crypto@vger.kernel.org
---
 crypto/sha3_generic.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 6917a1aeb8e5..4fae066ec3f5 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -95,6 +95,28 @@ static struct shash_alg algs[] = { {
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHAKE128_DEFAULT_SIZE,
+	.init			= crypto_sha3_init,
+	.update			= crypto_sha3_update,
+	.finup			= crypto_sha3_finup,
+	.descsize		= sizeof(struct sha3_ctx),
+	.base.cra_name		= "shake128",
+	.base.cra_driver_name	= "shake128-generic",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
+	.base.cra_blocksize	= SHAKE128_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHAKE256_DEFAULT_SIZE,
+	.init			= crypto_sha3_init,
+	.update			= crypto_sha3_update,
+	.finup			= crypto_sha3_finup,
+	.descsize		= sizeof(struct sha3_ctx),
+	.base.cra_name		= "shake256",
+	.base.cra_driver_name	= "shake256-generic",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
+	.base.cra_blocksize	= SHAKE256_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
 } };
 
 static int __init sha3_generic_mod_init(void)
@@ -121,3 +143,7 @@ MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-384-generic");
 MODULE_ALIAS_CRYPTO("sha3-512");
 MODULE_ALIAS_CRYPTO("sha3-512-generic");
+MODULE_ALIAS_CRYPTO("shake128");
+MODULE_ALIAS_CRYPTO("shake128-generic");
+MODULE_ALIAS_CRYPTO("shake256");
+MODULE_ALIAS_CRYPTO("shake256-generic");

