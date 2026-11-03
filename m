Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793664206;
	b=hQ9DgFvLkWzeD4ddBTh11fMdAWLyAF6b1RWAdP/UHW+GOmer9mKq43XFzhJhkz6cUN58
	 ToBcPg68VsFS4jU9rc/9SZIaWearrihhgL0dMvv3fCfqFtdRnGlr/ZMoEVxmKyrbykJDc
	 6e8bdquH+CY2xRfT+7NffLLpqUOagKBVfU5T1Uhke2001Ql2rokqIUg5pLMpdM6cqyY2y
	 i/Q4XUfIDgKoHczK5Bjh+6Y3xam7jH+4X3YhhKyfWA575GkdgdBt7hJ8f9H1+3lVA/hyC
	 bVWkwIcpGblG3ruBapxHZ+EAyNj0J9gAGK3CWAdgtyOM+8n43H9VuCa3xgLMe85kJnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793664206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mwQ2z/age/B8OVHRkYCsNYXmBR1En6PKc33rR/ATxnM=;
	b=c3NWrZcnyOaAZ+3aEjW8KYoZirwyEa1jLxrPw+TYMf+G3hH1AFM9t0QQj8qlM9JQGN+P
	 J7MAh4QQlI7kd4udaK4buiE5VEJMs5bgOhc+zeE3ATl45bgolmfg8twD5km06Dt0tB9DM
	 vENPs0hb/IrHLp8f082CPSgfUFGEKFnQ3RfZkQfoqKIy7HEz5GHOtZ501J55R1sn9z0zT
	 /Jqvru8OrmFuED7Af7htdMUHsRjdJdRqzrQKVfgTQAvYV24cw/tn28GDJEimeafFdv9C0
	 X3j9shU4dsMvrZfLoiJIECawPK2k42tLoB1+lR6juIIVnFWcmtTifVWvUEW+RSAj9Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gvvbvhit;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1CA606D807
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 00:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C1CA606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gvvbvhit
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36a18fc7a38so6660152eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 16:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793664205; x=1794269005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mwQ2z/age/B8OVHRkYCsNYXmBR1En6PKc33rR/ATxnM=;
        b=gvvbvhit4nOAdNkRPqtYIUGcc6H/xG2s8hlp9IhhIq9jKPuQGFb29VyWC6t4fPgxEY
         K1dCFrM3A1YvNsszCGWXiyTq0IBycUQbiUmPphnV0IzOKQ+Ma9EbpM7TZcBpHkynviJ1
         r7yQ1nvl6FcMfxNksKst1MMkUWlit9ClXviYQB+ToKSPooKSIfqPX/CUxckfUgTQnK2C
         bkzo8sJsdIrsrEMD1la9b0TtU9MpjHsYM45COJYCdMQcNUmGvGcBFc9kzOvFONyCw6BG
         c+1kCsrND1aUi1SU2E/n8brTsX48fXDq2ioWdI0F3aJbkufqiXbSHZyrEU3ZkXciqkg/
         zJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793664205; x=1794269005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mwQ2z/age/B8OVHRkYCsNYXmBR1En6PKc33rR/ATxnM=;
        b=vCTIGcafIz7w8B/bnXjbOUrAoW1aVl+Z1hU16/EGDKdBjZcm0WVm4VeM5Cy9tydaaX
         imRDCNBI2LqTuprRHNiBH5I2PvjJXa0hkba5CVjhe7mBY+XXCB3vZRQ9W/4YS1lD25Tw
         K1QI5q9wyKBzlxVcK4N3zIcxTQaPlRBo3ODxB7px2k/KM5iHS/ZqjjwuAywcUhx1DLWw
         ZkBiWolXzdN9cGWc/7N5Pod6qQFUWHnIE4VqsczvI72KolO6zij1MLVgmYvFKtVlF+y4
         sGqeu6nTDDe0neFPETNSjqA8rk4AsBkhpxBV6ueedNKY+jPx27+04vOdB5ufTzLdULR0
         2CXQ==
X-Forwarded-Encrypted: i=1; AKwUvBwunu0qYcYm0sVTM4veCE2VOvSq28u/OdWWHsLorTMHXQyyj0Z/aQwBpHhXhc0mTXErHcQxVgI0mKSweYQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9XWHU1Le1dvt9tNOVnnyEdjQfkWcsx02+ls+rKW8SeBFX4hUGr
	32qAQBe5saLxGbOg080T62VQ+YY7LGvdS86oy16UnzR+EoWqIe0CyM9k
X-Gm-Gg: AYBFou1fO55BygGOGWu0U/uInDjgVkF3DqEQAS/EwvLqAK2Lw/9epB1KRJUCkUmM6VY
	u35EBgbTGNeYb6UbjIZ6TXD3VSBJTKje/45rFtww142WMT33hQowLEaIf2swbpkVNGEJx5gITov
	7yvSov5z645f9kfumbSSa474qVq5z3IhaXy5llWxsVg6zvH4Ap5B47WShwyxQl+bLnfhnY/Dnhp
	EEt7QXlZwH345M+9+u1sZetkMZpGMEBmxXGlshtuauTIkIxZez7SZgiYEZXU2kk6q7dLfRLIGGQ
	HmdUdk6tHu5ey42c0fx8ElVv/MLJ0hcjvlkreAdChdmwYp+V5nF+DRZNaAMpEe6u+YV02q5yh62
	0/MRhxVtIlDTFPi6lpAIK33SbjVYb++v16cIzQgw1eTO0DoIDDIftVefxNhJaVaDfdImmFpNSXo
	+UtuSbVFKcHd+uYjMx7ZhilCBjjMmZAddkMHiZbLA1z3qtriABupC752L3EZQtLf7x+QVERRYhS
	5LWknimdl7JAJzqL5lVe1Wb7PupFQCuT+9cIqDNR5T3TCIOZZiL/5fe4giiLWJBkbvAOyDluyPc
	wBr6rVLYGv997HQEQ5FCoYkX1XLOfYZpd5vqxJuFrA==
