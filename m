Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F42D3E63B5;
	Mon, 27 Apr 2026 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310873; cv=none; b=OnHREuH5368nH5QLd5y6DYYvp7Bor0wHav31MEOuqSf4Eq0w3x05lhLDEcTLsBu7dCqluTzBAP8MAZZSV1MY9a9wKzUEs6nnEqSSRo6nB2l9rukMDt8omdRg/eOZwGcJEESLEUP8BGGuLpBGNOrnO/LLf3sHFDTbCxSZIYApqiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310873; c=relaxed/simple;
	bh=+NrWvMgiVvlEudVsw7+IRDB0fGeSLZsPN3zldOZaqqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqfYkNe3yQKUc68tF98RwtR3JZ7jQPfMNyCyfFgNgVaUwhIchg6lR3zX0eW98G/3rHwP1dxQY3IS+qVhvG8M5tzpvlBCbSZcnQeQtnQD9EzaL2PoKzIdHk9fYoB7HjcT6zFSi/p6hzIdfsEqDrKDWODqL6rVJ6pjiW5E+8OgNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpP4LBmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpP4LBmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C62AC2BCB9;
	Mon, 27 Apr 2026 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310872;
	bh=+NrWvMgiVvlEudVsw7+IRDB0fGeSLZsPN3zldOZaqqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpP4LBmCGZHspJLD+2JNirRNPwOdffnXFVxWNXDIPBER45CMZ2UxWs8snY6g1jesw
	 isScPYoccE6JSVmSmF8tz3fnY7TDSZFEpMfQSGMlAe6diHp1OD8OZUI/6f/kSU76Qp
	 hkG15fppU8+75p5COCMAIBZ1ODj6YRNNY7dIWFbt4gwmjDeGSpzObx+jdlRgFko0A8
	 xB24qm985vJTyal9g74Bbg8a0AKIZqUPRj0BEdhK/7yhZh6GXn3XX1J5XMLkhuduQG
	 021P3oYePofglP6vRUsL3ZWqCwuBMiJ/o6Gz+mw+5ITcEmQ/V2b9xaLQGfz0zMf/MC
	 eVopHRYOeqv4w==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next v2 5/5] net/tcp: Remove tcp_sigpool
Date: Mon, 27 Apr 2026 10:27:27 -0700
Message-ID: <20260427172727.9310-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427172727.9310-1-ebiggers@kernel.org>
References: <20260427172727.9310-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tcp_sigpool is no longer used.  It existed only as a workaround for
issues in the design of the crypto_ahash API, which have been avoided by
switching to the much easier-to-use library APIs instead.  Remove it.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/net/tcp.h      |  34 ----
 net/ipv4/Kconfig       |   3 -
 net/ipv4/Makefile      |   1 -
 net/ipv4/tcp_sigpool.c | 366 -----------------------------------------
 4 files changed, 404 deletions(-)
 delete mode 100644 net/ipv4/tcp_sigpool.c

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8817e7b8cc67..660ad8c63395 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2015,44 +2015,10 @@ struct tcp6_pseudohdr {
 	struct in6_addr daddr;
 	__be32		len;
 	__be32		protocol;	/* including padding */
 };
 
-/*
- * struct tcp_sigpool - per-CPU pool of ahash_requests
- * @scratch: per-CPU temporary area, that can be used between
- *	     tcp_sigpool_start() and tcp_sigpool_end() to perform
- *	     crypto request
- * @req: pre-allocated ahash request
- */
-struct tcp_sigpool {
-	void *scratch;
-	struct ahash_request *req;
-};
-
-int tcp_sigpool_alloc_ahash(const char *alg, size_t scratch_size);
-void tcp_sigpool_get(unsigned int id);
-void tcp_sigpool_release(unsigned int id);
-int tcp_sigpool_hash_skb_data(struct tcp_sigpool *hp,
-			      const struct sk_buff *skb,
-			      unsigned int header_len);
-
-/**
- * tcp_sigpool_start - disable bh and start using tcp_sigpool_ahash
- * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
- * @c: returned tcp_sigpool for usage (uninitialized on failure)
- *
- * Returns: 0 on success, error otherwise.
- */
-int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c);
-/**
- * tcp_sigpool_end - enable bh and stop using tcp_sigpool
- * @c: tcp_sigpool context that was returned by tcp_sigpool_start()
- */
-void tcp_sigpool_end(struct tcp_sigpool *c);
-size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len);
-/* - functions */
 void tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			 const struct sock *sk, const struct sk_buff *skb);
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
 		   const u8 *newkey, u8 newkeylen);
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 77b053b445a0..301b47660305 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -739,13 +739,10 @@ config DEFAULT_TCP_CONG
 	default "dctcp" if DEFAULT_DCTCP
 	default "cdg" if DEFAULT_CDG
 	default "bbr" if DEFAULT_BBR
 	default "cubic"
 
