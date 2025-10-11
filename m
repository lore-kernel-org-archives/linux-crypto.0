Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1159E323E
	for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 01:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760147344; cv=none; b=VS3kPMbXhpuHEv1cqyIfhZUskQrIEXlNiiIp4FuCZNJrff9QILoAx5P6yPOyZ4/4VGIjKfjruRahBr2ewUUc0a7Rm0Jxhe+79mmyETzQoZ8rhh4CP6DCRsM8KpA9+x4yYj/yKNm86/IeW+o7zHEpw0HQeP07pLXqHkx0plL0U8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760147344; c=relaxed/simple;
	bh=g7GDvoZrs8cwwpKWce4EUVp8OaXJbDT9MVkHEmFnElU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HlwWu/tnMZk768LIlUVfoIsmaC9inc+J3Nuy5mh0S/ARHmib1v70oEFTcNs/Mc0w3RkMljbpr0x1JvNsJRbLR7kEBN8ayt7rnEu7DVtEJkGx7QCwFzyEboVqFYQrIlYK7OkCXNWGzWu7gtIZlEAjEWpOx/hiX0QiPrAoGBYfsdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMnOc+43; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMnOc+43"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-28832ad6f64so30080755ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Oct 2025 18:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760147342; x=1760752142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iruFdvkToYSVQ/3V/DRRgXRgcaTu19K2IWXmsVEetJo=;
        b=KMnOc+43IM201PEOOYmMagOHgeBuEMuNBqHluuFvUCeurHTsZbgZCuybrhrFvNTmvC
         lcBbLU20Q1+ewfFF3gY42QOhB2PsRJ3cvJzBroL4tCMVrbQqNPUUsMBG/m9M5N4W8EK/
         bxnEQLf+seuumtZz6mJePa5AG18nj9D1Q0NPa7F3HB0adt99uMSFmKICfDj/46Poyjzj
         lauMv8ZHJ9hvhz9lqr3KXbD9e//xFbMJYjfe0KayehIQFd5idNblHC5ZIlXkaLvu4YYC
         A5+QHWaErHED79QUiZ9icBSm3eL8g+AeO70y4k0eF12A07GYxu2m2vnSoyaWoHKI8HV6
         LIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760147342; x=1760752142;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iruFdvkToYSVQ/3V/DRRgXRgcaTu19K2IWXmsVEetJo=;
        b=uQElQk9j4f7elIECGQbSrEmk2QSU0BvS8zROk6XQTbBDw86kskBU5WB/rQcPLHwKS8
         YQm4vKjN2kRwcPFc11Wo58EFab43DcTFvd0OdV35UIBN6TiF+o7uQbLtncxW28BVGwDg
         J1ea6YhAzg7HXEvtqOMLdY5hHeiSLauqFM5VvPZ4MIjMfYxzILWxVJwsgrz01E0agQuH
         TWFm7moX9hEpUFcdQxSFoCjy+xXkdFkA0/n5l/HaU6gXLDIRVAPfWCc1XMajvm4xJxVG
         0wgO5Br3kUjhqvV7mwD/i+KNhYjkZI3QtDBIP7qLj8oY+W9egirQRSyOrC1WbXkC6Opu
         ae9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV3XDbgL4IAWEJtqSy51PCBP74/D62fR+sZwoYa/I0unS0VgbiFaRKrCD3UB4ZecYhkVA+yqznUpaw4vZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxixZjou8D/F34QUIdQCTLRcUXYj8ekb8qgZlGR5VeyKhvS/AC0
	US8UUfsEw+9UjFQz4QpHTj1Fns9YZPBl6Ng2kcvITap/A5814U8mZQch
X-Gm-Gg: ASbGncvt80fc/4JsTAKVwH5khPji5Y92IhaiSmuUJxgfmdPtPP1Ikr326tqV0pSrgv/
	Cc+ms/hsuy5ZJ1ril8qAg19I97urh5aEZGiG2omgfl0F2NGWWwQaPZo+6jwny9WBJ+HiKiEW05O
	sdLSlz9XJGFLDXuzkfr+iRiu9Alecirhr5YjKYkcsKy9lR4qZWxjT+UrxVOyTg1ihdzOBtuvjKj
	JdHT7Q3/eI45NaGA1Kmp3LJkKF2T4NoTBgcbOPEXNIIj7E4wpQBrlea1y2V2iVFUVisZenLFoLr
	Yi8ul1BlvApKvhn0gwECUQY8S9ZhPKFpeO7dVC1kdUA8QsKxgYzy2vocVZrm5XW9rf+0xVUuvEq
	uqM/pWxOrhInvI/fanb/Aiw2Zig6HVkNQx8PMHRaFNQ==
