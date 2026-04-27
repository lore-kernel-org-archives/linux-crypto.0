Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8223E5EF3;
	Mon, 27 Apr 2026 17:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310872; cv=none; b=TogSj5UTZkorp//yyvl+5UdZEBL7M3RU2wbxQBiABB1jY/6Qpp6YCmfaanjwHMLrCTdds7ETk4rhlFySiSavf3YtnvA4LxzoJlxdnr3Sto7D3f1iKT9ykGlv/tVB4VtpGc+eOOcj2GdMzucJ4lDjW7TfvN6+yABw6qq9jT6CmvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310872; c=relaxed/simple;
	bh=XbmmVDndj7f9GUgu5NkcqhTk4vT+0zEbC3/9ML1U4UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d95XannoL216XL1uPvew6kYjSb49zTM/sQEaP6qYpLDZHvMZchUPiCao7ZLQVYdMeg3Bm9kKcSdf7FNG+YGyITNTJHJJEF975oH85DspEqhjpUEFf3Ri3f0TtDgstR+uuzJgp19F4P8g+qSUe7oYIqJ4ML00rEsA7UmrKllFpho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpCGmgoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpCGmgoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA00C2BCB7;
	Mon, 27 Apr 2026 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310871;
	bh=XbmmVDndj7f9GUgu5NkcqhTk4vT+0zEbC3/9ML1U4UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpCGmgoNHCD9+2D654qPkIqsQp27tyCDdWfinRvQQ/mA5BOwKvNtsplKboiSKqql8
	 9CkyilMGs7vXK6tVzIQd3//SMqrXT28+RqkEVICUG3RagcJQcPxUMG9C3qkSMVYhSq
	 6FGzjhaB9U9NnoqxBhwAh4oPDbvhui4JJVRTOFRzleQI8NaLhjvFhYq/VWHDr0cesm
	 zNNPCan3xC1/Ay69ktn7Zu+TVegkdiAZE0/hFvX23QlhGMBNtmhZXncY+x8Ji5m9QO
	 ig7UbM5G+BeYLaaY0fH+CgLb+QTVqEZD77eciEb/aIixdKOq0x4Ivf4mXEO8iAqR0G
	 bGWuGVKMdsaxA==
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
Subject: [PATCH net-next v2 4/5] net/tcp-ao: Return void from functions that can no longer fail
Date: Mon, 27 Apr 2026 10:27:26 -0700
Message-ID: <20260427172727.9310-5-ebiggers@kernel.org>
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

Since tcp-ao now uses the crypto library API instead of crypto_ahash,
and MACs and keys now have a statically-known maximum size, many tcp-ao
functions can no longer fail.  Propagate this change up into the return
types of various functions.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/net/tcp.h     |   8 +--
 include/net/tcp_ao.h  |  44 +++++++--------
 net/ipv4/tcp_ao.c     | 128 ++++++++++++++++++++++--------------------
 net/ipv4/tcp_output.c |  10 +---
 net/ipv6/tcp_ao.c     |  65 ++++++++++-----------
 5 files changed, 123 insertions(+), 132 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ecbadcb3a744..8817e7b8cc67 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2508,13 +2508,13 @@ struct tcp_sock_af_ops {
 #ifdef CONFIG_TCP_AO
 	int (*ao_parse)(struct sock *sk, int optname, sockptr_t optval, int optlen);
 	struct tcp_ao_key *(*ao_lookup)(const struct sock *sk,
 					struct sock *addr_sk,
 					int sndid, int rcvid);
-	int (*ao_calc_key_sk)(struct tcp_ao_key *mkt, u8 *key,
-			      const struct sock *sk,
-			      __be32 sisn, __be32 disn, bool send);
+	void (*ao_calc_key_sk)(struct tcp_ao_key *mkt, u8 *key,
+			       const struct sock *sk,
+			       __be32 sisn, __be32 disn, bool send);
 	int (*calc_ao_hash)(char *location, struct tcp_ao_key *ao,
 			    const struct sock *sk, const struct sk_buff *skb,
 			    const u8 *tkey, int hash_offset, u32 sne);
 #endif
 };