-config TCP_SIGPOOL
-	tristate
-
 config TCP_AO
 	bool "TCP: Authentication Option (RFC5925)"
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_SHA1
 	select CRYPTO_LIB_SHA256
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 7f9f98813986..7964234f0d08 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -58,11 +58,10 @@ obj-$(CONFIG_TCP_CONG_NV) += tcp_nv.o
 obj-$(CONFIG_TCP_CONG_VENO) += tcp_veno.o
 obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_scalable.o
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
-obj-$(CONFIG_TCP_SIGPOOL) += tcp_sigpool.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
 obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
diff --git a/net/ipv4/tcp_sigpool.c b/net/ipv4/tcp_sigpool.c
deleted file mode 100644
index 10b2e5970c40..000000000000
--- a/net/ipv4/tcp_sigpool.c
+++ /dev/null
@@ -1,366 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-
-#include <crypto/hash.h>
-#include <linux/cpu.h>
-#include <linux/kref.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/percpu.h>
-#include <linux/workqueue.h>
-#include <net/tcp.h>
-
-static size_t __scratch_size;
-struct sigpool_scratch {
-	local_lock_t bh_lock;
-	void __rcu *pad;
-};
-
-static DEFINE_PER_CPU(struct sigpool_scratch, sigpool_scratch) = {
-	.bh_lock = INIT_LOCAL_LOCK(bh_lock),
-};
-
-struct sigpool_entry {
-	struct crypto_ahash	*hash;
-	const char		*alg;
-	struct kref		kref;
-	uint16_t		needs_key:1,
-				reserved:15;
-};
-
-#define CPOOL_SIZE (PAGE_SIZE / sizeof(struct sigpool_entry))
-static struct sigpool_entry cpool[CPOOL_SIZE];
-static unsigned int cpool_populated;
-static DEFINE_MUTEX(cpool_mutex);
-
-/* Slow-path */
-struct scratches_to_free {
-	struct rcu_head rcu;
-	unsigned int cnt;
-	void *scratches[];
-};
-
-static void free_old_scratches(struct rcu_head *head)
-{
-	struct scratches_to_free *stf;
-
-	stf = container_of(head, struct scratches_to_free, rcu);
-	while (stf->cnt--)
-		kfree(stf->scratches[stf->cnt]);
-	kfree(stf);
-}
-
-/**
- * sigpool_reserve_scratch - re-allocates scratch buffer, slow-path
- * @size: request size for the scratch/temp buffer
- */
-static int sigpool_reserve_scratch(size_t size)
-{
-	struct scratches_to_free *stf;
-	size_t stf_sz = struct_size(stf, scratches, num_possible_cpus());
-	int cpu, err = 0;
-
-	lockdep_assert_held(&cpool_mutex);
-	if (__scratch_size >= size)
-		return 0;
-
-	stf = kmalloc(stf_sz, GFP_KERNEL);
-	if (!stf)
-		return -ENOMEM;
-	stf->cnt = 0;
-
-	size = max(size, __scratch_size);
-	cpus_read_lock();
-	for_each_possible_cpu(cpu) {
-		void *scratch, *old_scratch;
-
-		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
-		if (!scratch) {
-			err = -ENOMEM;
-			break;
-		}
-
-		old_scratch = rcu_replace_pointer(per_cpu(sigpool_scratch.pad, cpu),
-					scratch, lockdep_is_held(&cpool_mutex));
-		if (!cpu_online(cpu) || !old_scratch) {
-			kfree(old_scratch);
-			continue;
-		}
-		stf->scratches[stf->cnt++] = old_scratch;
-	}
-	cpus_read_unlock();
-	if (!err)
-		__scratch_size = size;
-
-	call_rcu(&stf->rcu, free_old_scratches);
-	return err;
-}
-
-static void sigpool_scratch_free(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		kfree(rcu_replace_pointer(per_cpu(sigpool_scratch.pad, cpu),
-					  NULL, lockdep_is_held(&cpool_mutex)));
-	__scratch_size = 0;
-}
-
-static int __cpool_try_clone(struct crypto_ahash *hash)
-{
-	struct crypto_ahash *tmp;
-
-	tmp = crypto_clone_ahash(hash);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-
-	crypto_free_ahash(tmp);
-	return 0;
-}
-
-static int __cpool_alloc_ahash(struct sigpool_entry *e, const char *alg)
-{
-	struct crypto_ahash *cpu0_hash;
-	int ret;
-
-	e->alg = kstrdup(alg, GFP_KERNEL);
-	if (!e->alg)
-		return -ENOMEM;
-
-	cpu0_hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(cpu0_hash)) {
-		ret = PTR_ERR(cpu0_hash);
-		goto out_free_alg;
-	}
-
-	e->needs_key = crypto_ahash_get_flags(cpu0_hash) & CRYPTO_TFM_NEED_KEY;
-
-	ret = __cpool_try_clone(cpu0_hash);
-	if (ret)
-		goto out_free_cpu0_hash;
-	e->hash = cpu0_hash;
-	kref_init(&e->kref);
-	return 0;
-
-out_free_cpu0_hash:
-	crypto_free_ahash(cpu0_hash);
-out_free_alg:
-	kfree(e->alg);
-	e->alg = NULL;
-	return ret;
-}
-
-/**
- * tcp_sigpool_alloc_ahash - allocates pool for ahash requests
- * @alg: name of async hash algorithm
- * @scratch_size: reserve a tcp_sigpool::scratch buffer of this size
- */
-int tcp_sigpool_alloc_ahash(const char *alg, size_t scratch_size)
-{
-	int i, ret;
-
-	/* slow-path */
-	mutex_lock(&cpool_mutex);
-	ret = sigpool_reserve_scratch(scratch_size);
-	if (ret)
-		goto out;
-	for (i = 0; i < cpool_populated; i++) {
-		if (!cpool[i].alg)
-			continue;
-		if (strcmp(cpool[i].alg, alg))
-			continue;
-
-		/* pairs with tcp_sigpool_release() */
-		if (!kref_get_unless_zero(&cpool[i].kref))
-			kref_init(&cpool[i].kref);
-		ret = i;
-		goto out;
-	}
-
-	for (i = 0; i < cpool_populated; i++) {
-		if (!cpool[i].alg)
-			break;
-	}
-	if (i >= CPOOL_SIZE) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
-	ret = __cpool_alloc_ahash(&cpool[i], alg);
-	if (!ret) {
-		ret = i;
-		if (i == cpool_populated)
-			cpool_populated++;
-	}
-out:
-	mutex_unlock(&cpool_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(tcp_sigpool_alloc_ahash);
-
-static void __cpool_free_entry(struct sigpool_entry *e)
-{
-	crypto_free_ahash(e->hash);
-	kfree(e->alg);
-	memset(e, 0, sizeof(*e));
-}
-
-static void cpool_cleanup_work_cb(struct work_struct *work)
-{
-	bool free_scratch = true;
-	unsigned int i;
-
-	mutex_lock(&cpool_mutex);
-	for (i = 0; i < cpool_populated; i++) {
-		if (kref_read(&cpool[i].kref) > 0) {
-			free_scratch = false;
-			continue;
-		}
-		if (!cpool[i].alg)
-			continue;
-		__cpool_free_entry(&cpool[i]);
-	}
-	if (free_scratch)
-		sigpool_scratch_free();
-	mutex_unlock(&cpool_mutex);
-}
-
-static DECLARE_WORK(cpool_cleanup_work, cpool_cleanup_work_cb);
-static void cpool_schedule_cleanup(struct kref *kref)
-{
-	schedule_work(&cpool_cleanup_work);
-}
-
-/**
- * tcp_sigpool_release - decreases number of users for a pool. If it was
- * the last user of the pool, releases any memory that was consumed.
- * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
- */
-void tcp_sigpool_release(unsigned int id)
-{
-	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg))
-		return;
-
-	/* slow-path */
-	kref_put(&cpool[id].kref, cpool_schedule_cleanup);
-}
-EXPORT_SYMBOL_GPL(tcp_sigpool_release);
-
-/**
- * tcp_sigpool_get - increases number of users (refcounter) for a pool
- * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
- */
-void tcp_sigpool_get(unsigned int id)
-{
-	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg))
-		return;
-	kref_get(&cpool[id].kref);
-}
-EXPORT_SYMBOL_GPL(tcp_sigpool_get);
-
-int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c) __cond_acquires(0, RCU_BH)
-{
-	struct crypto_ahash *hash;
-
-	rcu_read_lock_bh();
-	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg)) {
-		rcu_read_unlock_bh();
-		return -EINVAL;
-	}
-
-	hash = crypto_clone_ahash(cpool[id].hash);
-	if (IS_ERR(hash)) {
-		rcu_read_unlock_bh();
-		return PTR_ERR(hash);
-	}
-
-	c->req = ahash_request_alloc(hash, GFP_ATOMIC);
-	if (!c->req) {
-		crypto_free_ahash(hash);
-		rcu_read_unlock_bh();
-		return -ENOMEM;
-	}
-	ahash_request_set_callback(c->req, 0, NULL, NULL);
-
-	/* Pairs with tcp_sigpool_reserve_scratch(), scratch area is
-	 * valid (allocated) until tcp_sigpool_end().
-	 */
-	local_lock_nested_bh(&sigpool_scratch.bh_lock);
-	c->scratch = rcu_dereference_bh(*this_cpu_ptr(&sigpool_scratch.pad));
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tcp_sigpool_start);
-
-void tcp_sigpool_end(struct tcp_sigpool *c) __releases(RCU_BH)
-{
-	struct crypto_ahash *hash = crypto_ahash_reqtfm(c->req);
-
-	local_unlock_nested_bh(&sigpool_scratch.bh_lock);
-	rcu_read_unlock_bh();
-	ahash_request_free(c->req);
-	crypto_free_ahash(hash);
-}
-EXPORT_SYMBOL_GPL(tcp_sigpool_end);
-
-/**
- * tcp_sigpool_algo - return algorithm of tcp_sigpool
- * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
- * @buf: buffer to return name of algorithm
- * @buf_len: size of @buf
- */
-size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len)
-{
-	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg))
-		return -EINVAL;
-
-	return strscpy(buf, cpool[id].alg, buf_len);
-}
-EXPORT_SYMBOL_GPL(tcp_sigpool_algo);
-
-/**
- * tcp_sigpool_hash_skb_data - hash data in skb with initialized tcp_sigpool
- * @hp: tcp_sigpool pointer
- * @skb: buffer to add sign for
- * @header_len: TCP header length for this segment
- */
-int tcp_sigpool_hash_skb_data(struct tcp_sigpool *hp,
-			      const struct sk_buff *skb,
-			      unsigned int header_len)
-{
-	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
-					   skb_headlen(skb) - header_len : 0;
-	const struct skb_shared_info *shi = skb_shinfo(skb);
-	const struct tcphdr *tp = tcp_hdr(skb);
-	struct ahash_request *req = hp->req;
-	struct sk_buff *frag_iter;
-	struct scatterlist sg;
-	unsigned int i;
-
-	sg_init_table(&sg, 1);
-
-	sg_set_buf(&sg, ((u8 *)tp) + header_len, head_data_len);
-	ahash_request_set_crypt(req, &sg, NULL, head_data_len);
-	if (crypto_ahash_update(req))
-		return 1;
-
-	for (i = 0; i < shi->nr_frags; ++i) {
-		const skb_frag_t *f = &shi->frags[i];
-		unsigned int offset = skb_frag_off(f);
-		struct page *page;
-
-		page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
-		sg_set_page(&sg, page, skb_frag_size(f), offset_in_page(offset));
-		ahash_request_set_crypt(req, &sg, NULL, skb_frag_size(f));
-		if (crypto_ahash_update(req))
-			return 1;
-	}
-
-	skb_walk_frags(skb, frag_iter)
-		if (tcp_sigpool_hash_skb_data(hp, frag_iter, 0))
-			return 1;
-
-	return 0;
-}
-EXPORT_SYMBOL(tcp_sigpool_hash_skb_data);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Per-CPU pool of crypto requests");
-- 
2.54.0

