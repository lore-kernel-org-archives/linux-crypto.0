Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBD763CB;
	Fri, 17 Apr 2026 00:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776385491; cv=none; b=PIluADZjGkSpLcfqo7HDGD9DjZp2ria7Rgq0Nq2T6BHYKK/sNeQduDU7CZdYApMEtOFcIoCjRJ9rEoaw6E/9lThVlIEzJmTzNxl+t5uPzFJO9aA5b/pAPmoZzxOu27crXmxbTqwe1123LaGjLJfXcLZDDZNe/seUkpH9EdEbsmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776385491; c=relaxed/simple;
	bh=y6LTZHncCej35ex2qI+cmlgV4pN0OztUwdHZgg34Av4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HiHAMOOI4GwCcmWbwr2JCl7688jkpkf/7flHCd+Qa8KNGeQWqEKLghuzo0BR7xN3Eq+sBWPqXUAdou/FCpABIA9hyyct7tXHna0+/Gb80lTFpRrSNFMuT7ylkDG9RCwmo5jlCvFr/wBrtz7Gj49n05WYcmtLV7nk65VKGocKykI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsXuyWmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsXuyWmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB931C2BCAF;
	Fri, 17 Apr 2026 00:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776385491;
	bh=y6LTZHncCej35ex2qI+cmlgV4pN0OztUwdHZgg34Av4=;
	h=From:To:Cc:Subject:Date:From;
	b=tsXuyWmTR4qJmHkfE6fjbc4g/gI67qzujeEOjk8lqAkyabNYiEt9TnT1rWKvi+sXt
	 y/WASPpvaiirgHrYAwAxJhik8sD6X+eQnk3liP2oTdsFYuIKnGVF5wzDLCnZcb/yeL
	 amkiw1CEL9+mq26q721Rf6RBVW3Dp+ggq5xniRNmSNa6IZkDMVILFs+uaOftDMqDCP
	 qYlqztwn2hTwb0ix8lNW5rYj5gYOsa/8XQVzK26nEcg6TL2V7D3NQpt5fA0LenFXnj
	 OxVRpFDMj3XmrJaV+6pdGG0nR7tefy9b6zMDnA1B73bWu+msquFwPpXM6XsKEpm6+P
	 BYvFgQdYrvW1Q==
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Graf <tgraf@suug.ch>,
	David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Date: Thu, 16 Apr 2026 14:24:48 -1000
Message-ID: <20260417002449.2290577-1-tj@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sync grow path on insert calls get_random_u32() and kvmalloc(), both of
which take regular spinlocks and are unsafe under raw_spinlock_t. Add an
opt-in flag that skips the >100% grow check; inserts always succeed by
appending to the chain, and the deferred worker still grows at >75% load.

sched_ext already uses rhashtable under raw_spinlock_t and is technically
broken, though hard to hit in practice because the tables stay small.

Cc: stable@vger.kernel.org # prerequisite for the next sched_ext fix
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

The follow-up sched_ext patch is a fix targeting sched_ext/for-7.1-fixes
which I'd like to send Linus's way sooner than later. Would it be okay
to route both patches through sched_ext/for-7.1-fixes? If you'd prefer
to route the rhashtable change differently, that works too. Please let
me know, thanks.

Based on linus/master (3cd8b194bf34).

 include/linux/rhashtable-types.h | 2 ++
 include/linux/rhashtable.h       | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 015c8298bebc..555eea6077f8 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -50,6 +50,7 @@ typedef int (*rht_obj_cmpfn_t)(struct rhashtable_compare_arg *arg,
  * @max_size: Maximum size while expanding
  * @min_size: Minimum size while shrinking
  * @automatic_shrinking: Enable automatic shrinking of tables
+ * @no_sync_grow: Skip sync grow on insert (allows inserts under raw_spinlock_t)
  * @hashfn: Hash function (default: jhash2 if !(key_len % 4), or jhash)
  * @obj_hashfn: Function to hash object
  * @obj_cmpfn: Function to compare key with object
@@ -62,6 +63,7 @@ struct rhashtable_params {
 	unsigned int		max_size;
 	u16			min_size;
 	bool			automatic_shrinking;
+	bool			no_sync_grow;
 	rht_hashfn_t		hashfn;
 	rht_obj_hashfn_t	obj_hashfn;
 	rht_obj_cmpfn_t		obj_cmpfn;
diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 0480509a6339..a977a597d288 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -197,11 +197,14 @@ static inline bool rht_shrink_below_30(const struct rhashtable *ht,
  * rht_grow_above_100 - returns true if nelems > table-size
  * @ht:		hash table
  * @tbl:	current table
+ *
+ * Returns false if the caller opted out of synchronous grow.
  */
 static inline bool rht_grow_above_100(const struct rhashtable *ht,
 				      const struct bucket_table *tbl)
 {
-	return atomic_read(&ht->nelems) > tbl->size &&
+	return !ht->p.no_sync_grow &&
+		atomic_read(&ht->nelems) > tbl->size &&
 		(!ht->p.max_size || tbl->size < ht->p.max_size);
 }
 
-- 
2.53.0