@@ -2531,11 +2531,11 @@ struct tcp_request_sock_ops {
 #endif
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_key *(*ao_lookup)(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid);
-	int (*ao_calc_key)(struct tcp_ao_key *mkt, u8 *key, struct request_sock *sk);
+	void (*ao_calc_key)(struct tcp_ao_key *mkt, u8 *key, struct request_sock *sk);
 	int (*ao_synack_hash)(char *ao_hash, struct tcp_ao_key *mkt,
 			      struct request_sock *req, const struct sk_buff *skb,
 			      int hash_offset, u32 sne);
 #endif
 #ifdef CONFIG_SYN_COOKIES
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 20997aef3b0d..29fd7b735afa 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -185,13 +185,13 @@ struct tcp6_ao_context {
 
 /* Established states are fast-path and there always is current_key/rnext_key */
 #define TCP_AO_ESTABLISHED (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | \
 			    TCPF_CLOSE_WAIT | TCPF_LAST_ACK | TCPF_CLOSING)
 
-int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
-			struct tcp_ao_key *key, struct tcphdr *th,
-			__u8 *hash_location);
+void tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
+			 struct tcp_ao_key *key, struct tcphdr *th,
+			 __u8 *hash_location);
 void tcp_ao_mac_update(struct tcp_ao_mac_ctx *mac_ctx, const void *data,
 		       size_t data_len);
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
@@ -236,32 +236,33 @@ int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid);
 int tcp_v4_ao_synack_hash(char *ao_hash, struct tcp_ao_key *mkt,
 			  struct request_sock *req, const struct sk_buff *skb,
 			  int hash_offset, u32 sne);
-int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
-			  const struct sock *sk,
-			  __be32 sisn, __be32 disn, bool send);
-int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
-			   struct request_sock *req);
+void tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sock *sk,
+			   __be32 sisn, __be32 disn, bool send);
+void tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			    struct request_sock *req);
 struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid);
 int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne);
 /* ipv6 specific functions */
-int tcp_v6_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
-				const struct in6_addr *daddr,
-				const struct in6_addr *saddr, int nbytes);
-int tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
-			   const struct sk_buff *skb, __be32 sisn, __be32 disn);
-int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
-			  const struct sock *sk, __be32 sisn,
-			  __be32 disn, bool send);
-int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
-			   struct request_sock *req);
+void tcp_v6_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
+				 const struct in6_addr *daddr,
+				 const struct in6_addr *saddr, int nbytes);
+void tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			    const struct sk_buff *skb, __be32 sisn,
+			    __be32 disn);
+void tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sock *sk, __be32 sisn,
+			   __be32 disn, bool send);
+void tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			    struct request_sock *req);
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk, int sndid, int rcvid);
 struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid);
@@ -277,15 +278,14 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
 void tcp_ao_connect_init(struct sock *sk);
 void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      struct request_sock *req, unsigned short int family);
 #else /* CONFIG_TCP_AO */
 
-static inline int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
-				      struct tcp_ao_key *key, struct tcphdr *th,
-				      __u8 *hash_location)
+static inline void tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
+				       struct tcp_ao_key *key,
+				       struct tcphdr *th, __u8 *hash_location)
 {
-	return 0;
 }
 
 static inline void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 				    struct request_sock *req, unsigned short int family)
 {
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 69f1d6d26562..36a64c1cd8c9 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -433,14 +433,14 @@ void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp)
 		tcptw->ao_info = NULL;
 	}
 }
 
 /* 4 tuple and ISNs are expected in NBO */
-static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
-			      __be32 saddr, __be32 daddr,
-			      __be16 sport, __be16 dport,
-			      __be32 sisn,  __be32 disn)
+static void tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
+			       __be32 saddr, __be32 daddr,
+			       __be16 sport, __be16 dport,
+			       __be32 sisn, __be32 disn)
 {
 	/* See RFC5926 3.1.1 */
 	struct kdf_input_block {
 		u8                      counter;
 		u8                      label[6];
@@ -459,91 +459,92 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
 		},
 		.outlen = htons(tcp_ao_digest_size(mkt) * 8), /* in bits */
 	};
 
 	tcp_ao_calc_traffic_key(mkt, key, &input, sizeof(input));
-	return 0;
 }
 