X-Received: by 2002:a05:693c:69d1:b0:358:3426:d601 with SMTP id 5a478bee46e88-36a4221b3c6mr19297627eec.2.1793664205205;
        Mon, 02 Nov 2026 16:03:25 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a429018casm36699729eec.14.2026.11.02.16.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 16:03:23 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool, instead of per-CPU.
Date: Mon,  2 Nov 2026 16:03:13 -0800
Message-Id: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "struct crypto_acomp" member of the per-CPU "struct
crypto_acomp_ctx" has been moved to "struct zswap_pool" since this is a
global entity representing the crypto algorithm.

We save 56 bytes per-CPU by not allocating per-CPU memory for the
crypto_acomp. The size of the global "struct zswap_pool" increases from
240 to 248 bytes as a result of this change.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 63 +++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..68825a6c0b68 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -151,7 +151,6 @@ struct zswap_comp_ctx {
 
 /* Separate requests, so that decompression does not wait for compression. */
 struct crypto_acomp_ctx {
-	struct crypto_acomp *acomp;
 	struct zswap_comp_ctx comp;
 	struct zswap_acomp_req decomp;	/* unused with on-stack requests */
 };
@@ -167,6 +166,7 @@ struct zswap_pool {
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct rcu_work release_rwork;
+	struct crypto_acomp *acomp;
 	struct hlist_node node;
 	u8 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
@@ -286,16 +286,6 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	acomp_request_free(acomp_ctx->decomp.req);
 	acomp_ctx->decomp.req = NULL;
 
-	/*
-	 * We have to handle both cases here: an error pointer return from
-	 * crypto_alloc_acomp_node(); and a) NULL initialization by zswap, or
-	 * b) NULL assignment done in a previous call to acomp_ctx_free().
-	 */
-	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
-		crypto_free_acomp(acomp_ctx->acomp);
-
-	acomp_ctx->acomp = NULL;
-
 	kfree(acomp_ctx->comp.buffer);
 	acomp_ctx->comp.buffer = NULL;
 }
@@ -322,6 +312,17 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
+	/*
+	 * In case of an error, crypto_alloc_acomp() returns an
+	 * error pointer, never NULL.
+	 */
+	pool->acomp = crypto_alloc_acomp(pool->tfm_name, 0, 0);
+	if (IS_ERR(pool->acomp)) {
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+			pool->tfm_name, pool->acomp);
+		goto error;
+	}
+
 	/* Many things rely on the zero-initialization. */
 	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
 					   GFP_KERNEL | __GFP_ZERO);
@@ -385,6 +386,14 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
+
+	/*
+	 * We have to handle both cases here: an error pointer return from
+	 * crypto_alloc_acomp(); and NULL initialization by kzalloc_obj().
+	 */
+	if (!IS_ERR_OR_NULL(pool->acomp))
+		crypto_free_acomp(pool->acomp);
+
 	if (pool->zs_pool)
 		zs_destroy_pool(pool->zs_pool);
 	kfree(pool);
@@ -423,6 +432,13 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 
 	free_percpu(pool->acomp_ctx);
 
+	/*
+	 * We have to handle both cases here: an error pointer return from
+	 * crypto_alloc_acomp(); and NULL initialization by kzalloc_obj().
+	 */
+	if (!IS_ERR_OR_NULL(pool->acomp))
+		crypto_free_acomp(pool->acomp);
+
 	zs_destroy_pool(pool->zs_pool);
 	kfree(pool);
 }
@@ -840,34 +856,20 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	 * To handle cases where the CPU goes through online-offline-online
 	 * transitions, we return if the acomp_ctx has already been initialized.
 	 */
-	if (acomp_ctx->acomp) {
-		WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
+	if (acomp_ctx->comp.areq.req)
 		return 0;
-	}
 
 	acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
 	if (!acomp_ctx->comp.buffer)
 		return ret;
 
-	/*
-	 * In case of an error, crypto_alloc_acomp_node() returns an
-	 * error pointer, never NULL.
-	 */
-	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
-		pr_err("could not alloc crypto acomp %s : %pe\n",
-				pool->tfm_name, acomp_ctx->acomp);
-		ret = PTR_ERR(acomp_ctx->acomp);
-		goto fail;
-	}
-
-	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
+	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, pool->acomp);
 	if (ret)
 		goto req_fail;
 
 	/* Skip the per-CPU request when decompression can use the stack. */
-	if (acomp_is_async(acomp_ctx->acomp)) {
-		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
+	if (acomp_is_async(pool->acomp)) {
+		ret = zswap_acomp_req_init(&acomp_ctx->decomp, pool->acomp);
 		if (ret)
 			goto req_fail;
 	}
@@ -876,7 +878,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 req_fail:
 	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
-fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
 }
@@ -1031,7 +1032,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	 * Otherwise serialize decompression on the shared per-CPU request.
 	 */
 	if (!acomp_ctx->decomp.req) {
-		ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
+		ACOMP_REQUEST_ON_STACK(req, pool->acomp);
 		DECLARE_CRYPTO_WAIT(wait);
 
 		zswap_set_acomp_req_callback(req, &wait);
-- 
2.39.5

