Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AAA1E3DED;
	Tue, 14 Oct 2025 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479173; cv=none; b=AxqKNFx1PD02r48k8OLOxK2JhSoeeteaMLEbPhuwh64yIHekNTjBxVJHxnXg0p6mnOSjJUU8MDgmP2y2XCks+opze2ufHsbC37Jx/QigN7kBudVXQf31MbMYrTczcEFm2qgtardzvYBnmW6CNbr5xCHnvSinC3G3HtdGtpQvmwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479173; c=relaxed/simple;
	bh=/qF5PzPiiPmIwwAEi43doBZCuFQDjGH8HHwtdHHbiiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TZHG9zI2YkoWUiuEujO5F6F01KUn4IE2uF9LSlDaUtM7gWZ8MVc7agg0ro2bLiGZ7Hwbyd5kadJHGs9AND6X1KFYwxwiHz7OErtwbzalo7D3KdNbtgZc01a83OKgj1cYOWkvBI0+JW9fY4MFGLXLmxJAOWc3CWcR7ifVNP2BlLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTPYVEt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTPYVEt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A09C4CEE7;
	Tue, 14 Oct 2025 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760479172;
	bh=/qF5PzPiiPmIwwAEi43doBZCuFQDjGH8HHwtdHHbiiY=;
	h=From:To:Cc:Subject:Date:From;
	b=fTPYVEt1m5Hwp6v9b00gQgVlDYf94XuhfJoXjIEo2GAT0D2DulmTDJvlfqcbihBeJ
	 5UZ1I8BhJwPyWdKhuLeaGtRXpbsW9VNYVyJm4ecD+QRPvlaIbC3dChskjwvZbJ/+dF
	 s9rblHFLUr6pIYennX9IJUyFLNk26AbSa29+qCjDZ2VR0sKgbJXJ8ZcTjzJsOj1/yq
	 QdKwAludeJYFO7z5T6G+8wTvBebGUmx56GN1G5g8XbtWmYQ4E4LYCKorM3kUiTlgXe
	 Y+BHaDCGbv9VOe+yBBIwLwYTpV8V81VNIDyP5jO3wYWRfzUVgi5o0IFaR/B+zWiam6
	 WFzbU4QpnsZhQ==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next] tcp: Convert tcp-md5 to use MD5 library instead of crypto_ahash
Date: Tue, 14 Oct 2025 14:58:36 -0700
Message-ID: <20251014215836.115616-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make tcp-md5 use the MD5 library API (added in 6.18) instead of the
crypto_ahash API.  This is much simpler and also more efficient:

- The library API just operates on struct md5_ctx.  Just allocate this
  struct on the stack instead of using a pool of pre-allocated
  crypto_ahash and ahash_request objects.

- The library API accepts standard pointers and doesn't require
  scatterlists.  So, for hashing the headers just use an on-stack buffer
  instead of a pool of pre-allocated kmalloc'ed scratch buffers.

- The library API never fails.  Therefore, checking for MD5 hashing
  errors is no longer necessary.  Update tcp_v4_md5_hash_skb(),
  tcp_v6_md5_hash_skb(), tcp_v4_md5_hash_hdr(), tcp_v6_md5_hash_hdr(),
  tcp_md5_hash_key(), tcp_sock_af_ops::calc_md5_hash, and
  tcp_request_sock_ops::calc_md5_hash to return void instead of int.

- The library API provides direct access to the MD5 code, eliminating
  unnecessary overhead such as indirect function calls and scatterlist
  management.  Microbenchmarks of tcp_v4_md5_hash_skb() on x86_64 show a
  speedup from 7518 to 7041 cycles (6% fewer) with skb->len == 1440, or
  from 1020 to 678 cycles (33% fewer) with skb->len == 140.

Since tcp_sigpool_hash_skb_data() can no longer be used, add a function
tcp_md5_hash_skb_data() which is specialized to MD5.  Of course, to the
extent that this duplicates any code, it's well worth it.

