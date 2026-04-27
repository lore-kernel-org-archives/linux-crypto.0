Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1403E51EF;
	Mon, 27 Apr 2026 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310870; cv=none; b=hC6qAbwJ/SXK0pjaZX0CykY4mw4HDoAIujXneb6EBB3aE5cgrXPZMsMW739P1dzDUFQKDuILit1ncjGswYdfI+iykeX0dJ5C/YbTorxJ9Kq4SXMAcPbH5fXmN+YB5d1C8gQNR3JMMAYazTmPVoU3tUh79QRds8ono+9a5VZf6eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310870; c=relaxed/simple;
	bh=WwSRkUiIZJfp2dCE2WV7tWtIceXntadz2RdvKLMPvTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLSoScLKOLGO5nKyeB39MJJvBs5S3nS8DaRfCTtLU3bR7c9hjI0JpcFHtN6dpfNEPOYxjh4gjF9QyGcmdV0GpHJ2oWcEpqihmUWXugGJv0CILA0SZdpAE+uVdafeOIubnpFBdKbxylGzZsTQ6FPDObwbzWI4Df7BTzErIHRsc1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0/xk8Pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0/xk8Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AC7C2BCB4;
	Mon, 27 Apr 2026 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310869;
	bh=WwSRkUiIZJfp2dCE2WV7tWtIceXntadz2RdvKLMPvTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0/xk8PzJLUCW/VrOdGBWcDrnv7VzrLqA71aFIyohcD3eR8JV3BVfhfV8IbYzZLjP
	 DzfLwROdYepycNZgM7hN/U0AbBSZnR0pajGFo/XmQ/Nsmledu21rnzJ1I7AEzvaktW
	 gQMeTRraWAv1O7UJFIVjh8jEBu7SYJQ6tQNqlkawEtjqYxdaPUVq4cDpcXPzHgcQVB
	 MqgmbR7Zu5pb8kdV2OGXxG/H9Zcb8YM5jhE9P2RLIfDClVOybZVRBl+uQOI6W8AXPB
	 XY5xY+Yl5X2/xKuitFg0lVxNk8HNaZnj7aczquuKWT/LP9mlM3BijkvU/Kzq3w74TK
	 cjvl4/NpEj+bQ==
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
Subject: [PATCH net-next v2 2/5] net/tcp-ao: Use crypto library API instead of crypto_ahash
Date: Mon, 27 Apr 2026 10:27:24 -0700
Message-ID: <20260427172727.9310-3-ebiggers@kernel.org>
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

Currently the kernel's TCP-AO implementation does the MAC and KDF
computations using the crypto_ahash API.  This API is inefficient and
difficult to use, and it has required extensive workarounds in the form
of per-CPU preallocated objects (tcp_sigpool) to work at all.

Let's use lib/crypto/ instead.  This means switching to straightforward
stack-allocated structures, virtually addressed buffers, and direct
function calls.  It also means removing quite a bit of error handling.
This makes TCP-AO quite a bit faster.

This also enables many additional cleanups, which later commits will
handle: removing tcp-sigpool, removing support for crypto_tfm cloning,
removing more error handling, and replacing more dynamically-allocated
buffers with stack buffers based on the now-statically-known limits.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/net/tcp_ao.h                      |  32 +-
 net/ipv4/Kconfig                          |   5 +-
 net/ipv4/tcp_ao.c                         | 523 +++++++++++-----------
 net/ipv6/tcp_ao.c                         |  63 ++-
 tools/testing/selftests/net/tcp_ao/config |   3 -
 5 files changed, 309 insertions(+), 317 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 1e9e27d6e06b..20997aef3b0d 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -1,11 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 #ifndef _TCP_AO_H
 #define _TCP_AO_H
 
-#define TCP_AO_KEY_ALIGN	1
-#define __tcp_ao_key_align __aligned(TCP_AO_KEY_ALIGN)
+#include <crypto/sha2.h> /* for SHA256_DIGEST_SIZE */
 
 union tcp_ao_addr {
 	struct in_addr  a4;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr	a6;
@@ -30,15 +29,31 @@ struct tcp_ao_counters {
 	atomic64_t	key_not_found;
 	atomic64_t	ao_required;
 	atomic64_t	dropped_icmp;
 };
 
+enum tcp_ao_algo_id {
+	TCP_AO_ALGO_HMAC_SHA1 = 1, /* specified by RFC 5926 */
+	TCP_AO_ALGO_HMAC_SHA256, /* Linux extension */
+	TCP_AO_ALGO_AES_128_CMAC, /* specified by RFC 5926 */
+};
+
+/*
+ * This is the maximum untruncated MAC length, in bytes.  Note that the MACs
+ * actually get truncated to 20 or fewer bytes to fit in the TCP options space.
+ */
+#define TCP_AO_MAX_MAC_LEN		SHA256_DIGEST_SIZE
+
+#define TCP_AO_MAX_TRAFFIC_KEY_LEN	SHA256_DIGEST_SIZE
+
+struct tcp_ao_mac_ctx;
+
 struct tcp_ao_key {
 	struct hlist_node	node;
 	union tcp_ao_addr	addr;
-	u8			key[TCP_AO_MAXKEYLEN] __tcp_ao_key_align;
-	unsigned int		tcp_sigpool_id;
+	u8			key[TCP_AO_MAXKEYLEN];
+	enum tcp_ao_algo_id	algo;
 	unsigned int		digest_size;
 	int			l3index;
 	u8			prefixlen;
 	u8			family;
 	u8			keylen;
@@ -166,18 +181,19 @@ struct tcp6_ao_context {
 	__be16		dport;
 	__be32		sisn;
 	__be32		disn;
 };
 
-struct tcp_sigpool;
 /* Established states are fast-path and there always is current_key/rnext_key */
 #define TCP_AO_ESTABLISHED (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | \
 			    TCPF_CLOSE_WAIT | TCPF_LAST_ACK | TCPF_CLOSING)
 
 int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
 			struct tcp_ao_key *key, struct tcphdr *th,
 			__u8 *hash_location);
