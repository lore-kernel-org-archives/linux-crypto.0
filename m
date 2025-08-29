Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C7E267386;
	Fri, 29 Aug 2025 07:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756452534; cv=none; b=U4F6016oy4utRqZURiExJ55NqGkinXwwj7Gxr2lW43rUcLYib11E+Ccdm8SuvTi14G3f9XSGMFNBYOGBNx6quSnJS/hy2MBOB38V5JGm/KZLTY8QQ+f94N623ETpBvlHYLWLoW2OntKZX0RzOdszUk4UsBc4DPdjpp+BM+2QoyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756452534; c=relaxed/simple;
	bh=STg3j8XzDW91rQul+W48CopkAC2QOSmZD7eY96ubL/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rmtTRdxU2tw/GnzlGdZZJThn1i95/PKIqgGzwWoMwlcFTZbsIp7vvHeKriluqq+GJIK7t5Qrp2O2V99swl1v8Er8/kHjjpTFkL6itBA2hlI4oQueFD27ViisAi2ugRcdaSPOLbfBu9B58vZuKyHGckFWtmr+Uc7H1Z94MeIk87w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLWsK2Np; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLWsK2Np"
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-b471737b347so1219994a12.1;
        Fri, 29 Aug 2025 00:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756452531; x=1757057331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7uXRB8A/81WekF9b01upV2VcbQiZFPOp207Ca9bht8s=;
        b=iLWsK2NpMoVKaTL2YcKS/hcMT9uL1poom0NVACZTXY6UOjeuFi2TyqpgL0pRRmVoxO
         d/fvDYJRLyq8/pm+pVXpF0IAI3p3Vithhty/Z7nKnNI0mLraUuv/gooRBFIC3YcDZgYq
         kuX4f7YlBmxqMfWCxnJUzaVl3mFt7OHhul+ZhNdxPaGbbj2D6tl76/+ClADzja8ZOFgC
         4OoCA0IfkD58i3mN41qhq9MjyYPIfWzqaRq/LP9MP4xX35Q7HK2wYX7HAawcjvxbk9GE
         7C1j8Z837HEZHRVNby/0MH4dJ4bODe89VfIMTddW3DmCxHCjh51hQgQS7Yc6r+72xoEm
         2hyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756452531; x=1757057331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7uXRB8A/81WekF9b01upV2VcbQiZFPOp207Ca9bht8s=;
        b=vgv4wf96k9XAo5Fse3kXMUWQ4Kf98+VefII4fXHLmCV9XfubypHaOvN6/H+kTK/Gn4
         6amA3L9kP0/sMU+J7VYjKrOs8GrmrgEjaZmrBBDBEYWrolSzzUoKWmwEJFMpxmyJa2hB
         m8YyI2teymzok5+AeyqaZsfhC3uAwJklojt+XTpV4JEMK1v1kuGCLGRujwwlADyRbaIJ
         k4RTXJCYVxmMefRv0Hqgb7+SDlrbaHKWZtCV6laPxc6euK+La+2bYKOI4iUT7fO3a5ug
         TEXnogk5eo/9VYFpZpHglMoJPiB+Q64pHZR6rTSMSI56M5cDeWb9NOpV8qavC9q19YE0
         IvQg==
X-Forwarded-Encrypted: i=1; AJvYcCVpAArUzRLNE+Nbk1wE4exguLtf5nqwC0rNsuq1eKN7HhXJZXRYsqbx5TkqF6wa5XX+WbTvxeDwttwQuPnF@vger.kernel.org, AJvYcCXVw5adftHXoKfBAJx4lrYczpW7P9KJien7HHAX9hfzAEfjpuxRwsSr1cxvwX15o5cA4rmqeX98QODaqus=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRw6vKkngNP0sL8LbzxmGFzgJqmupvH9JxdU3zysKkOezpgNz1
	q9BfW2JoNwviukMqCjZuNlu54+K6kCpkn41sqLV5uBd9ROX/v6vyJWKwWystgP+L
X-Gm-Gg: ASbGncukZwhg7v7IQQtzjDfiA4Ps8Y491vDdmsC/cQkA0q463iGBv/Q5/dU6Ap1WYfT
	e+nPbwm7+mEpHliAhQs04jnG0VRjj+vA4EK+ls3y6kGg6AiOz1/CaAgTagkTLrminfHgf/54bPs
	pTESe1aouP9gokMlo0CxUjbKe4yYz7mNkYA62XbFvGh5trJkGNUowRpR2+34GNoSe3qn9wzSb56
	Vow3DI3eZU3aE3FQ8DnBtkb4ovz5la96QStpeefWZCEXEIFcTYXSB1TCvoGAprseQrvqpYBddbI
	q6xPtG3QurudpknF0lZ9aMB9Tt6/9WDI2dQtkFeonoBIp5/s5GXF19jssKnkNf5i8k5QYP+hWa7
	iTYFlaBXTNqW2kmPOI+DgPQo=