To preserve the existing behavior of TCP-MD5 support being disabled when
the kernel is booted with "fips=1", make tcp_md5_do_add() check
fips_enabled itself.  Previously it relied on the error from
crypto_alloc_ahash("md5") being bubbled up.  I don't know for sure that
this is actually needed, but this preserves the existing behavior.

Tested with bidirectional TCP-MD5, both IPv4 and IPv6, between a kernel
that includes this commit and a kernel that doesn't include this commit.

(Side note: please don't use TCP-MD5!  It's cryptographically weak.  But
as long as Linux supports it, it might as well be implemented properly.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/net/tcp.h        |  26 +++-----
 net/ipv4/Kconfig         |   4 +-
 net/ipv4/tcp.c           |  73 +++++++++------------
 net/ipv4/tcp_ipv4.c      | 137 +++++++++++++--------------------------
 net/ipv4/tcp_minisocks.c |   2 -
 net/ipv6/tcp_ipv6.c      | 119 +++++++++++-----------------------
 6 files changed, 121 insertions(+), 240 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5ca230ed526ae..74a485af414bb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1894,17 +1894,10 @@ struct tcp6_pseudohdr {
 	struct in6_addr daddr;
 	__be32		len;
 	__be32		protocol;	/* including padding */
 };
 
-union tcp_md5sum_block {
-	struct tcp4_pseudohdr ip4;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct tcp6_pseudohdr ip6;
-#endif
-};
-
 /*
  * struct tcp_sigpool - per-CPU pool of ahash_requests
  * @scratch: per-CPU temporary area, that can be used between
  *	     tcp_sigpool_start() and tcp_sigpool_end() to perform
  *	     crypto request
@@ -1935,12 +1928,12 @@ int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c);
  * @c: tcp_sigpool context that was returned by tcp_sigpool_start()
  */
 void tcp_sigpool_end(struct tcp_sigpool *c);
 size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len);
 /* - functions */
-int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
-			const struct sock *sk, const struct sk_buff *skb);
+void tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
+			 const struct sock *sk, const struct sk_buff *skb);
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
 		   const u8 *newkey, u8 newkeylen);
 int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 		     int family, u8 prefixlen, int l3index,