+void tcp_ao_mac_update(struct tcp_ao_mac_ctx *mac_ctx, const void *data,
+		       size_t data_len);
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
 		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
@@ -186,12 +202,12 @@ struct tcp_ao_key *tcp_ao_established_key(const struct sock *sk,
 					  struct tcp_ao_info *ao,
 					  int sndid, int rcvid);
 int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 			     struct request_sock *req, struct sk_buff *skb,
 			     int family);
-int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
-			    unsigned int len, struct tcp_sigpool *hp);
+void tcp_ao_calc_traffic_key(const struct tcp_ao_key *mkt, u8 *traffic_key,
+			     const void *input, unsigned int input_len);
 void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 bool tcp_ao_ignore_icmp(const struct sock *sk, int family, int type, int code);
 int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen);
@@ -232,11 +248,11 @@ struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
 					int sndid, int rcvid);
 int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne);
 /* ipv6 specific functions */
-int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
+int tcp_v6_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
 				const struct in6_addr *daddr,
 				const struct in6_addr *saddr, int nbytes);
 int tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
 			   const struct sk_buff *skb, __be32 sisn, __be32 disn);
 int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 21e5164e30db..77b053b445a0 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -744,13 +744,14 @@ config DEFAULT_TCP_CONG
 config TCP_SIGPOOL
 	tristate
 
 config TCP_AO
 	bool "TCP: Authentication Option (RFC5925)"
-	select CRYPTO
+	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_UTILS
-	select TCP_SIGPOOL
 	depends on 64BIT # seq-number extension needs WRITE_ONCE(u64)
 	help
 	  TCP-AO specifies the use of stronger Message Authentication Codes (MACs),
 	  protects against replays for long-lived TCP connections, and
 	  provides more details on the association of security with TCP
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index b21bd69b4e82..0d24cbd66c9a 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -7,11 +7,13 @@
  *		Francesco Ruggeri <fruggeri@arista.com>
  *		Salam Noureddine <noureddine@arista.com>
  */
 #define pr_fmt(fmt) "TCP: " fmt
 
-#include <crypto/hash.h>
+#include <crypto/aes-cbc-macs.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
 #include <crypto/utils.h>
 #include <linux/inetdevice.h>
 #include <linux/tcp.h>
 
 #include <net/tcp.h>
@@ -19,36 +21,137 @@
 #include <net/icmp.h>
 #include <trace/events/tcp.h>
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_ao_needed, HZ);
 