X-Google-Smtp-Source: AGHT+IElOePnXroAuR8vG2/RTmvOQ2BoS7tksyYHx0eZfe2Z6xGU8a9JREQnZrzzv403IKJRSijjcQ==
X-Received: by 2002:a17:903:24d:b0:242:3105:1788 with SMTP id d9443c01a7336-2462ef8ef7fmr364149775ad.45.1756452531151;
        Fri, 29 Aug 2025 00:28:51 -0700 (PDT)
Received: from 7940hx ([43.129.244.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490374412bsm15960275ad.51.2025.08.29.00.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:28:50 -0700 (PDT)
From: Menglong Dong <menglong8.dong@gmail.com>
X-Google-Original-From: Menglong Dong <dongml2@chinatelecom.cn>
To: herbert@gondor.apana.org.au
Cc: tgraf@suug.ch,
	menglong.dong@linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] rhashtable: use __always_inline for rhashtable
Date: Fri, 29 Aug 2025 15:28:44 +0800
Message-ID: <20250829072844.333123-1-dongml2@chinatelecom.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometimes, the compiler is not clever enough to inline the
rhashtable_lookup() for us, even if the "obj_cmpfn" and "key_len" in
params is const. This can introduce more overhead.

Therefore, use __always_inline for the rhashtable.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
---
 include/linux/rhashtable.h | 42 +++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 6c85b28ea30b..e740157f3cd7 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -122,7 +122,7 @@ static inline unsigned int rht_bucket_index(const struct bucket_table *tbl,
 	return hash & (tbl->size - 1);
 }
 
-static inline unsigned int rht_key_get_hash(struct rhashtable *ht,
+static __always_inline unsigned int rht_key_get_hash(struct rhashtable *ht,
 	const void *key, const struct rhashtable_params params,
 	unsigned int hash_rnd)
 {
@@ -152,7 +152,7 @@ static inline unsigned int rht_key_get_hash(struct rhashtable *ht,
 	return hash;
 }
 
-static inline unsigned int rht_key_hashfn(
+static __always_inline unsigned int rht_key_hashfn(
 	struct rhashtable *ht, const struct bucket_table *tbl,
 	const void *key, const struct rhashtable_params params)
 {
@@ -161,7 +161,7 @@ static inline unsigned int rht_key_hashfn(
 	return rht_bucket_index(tbl, hash);
 }
 
-static inline unsigned int rht_head_hashfn(
+static __always_inline unsigned int rht_head_hashfn(
 	struct rhashtable *ht, const struct bucket_table *tbl,
 	const struct rhash_head *he, const struct rhashtable_params params)
 {
@@ -586,7 +586,7 @@ static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
 }
 
 /* Internal function, do not use. */
-static inline struct rhash_head *__rhashtable_lookup(
+static __always_inline struct rhash_head *__rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
 {
@@ -639,7 +639,7 @@ static inline struct rhash_head *__rhashtable_lookup(
  *
  * Returns the first entry on which the compare function returned true.
  */
-static inline void *rhashtable_lookup(
+static __always_inline void *rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
 {
@@ -662,7 +662,7 @@ static inline void *rhashtable_lookup(
  *
  * Returns the first entry on which the compare function returned true.
  */
-static inline void *rhashtable_lookup_fast(
+static __always_inline void *rhashtable_lookup_fast(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
 {
@@ -689,7 +689,7 @@ static inline void *rhashtable_lookup_fast(
  *
  * Returns the list of entries that match the given key.
  */
-static inline struct rhlist_head *rhltable_lookup(
+static __always_inline struct rhlist_head *rhltable_lookup(
 	struct rhltable *hlt, const void *key,
 	const struct rhashtable_params params)
 {
@@ -702,7 +702,7 @@ static inline struct rhlist_head *rhltable_lookup(
  * function returns the existing element already in hashes if there is a clash,
  * otherwise it returns an error via ERR_PTR().
  */
-static inline void *__rhashtable_insert_fast(
+static __always_inline void *__rhashtable_insert_fast(
 	struct rhashtable *ht, const void *key, struct rhash_head *obj,
 	const struct rhashtable_params params, bool rhlist)
 {
@@ -825,7 +825,7 @@ static inline void *__rhashtable_insert_fast(
  * Will trigger an automatic deferred table resizing if residency in the
  * table grows beyond 70%.
  */
-static inline int rhashtable_insert_fast(
+static __always_inline int rhashtable_insert_fast(
 	struct rhashtable *ht, struct rhash_head *obj,
 	const struct rhashtable_params params)
 {
@@ -854,7 +854,7 @@ static inline int rhashtable_insert_fast(
  * Will trigger an automatic deferred table resizing if residency in the
  * table grows beyond 70%.
  */
-static inline int rhltable_insert_key(
+static __always_inline int rhltable_insert_key(
 	struct rhltable *hlt, const void *key, struct rhlist_head *list,
 	const struct rhashtable_params params)
 {
@@ -877,7 +877,7 @@ static inline int rhltable_insert_key(
  * Will trigger an automatic deferred table resizing if residency in the
  * table grows beyond 70%.
  */
-static inline int rhltable_insert(
+static __always_inline int rhltable_insert(
 	struct rhltable *hlt, struct rhlist_head *list,
 	const struct rhashtable_params params)
 {
@@ -902,7 +902,7 @@ static inline int rhltable_insert(
  * Will trigger an automatic deferred table resizing if residency in the
  * table grows beyond 70%.
  */
-static inline int rhashtable_lookup_insert_fast(
+static __always_inline int rhashtable_lookup_insert_fast(
 	struct rhashtable *ht, struct rhash_head *obj,
 	const struct rhashtable_params params)
 {
@@ -929,7 +929,7 @@ static inline int rhashtable_lookup_insert_fast(
  * object if it exists, NULL if it did not and the insertion was successful,
  * and an ERR_PTR otherwise.
  */
-static inline void *rhashtable_lookup_get_insert_fast(
+static __always_inline void *rhashtable_lookup_get_insert_fast(
 	struct rhashtable *ht, struct rhash_head *obj,
 	const struct rhashtable_params params)
 {
@@ -956,7 +956,7 @@ static inline void *rhashtable_lookup_get_insert_fast(
  *
  * Returns zero on success.
  */
-static inline int rhashtable_lookup_insert_key(
+static __always_inline int rhashtable_lookup_insert_key(
 	struct rhashtable *ht, const void *key, struct rhash_head *obj,
 	const struct rhashtable_params params)
 {
@@ -982,7 +982,7 @@ static inline int rhashtable_lookup_insert_key(
  * object if it exists, NULL if it does not and the insertion was successful,
  * and an ERR_PTR otherwise.
  */
-static inline void *rhashtable_lookup_get_insert_key(
+static __always_inline void *rhashtable_lookup_get_insert_key(
 	struct rhashtable *ht, const void *key, struct rhash_head *obj,
 	const struct rhashtable_params params)
 {
@@ -992,7 +992,7 @@ static inline void *rhashtable_lookup_get_insert_key(
 }
 
 /* Internal function, please use rhashtable_remove_fast() instead */
-static inline int __rhashtable_remove_fast_one(
+static __always_inline int __rhashtable_remove_fast_one(
 	struct rhashtable *ht, struct bucket_table *tbl,
 	struct rhash_head *obj, const struct rhashtable_params params,
 	bool rhlist)
@@ -1074,7 +1074,7 @@ static inline int __rhashtable_remove_fast_one(
 }
 
 /* Internal function, please use rhashtable_remove_fast() instead */
-static inline int __rhashtable_remove_fast(
+static __always_inline int __rhashtable_remove_fast(
 	struct rhashtable *ht, struct rhash_head *obj,
 	const struct rhashtable_params params, bool rhlist)
 {
@@ -1115,7 +1115,7 @@ static inline int __rhashtable_remove_fast(
  *
  * Returns zero on success, -ENOENT if the entry could not be found.
  */
-static inline int rhashtable_remove_fast(
+static __always_inline int rhashtable_remove_fast(
 	struct rhashtable *ht, struct rhash_head *obj,
 	const struct rhashtable_params params)
 {
@@ -1137,7 +1137,7 @@ static inline int rhashtable_remove_fast(
  *
  * Returns zero on success, -ENOENT if the entry could not be found.
  */
-static inline int rhltable_remove(
+static __always_inline int rhltable_remove(
 	struct rhltable *hlt, struct rhlist_head *list,
 	const struct rhashtable_params params)
 {
@@ -1145,7 +1145,7 @@ static inline int rhltable_remove(
 }
 
 /* Internal function, please use rhashtable_replace_fast() instead */
-static inline int __rhashtable_replace_fast(
+static __always_inline int __rhashtable_replace_fast(
 	struct rhashtable *ht, struct bucket_table *tbl,
 	struct rhash_head *obj_old, struct rhash_head *obj_new,
 	const struct rhashtable_params params)
@@ -1208,7 +1208,7 @@ static inline int __rhashtable_replace_fast(
  * Returns zero on success, -ENOENT if the entry could not be found,
  * -EINVAL if hash is not the same for the old and new objects.
  */
-static inline int rhashtable_replace_fast(
+static __always_inline int rhashtable_replace_fast(
 	struct rhashtable *ht, struct rhash_head *obj_old,
 	struct rhash_head *obj_new,
 	const struct rhashtable_params params)
-- 
2.51.0