@@ -1995,17 +1988,14 @@ tcp_md5_do_lookup_any_l3index(const struct sock *sk,
 static inline void tcp_md5_destruct_sock(struct sock *sk)
 {
 }
 #endif
 
-int tcp_md5_alloc_sigpool(void);
-void tcp_md5_release_sigpool(void);
-void tcp_md5_add_sigpool(void);
-extern int tcp_md5_sigpool_id;
-
-int tcp_md5_hash_key(struct tcp_sigpool *hp,
-		     const struct tcp_md5sig_key *key);
+struct md5_ctx;
+void tcp_md5_hash_skb_data(struct md5_ctx *ctx, const struct sk_buff *skb,
+			   unsigned int header_len);
+void tcp_md5_hash_key(struct md5_ctx *ctx, const struct tcp_md5sig_key *key);
 
 /* From tcp_fastopen.c */
 void tcp_fastopen_cache_get(struct sock *sk, u16 *mss,
 			    struct tcp_fastopen_cookie *cookie);
 void tcp_fastopen_cache_set(struct sock *sk, u16 mss,
@@ -2351,11 +2341,11 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 /* TCP af-specific functions */
 struct tcp_sock_af_ops {
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key	*(*md5_lookup) (const struct sock *sk,
 						const struct sock *addr_sk);
-	int		(*calc_md5_hash)(char *location,
+	void		(*calc_md5_hash)(char *location,
 					 const struct tcp_md5sig_key *md5,
 					 const struct sock *sk,
 					 const struct sk_buff *skb);
 	int		(*md5_parse)(struct sock *sk,
 				     int optname,
@@ -2379,11 +2369,11 @@ struct tcp_sock_af_ops {
 struct tcp_request_sock_ops {
 	u16 mss_clamp;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *(*req_md5_lookup)(const struct sock *sk,
 						 const struct sock *addr_sk);
-	int		(*calc_md5_hash) (char *location,
+	void		(*calc_md5_hash) (char *location,
 					  const struct tcp_md5sig_key *md5,
 					  const struct sock *sk,
 					  const struct sk_buff *skb);
 #endif
 #ifdef CONFIG_TCP_AO
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 12850a277251d..b71c22475c515 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -758,13 +758,11 @@ config TCP_AO
 
 	  If unsure, say N.
 
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
-	select CRYPTO
-	select CRYPTO_MD5
-	select TCP_SIGPOOL
+	select CRYPTO_LIB_MD5
 	help
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
 	  on the Internet.
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8a18aeca7ab07..b0c5f73ce7fdd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -241,21 +241,20 @@
  *	TCP_CLOSE		socket is finished
  */
 
 #define pr_fmt(fmt) "TCP: " fmt
 
-#include <crypto/hash.h>
+#include <crypto/md5.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/poll.h>
 #include <linux/inet_diag.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/skbuff.h>
-#include <linux/scatterlist.h>
 #include <linux/splice.h>
 #include <linux/net.h>
 #include <linux/socket.h>
 #include <linux/random.h>
 #include <linux/memblock.h>
@@ -423,11 +422,10 @@ void tcp_md5_destruct_sock(struct sock *sk)
 	if (tp->md5sig_info) {
 
 		tcp_clear_md5_list(sk);
 		kfree(rcu_replace_pointer(tp->md5sig_info, NULL, 1));
 		static_branch_slow_dec_deferred(&tcp_md5_needed);
-		tcp_md5_release_sigpool();
 	}
 }
 EXPORT_IPV6_MOD_GPL(tcp_md5_destruct_sock);
 #endif
 
@@ -4813,56 +4811,49 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 				 USER_SOCKPTR(optlen));
 }
 EXPORT_IPV6_MOD(tcp_getsockopt);
 
 #ifdef CONFIG_TCP_MD5SIG
-int tcp_md5_sigpool_id = -1;
-EXPORT_IPV6_MOD_GPL(tcp_md5_sigpool_id);
-
-int tcp_md5_alloc_sigpool(void)
+void tcp_md5_hash_skb_data(struct md5_ctx *ctx, const struct sk_buff *skb,
+			   unsigned int header_len)
 {
-	size_t scratch_size;
-	int ret;
+	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
+					   skb_headlen(skb) - header_len : 0;
+	const struct skb_shared_info *shi = skb_shinfo(skb);
+	struct sk_buff *frag_iter;
+	unsigned int i;
 
-	scratch_size = sizeof(union tcp_md5sum_block) + sizeof(struct tcphdr);
-	ret = tcp_sigpool_alloc_ahash("md5", scratch_size);
-	if (ret >= 0) {
-		/* As long as any md5 sigpool was allocated, the return
-		 * id would stay the same. Re-write the id only for the case
-		 * when previously all MD5 keys were deleted and this call
-		 * allocates the first MD5 key, which may return a different
-		 * sigpool id than was used previously.
-		 */
-		WRITE_ONCE(tcp_md5_sigpool_id, ret); /* Avoids the compiler potentially being smart here */
-		return 0;
-	}
-	return ret;
-}
+	md5_update(ctx, (const u8 *)tcp_hdr(skb) + header_len, head_data_len);
 
-void tcp_md5_release_sigpool(void)
-{
-	tcp_sigpool_release(READ_ONCE(tcp_md5_sigpool_id));
-}
+	for (i = 0; i < shi->nr_frags; ++i) {
+		const skb_frag_t *f = &shi->frags[i];
+		u32 p_off, p_len, copied;
+		const void *vaddr;
+		struct page *p;
 
-void tcp_md5_add_sigpool(void)
-{
-	tcp_sigpool_get(READ_ONCE(tcp_md5_sigpool_id));
+		skb_frag_foreach_page(f, skb_frag_off(f), skb_frag_size(f),
+				      p, p_off, p_len, copied) {
+			vaddr = kmap_local_page(p);
+			md5_update(ctx, vaddr + p_off, p_len);
+			kunmap_local(vaddr);
+		}
+	}
+
+	skb_walk_frags(skb, frag_iter)
+		tcp_md5_hash_skb_data(ctx, frag_iter, 0);
 }
+EXPORT_IPV6_MOD(tcp_md5_hash_skb_data);
 
-int tcp_md5_hash_key(struct tcp_sigpool *hp,
-		     const struct tcp_md5sig_key *key)
+void tcp_md5_hash_key(struct md5_ctx *ctx,
+		      const struct tcp_md5sig_key *key)
 {
 	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
-	struct scatterlist sg;
-
-	sg_init_one(&sg, key->key, keylen);
-	ahash_request_set_crypt(hp->req, &sg, NULL, keylen);
 
 	/* We use data_race() because tcp_md5_do_add() might change
 	 * key->key under us
 	 */
-	return data_race(crypto_ahash_update(hp->req));
+	data_race(({ md5_update(ctx, key->key, keylen), 0; }));
 }
 EXPORT_IPV6_MOD(tcp_md5_hash_key);
 
 /* Called with rcu_read_lock() */
 static enum skb_drop_reason
@@ -4877,11 +4868,10 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * o MD5 hash and its wrong.
 	 */
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
 	u8 newhash[16];
-	int genhash;
 
 	key = tcp_md5_do_lookup(sk, l3index, saddr, family);
 
 	if (!key && hash_location) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
@@ -4892,15 +4882,14 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	/* Check the signature.
 	 * To support dual stack listeners, we need to handle
 	 * IPv4-mapped case.
 	 */
 	if (family == AF_INET)
-		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
+		tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 	else
-		genhash = tp->af_specific->calc_md5_hash(newhash, key,
-							 NULL, skb);
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+		tp->af_specific->calc_md5_hash(newhash, key, NULL, skb);
+	if (memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		trace_tcp_hash_md5_mismatch(sk, skb);
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
 	return SKB_NOT_DROPPED_YET;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b1fcf3e4e1ce0..40a76da5364a1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -51,10 +51,11 @@
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/cache.h>
+#include <linux/fips.h>
 #include <linux/jhash.h>
 #include <linux/init.h>
 #include <linux/times.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
@@ -84,18 +85,17 @@
 #include <linux/seq_file.h>
 #include <linux/inetdevice.h>
 #include <linux/btf_ids.h>
 #include <linux/skbuff_ref.h>
 
-#include <crypto/hash.h>
-#include <linux/scatterlist.h>
+#include <crypto/md5.h>
 
 #include <trace/events/tcp.h>
 
 #ifdef CONFIG_TCP_MD5SIG
-static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
-			       __be32 daddr, __be32 saddr, const struct tcphdr *th);
+static void tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
+				__be32 daddr, __be32 saddr, const struct tcphdr *th);
 #endif
 
 struct inet_hashinfo tcp_hashinfo;
 
 static DEFINE_PER_CPU(struct sock_bh_locked, ipv4_tcp_sk) = {
@@ -752,11 +752,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb,
 	struct ip_reply_arg arg;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key = NULL;
 	unsigned char newhash[16];
 	struct sock *sk1 = NULL;
-	int genhash;
 #endif
 	u64 transmit_time = 0;
 	struct sock *ctl_sk;
 	struct net *net;
 	u32 txhash = 0;
@@ -838,15 +837,13 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb,
 		addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
 		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
 		if (!key)
 			goto out;
 
-
-		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
+		tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
+		if (memcmp(md5_hash_location, newhash, 16) != 0)
 			goto out;
-
 	}
 
 	if (key) {
 		rep.opt[0] = htonl((TCPOPT_NOP << 24) |
 				   (TCPOPT_NOP << 16) |
@@ -1423,25 +1420,24 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   const u8 *newkey, u8 newkeylen)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5_alloc_sigpool())
-			return -ENOMEM;
+		if (fips_enabled) {
+			pr_warn_once("TCP-MD5 support is disabled due to FIPS\n");
+			return -EOPNOTSUPP;
+		}
 
-		if (tcp_md5sig_info_add(sk, GFP_KERNEL)) {
-			tcp_md5_release_sigpool();
+		if (tcp_md5sig_info_add(sk, GFP_KERNEL))
 			return -ENOMEM;
-		}
 
 		if (!static_branch_inc(&tcp_md5_needed.key)) {
 			struct tcp_md5sig_info *md5sig;
 
 			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
-			tcp_md5_release_sigpool();
 			return -EUSERS;
 		}
 	}
 
 	return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index, flags,
@@ -1454,25 +1450,21 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 		     struct tcp_md5sig_key *key)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		tcp_md5_add_sigpool();
 
-		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC))) {
-			tcp_md5_release_sigpool();
+		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
 			return -ENOMEM;
-		}
 
 		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key)) {
 			struct tcp_md5sig_info *md5sig;
 
 			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
 			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
-			tcp_md5_release_sigpool();
 			return -EUSERS;
 		}
 	}
 
 	return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index,