-int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
-			  const struct sock *sk,
-			  __be32 sisn, __be32 disn, bool send)
+void tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sock *sk,
+			   __be32 sisn, __be32 disn, bool send)
 {
 	if (send)
-		return tcp_v4_ao_calc_key(mkt, key, sk->sk_rcv_saddr,
-					  sk->sk_daddr, htons(sk->sk_num),
-					  sk->sk_dport, sisn, disn);
+		tcp_v4_ao_calc_key(mkt, key, sk->sk_rcv_saddr, sk->sk_daddr,
+				   htons(sk->sk_num), sk->sk_dport, sisn, disn);
 	else
-		return tcp_v4_ao_calc_key(mkt, key, sk->sk_daddr,
-					  sk->sk_rcv_saddr, sk->sk_dport,
-					  htons(sk->sk_num), disn, sisn);
+		tcp_v4_ao_calc_key(mkt, key, sk->sk_daddr, sk->sk_rcv_saddr,
+				   sk->sk_dport, htons(sk->sk_num), disn, sisn);
 }
 
 static int tcp_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			      const struct sock *sk,
 			      __be32 sisn, __be32 disn, bool send)
 {
-	if (mkt->family == AF_INET)
-		return tcp_v4_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
+	if (mkt->family == AF_INET) {
+		tcp_v4_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
+		return 0;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
-	else if (mkt->family == AF_INET6)
-		return tcp_v6_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
+	if (mkt->family == AF_INET6) {
+		tcp_v6_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
+		return 0;
+	}
 #endif
-	else
-		return -EOPNOTSUPP;
+	return -EOPNOTSUPP;
 }
 
-int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
-			   struct request_sock *req)
+void tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			    struct request_sock *req)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 
-	return tcp_v4_ao_calc_key(mkt, key,
-				  ireq->ir_loc_addr, ireq->ir_rmt_addr,
-				  htons(ireq->ir_num), ireq->ir_rmt_port,
-				  htonl(tcp_rsk(req)->snt_isn),
-				  htonl(tcp_rsk(req)->rcv_isn));
+	tcp_v4_ao_calc_key(mkt, key, ireq->ir_loc_addr, ireq->ir_rmt_addr,
+			   htons(ireq->ir_num), ireq->ir_rmt_port,
+			   htonl(tcp_rsk(req)->snt_isn),
+			   htonl(tcp_rsk(req)->rcv_isn));
 }
 
-static int tcp_v4_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
-				  const struct sk_buff *skb,
-				  __be32 sisn, __be32 disn)
+static void tcp_v4_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+				   const struct sk_buff *skb,
+				   __be32 sisn, __be32 disn)
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	const struct tcphdr *th = tcp_hdr(skb);
 
-	return tcp_v4_ao_calc_key(mkt, key, iph->saddr, iph->daddr,
-				  th->source, th->dest, sisn, disn);
+	tcp_v4_ao_calc_key(mkt, key, iph->saddr, iph->daddr, th->source,
+			   th->dest, sisn, disn);
 }
 
 static int tcp_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
 			       const struct sk_buff *skb,
 			       __be32 sisn, __be32 disn, int family)
 {
-	if (family == AF_INET)
-		return tcp_v4_ao_calc_key_skb(mkt, key, skb, sisn, disn);
+	if (family == AF_INET) {
+		tcp_v4_ao_calc_key_skb(mkt, key, skb, sisn, disn);
+		return 0;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
-	else if (family == AF_INET6)
-		return tcp_v6_ao_calc_key_skb(mkt, key, skb, sisn, disn);
+	if (family == AF_INET6) {
+		tcp_v6_ao_calc_key_skb(mkt, key, skb, sisn, disn);
+		return 0;
+	}
 #endif
 	return -EAFNOSUPPORT;
 }
 
-static int tcp_v4_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
-				       __be32 daddr, __be32 saddr,
-				       int nbytes)
+static void tcp_v4_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
+					__be32 daddr, __be32 saddr, int nbytes)
 {
 	struct tcp4_pseudohdr phdr = {
 		.saddr = saddr,
 		.daddr = daddr,
 		.pad = 0,
 		.protocol = IPPROTO_TCP,
 		.len = cpu_to_be16(nbytes),
 	};
 
 	tcp_ao_mac_update(mac_ctx, &phdr, sizeof(phdr));
-	return 0;
 }
 
 static int tcp_ao_hash_pseudoheader(unsigned short int family,
 				    const struct sock *sk,
 				    const struct sk_buff *skb,
@@ -551,35 +552,42 @@ static int tcp_ao_hash_pseudoheader(unsigned short int family,
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	/* TODO: Can we rely on checksum being zero to mean outbound pkt? */
 	if (!th->check) {
-		if (family == AF_INET)
-			return tcp_v4_ao_hash_pseudoheader(mac_ctx, sk->sk_daddr,
-					sk->sk_rcv_saddr, skb->len);
+		if (family == AF_INET) {
+			tcp_v4_ao_hash_pseudoheader(mac_ctx, sk->sk_daddr,
+						    sk->sk_rcv_saddr, skb->len);
+			return 0;
+		}
 #if IS_ENABLED(CONFIG_IPV6)
-		else if (family == AF_INET6)
-			return tcp_v6_ao_hash_pseudoheader(mac_ctx, &sk->sk_v6_daddr,
-					&sk->sk_v6_rcv_saddr, skb->len);
+		if (family == AF_INET6) {
+			tcp_v6_ao_hash_pseudoheader(mac_ctx, &sk->sk_v6_daddr,
+						    &sk->sk_v6_rcv_saddr,
+						    skb->len);
+			return 0;
+		}
 #endif
-		else
-			return -EAFNOSUPPORT;
+		return -EAFNOSUPPORT;
 	}
 
 	if (family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(skb);
 
-		return tcp_v4_ao_hash_pseudoheader(mac_ctx, iph->daddr,
-				iph->saddr, skb->len);
+		tcp_v4_ao_hash_pseudoheader(mac_ctx, iph->daddr, iph->saddr,
+					    skb->len);
+		return 0;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
-	} else if (family == AF_INET6) {
+	if (family == AF_INET6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 
-		return tcp_v6_ao_hash_pseudoheader(mac_ctx, &iph->daddr,
-				&iph->saddr, skb->len);
-#endif
+		tcp_v6_ao_hash_pseudoheader(mac_ctx, &iph->daddr, &iph->saddr,
+					    skb->len);
+		return 0;
 	}
+#endif
 	return -EAFNOSUPPORT;
 }
 
 u32 tcp_ao_compute_sne(u32 next_sne, u32 next_seq, u32 seq)
 {
@@ -738,15 +746,12 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 int tcp_v4_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
 			  struct request_sock *req, const struct sk_buff *skb,
 			  int hash_offset, u32 sne)
 {
 	u8 tkey_buf[TCP_AO_MAX_TRAFFIC_KEY_LEN];
-	int err;
 
-	err = tcp_v4_ao_calc_key_rsk(ao_key, tkey_buf, req);
-	if (err)
-		return err;
+	tcp_v4_ao_calc_key_rsk(ao_key, tkey_buf, req);
 
 	return tcp_ao_hash_skb(AF_INET, ao_hash, ao_key, req_to_sk(req), skb,
 			       tkey_buf, hash_offset, sne);
 }
 
@@ -855,13 +860,13 @@ int tcp_ao_prepare_reset(const struct sock *sk, struct sk_buff *skb,
 					  snd_basis, seq);
 	}
 	return 0;
 }
 
