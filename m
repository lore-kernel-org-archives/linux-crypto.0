Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8B64B0495
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484134; cv=none; b=ojMESSaVXy8f2f9gj1G/UjC1+uS/BuhxLHiazGZJGGHFmlt9TuhVhPnq6LOMqhMENYpYYoC3qf2R83U+jHHL8tPA7YV9iPheTARt/rGoFD2hX+iXo0nA/WCaNY6Wk3y0LLM1jttUmaXvb8CcVMf8cONfmonCZkwC2vnAdfMDXXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484134; c=relaxed/simple;
	bh=vAn31BgMqMt9oqNCmvWWiyP+yK6Na/BpJ46cuwCrGsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rohICvMowMTErQJO9gEcTPCqNWQajRhDj3UQHCAwvIZuxjG5YNFffYCwnx0pyhOhBbaQxXeP/76s3CZnBGsWMO1uJ6uDw+tp3LRI9cdxkBdUWtzZsjg4JIDa1JWBsGftKrmel0YmSzUNXJAyu+s22pzUne+cQiEOaMo864b75Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQ85Z5N9; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQ85Z5N9"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3514e7cbbbaso6877680eec.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484118; x=1792088918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rVjA49YbHPrrArJOEmGKyCCKQKJO7CIf1JAShxUw9ic=;
        b=LQ85Z5N9izQfPoT2VCiw9j7hxuzK1alDDBUTh6AWJkWG95fzSsHyNj79Bg/v2h3xqN
         w4Ry04ja3pY/OdkhwdCpcoQzt6eVXIlPkU+GVG2vy/I5ozRpLPrXcBzpCZZhH1OsH+Vw
         xB20vVRibLvYHpZ9UBEx0WFu+akDDNhUrfHRWsWZWJZPY2rQu/4T3Rx3PZBGySPvhOr3
         3rRRo46Ich7BrhlL9GqRNqPG+bxw1aC/T2FUScrhENO0u6RWZJsOopmMifNHJtrR/bQL
         citLHrXQBRyq9BmTmlDinlfccrhYIZQvK/oabjfk53ncB+U9E1XyMDYOsQY2qJw/vMnQ
         C0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484118; x=1792088918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rVjA49YbHPrrArJOEmGKyCCKQKJO7CIf1JAShxUw9ic=;
        b=hc5+yCFn1KZMjWNp+7YXOzin0fcVm5Iu/0XCa2LIAX6g7fLqoYeytGI172i6FCVCZT
         gHmvjkNrHTne1BG0GYPCyeXHXFEaPEHorapnCx33hdouZjRQRRzu4tCfyu/AEtoq8fZE
         hGye+rdgDbKidEsP6FiCXrZXGLWiV+Gyqiqn2vVCY0i9NMkbSTu4pJ92Sz9fUqzwtG1J
         WQKRCKZnekY8KxcnFUbE78V1erRZbSCu3RQX+5ylLWjaXjFS34iOlY/fB9gPu1tYH4ne
         +VPncO+X4V8m8/I8yJdX6Xauchv1PWzVq8u9ZxVALxMoQhRWIfQ0mEX/HbXH80FtvTat
         zQBw==
X-Forwarded-Encrypted: i=1; AKwUvByCfeTOF0zX1ZnWxpJXHoHsa5H3Ex5lbps6wtyV9jbjaRZOXk+hqjxBw4fPsLR2kKjf84z3vXuC+i66N/Q=@vger.kernel.org
X-Gm-Message-State: AFuF++kiYqq2OlsJtwlaoc7Dl8QaGPhOnjPf/x/+qksEMZvWtyNYFmE7
	+1xP/TuaRcIME5oivV3t72YXdAYA5Y17EZSg1OToj5dMXwLDAkCnOK8V
X-Gm-Gg: AYBFou3f+0rWvv+Qi/f2e98HSPAAUFKaNzptPETQzGjPu82QOX+OBzCxoK2Al/ZSyz9
	9e0W/ew267+0/D30y4//IPy+DUWsHBC/B0a49loIN9ijDHOEGPZcziGN25DCOtj2683PNwmsHf0
	e0Fg+Fx+k6bzkafV+BvdbQLmv7S3v+ql/KtgIDJAibe3VF1GU49lvmiE1jOP8fb2pJr5P9I7sf0
	RhIr9n/FI5zOumecOKbhr/vDFLcVIBB/yDg2Hm9ViCvl6nCs819daD8rCKUWkm5xt4ezvqI1813
	hDrv/xOTp7FEx/WaSRl3NQIgrm9G5PYn4dMjkk4ycqmx8UPQcVVaiHIkob4Q5BaIBmbLLZp5FvS
	yYInap/+BS6rV5J7kTqPNnqA3rhGLooG1pQiTkWdZr66zAFZHmDXKBpw+Teg8acsQ5Br5M24bMD
	vL75gakNsY11aUKtZUm8n0y0AfP5XtkWi1FqfS7sJvOLvHFM+LmNSUN3ruDHSXoZ0dMX4UOux+j
	zEInG9PB73IaeF+61IqIg==
X-Received: by 2002:a05:701b:2912:b0:144:fb31:a597 with SMTP id a92af1059eb24-16208fb33a6mr7919513c88.47.1791484117710;
        Thu, 08 Oct 2026 11:28:37 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:37 -0700 (PDT)
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
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v1 7/8] mm: zswap: Optimally place members of struct zswap_pool, struct zswap_entry.
Date: Thu,  8 Oct 2026 11:28:13 -0700
Message-Id: <20261008182814.27450-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Place and align the members of struct zswap_pool and struct zswap_entry
such that members used together in compress/decompress hot paths are
able to share the same cacheline. Minimize holes within these structs
while doing so.

Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 8ae67fd10522..ade84ac4076e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
 struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
-	u8 compr_batch_size;
 	struct percpu_ref ref;
-	struct rcu_work release_rwork;
-	struct hlist_node node;
 	u8 idx;
+	u8 compr_batch_size;
+	struct hlist_node node;
+	struct rcu_work release_rwork;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
@@ -202,10 +202,10 @@ static struct shrinker *zswap_shrinker;
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
  * nid - NUMA node id of the page for which this is the zswap entry.
- * pool_idx - id of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
+ * pool_idx - id of the zswap_pool that the entry's data is in.
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
@@ -214,10 +214,10 @@ struct zswap_entry {
 		bool referenced:1;
 	};
 	int nid;
-	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
+	u8 pool_idx;
 };
 
 /*
-- 
2.39.5