@@ -1576,104 +1568,63 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v4_md5_hash_headers(struct tcp_sigpool *hp,
-				   __be32 daddr, __be32 saddr,
-				   const struct tcphdr *th, int nbytes)
+static void tcp_v4_md5_hash_headers(struct md5_ctx *ctx,
+				    __be32 daddr, __be32 saddr,
+				    const struct tcphdr *th, int nbytes)
 {
-	struct tcp4_pseudohdr *bp;
-	struct scatterlist sg;
-	struct tcphdr *_th;
-
-	bp = hp->scratch;
-	bp->saddr = saddr;
-	bp->daddr = daddr;
-	bp->pad = 0;
-	bp->protocol = IPPROTO_TCP;
-	bp->len = cpu_to_be16(nbytes);
-
-	_th = (struct tcphdr *)(bp + 1);
-	memcpy(_th, th, sizeof(*th));
-	_th->check = 0;
+	struct {
+		struct tcp4_pseudohdr ip;
+		struct tcphdr tcp;
+	} h;
 
-	sg_init_one(&sg, bp, sizeof(*bp) + sizeof(*th));
-	ahash_request_set_crypt(hp->req, &sg, NULL,
-				sizeof(*bp) + sizeof(*th));
-	return crypto_ahash_update(hp->req);
+	h.ip.saddr = saddr;
+	h.ip.daddr = daddr;
+	h.ip.pad = 0;
+	h.ip.protocol = IPPROTO_TCP;
+	h.ip.len = cpu_to_be16(nbytes);
+	h.tcp = *th;
+	h.tcp.check = 0;
+	md5_update(ctx, (const u8 *)&h, sizeof(h.ip) + sizeof(h.tcp));
 }
 