-int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
-			struct tcp_ao_key *key, struct tcphdr *th,
-			__u8 *hash_location)
+void tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
+			 struct tcp_ao_key *key, struct tcphdr *th,
+			 __u8 *hash_location)
 {
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
 	u8 tkey_buf[TCP_AO_MAX_TRAFFIC_KEY_LEN];
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_ao_info *ao;
@@ -885,11 +890,10 @@ int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	}
 	sne = tcp_ao_compute_sne(READ_ONCE(ao->snd_sne), READ_ONCE(tp->snd_una),
 				 ntohl(th->seq));
 	tp->af_specific->calc_ao_hash(hash_location, key, sk, skb, traffic_key,
 				      hash_location - (u8 *)th, sne);
-	return 0;
 }
 
 static struct tcp_ao_key *tcp_ao_inbound_lookup(unsigned short int family,
 		const struct sock *sk, const struct sk_buff *skb,
 		int sndid, int rcvid, int l3index)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f9d8755705f7..2671355661e4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1661,18 +1661,12 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		sk_gso_disable(sk);
 		tp->af_specific->calc_md5_hash(opts.hash_location,
 					       key.md5_key, sk, skb);
 #endif
 	} else if (tcp_key_is_ao(&key)) {
-		int err;
-
-		err = tcp_ao_transmit_skb(sk, skb, key.ao_key, th,
-					  opts.hash_location);
-		if (err) {
-			sk_skb_reason_drop(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
-			return -ENOMEM;
-		}
+		tcp_ao_transmit_skb(sk, skb, key.ao_key, th,
+				    opts.hash_location);
 	}
 
 	/* BPF prog is the last one writing header option */
 	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index bf30b970181d..01a8472805d1 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -10,15 +10,15 @@
 #include <linux/tcp.h>
 
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
-static int tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
-			      const struct in6_addr *saddr,
-			      const struct in6_addr *daddr,
-			      __be16 sport, __be16 dport,
-			      __be32 sisn, __be32 disn)
+static void tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
+			       const struct in6_addr *saddr,
+			       const struct in6_addr *daddr,
+			       __be16 sport, __be16 dport,
+			       __be32 sisn, __be32 disn)
 {
 	struct kdf_input_block {
 		u8			counter;
 		u8			label[6];
 		struct tcp6_ao_context	ctx;
@@ -36,49 +36,46 @@ static int tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
 		},
 		.outlen = htons(tcp_ao_digest_size(mkt) * 8), /* in bits */
 	};
 
 	tcp_ao_calc_traffic_key(mkt, key, &input, sizeof(input));
