Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ED130569E;
	Wed, 27 May 2026 06:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864638; cv=none; b=q1nfAE6V8VNX7m9n8hi0wbIO7oCQx6M6Izwsr79FIMw7/m9qIPfd5rn2Z0IqaiKFK5N8ywQbAYiLlscLxaeqVdbij97b6tC9ynuXE71ZQDGIGX6Zuky522noLr5eUZ3fNRO77k3bgzOb9PavbsGdslm9IeCYV1UC4cNb2pFPOuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864638; c=relaxed/simple;
	bh=UELCM2h04zdJYWmKKSJlAM9eZYQBgK9+WwrE1+sp08c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RK11LhZxNBtuDFibLpLH46kxQo4TMGqNEEpI/uDrejBhAINrBYMy8eg+rOlAD/3uV9tVa04fsdnasbvpntDT3+SjGvbCwcmSVW03wDI3KCuOW6LBLBpWiIhyer0KHhptppCuWG7bLB3jesqbgd7K0S2JMszve4i6jXqBtT6/KaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=q9IF6TzU; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="q9IF6TzU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779864637; x=1811400637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=avUDsFcJLGOTHoHOJ0Z0BmzumyUYOy0sTCh3tq0rYpM=;
  b=q9IF6TzUgjQHlT3WQ4WXxT4SF++AVchqSFjQkKJ1UrMJhzg2ExiLOl2Q
   C9FQc1aeQqTGDSU8raPwz+PMdLfgb1OVx7C6l6zGtwj9LlYKJ6Tg+Lh1R
   hik7ASSvdFv2qUO1Q9U0u9QIclAoOMthJz00bxMKbblxzhvMG8E5I2QH0
   fRbyyuNr86GAEGS0IQzlH/IOW5tIH5p8G1SiYAs1xJB5j0rBhPBhDIu+3
   rr9oTPkuzNeaxwheUVIJlUAKIyQftmFuVLJk9GKdABl4ZqCTgmw5IkM83
   NpNZfeN33/6yM9NsDZpUmx6eAvJw3ZaQT2PG8pC73YleGoDGuK6Tn5VMY
   g==;
X-CSE-ConnectionGUID: +aOtrcPDT1ifuzIpj/fKeg==
X-CSE-MsgGUID: lI/9jJO0SdipniavzJN9uA==
X-IronPort-AV: E=Sophos;i="6.24,171,1774310400"; 
   d="scan'208";a="20522599"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 06:50:34 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:29202]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.252:2525] with esmtp (Farcaster)
 id 43ceb8a4-5eeb-4d1f-bd00-1bc1ab9bf020; Wed, 27 May 2026 06:50:33 +0000 (UTC)
X-Farcaster-Flow-ID: 43ceb8a4-5eeb-4d1f-bd00-1bc1ab9bf020
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 06:50:33 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 06:50:31 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon
	<agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v2 2/4] crypto: xts - support multiple data units per request in template
Date: Wed, 27 May 2026 06:50:18 +0000
Message-ID: <20260527065021.19525-3-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260527065021.19525-1-lravich@amazon.com>
References: <20260527065021.19525-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
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
index ad97c8091582..f0585ea9d6d5 100644
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

