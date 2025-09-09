Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2254623A9AD;
	Tue,  9 Sep 2025 09:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757411480; cv=none; b=O/VpoM8kcQ8fbqhcCxkK1CIE+vfLnhQ7H6fS49KCL+aZkNjcJnQ7q8IFXieAR0GgXgx3qoW5JM2I70V6MHWoS80T0gbP2ffJ+O59jZ6TtcKNQUWxcDZWicrdTVFv9As3cFetSJs2+l+ofgX8njmd0kS3CVZAO+tUIjH/iAdroXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757411480; c=relaxed/simple;
	bh=dxAgqHYfwc+Jq/6iS88EyuM4BR3dfbdXdAyPr/Im890=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pr+H2vn/NA1N91c2SxwdVvoM521aod/PIYwO2OrYhcp5XFSeixuwC2Ox9C+YjMijVtkGRy7IxAzyWmcw0YbxQ6lV2Wd+hbPxHWYEIT1xgT6qCgCxoNNP849kIxTcGijxnAPdgeltW4/YKHeTOz5PhgpMVJL4pAV6ZCqMUVsTyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dtmKSne/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dtmKSne/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UXVb8+XVTA+K7M34tFHgxCD3hHpqzNEL7ZAPbcMEDKg=; b=dtmKSne/vV66aDS+9THZZ9GXJr
	F/wABRDacifQCpnTsHdwECyvrgxe6K6xipEH46NCv2I2Rrz4hEbwNDRi+1g/NVeB5VdUUvNUAkFWQ
	WQCGjt0XWpPWPDCyPxcW99olCQ5dSBwGxeSkHbqvWZFOsIb3jgXR9gv8bzaCHhuYHQOXbeUt78/Le
	6vJ1zezscnJf5rFzCLgLM2bSPiv7s3zMQMK7KbuU9gqpFT6a0uAVpUaZigw3FyxWhrZq0k7z/6sj6
	MQn0RUQ3fm9OqREp8ivu0k5C/zQUVjUNCEbPCoetqs4Uact9KZ6/5IyonW25lRa9C2CQe/3X12R1n
	MpqMIHgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uvuke-003uPR-1b;
	Tue, 09 Sep 2025 17:50:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Sep 2025 17:50:56 +0800
Date: Tue, 9 Sep 2025 17:50:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>, tgraf@suug.ch,
	linux-crypto@vger.kernel.org
Subject: [v2 PATCH] rhashtable: Use rcu_dereference_all and
 rcu_dereference_all_check
Message-ID: <aL_4gCJibYMW0J98@gondor.apana.org.au>
References: <20250829021436.19982-1-dongml2@chinatelecom.cn>
 <20250828222357.55fab4c2@batman.local.home>
 <d1da3939-62e6-4ad1-afcc-5710ce3f6cbd@paulmck-laptop>
 <20250901170655.0757884ad7c2afb63ced3230@kernel.org>
 <615da75d-cb2f-4e7e-9e11-6b19f03fea6c@paulmck-laptop>
 <aLlflTV_SDwMB7mq@gondor.apana.org.au>
 <c3ada9ab-0676-4d73-9feb-9f401a031a4e@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3ada9ab-0676-4d73-9feb-9f401a031a4e@paulmck-laptop>

On Mon, Sep 08, 2025 at 08:23:27AM -0700, Paul E. McKenney wrote:
>
> I am guessing that you want to send this up via the rhashtable path.

Yes I could push that along.

>  * This is similar to rcu_dereference_check(), but allows protection
>  * by all forms of vanilla RCU readers, including preemption disabled,
>  * bh-disabled, and interrupt-disabled regions of code.  Note that "vanilla
>  * RCU" excludes SRCU and the various Tasks RCU flavors.  Please note
>  * that this macro should not be backported to any Linux-kernel version
>  * preceding v5.0 due to changes in synchronize_rcu() semantics prior
>  * to that version.
> 
> The "should not" vs. "can not" accounts for the possibility of people
> using synchronize_rcu_mult(), but someone wanting to do that best know
> what they are doing.  ;-)

Thanks! I've incorported that into the patch:

---8<---
Add rcu_dereference_all and rcu_dereference_all_check so that
library code such as rhashtable can be used with any RCU variant.

As it stands rcu_dereference is used within rashtable, which
creates false-positive warnings if the user calls it from another
RCU context, such as preempt_disable().

Use the rcu_dereference_all and rcu_dereference_all_check calls
in rhashtable to suppress these warnings.

Also replace the rcu_dereference_raw calls in the list iterators
with rcu_dereference_all to uncover buggy calls.

