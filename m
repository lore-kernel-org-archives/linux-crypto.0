Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453C14C042E;
	Tue, 19 May 2026 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779192020; cv=none; b=f5IN8LKdlpjvMzAOppHCaAcx0spGuGLfxrjUuayTadAPDxhrhtZodxom560lqR7SU5M9VxMTb25uX9FOplRSovlmSOOAOsNgO2kW+aWJfpxMB/9H5aDfURQLOGIhCoxHFdc1SR7NAR01ZmiwwBJ8jpLzbdM/RCud0wNQRucD4Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779192020; c=relaxed/simple;
	bh=/aWnUkgb2nIyKnH5OvtJUPMy+9VC929KOVZRdjvfhPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JpI/zBLza939OMQBRtS2OClMVghcVuoYoZrULWCiHC9tWo0fCEdI18CG2VNm9F+kNSFGZUaQlZKzDNFxZ4JGUZa0Z403XqH0NdLMtpuPG7Hb0K8apr1jhY9SqZQW9Vu14+gH4+hy7IMNE0u906qSRfpNrlu6Gv4aCSHUh0AqkZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=dMH7K8ie; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="dMH7K8ie"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779192018; x=1810728018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DVXLgDMdttY3yDa6EPP/qcNVXhS+cIywuKpse1q4azY=;
  b=dMH7K8ie0eUuRaxWhukFvHEyMJJNL8qFrVxLIUIZO7kkRhjej0Kf7xJL
   ktG3V3WpLO99F/x7YKiVQZ0C5BCWJK4PFfN33VDOgPXPOyH4gvot9xSRr
   NZNU/4VGHlMtivF9ntBcQAkG6ScVDy+7zik7jSuGfVHjUGKKB99XejQWN
   uzPRyayQz9USx6EjcpdKgiBPucRMdEoxAWJwT4JPfAxmBdJguCAgg+g96
   pKWuGT3zSZh+Gpjh3H5VtfvoofEcl+VfNRH+0cJigZ4ShsQ38KrUiT65A
   54+Y0CGC+iqmeFemMl1bvzQiPG3J6ql5rg6LfUp7CEoNdDjfSDDgE2XLV
   Q==;
X-CSE-ConnectionGUID: 9CsgS5myRJa8QQ0vvRvsNg==
X-CSE-MsgGUID: XjWqDxDURW2vTs+b2f3oDg==
X-IronPort-AV: E=Sophos;i="6.23,243,1770595200"; 
   d="scan'208";a="20004678"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 12:00:17 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:17780]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.141:2525] with esmtp (Farcaster)
 id 2e6ea43b-d16b-416c-9206-641ce7d3d7fe; Tue, 19 May 2026 12:00:17 +0000 (UTC)
X-Farcaster-Flow-ID: 2e6ea43b-d16b-416c-9206-641ce7d3d7fe
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:16 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:14 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon
	<agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH 2/4] crypto: xts - support multiple data units per request in template
Date: Tue, 19 May 2026 11:59:58 +0000
Message-ID: <20260519120002.27267-3-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428101225.24316-1-lravich@amazon.com>
References: <20260428101225.24316-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Teach the generic xts() template to consume cryptlen larger than one
data unit when the caller has configured a non-zero data_unit_size on
the tfm.  Each data unit is processed with its own IV, derived from
the caller-supplied IV by treating it as a 128-bit little-endian
counter and adding the data-unit index.  This matches the
sector-indexed XTS used by dm-crypt's plain64 IV mode and by typical
inline-encryption hardware.

The single-data-unit body is unchanged and is now reached via a thin
xts_crypt_multi() dispatcher that skips straight to the body when
data_unit_size is zero (the legacy default), so existing users see
no extra cost.

Advertise CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT in cra_flags only when
the inner cipher is synchronous.  An async inner cipher would require
a per-DU completion chain which is out of scope for the slow software
template; consumers that need multi-DU on async hardware will use one
of the arch-specific drivers added later in this series.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/xts.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 3da8f5e053d6..2b7233311dad 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -258,7 +258,7 @@ static int xts_init_crypt(struct skcipher_request *req,
 	return 0;
 }
 
-static int xts_encrypt(struct skcipher_request *req)
+static int xts_encrypt_one(struct skcipher_request *req)
 {
 	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
@@ -275,7 +275,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	return xts_cts_final(req, crypto_skcipher_encrypt);
 }
 
-static int xts_decrypt(struct skcipher_request *req)
+static int xts_decrypt_one(struct skcipher_request *req)
 {
 	struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_request *subreq = &rctx->subreq;
@@ -292,6 +292,16 @@ static int xts_decrypt(struct skcipher_request *req)
 	return xts_cts_final(req, crypto_skcipher_decrypt);
 }
 
+static int xts_encrypt(struct skcipher_request *req)
+{
+	return skcipher_walk_data_units(req, xts_encrypt_one);
+}
+
+static int xts_decrypt(struct skcipher_request *req)
+{
+	return skcipher_walk_data_units(req, xts_decrypt_one);
+}
+
 static int xts_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
@@ -427,6 +437,17 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
 				       (__alignof__(u64) - 1);
 
+	/*
+	 * Advertise multi-data-unit support only when the inner cipher is
+	 * synchronous.  The dispatcher in skcipher_walk_data_units() calls
+	 * the single-DU body in a loop and assumes synchronous completion;
+	 * supporting async would require a per-DU callback chain, which
+	 * the slow software template does not need.
+	 */
+	if (!(alg->base.cra_flags & CRYPTO_ALG_ASYNC))
+		inst->alg.base.cra_flags |=
+			CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT;
+
 	inst->alg.ivsize = XTS_BLOCK_SIZE;
 	inst->alg.min_keysize = alg->min_keysize * 2;
 	inst->alg.max_keysize = alg->max_keysize * 2;
-- 
2.47.3