-int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
-			    unsigned int len, struct tcp_sigpool *hp)
-{
-	struct scatterlist sg;
-	int ret;
+static const struct tcp_ao_algo {
+	const char *name;
+	unsigned int digest_size;
+} tcp_ao_algos[] = {
+	[TCP_AO_ALGO_HMAC_SHA1] = {
+		.name = "hmac(sha1)",
+		.digest_size = SHA1_DIGEST_SIZE,
+	},
+	[TCP_AO_ALGO_HMAC_SHA256] = {
+		.name = "hmac(sha256)",
+		.digest_size = SHA256_DIGEST_SIZE,
+	},
+	[TCP_AO_ALGO_AES_128_CMAC] = {
+		.name = "cmac(aes128)",
+		.digest_size = AES_BLOCK_SIZE, /* same as AES_KEYSIZE_128 */
+	},
+};
+
+struct tcp_ao_mac_ctx {
+	enum tcp_ao_algo_id algo;
+	union {
+		struct hmac_sha1_ctx hmac_sha1;
+		struct hmac_sha256_ctx hmac_sha256;
+		struct {
+			struct aes_cmac_key key;
+			struct aes_cmac_ctx ctx;
+		} aes_cmac;
+	};
+};
+
+static const struct tcp_ao_algo *tcp_ao_find_algo(const char *name)
+{
+	for (size_t i = 0; i < ARRAY_SIZE(tcp_ao_algos); i++) {
+		const struct tcp_ao_algo *algo = &tcp_ao_algos[i];
+
+		if (!algo->name)
+			continue;
+		if (WARN_ON_ONCE(algo->digest_size > TCP_AO_MAX_MAC_LEN ||
+				 algo->digest_size >
+					 TCP_AO_MAX_TRAFFIC_KEY_LEN))
+			continue;
+		if (strcmp(name, algo->name) == 0)
+			return algo;
+	}
+	return NULL;
+}
 
-	if (crypto_ahash_setkey(crypto_ahash_reqtfm(hp->req),
-				mkt->key, mkt->keylen))
-		goto clear_hash;
+static void tcp_ao_mac_init(struct tcp_ao_mac_ctx *mac_ctx,
+			    enum tcp_ao_algo_id algo, const u8 *traffic_key)
+{
+	mac_ctx->algo = algo;
+	switch (mac_ctx->algo) {
+	case TCP_AO_ALGO_HMAC_SHA1:
+		hmac_sha1_init_usingrawkey(&mac_ctx->hmac_sha1, traffic_key,
+					   SHA1_DIGEST_SIZE);
+		return;
+	case TCP_AO_ALGO_HMAC_SHA256:
+		hmac_sha256_init_usingrawkey(&mac_ctx->hmac_sha256, traffic_key,
+					     SHA256_DIGEST_SIZE);
+		return;
+	case TCP_AO_ALGO_AES_128_CMAC:
+		aes_cmac_preparekey(&mac_ctx->aes_cmac.key, traffic_key,
+				    AES_KEYSIZE_128);
+		aes_cmac_init(&mac_ctx->aes_cmac.ctx, &mac_ctx->aes_cmac.key);
+		return;
+	default:
+		WARN_ON_ONCE(1); /* algo was validated earlier. */
+	}
+}
 
-	ret = crypto_ahash_init(hp->req);
-	if (ret)
-		goto clear_hash;
+void tcp_ao_mac_update(struct tcp_ao_mac_ctx *mac_ctx, const void *data,
+		       size_t data_len)
+{
+	switch (mac_ctx->algo) {
+	case TCP_AO_ALGO_HMAC_SHA1:
+		hmac_sha1_update(&mac_ctx->hmac_sha1, data, data_len);
+		return;
+	case TCP_AO_ALGO_HMAC_SHA256:
+		hmac_sha256_update(&mac_ctx->hmac_sha256, data, data_len);
+		return;
+	case TCP_AO_ALGO_AES_128_CMAC:
+		aes_cmac_update(&mac_ctx->aes_cmac.ctx, data, data_len);
+		return;
+	default:
+		WARN_ON_ONCE(1); /* algo was validated earlier. */
+	}
+}
 
-	sg_init_one(&sg, ctx, len);
-	ahash_request_set_crypt(hp->req, &sg, key, len);
-	crypto_ahash_update(hp->req);
+static void tcp_ao_mac_final(struct tcp_ao_mac_ctx *mac_ctx, u8 *out)
+{
+	switch (mac_ctx->algo) {
+	case TCP_AO_ALGO_HMAC_SHA1:
+		hmac_sha1_final(&mac_ctx->hmac_sha1, out);
+		return;
+	case TCP_AO_ALGO_HMAC_SHA256:
+		hmac_sha256_final(&mac_ctx->hmac_sha256, out);
+		return;
+	case TCP_AO_ALGO_AES_128_CMAC:
+		aes_cmac_final(&mac_ctx->aes_cmac.ctx, out);
+		return;
+	default:
+		WARN_ON_ONCE(1); /* algo was validated earlier. */
+	}
+}
 
-	ret = crypto_ahash_final(hp->req);
-	if (ret)
-		goto clear_hash;
+void tcp_ao_calc_traffic_key(const struct tcp_ao_key *mkt, u8 *traffic_key,
+			     const void *input, unsigned int input_len)
+{
+	switch (mkt->algo) {
+	case TCP_AO_ALGO_HMAC_SHA1:
+		hmac_sha1_usingrawkey(mkt->key, mkt->keylen, input, input_len,
+				      traffic_key);
+		return;
+	case TCP_AO_ALGO_HMAC_SHA256:
+		hmac_sha256_usingrawkey(mkt->key, mkt->keylen, input, input_len,
+					traffic_key);
+		return;
+	case TCP_AO_ALGO_AES_128_CMAC: {
+		struct aes_cmac_key k;
 
-	return 0;
-clear_hash:
-	memset(key, 0, tcp_ao_digest_size(mkt));
-	return 1;
+		aes_cmac_preparekey(&k, mkt->key, AES_KEYSIZE_128);
+		aes_cmac(&k, input, input_len, traffic_key);
+		return;
+	}
+	default:
+		WARN_ON_ONCE(1); /* algo was validated earlier. */
+	}
 }
 
 bool tcp_ao_ignore_icmp(const struct sock *sk, int family, int type, int code)
 {
 	bool ignore_icmp = false;
@@ -252,33 +355,30 @@ static struct tcp_ao_key *tcp_ao_copy_key(struct sock *sk,
 	if (!new_key)
 		return NULL;
 
 	*new_key = *key;
 	INIT_HLIST_NODE(&new_key->node);
-	tcp_sigpool_get(new_key->tcp_sigpool_id);
 	atomic64_set(&new_key->pkt_good, 0);
 	atomic64_set(&new_key->pkt_bad, 0);
 
 	return new_key;
 }
 
 static void tcp_ao_key_free_rcu(struct rcu_head *head)
 {
 	struct tcp_ao_key *key = container_of(head, struct tcp_ao_key, rcu);
 
-	tcp_sigpool_release(key->tcp_sigpool_id);
 	kfree_sensitive(key);
 }
 
 static void tcp_ao_info_free(struct tcp_ao_info *ao)
 {
 	struct tcp_ao_key *key;
 	struct hlist_node *n;
 
 	hlist_for_each_entry_safe(key, n, &ao->head, node) {
 		hlist_del(&key->node);
-		tcp_sigpool_release(key->tcp_sigpool_id);
 		kfree_sensitive(key);
 	}
 	kfree(ao);
 	static_branch_slow_dec_deferred(&tcp_ao_needed);
 }
@@ -344,33 +444,26 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
 	struct kdf_input_block {
 		u8                      counter;
 		u8                      label[6];
 		struct tcp4_ao_context	ctx;
 		__be16                  outlen;
-	} __packed * tmp;
-	struct tcp_sigpool hp;
-	int err;
-
-	err = tcp_sigpool_start(mkt->tcp_sigpool_id, &hp);
-	if (err)
-		return err;
-
-	tmp = hp.scratch;
-	tmp->counter	= 1;
-	memcpy(tmp->label, "TCP-AO", 6);
-	tmp->ctx.saddr	= saddr;
-	tmp->ctx.daddr	= daddr;
-	tmp->ctx.sport	= sport;
-	tmp->ctx.dport	= dport;
-	tmp->ctx.sisn	= sisn;
-	tmp->ctx.disn	= disn;
-	tmp->outlen	= htons(tcp_ao_digest_size(mkt) * 8); /* in bits */
-
-	err = tcp_ao_calc_traffic_key(mkt, key, tmp, sizeof(*tmp), &hp);
-	tcp_sigpool_end(&hp);
-
-	return err;
+	} __packed input = {
+		.counter = 1,
+		.label = "TCP-AO",
+		.ctx = {
+			.saddr = saddr,
+			.daddr = daddr,
+			.sport = sport,
+			.dport = dport,
+			.sisn = sisn,
+			.disn = disn,
+		},
+		.outlen = htons(tcp_ao_digest_size(mkt) * 8), /* in bits */
+	};
+
+	tcp_ao_calc_traffic_key(mkt, key, &input, sizeof(input));
+	return 0;
 }
 
 int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk,
 			  __be32 sisn, __be32 disn, bool send)