-static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
-			       __be32 daddr, __be32 saddr, const struct tcphdr *th)
+static noinline_for_stack void
+tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
+		    __be32 daddr, __be32 saddr, const struct tcphdr *th)
 {
-	struct tcp_sigpool hp;
+	struct md5_ctx ctx;
 
-	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
-		goto clear_hash_nostart;
-
-	if (crypto_ahash_init(hp.req))
-		goto clear_hash;
-	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
-		goto clear_hash;
-	if (tcp_md5_hash_key(&hp, key))
-		goto clear_hash;
-	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(hp.req))
-		goto clear_hash;
-
-	tcp_sigpool_end(&hp);
-	return 0;
-
-clear_hash:
-	tcp_sigpool_end(&hp);
-clear_hash_nostart:
-	memset(md5_hash, 0, 16);
-	return 1;
+	md5_init(&ctx);
+	tcp_v4_md5_hash_headers(&ctx, daddr, saddr, th, th->doff << 2);
+	tcp_md5_hash_key(&ctx, key);
+	md5_final(&ctx, md5_hash);
 }
 
-int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
-			const struct sock *sk,
-			const struct sk_buff *skb)
+noinline_for_stack void
+tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
+		    const struct sock *sk, const struct sk_buff *skb)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
-	struct tcp_sigpool hp;
 	__be32 saddr, daddr;
+	struct md5_ctx ctx;
 
 	if (sk) { /* valid for establish/request sockets */
 		saddr = sk->sk_rcv_saddr;
 		daddr = sk->sk_daddr;
 	} else {
 		const struct iphdr *iph = ip_hdr(skb);
 		saddr = iph->saddr;
 		daddr = iph->daddr;
 	}
 