-	return 0;
 }
 
-int tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
-			   const struct sk_buff *skb,
-			   __be32 sisn, __be32 disn)
+void tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			    const struct sk_buff *skb, __be32 sisn, __be32 disn)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	const struct tcphdr *th = tcp_hdr(skb);
 
-	return tcp_v6_ao_calc_key(mkt, key, &iph->saddr,
-				  &iph->daddr, th->source,
-				  th->dest, sisn, disn);
+	tcp_v6_ao_calc_key(mkt, key, &iph->saddr, &iph->daddr, th->source,
+			   th->dest, sisn, disn);
 }
 
-int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
-			  const struct sock *sk, __be32 sisn,
-			  __be32 disn, bool send)
+void tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sock *sk, __be32 sisn,
+			   __be32 disn, bool send)
 {
 	if (send)
-		return tcp_v6_ao_calc_key(mkt, key, &sk->sk_v6_rcv_saddr,
-					  &sk->sk_v6_daddr, htons(sk->sk_num),
-					  sk->sk_dport, sisn, disn);
+		tcp_v6_ao_calc_key(mkt, key, &sk->sk_v6_rcv_saddr,
+				   &sk->sk_v6_daddr, htons(sk->sk_num),
+				   sk->sk_dport, sisn, disn);
 	else
-		return tcp_v6_ao_calc_key(mkt, key, &sk->sk_v6_daddr,
-					  &sk->sk_v6_rcv_saddr, sk->sk_dport,
-					  htons(sk->sk_num), disn, sisn);
+		tcp_v6_ao_calc_key(mkt, key, &sk->sk_v6_daddr,
+				   &sk->sk_v6_rcv_saddr, sk->sk_dport,
+				   htons(sk->sk_num), disn, sisn);
 }
 
-int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
-			   struct request_sock *req)
+void tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			    struct request_sock *req)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 
-	return tcp_v6_ao_calc_key(mkt, key,
-			&ireq->ir_v6_loc_addr, &ireq->ir_v6_rmt_addr,
-			htons(ireq->ir_num), ireq->ir_rmt_port,
-			htonl(tcp_rsk(req)->snt_isn),
-			htonl(tcp_rsk(req)->rcv_isn));
+	tcp_v6_ao_calc_key(mkt, key,
+			   &ireq->ir_v6_loc_addr, &ireq->ir_v6_rmt_addr,
+			   htons(ireq->ir_num), ireq->ir_rmt_port,
+			   htonl(tcp_rsk(req)->snt_isn),
+			   htonl(tcp_rsk(req)->rcv_isn));
 }
 
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid)
@@ -102,24 +99,23 @@ struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
 	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 	return tcp_ao_do_lookup(sk, l3index, (union tcp_ao_addr *)addr,
 				AF_INET6, sndid, rcvid);
 }
 
-int tcp_v6_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
-				const struct in6_addr *daddr,
-				const struct in6_addr *saddr, int nbytes)
+void tcp_v6_ao_hash_pseudoheader(struct tcp_ao_mac_ctx *mac_ctx,
+				 const struct in6_addr *daddr,
+				 const struct in6_addr *saddr, int nbytes)
 {
 	/* 1. TCP pseudo-header (RFC2460) */
 	struct tcp6_pseudohdr phdr = {
 		.saddr = *saddr,
 		.daddr = *daddr,
 		.len = cpu_to_be32(nbytes),
 		.protocol = cpu_to_be32(IPPROTO_TCP),
 	};
 
 	tcp_ao_mac_update(mac_ctx, &phdr, sizeof(phdr));
-	return 0;
 }
 
 int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne)
@@ -137,14 +133,11 @@ int tcp_v6_parse_ao(struct sock *sk, int cmd,
 int tcp_v6_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
 			  struct request_sock *req, const struct sk_buff *skb,
 			  int hash_offset, u32 sne)
 {
 	u8 tkey_buf[TCP_AO_MAX_TRAFFIC_KEY_LEN];
-	int err;
 
-	err = tcp_v6_ao_calc_key_rsk(ao_key, tkey_buf, req);
-	if (err)
-		return err;
+	tcp_v6_ao_calc_key_rsk(ao_key, tkey_buf, req);
 
 	return tcp_ao_hash_skb(AF_INET6, ao_hash, ao_key, req_to_sk(req), skb,
 			       tkey_buf, hash_offset, sne);
 }
-- 
2.54.0