Reported-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 120536f4c6eb..448eb1f0cb48 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -713,6 +713,24 @@ do {									      \
 				(c) || rcu_read_lock_sched_held(), \
 				__rcu)
 
+/**
+ * rcu_dereference_all_check() - rcu_dereference_all with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is similar to rcu_dereference_check(), but allows protection
+ * by all forms of vanilla RCU readers, including preemption disabled,
+ * bh-disabled, and interrupt-disabled regions of code.  Note that "vanilla
+ * RCU" excludes SRCU and the various Tasks RCU flavors.  Please note
+ * that this macro should not be backported to any Linux-kernel version
+ * preceding v5.0 due to changes in synchronize_rcu() semantics prior
+ * to that version.
+ */
+#define rcu_dereference_all_check(p, c) \
+	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
+				(c) || rcu_read_lock_any_held(), \
+				__rcu)
+
 /*
  * The tracing infrastructure traces RCU (we want that), but unfortunately
  * some of the RCU checks causes tracing to lock up the system.
@@ -767,6 +785,14 @@ do {									      \
  */
 #define rcu_dereference_sched(p) rcu_dereference_sched_check(p, 0)
 
+/**
+ * rcu_dereference_all() - fetch RCU-all-protected pointer for dereferencing
+ * @p: The pointer to read, prior to dereferencing
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_all(p) rcu_dereference_all_check(p, 0)
+
 /**
  * rcu_pointer_handoff() - Hand off a pointer from RCU to other mechanism
  * @p: The pointer to hand off
diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index e740157f3cd7..05a221ce79a6 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -272,13 +272,13 @@ struct rhash_lock_head __rcu **rht_bucket_nested_insert(
 	rcu_dereference_protected(p, lockdep_rht_mutex_is_held(ht))
 
 #define rht_dereference_rcu(p, ht) \
-	rcu_dereference_check(p, lockdep_rht_mutex_is_held(ht))
+	rcu_dereference_all_check(p, lockdep_rht_mutex_is_held(ht))
 
 #define rht_dereference_bucket(p, tbl, hash) \
 	rcu_dereference_protected(p, lockdep_rht_bucket_is_held(tbl, hash))
 
 #define rht_dereference_bucket_rcu(p, tbl, hash) \
-	rcu_dereference_check(p, lockdep_rht_bucket_is_held(tbl, hash))
+	rcu_dereference_all_check(p, lockdep_rht_bucket_is_held(tbl, hash))
 
 #define rht_entry(tpos, pos, member) \
 	({ tpos = container_of(pos, typeof(*tpos), member); 1; })
@@ -373,7 +373,7 @@ static inline struct rhash_head *__rht_ptr(
 static inline struct rhash_head *rht_ptr_rcu(
 	struct rhash_lock_head __rcu *const *bkt)
 {
-	return __rht_ptr(rcu_dereference(*bkt), bkt);
+	return __rht_ptr(rcu_dereference_all(*bkt), bkt);
 }
 
 static inline struct rhash_head *rht_ptr(
@@ -497,7 +497,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
 	for (({barrier(); }),						\
 	     pos = head;						\
 	     !rht_is_a_nulls(pos);					\
-	     pos = rcu_dereference_raw(pos->next))
+	     pos = rcu_dereference_all(pos->next))
 
 /**
  * rht_for_each_rcu - iterate over rcu hash chain
@@ -513,7 +513,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
 	for (({barrier(); }),					\
 	     pos = rht_ptr_rcu(rht_bucket(tbl, hash));		\
 	     !rht_is_a_nulls(pos);				\
-	     pos = rcu_dereference_raw(pos->next))
+	     pos = rcu_dereference_all(pos->next))
 
 /**
  * rht_for_each_entry_rcu_from - iterated over rcu hash chain from given head
@@ -560,7 +560,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
  * list returned by rhltable_lookup.
  */
 #define rhl_for_each_rcu(pos, list)					\
-	for (pos = list; pos; pos = rcu_dereference_raw(pos->next))
+	for (pos = list; pos; pos = rcu_dereference_all(pos->next))
 
 /**
  * rhl_for_each_entry_rcu - iterate over rcu hash table list of given type
@@ -574,7 +574,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
  */
 #define rhl_for_each_entry_rcu(tpos, pos, list, member)			\
 	for (pos = list; pos && rht_entry(tpos, pos, member);		\
-	     pos = rcu_dereference_raw(pos->next))
+	     pos = rcu_dereference_all(pos->next))
 
 static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
 				     const void *obj)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