-	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
-		goto clear_hash_nostart;
-
-	if (crypto_ahash_init(hp.req))
-		goto clear_hash;
-
-	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
-		goto clear_hash;
-	if (tcp_sigpool_hash_skb_data(&hp, skb, th->doff << 2))
-		goto clear_hash;
-	if (tcp_md5_hash_key(&hp, key))
-		goto clear_hash;
-	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(hp.req))
-		goto clear_hash;
-
-	tcp_sigpool_end(&hp);
-	return 0;
-
-clear_hash:
-	tcp_sigpool_end(&hp);
-clear_hash_nostart:
-	memset(md5_hash, 0, 16);
-	return 1;
+	md5_init(&ctx);
+	tcp_v4_md5_hash_headers(&ctx, daddr, saddr, th, skb->len);
+	tcp_md5_hash_skb_data(&ctx, skb, th->doff << 2);
+	tcp_md5_hash_key(&ctx, key);
+	md5_final(&ctx, md5_hash);
 }
 EXPORT_IPV6_MOD(tcp_v4_md5_hash_skb);
 
 #endif
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 2ec8c6f1cdccc..ded2cf1f60067 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -310,11 +310,10 @@ static void tcp_time_wait_init(struct sock *sk, struct tcp_timewait_sock *tcptw)
 		tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
 		if (!tcptw->tw_md5_key)
 			return;
 		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key))
 			goto out_free;
-		tcp_md5_add_sigpool();
 	}
 	return;
 out_free:
 	WARN_ON_ONCE(1);
 	kfree(tcptw->tw_md5_key);
@@ -404,11 +403,10 @@ void tcp_twsk_destructor(struct sock *sk)
 		struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 
 		if (twsk->tw_md5_key) {
 			kfree(twsk->tw_md5_key);
 			static_branch_slow_dec_deferred(&tcp_md5_needed);
-			tcp_md5_release_sigpool();
 		}
 	}
 #endif
 	tcp_ao_destroy_sock(sk, true);
 	psp_twsk_assoc_free(inet_twsk(sk));
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 59c4977a811a0..314684dcc0872 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -65,12 +65,11 @@
 #include <net/psp.h>
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
-#include <crypto/hash.h>
-#include <linux/scatterlist.h>
+#include <crypto/md5.h>
 
 #include <trace/events/tcp.h>
 
 static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 			      enum sk_rst_reason reason);
@@ -689,107 +688,64 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 
 	return tcp_md5_do_add(sk, addr, AF_INET6, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_sigpool *hp,
-				   const struct in6_addr *daddr,
-				   const struct in6_addr *saddr,
-				   const struct tcphdr *th, int nbytes)
+static void tcp_v6_md5_hash_headers(struct md5_ctx *ctx,
+				    const struct in6_addr *daddr,
+				    const struct in6_addr *saddr,
+				    const struct tcphdr *th, int nbytes)
 {
-	struct tcp6_pseudohdr *bp;
-	struct scatterlist sg;
-	struct tcphdr *_th;
-
-	bp = hp->scratch;
-	/* 1. TCP pseudo-header (RFC2460) */
-	bp->saddr = *saddr;
-	bp->daddr = *daddr;
-	bp->protocol = cpu_to_be32(IPPROTO_TCP);
-	bp->len = cpu_to_be32(nbytes);
-
-	_th = (struct tcphdr *)(bp + 1);
-	memcpy(_th, th, sizeof(*th));
-	_th->check = 0;
-
-	sg_init_one(&sg, bp, sizeof(*bp) + sizeof(*th));
-	ahash_request_set_crypt(hp->req, &sg, NULL,
-				sizeof(*bp) + sizeof(*th));
-	return crypto_ahash_update(hp->req);
+	struct {
+		struct tcp6_pseudohdr ip; /* TCP pseudo-header (RFC2460) */
+		struct tcphdr tcp;
+	} h;
+
+	h.ip.saddr = *saddr;
+	h.ip.daddr = *daddr;
+	h.ip.protocol = cpu_to_be32(IPPROTO_TCP);
+	h.ip.len = cpu_to_be32(nbytes);
+	h.tcp = *th;
+	h.tcp.check = 0;
+	md5_update(ctx, (const u8 *)&h, sizeof(h.ip) + sizeof(h.tcp));
 }
 
