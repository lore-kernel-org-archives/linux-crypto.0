Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1449F2F90E6;
	Thu,  4 Sep 2025 09:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979117; cv=none; b=qaGeqJOwozinFX0tmSvSn7IOotJs5E0IPBnEJNFCDvyvlPkUtygoKXmta2kZ+/HGS+rq2i0nKrBkiE4678Hml30zH8IVcLCqd6/LqRRhXS93w9O6N7lUuoWRaQ6WHvlZXHzyQfY6iWNeBaPMaZ/sk8IaxZ66w8/ZQLWjGtlCJPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979117; c=relaxed/simple;
	bh=XHPvdKbjG5ka9RaObhQu+o1XhqKNYZRUilx9t5/3HlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E22afEdyuE0OBdbcEdUypLMF4OFB0D5fLJkBS5+5LwswksRIcscSu1yUNqiNBq3zt5TWC3wFO8isaS9Ioi/xbx8rAvEpnRF+dDgokfwYYDhY/Y5NZwNZsIhKIcBTi4JzfVZf3/kRNpXoV1PbQ2bywHC00k8USwJW3Qdg1fom3LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KKgGORZe; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KKgGORZe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+EgLYPOzr2Seya9sjkwg+xKsIVeQv5IYNgfp7NTJIiw=; b=KKgGORZejla2hVwlTXeP8DUBX2
	UjtFEy9nX3hpfKCoAG3teGS/OU516sAxK6BwMLDQFJ+bXPMRAPxTqvxbRFoELKYQGvfUkQdEIW1E5
	g9pc1bEX6O8d32UvrdLom2K0zv3yOzNvKNVcEoTRQkZMj7WVN82fq8tJBUlcSHvF53qZ38zzWTAC4
	hS8Kw8v9IvX/I7wLZA/6blnhVw1Zib3giZt8A/xwY3VSdemkFVmqOGYtgzYXSbWf+PjGRpOHhEO33
	MXcf4K7kim/QHyxEPDCdGq+a81hWw6RmdANlfEgiLpDeqzkPjAFPUksHjApAsSfnWCcpSqWsPw9vs
	aYoWiHtA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uu6H3-002ZQx-1d;
	Thu, 04 Sep 2025 17:44:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Sep 2025 17:44:53 +0800
Date: Thu, 4 Sep 2025 17:44:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>, tgraf@suug.ch,
	linux-crypto@vger.kernel.org
Subject: [PATCH] rhashtable: Use rcu_dereference_all and
 rcu_dereference_all_check
Message-ID: <aLlflTV_SDwMB7mq@gondor.apana.org.au>
References: <20250829021436.19982-1-dongml2@chinatelecom.cn>
 <20250828222357.55fab4c2@batman.local.home>
 <d1da3939-62e6-4ad1-afcc-5710ce3f6cbd@paulmck-laptop>
 <20250901170655.0757884ad7c2afb63ced3230@kernel.org>
 <615da75d-cb2f-4e7e-9e11-6b19f03fea6c@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <615da75d-cb2f-4e7e-9e11-6b19f03fea6c@paulmck-laptop>

On Mon, Sep 01, 2025 at 08:00:15AM -0700, Paul E. McKenney wrote:
>
> However, another option for the the above rcu_dereference_check() to
> become something like this:
> 
> 	rcu_dereference_check(p, lockdep_rht_mutex_is_held(ht) ||
> 				 rcu_read_lock_any_held());
> 
> This would be happy with any RCU reader, including rcu_read_lock(),
> preempt_disable(), local_irq_disable(), local_bh_disable(), and various
> handler contexts.  One downside is that this would *always* be happy in
> a kernel built with CONFIG_PREEMPT_{NONE,VOLUNTARY}=y.

Why is that a problem? Assuming that it is always safe to perform
an rcu_dereference_all() on such a kernel, not warning would appear
to be the right thing to do.

> If this is happening often enough, it would be easy for me to create an
> rcu_dereference_all_check() that allows all forms of vanilla RCU readers
> (but not, for example, SRCU readers), but with only two use cases,
> it is not clear to me that this is an overall win.
> 
> Or am I missing a turn in here somewhere?

As I said rhashtable is just a middle-man, while it does some
RCU actions internally, in the end the user is free to choose
the RCU variant (vanilla, bh, sched).  So I'm faced with the
choice of using only rcu_dereference_all in rhashtable code,
or splitting the rhashtable API into three variants just like
RCU.  I'd rather not do this especially because it appears RCU
itself has essentially morphed into a single variant because
call_rcu etc. always waits for all three variants.

So how about this patch?

---8<---
Add rcu_dereference_all and rcu_dereference_all_check so that
library code such as rhashtable can be used with any RCU variant.

As it stands rcu_dereference is used within rashtable, which
creates false-positive warnings if the user calls it from another
RCU variant context, such as preempt_disable().

Use the rcu_dereference_all and rcu_dereference_all_check calls
in rhashtable to suppress these warnings.

Also replace the rcu_dereference_raw calls in the list iterators
with rcu_dereference_all to uncover buggy calls.

Reported-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 120536f4c6eb..b4261a0498f0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -713,6 +713,23 @@ do {									      \
 				(c) || rcu_read_lock_sched_held(), \
 				__rcu)
 
+/**
+ * rcu_dereference_all_check() - rcu_dereference_all with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-all counterpart to rcu_dereference_check().
+ * However, please note that starting in v5.0 kernels, vanilla RCU grace
+ * periods wait for preempt_disable() regions of code in addition to
+ * regions of code demarked by rcu_read_lock() and rcu_read_unlock().
+ * This means that synchronize_rcu(), call_rcu, and friends all take not
+ * only rcu_read_lock() but also rcu_read_lock_*() into account.
+ */
+#define rcu_dereference_all_check(p, c) \
+	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
+				(c) || rcu_read_lock_any_held(), \
+				__rcu)
+
 /*
  * The tracing infrastructure traces RCU (we want that), but unfortunately
  * some of the RCU checks causes tracing to lock up the system.
@@ -767,6 +784,14 @@ do {									      \
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
index 6c85b28ea30b..e9b5ac26b42d 100644
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

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