@@ -433,60 +526,57 @@ static int tcp_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
 		return tcp_v6_ao_calc_key_skb(mkt, key, skb, sisn, disn);
 #endif
 	return -EAFNOSUPPORT;
 }
 
-static int tcp_v4_ao_hash_pseudoheader(struct tcp_sigpool *hp,
+static int tcp_v4_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
 				       __be32 daddr, __be32 saddr,
 				       int nbytes)
 {
-	struct tcp4_pseudohdr *bp;
-	struct scatterlist sg;
+	struct tcp4_pseudohdr phdr = {
+		.saddr = saddr,
+		.daddr = daddr,
+		.pad = 0,
+		.protocol = IPPROTO_TCP,
+		.len = cpu_to_be16(nbytes),
+	};
 
-	bp = hp->scratch;
-	bp->saddr = saddr;
-	bp->daddr = daddr;
-	bp->pad = 0;
-	bp->protocol = IPPROTO_TCP;
-	bp->len = cpu_to_be16(nbytes);
-
-	sg_init_one(&sg, bp, sizeof(*bp));
-	ahash_request_set_crypt(hp->req, &sg, NULL, sizeof(*bp));
-	return crypto_ahash_update(hp->req);
+	tcp_ao_mac_update(mac_ctx, &phdr, sizeof(phdr));
+	return 0;
 }
 
 static int tcp_ao_hash_pseudoheader(unsigned short int family,
 				    const struct sock *sk,
 				    const struct sk_buff *skb,
-				    struct tcp_sigpool *hp, int nbytes)
+				    struct tcp_ao_mac_ctx *mac_ctx, int nbytes)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	/* TODO: Can we rely on checksum being zero to mean outbound pkt? */
 	if (!th->check) {
 		if (family == AF_INET)
-			return tcp_v4_ao_hash_pseudoheader(hp, sk->sk_daddr,
+			return tcp_v4_ao_hash_pseudoheader(mac_ctx, sk->sk_daddr,
 					sk->sk_rcv_saddr, skb->len);
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (family == AF_INET6)
-			return tcp_v6_ao_hash_pseudoheader(hp, &sk->sk_v6_daddr,
+			return tcp_v6_ao_hash_pseudoheader(mac_ctx, &sk->sk_v6_daddr,
 					&sk->sk_v6_rcv_saddr, skb->len);
 #endif
 		else
 			return -EAFNOSUPPORT;
 	}
 
 	if (family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(skb);
 
-		return tcp_v4_ao_hash_pseudoheader(hp, iph->daddr,
+		return tcp_v4_ao_hash_pseudoheader(mac_ctx, iph->daddr,
 				iph->saddr, skb->len);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (family == AF_INET6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 
-		return tcp_v6_ao_hash_pseudoheader(hp, &iph->daddr,
+		return tcp_v6_ao_hash_pseudoheader(mac_ctx, &iph->daddr,
 				&iph->saddr, skb->len);
 #endif
 	}
 	return -EAFNOSUPPORT;
 }
@@ -504,35 +594,24 @@ u32 tcp_ao_compute_sne(u32 next_sne, u32 next_seq, u32 seq)
 	}
 
 	return sne;
 }
 
-/* tcp_ao_hash_sne(struct tcp_sigpool *hp)
- * @hp	- used for hashing
- * @sne - sne value
- */
-static int tcp_ao_hash_sne(struct tcp_sigpool *hp, u32 sne)
+static void tcp_ao_hash_sne(struct tcp_ao_mac_ctx *mac_ctx, u32 sne)
 {
-	struct scatterlist sg;
-	__be32 *bp;
-
-	bp = (__be32 *)hp->scratch;
-	*bp = htonl(sne);
+	__be32 sne_be32 = htonl(sne);
 
-	sg_init_one(&sg, bp, sizeof(*bp));
-	ahash_request_set_crypt(hp->req, &sg, NULL, sizeof(*bp));
-	return crypto_ahash_update(hp->req);
+	tcp_ao_mac_update(mac_ctx, &sne_be32, sizeof(sne_be32));
 }
 
-static int tcp_ao_hash_header(struct tcp_sigpool *hp,
-			      const struct tcphdr *th,
-			      bool exclude_options, u8 *hash,
-			      int hash_offset, int hash_len)
+static void tcp_ao_hash_header(struct tcp_ao_mac_ctx *mac_ctx,
+			       const struct tcphdr *th, bool exclude_options,
+			       u8 *hash, int hash_offset, int hash_len)
 {
-	struct scatterlist sg;
-	u8 *hdr = hp->scratch;
-	int err, len;
+	/* Full TCP header (th->doff << 2) should fit into scratch area. */
+	u8 hdr[60];
+	int len;
 
 	/* We are not allowed to change tcphdr, make a local copy */
 	if (exclude_options) {
 		len = sizeof(*th) + sizeof(struct tcp_ao_hdr) + hash_len;
 		memcpy(hdr, th, sizeof(*th));
@@ -548,126 +627,105 @@ static int tcp_ao_hash_header(struct tcp_sigpool *hp,
 		/* zero out tcp-ao hash */
 		((struct tcphdr *)hdr)->check = 0;
 		memset(hdr + hash_offset, 0, hash_len);
 	}
 
-	sg_init_one(&sg, hdr, len);
-	ahash_request_set_crypt(hp->req, &sg, NULL, len);
-	err = crypto_ahash_update(hp->req);
-	WARN_ON_ONCE(err != 0);
-	return err;
+	tcp_ao_mac_update(mac_ctx, hdr, len);
 }
 
 int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
 		    struct tcp_ao_key *key, const u8 *tkey,
 		    const union tcp_ao_addr *daddr,
 		    const union tcp_ao_addr *saddr,
 		    const struct tcphdr *th, u32 sne)
 {
-	int tkey_len = tcp_ao_digest_size(key);
 	int hash_offset = ao_hash - (char *)th;
-	struct tcp_sigpool hp;
-	void *hash_buf = NULL;
-
-	hash_buf = kmalloc(tkey_len, GFP_ATOMIC);
-	if (!hash_buf)
-		goto clear_hash_noput;
-
-	if (tcp_sigpool_start(key->tcp_sigpool_id, &hp))
-		goto clear_hash_noput;
-
-	if (crypto_ahash_setkey(crypto_ahash_reqtfm(hp.req), tkey, tkey_len))
-		goto clear_hash;
-
-	if (crypto_ahash_init(hp.req))
-		goto clear_hash;
+	struct tcp_ao_mac_ctx mac_ctx;
+	u8 hash_buf[TCP_AO_MAX_MAC_LEN];
 
-	if (tcp_ao_hash_sne(&hp, sne))
-		goto clear_hash;
+	tcp_ao_mac_init(&mac_ctx, key->algo, tkey);
+	tcp_ao_hash_sne(&mac_ctx, sne);
 	if (family == AF_INET) {
-		if (tcp_v4_ao_hash_pseudoheader(&hp, daddr->a4.s_addr,
-						saddr->a4.s_addr, th->doff * 4))
-			goto clear_hash;
+		tcp_v4_ao_hash_pseudoheader(&mac_ctx, daddr->a4.s_addr,
+					    saddr->a4.s_addr, th->doff * 4);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (family == AF_INET6) {
-		if (tcp_v6_ao_hash_pseudoheader(&hp, &daddr->a6,
-						&saddr->a6, th->doff * 4))
-			goto clear_hash;
+		tcp_v6_ao_hash_pseudoheader(&mac_ctx, &daddr->a6,
+					    &saddr->a6, th->doff * 4);
 #endif
 	} else {
 		WARN_ON_ONCE(1);
 		goto clear_hash;
 	}
-	if (tcp_ao_hash_header(&hp, th,
-			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
-			       ao_hash, hash_offset, tcp_ao_maclen(key)))
-		goto clear_hash;
-	ahash_request_set_crypt(hp.req, NULL, hash_buf, 0);
-	if (crypto_ahash_final(hp.req))
-		goto clear_hash;
+	tcp_ao_hash_header(&mac_ctx, th,
+			   !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
+			   ao_hash, hash_offset, tcp_ao_maclen(key));
+	tcp_ao_mac_final(&mac_ctx, hash_buf);
 
 	memcpy(ao_hash, hash_buf, tcp_ao_maclen(key));
-	tcp_sigpool_end(&hp);
-	kfree(hash_buf);
 	return 0;
 
 clear_hash:
-	tcp_sigpool_end(&hp);
-clear_hash_noput:
 	memset(ao_hash, 0, tcp_ao_maclen(key));
-	kfree(hash_buf);
 	return 1;
 }
 
+static void tcp_ao_hash_skb_data(struct tcp_ao_mac_ctx *mac_ctx,
+				 const struct sk_buff *skb,
+				 unsigned int header_len)
+{
+	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
+					   skb_headlen(skb) - header_len : 0;
+	const struct skb_shared_info *shi = skb_shinfo(skb);
+	struct sk_buff *frag_iter;
+	unsigned int i;
+
+	tcp_ao_mac_update(mac_ctx, (const u8 *)tcp_hdr(skb) + header_len,
+			  head_data_len);
+
+	for (i = 0; i < shi->nr_frags; ++i) {
+		const skb_frag_t *f = &shi->frags[i];
+		u32 p_off, p_len, copied;
+		const void *vaddr;
+		struct page *p;
+
+		skb_frag_foreach_page(f, skb_frag_off(f), skb_frag_size(f),
+				      p, p_off, p_len, copied) {
+			vaddr = kmap_local_page(p);
+			tcp_ao_mac_update(mac_ctx, vaddr + p_off, p_len);
+			kunmap_local(vaddr);
+		}
+	}
+
+	skb_walk_frags(skb, frag_iter)
+		tcp_ao_hash_skb_data(mac_ctx, frag_iter, 0);
+}
+
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
 		    const u8 *tkey, int hash_offset, u32 sne)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
-	int tkey_len = tcp_ao_digest_size(key);
-	struct tcp_sigpool hp;
-	void *hash_buf = NULL;
-
-	hash_buf = kmalloc(tkey_len, GFP_ATOMIC);
-	if (!hash_buf)
-		goto clear_hash_noput;
-
-	if (tcp_sigpool_start(key->tcp_sigpool_id, &hp))
-		goto clear_hash_noput;
-
-	if (crypto_ahash_setkey(crypto_ahash_reqtfm(hp.req), tkey, tkey_len))
-		goto clear_hash;
-
-	/* For now use sha1 by default. Depends on alg in tcp_ao_key */
-	if (crypto_ahash_init(hp.req))
-		goto clear_hash;
+	struct tcp_ao_mac_ctx mac_ctx;
+	u8 hash_buf[TCP_AO_MAX_MAC_LEN];
 
-	if (tcp_ao_hash_sne(&hp, sne))
-		goto clear_hash;
-	if (tcp_ao_hash_pseudoheader(family, sk, skb, &hp, skb->len))
-		goto clear_hash;
-	if (tcp_ao_hash_header(&hp, th,
-			       !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
-			       ao_hash, hash_offset, tcp_ao_maclen(key)))
-		goto clear_hash;
-	if (tcp_sigpool_hash_skb_data(&hp, skb, th->doff << 2))
-		goto clear_hash;
-	ahash_request_set_crypt(hp.req, NULL, hash_buf, 0);
-	if (crypto_ahash_final(hp.req))
+	tcp_ao_mac_init(&mac_ctx, key->algo, tkey);
+	tcp_ao_hash_sne(&mac_ctx, sne);
+	if (tcp_ao_hash_pseudoheader(family, sk, skb, &mac_ctx, skb->len))
 		goto clear_hash;
+	tcp_ao_hash_header(&mac_ctx, th,
+			   !!(key->keyflags & TCP_AO_KEYF_EXCLUDE_OPT),
+			   ao_hash, hash_offset, tcp_ao_maclen(key));
+	tcp_ao_hash_skb_data(&mac_ctx, skb, th->doff << 2);
+	tcp_ao_mac_final(&mac_ctx, hash_buf);
 
 	memcpy(ao_hash, hash_buf, tcp_ao_maclen(key));
-	tcp_sigpool_end(&hp);
-	kfree(hash_buf);
 	return 0;
 
 clear_hash:
-	tcp_sigpool_end(&hp);
-clear_hash_noput:
 	memset(ao_hash, 0, tcp_ao_maclen(key));
-	kfree(hash_buf);
 	return 1;
 }
 
 int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
@@ -1278,11 +1336,10 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 	return 0;
 
 free_and_exit:
 	hlist_for_each_entry_safe(key, key_head, &new_ao->head, node) {
 		hlist_del(&key->node);
-		tcp_sigpool_release(key->tcp_sigpool_id);
 		atomic_sub(tcp_ao_sizeof_key(key), &newsk->sk_omem_alloc);
 		kfree_sensitive(key);
 	}
 free_ao:
 	kfree(new_ao);
@@ -1334,27 +1391,14 @@ static int tcp_ao_verify_ipv4(struct sock *sk, struct tcp_ao_add *cmd,
 
 	*addr = (union tcp_ao_addr *)&sin->sin_addr;
 	return 0;
 }
 
-static int tcp_ao_parse_crypto(struct tcp_ao_add *cmd, struct tcp_ao_key *key)
+static int tcp_ao_parse_crypto(const struct tcp_ao_add *cmd,
+			       struct tcp_ao_key *key)
 {
 	unsigned int syn_tcp_option_space;
-	bool is_kdf_aes_128_cmac = false;
-	struct crypto_ahash *tfm;
-	struct tcp_sigpool hp;
-	void *tmp_key = NULL;
-	int err;
-
-	/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
-	if (!strcmp("cmac(aes128)", cmd->alg_name)) {
-		strscpy(cmd->alg_name, "cmac(aes)", sizeof(cmd->alg_name));
-		is_kdf_aes_128_cmac = (cmd->keylen != 16);
-		tmp_key = kmalloc(cmd->keylen, GFP_KERNEL);
-		if (!tmp_key)
-			return -ENOMEM;
-	}
 
 	key->maclen = cmd->maclen ?: 12; /* 12 is the default in RFC5925 */
 
 	/* Check: maclen + tcp-ao header <= (MAX_TCP_OPTION_SPACE - mss
 	 *					- tstamp (including sackperm)
@@ -1386,68 +1430,31 @@ static int tcp_ao_parse_crypto(struct tcp_ao_add *cmd, struct tcp_ao_key *key)
 	 */
 	syn_tcp_option_space = MAX_TCP_OPTION_SPACE;
 	syn_tcp_option_space -= TCPOLEN_MSS_ALIGNED;
 	syn_tcp_option_space -= TCPOLEN_TSTAMP_ALIGNED;
 	syn_tcp_option_space -= TCPOLEN_WSCALE_ALIGNED;
-	if (tcp_ao_len_aligned(key) > syn_tcp_option_space) {
-		err = -EMSGSIZE;
-		goto err_kfree;
-	}
-
-	key->keylen = cmd->keylen;
-	memcpy(key->key, cmd->key, cmd->keylen);
-
-	err = tcp_sigpool_start(key->tcp_sigpool_id, &hp);
-	if (err)
-		goto err_kfree;
-
-	tfm = crypto_ahash_reqtfm(hp.req);
-	if (is_kdf_aes_128_cmac) {
-		void *scratch = hp.scratch;
-		struct scatterlist sg;
-
-		memcpy(tmp_key, cmd->key, cmd->keylen);
-		sg_init_one(&sg, tmp_key, cmd->keylen);
-
-		/* Using zero-key of 16 bytes as described in RFC5926 */
-		memset(scratch, 0, 16);
-		err = crypto_ahash_setkey(tfm, scratch, 16);
-		if (err)
-			goto err_pool_end;
-
-		err = crypto_ahash_init(hp.req);
-		if (err)
-			goto err_pool_end;
-
-		ahash_request_set_crypt(hp.req, &sg, key->key, cmd->keylen);
-		err = crypto_ahash_update(hp.req);
-		if (err)
-			goto err_pool_end;
-
-		err |= crypto_ahash_final(hp.req);
-		if (err)
-			goto err_pool_end;
-		key->keylen = 16;
+	if (tcp_ao_len_aligned(key) > syn_tcp_option_space)
+		return -EMSGSIZE;
+
+	if (key->algo == TCP_AO_ALGO_AES_128_CMAC &&
+	    cmd->keylen != AES_KEYSIZE_128) {
+		/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
+		static const u8 zeroes[AES_KEYSIZE_128];
+		struct aes_cmac_key extractor;
+
+		aes_cmac_preparekey(&extractor, zeroes, AES_KEYSIZE_128);
+		aes_cmac(&extractor, cmd->key, cmd->keylen, key->key);
+		key->keylen = AES_KEYSIZE_128;
+	} else {
+		memcpy(key->key, cmd->key, cmd->keylen);
+		key->keylen = cmd->keylen;
 	}
 
-	err = crypto_ahash_setkey(tfm, key->key, key->keylen);
-	if (err)
-		goto err_pool_end;
-
-	tcp_sigpool_end(&hp);
-	kfree_sensitive(tmp_key);
-
 	if (tcp_ao_maclen(key) > key->digest_size)
 		return -EINVAL;
 
 	return 0;
-
-err_pool_end:
-	tcp_sigpool_end(&hp);
-err_kfree:
-	kfree_sensitive(tmp_key);
-	return err;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static int tcp_ao_verify_ipv6(struct sock *sk, struct tcp_ao_add *cmd,
 			      union tcp_ao_addr **paddr,
@@ -1547,58 +1554,37 @@ static struct tcp_ao_info *getsockopt_ao_info(struct sock *sk)
 #define TCP_AO_GET_KEYF_VALID	(TCP_AO_KEYF_IFINDEX)
 
 static struct tcp_ao_key *tcp_ao_key_alloc(struct sock *sk,
 					   struct tcp_ao_add *cmd)
 {
-	const char *algo = cmd->alg_name;
-	unsigned int digest_size;
-	struct crypto_ahash *tfm;
+	const struct tcp_ao_algo *algo;
 	struct tcp_ao_key *key;
-	struct tcp_sigpool hp;
-	int err, pool_id;
 	size_t size;
 
 	/* Force null-termination of alg_name */
 	cmd->alg_name[ARRAY_SIZE(cmd->alg_name) - 1] = '\0';
 
-	/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
-	if (!strcmp("cmac(aes128)", algo))
-		algo = "cmac(aes)";
-	else if (strcmp("hmac(sha1)", algo) &&
-		 strcmp("hmac(sha256)", algo) &&
-		 (strcmp("cmac(aes)", algo) || cmd->keylen != 16))
-		return ERR_PTR(-ENOENT);
-
-	/* Full TCP header (th->doff << 2) should fit into scratch area,
-	 * see tcp_ao_hash_header().
+	/*
+	 * For backwards compatibility, accept "cmac(aes)" as an alias for
+	 * "cmac(aes128)", provided that the key length is exactly 128 bits.
 	 */
-	pool_id = tcp_sigpool_alloc_ahash(algo, 60);
-	if (pool_id < 0)
-		return ERR_PTR(pool_id);
-
-	err = tcp_sigpool_start(pool_id, &hp);
-	if (err)
-		goto err_free_pool;
+	if (strcmp(cmd->alg_name, "cmac(aes)") == 0 &&
+	    cmd->keylen == AES_KEYSIZE_128)
+		strscpy(cmd->alg_name, "cmac(aes128)");
 
-	tfm = crypto_ahash_reqtfm(hp.req);
-	digest_size = crypto_ahash_digestsize(tfm);
-	tcp_sigpool_end(&hp);
+	algo = tcp_ao_find_algo(cmd->alg_name);
+	if (!algo)
+		return ERR_PTR(-ENOENT);
 
-	size = sizeof(struct tcp_ao_key) + (digest_size << 1);
+	size = sizeof(struct tcp_ao_key) + (algo->digest_size << 1);
 	key = sock_kmalloc(sk, size, GFP_KERNEL);
-	if (!key) {
-		err = -ENOMEM;
-		goto err_free_pool;
-	}
+	if (!key)
+		return ERR_PTR(-ENOMEM);
 
-	key->tcp_sigpool_id = pool_id;
-	key->digest_size = digest_size;
+	key->algo = algo - tcp_ao_algos;
+	key->digest_size = algo->digest_size;
 	return key;
-
-err_free_pool:
-	tcp_sigpool_release(pool_id);
-	return ERR_PTR(err);
 }
 
 static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
 {
@@ -1755,11 +1741,10 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 		WRITE_ONCE(ao_info->rnext_key, key);
 	return 0;
 
 err_free_sock:
 	atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
-	tcp_sigpool_release(key->tcp_sigpool_id);
 	kfree_sensitive(key);
 err_free_ao:
 	if (first)
 		kfree(ao_info);
 	return ret;
@@ -2286,11 +2271,15 @@ static int tcp_ao_copy_mkts_to_user(const struct sock *sk,
 		opt_out.keylen = key->keylen;
 		opt_out.ifindex = key->l3index;
 		opt_out.pkt_good = atomic64_read(&key->pkt_good);
 		opt_out.pkt_bad = atomic64_read(&key->pkt_bad);
 		memcpy(&opt_out.key, key->key, key->keylen);
-		tcp_sigpool_algo(key->tcp_sigpool_id, opt_out.alg_name, 64);
+		if (key->algo == TCP_AO_ALGO_AES_128_CMAC)
+			/* This is needed for backwards compatibility. */
+			strscpy(opt_out.alg_name, "cmac(aes)");
+		else
+			strscpy(opt_out.alg_name, tcp_ao_algos[key->algo].name);
 
 		/* Copy key to user */
 		if (copy_to_sockptr_offset(optval, out_offset,
 					   &opt_out, bytes_to_write))
 			return -EFAULT;
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 3c09ac26206e..2dcfe9dda7f4 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -5,11 +5,10 @@
  *
  * Authors:	Dmitry Safonov <dima@arista.com>
  *		Francesco Ruggeri <fruggeri@arista.com>
  *		Salam Noureddine <noureddine@arista.com>
  */
-#include <crypto/hash.h>
 #include <linux/tcp.h>
 
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
@@ -22,33 +21,26 @@ static int tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
 	struct kdf_input_block {
 		u8			counter;
 		u8			label[6];
 		struct tcp6_ao_context	ctx;
 		__be16			outlen;
-	} __packed * tmp;
-	struct tcp_sigpool hp;
-	int err;
-
-	err = tcp_sigpool_start(mkt->tcp_sigpool_id, &hp);
-	if (err)
-		return err;
-
-	tmp = hp.scratch;
-	tmp->counter	= 1;
-	memcpy(tmp->label, "TCP-AO", 6);
-	tmp->ctx.saddr	= *saddr;
-	tmp->ctx.daddr	= *daddr;
-	tmp->ctx.sport	= sport;
-	tmp->ctx.dport	= dport;
-	tmp->ctx.sisn	= sisn;
-	tmp->ctx.disn	= disn;
-	tmp->outlen	= htons(tcp_ao_digest_size(mkt) * 8); /* in bits */
-
-	err = tcp_ao_calc_traffic_key(mkt, key, tmp, sizeof(*tmp), &hp);
-	tcp_sigpool_end(&hp);
-
-	return err;
+	} __packed input = {
+		.counter = 1,
+		.label = "TCP-AO",
+		.ctx = {
+			.saddr = *saddr,
+			.daddr = *daddr,
+			.sport = sport,
+			.dport = dport,
+			.sisn = sisn,
+			.disn = disn,
+		},
+		.outlen = htons(tcp_ao_digest_size(mkt) * 8), /* in bits */
+	};
+
+	tcp_ao_calc_traffic_key(mkt, key, &input, sizeof(input));
+	return 0;
 }
 
 int tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
 			   const struct sk_buff *skb,
 			   __be32 sisn, __be32 disn)
@@ -110,27 +102,24 @@ struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
 	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 	return tcp_ao_do_lookup(sk, l3index, (union tcp_ao_addr *)addr,
 				AF_INET6, sndid, rcvid);
 }
 
-int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
+int tcp_v6_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
 				const struct in6_addr *daddr,
 				const struct in6_addr *saddr, int nbytes)
 {
-	struct tcp6_pseudohdr *bp;
-	struct scatterlist sg;
-
-	bp = hp->scratch;
 	/* 1. TCP pseudo-header (RFC2460) */
-	bp->saddr = *saddr;
-	bp->daddr = *daddr;
-	bp->len = cpu_to_be32(nbytes);
-	bp->protocol = cpu_to_be32(IPPROTO_TCP);
-
-	sg_init_one(&sg, bp, sizeof(*bp));
-	ahash_request_set_crypt(hp->req, &sg, NULL, sizeof(*bp));
-	return crypto_ahash_update(hp->req);
+	struct tcp6_pseudohdr phdr = {
+		.saddr = *saddr,
+		.daddr = *daddr,
+		.len = cpu_to_be32(nbytes),
+		.protocol = cpu_to_be32(IPPROTO_TCP),
+	};
+
+	tcp_ao_mac_update(mac_ctx, &phdr, sizeof(phdr));
+	return 0;
 }
 
 int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne)
diff --git a/tools/testing/selftests/net/tcp_ao/config b/tools/testing/selftests/net/tcp_ao/config
index 47228a7d0b90..1b120bfd89c4 100644
--- a/tools/testing/selftests/net/tcp_ao/config
+++ b/tools/testing/selftests/net/tcp_ao/config
@@ -1,8 +1,5 @@
-CONFIG_CRYPTO_CMAC=y
-CONFIG_CRYPTO_HMAC=y
-CONFIG_CRYPTO_SHA1=y
 CONFIG_IPV6=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_NET_L3_MASTER_DEV=y
 CONFIG_NET_VRF=y
 CONFIG_TCP_AO=y
-- 
2.54.0