-static int tcp_v6_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
-			       const struct in6_addr *daddr, struct in6_addr *saddr,
-			       const struct tcphdr *th)
+static noinline_for_stack void
+tcp_v6_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
+		    const struct in6_addr *daddr, struct in6_addr *saddr,
+		    const struct tcphdr *th)
 {
-	struct tcp_sigpool hp;
-
-	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
-		goto clear_hash_nostart;
-
-	if (crypto_ahash_init(hp.req))
-		goto clear_hash;
-	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
-		goto clear_hash;
-	if (tcp_md5_hash_key(&hp, key))
-		goto clear_hash;
-	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(hp.req))
-		goto clear_hash;
-
-	tcp_sigpool_end(&hp);
-	return 0;
+	struct md5_ctx ctx;
 
-clear_hash:
-	tcp_sigpool_end(&hp);
-clear_hash_nostart:
-	memset(md5_hash, 0, 16);
-	return 1;
+	md5_init(&ctx);
+	tcp_v6_md5_hash_headers(&ctx, daddr, saddr, th, th->doff << 2);
+	tcp_md5_hash_key(&ctx, key);
+	md5_final(&ctx, md5_hash);
 }
 
-static int tcp_v6_md5_hash_skb(char *md5_hash,
-			       const struct tcp_md5sig_key *key,
-			       const struct sock *sk,
-			       const struct sk_buff *skb)
+static noinline_for_stack void
+tcp_v6_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
+		    const struct sock *sk, const struct sk_buff *skb)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_sigpool hp;
+	struct md5_ctx ctx;
 
 	if (sk) { /* valid for establish/request sockets */
 		saddr = &sk->sk_v6_rcv_saddr;
 		daddr = &sk->sk_v6_daddr;
 	} else {
 		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 		saddr = &ip6h->saddr;
 		daddr = &ip6h->daddr;
 	}
 
-	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
-		goto clear_hash_nostart;
-
-	if (crypto_ahash_init(hp.req))
-		goto clear_hash;
-
-	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
-		goto clear_hash;
-	if (tcp_sigpool_hash_skb_data(&hp, skb, th->doff << 2))
-		goto clear_hash;
-	if (tcp_md5_hash_key(&hp, key))
-		goto clear_hash;
-	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(hp.req))
-		goto clear_hash;
-
-	tcp_sigpool_end(&hp);
-	return 0;
-
-clear_hash:
-	tcp_sigpool_end(&hp);
-clear_hash_nostart:
-	memset(md5_hash, 0, 16);
-	return 1;
+	md5_init(&ctx);
+	tcp_v6_md5_hash_headers(&ctx, daddr, saddr, th, skb->len);
+	tcp_md5_hash_skb_data(&ctx, skb, th->doff << 2);
+	tcp_md5_hash_key(&ctx, key);
+	md5_final(&ctx, md5_hash);
 }
 #endif
 
 static void tcp_v6_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
@@ -1030,11 +986,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 	struct net *net;
 	u32 txhash = 0;
 	int oif = 0;
 #ifdef CONFIG_TCP_MD5SIG
 	unsigned char newhash[16];
-	int genhash;
 	struct sock *sk1 = NULL;
 #endif
 
 	if (th->rst)
 		return;
@@ -1089,12 +1044,12 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 		key.md5_key = tcp_v6_md5_do_lookup(sk1, &ipv6h->saddr, l3index);
 		if (!key.md5_key)
 			goto out;
 		key.type = TCP_KEY_MD5;
 
-		genhash = tcp_v6_md5_hash_skb(newhash, key.md5_key, NULL, skb);
-		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
+		tcp_v6_md5_hash_skb(newhash, key.md5_key, NULL, skb);
+		if (memcmp(md5_hash_location, newhash, 16) != 0)
 			goto out;
 	}
 #endif
 
 	if (th->ack)

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.0