X-Google-Smtp-Source: AGHT+IEYTp589+Jwre/BvJaC5w/WWVYQKdwor88i4CTTMt0bRlBAFpwCuP6hdr/NPHxriRgjt2kUfw==
X-Received: by 2002:a17:902:e943:b0:26c:bcb5:1573 with SMTP id d9443c01a7336-29027303192mr170515445ad.53.1760147342092;
        Fri, 10 Oct 2025 18:49:02 -0700 (PDT)
Received: from 7950hx ([43.129.244.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f07275sm69336655ad.66.2025.10.10.18.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 18:49:01 -0700 (PDT)
From: Menglong Dong <menglong8.dong@gmail.com>
X-Google-Original-From: Menglong Dong <dongml2@chinatelecom.cn>
To: herbert@gondor.apana.org.au,
	neilb@ownmail.net
Cc: tgraf@suug.ch,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jiang.biao@linux.dev
Subject: [PATCH v2] rhashtable: use likely for rhashtable lookup
Date: Sat, 11 Oct 2025 09:48:55 +0800
Message-ID: <20251011014855.73649-1-dongml2@chinatelecom.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometimes, the result of the rhashtable_lookup() is expected to be found.
Therefore, we can use likely() for such cases.

Following new functions are introduced, which will use likely or unlikely
during the lookup:

 rhashtable_lookup_likely
 rhltable_lookup_likely

A micro-benchmark is made for these new functions: lookup a existed entry
repeatedly for 100000000 times, and rhashtable_lookup_likely() gets ~30%
speedup.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
---
v2:
- remove the unlikely, as it's not suitable

This patch base on the patch that I commit before:
  rhashtable: use __always_inline for rhashtable

The new functions that we introduced can be used by other modules, and I'm
not sure if it is a good idea to do it in this series, as they belong to
different tree. So I decide to do it in the target tree after this patch
merged.
---
 include/linux/rhashtable.h | 70 +++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 12 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index e740157f3cd7..5b42dcdef23f 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -355,12 +355,25 @@ static inline void rht_unlock(struct bucket_table *tbl,
 	local_irq_restore(flags);
 }
 
-static inline struct rhash_head *__rht_ptr(
-	struct rhash_lock_head *p, struct rhash_lock_head __rcu *const *bkt)
+enum rht_lookup_freq {
+	RHT_LOOKUP_NORMAL,
+	RHT_LOOKUP_LIKELY,
+};
+
+static __always_inline struct rhash_head *__rht_ptr(
+	struct rhash_lock_head *p, struct rhash_lock_head __rcu *const *bkt,
+	const enum rht_lookup_freq freq)
 {
-	return (struct rhash_head *)
-		((unsigned long)p & ~BIT(0) ?:
-		 (unsigned long)RHT_NULLS_MARKER(bkt));
+	unsigned long p_val = (unsigned long)p & ~BIT(0);
+
+	BUILD_BUG_ON(!__builtin_constant_p(freq));
+
+	if (freq == RHT_LOOKUP_LIKELY)
+		return (struct rhash_head *)
+			(likely(p_val) ? p_val : (unsigned long)RHT_NULLS_MARKER(bkt));
+	else
+		return (struct rhash_head *)
+			(p_val ?: (unsigned long)RHT_NULLS_MARKER(bkt));
 }
 
 /*
@@ -370,10 +383,17 @@ static inline struct rhash_head *__rht_ptr(
  *   rht_ptr_exclusive() dereferences in a context where exclusive
  *            access is guaranteed, such as when destroying the table.
  */
+static __always_inline struct rhash_head *__rht_ptr_rcu(
+	struct rhash_lock_head __rcu *const *bkt,
+	const enum rht_lookup_freq freq)
+{
+	return __rht_ptr(rcu_dereference(*bkt), bkt, freq);
+}
+
 static inline struct rhash_head *rht_ptr_rcu(
 	struct rhash_lock_head __rcu *const *bkt)
 {
-	return __rht_ptr(rcu_dereference(*bkt), bkt);
+	return __rht_ptr_rcu(bkt, RHT_LOOKUP_NORMAL);
 }
 
 static inline struct rhash_head *rht_ptr(
@@ -381,13 +401,15 @@ static inline struct rhash_head *rht_ptr(
 	struct bucket_table *tbl,
 	unsigned int hash)
 {
-	return __rht_ptr(rht_dereference_bucket(*bkt, tbl, hash), bkt);
+	return __rht_ptr(rht_dereference_bucket(*bkt, tbl, hash), bkt,
+			 RHT_LOOKUP_NORMAL);
 }
 
 static inline struct rhash_head *rht_ptr_exclusive(
 	struct rhash_lock_head __rcu *const *bkt)
 {
-	return __rht_ptr(rcu_dereference_protected(*bkt, 1), bkt);
+	return __rht_ptr(rcu_dereference_protected(*bkt, 1), bkt,
+			 RHT_LOOKUP_NORMAL);
 }
 
 static inline void rht_assign_locked(struct rhash_lock_head __rcu **bkt,
@@ -588,7 +610,8 @@ static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
 /* Internal function, do not use. */
 static __always_inline struct rhash_head *__rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
-	const struct rhashtable_params params)
+	const struct rhashtable_params params,
+	const enum rht_lookup_freq freq)
 {
 	struct rhashtable_compare_arg arg = {
 		.ht = ht,
@@ -599,12 +622,13 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 	struct rhash_head *he;
 	unsigned int hash;
 
+	BUILD_BUG_ON(!__builtin_constant_p(freq));
 	tbl = rht_dereference_rcu(ht->tbl, ht);
 restart:
 	hash = rht_key_hashfn(ht, tbl, key, params);
 	bkt = rht_bucket(tbl, hash);
 	do {
-		rht_for_each_rcu_from(he, rht_ptr_rcu(bkt), tbl, hash) {
+		rht_for_each_rcu_from(he, __rht_ptr_rcu(bkt, freq), tbl, hash) {
 			if (params.obj_cmpfn ?
 			    params.obj_cmpfn(&arg, rht_obj(ht, he)) :
 			    rhashtable_compare(&arg, rht_obj(ht, he)))
@@ -643,11 +667,22 @@ static __always_inline void *rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
 {
-	struct rhash_head *he = __rhashtable_lookup(ht, key, params);
+	struct rhash_head *he = __rhashtable_lookup(ht, key, params,
+						    RHT_LOOKUP_NORMAL);
 
 	return he ? rht_obj(ht, he) : NULL;
 }
 
+static __always_inline void *rhashtable_lookup_likely(
+	struct rhashtable *ht, const void *key,
+	const struct rhashtable_params params)
+{
+	struct rhash_head *he = __rhashtable_lookup(ht, key, params,
+						    RHT_LOOKUP_LIKELY);
+
+	return likely(he) ? rht_obj(ht, he) : NULL;
+}
+
 /**
  * rhashtable_lookup_fast - search hash table, without RCU read lock
  * @ht:		hash table
@@ -693,11 +728,22 @@ static __always_inline struct rhlist_head *rhltable_lookup(
 	struct rhltable *hlt, const void *key,
 	const struct rhashtable_params params)
 {
-	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params);
+	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params,
+						    RHT_LOOKUP_NORMAL);
 
 	return he ? container_of(he, struct rhlist_head, rhead) : NULL;
 }
 
+static __always_inline struct rhlist_head *rhltable_lookup_likely(
+	struct rhltable *hlt, const void *key,
+	const struct rhashtable_params params)
+{
+	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params,
+						    RHT_LOOKUP_LIKELY);
+
+	return likely(he) ? container_of(he, struct rhlist_head, rhead) : NULL;
+}
+
 /* Internal function, please use rhashtable_insert_fast() instead. This
  * function returns the existing element already in hashes if there is a clash,
  * otherwise it returns an error via ERR_PTR().
-- 
2.51.0

