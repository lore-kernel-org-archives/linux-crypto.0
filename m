Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204B23E5595;
	Mon, 27 Apr 2026 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310871; cv=none; b=d92S4EBVO1HxcyN9hYRZeZT4ZpcN0AETgN6J1Y/cygIdCk5XPf4YAxTdKs0XM3JOWIzLEbbuBi+ZwtoMJeQ0s0C6KhixpL8izyO/FV6eTo1bATMPFS/5hEzr4iwYmIKVPkIPE1ox95DCdon/FwGwp3LRnI0R3cdLuSKy98uYXvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310871; c=relaxed/simple;
	bh=f1dObrzVPHjwrICq9Ja3ww+bzW7BqBVt8TxP6y5S4Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJv9OmN5srS0REfELviZt19Nbl/tkBtgt8fANd86yU+9GaoWXO1pqCWGHW6TiqrHvx21oZQiY+d/d1K5sR3f/J0OWRZpAkPeWfaPRqc/kySoqA4ZsRDkxuh3qwDxdI/AnkXC7xd73cSV0g3RHGz8Wc0e0DMV5scy2ACctRDRib4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqftUBkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqftUBkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D55C19425;
	Mon, 27 Apr 2026 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310870;
	bh=f1dObrzVPHjwrICq9Ja3ww+bzW7BqBVt8TxP6y5S4Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqftUBkVtdCkwYfcbHp+0b1O1Vqy1GRJRpWXCaxpq7PoiURwo4wf3utGXjWZW2es/
	 hxVbusk4Ns7zCunR2KsaXzCjBTOgpbax8AtoIzB2f1mOG0E+QoBY7s/QCfr5n0DVgb
	 zBS4bxRFycEIiIxRJcTmmYJmNKpPY/l1UkQiiY+StIVy+Oyz4z79DpfMvNraRRxOAE
	 usEyeN9VSaG+HppnNE3GS0cWYZnelpCnbCBFqK7j5E3oTe8i7Wi/4PHYPjg9K9ccKe
	 WnBz8zdrUfhsbwUoAEOa9dniUIobqOrtG5ZfcEPVTPVzI1K9rqsn+4x7lsn/t9O/F3
	 UOfbabue8sjPw==
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
Subject: [PATCH net-next v2 3/5] net/tcp-ao: Use stack-allocated MAC and traffic_key buffers
Date: Mon, 27 Apr 2026 10:27:25 -0700
Message-ID: <20260427172727.9310-4-ebiggers@kernel.org>
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

Now that the maximum MAC and traffic key lengths are statically-known
small values, allocate MACs and traffic keys on the stack instead of
with kmalloc.  This eliminates multiple failure-prone GFP_ATOMIC
allocations.

Note that some cases such as tcp_ao_prepare_reset() are left unchanged
for now since they would require slightly wider changes.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/ipv4/tcp_ao.c | 44 +++++++++++---------------------------------
 net/ipv6/tcp_ao.c | 17 +++++------------
 2 files changed, 16 insertions(+), 45 deletions(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 0d24cbd66c9a..69f1d6d26562 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -737,26 +737,19 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 
 int tcp_v4_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
 			  struct request_sock *req, const struct sk_buff *skb,
 			  int hash_offset, u32 sne)
 {
-	void *hash_buf = NULL;
+	u8 tkey_buf[TCP_AO_MAX_TRAFFIC_KEY_LEN];
 	int err;
 
-	hash_buf = kmalloc(tcp_ao_digest_size(ao_key), GFP_ATOMIC);
-	if (!hash_buf)
-		return -ENOMEM;
-
-	err = tcp_v4_ao_calc_key_rsk(ao_key, hash_buf, req);
+	err = tcp_v4_ao_calc_key_rsk(ao_key, tkey_buf, req);
 	if (err)
-		goto out;
+		return err;
 
-	err = tcp_ao_hash_skb(AF_INET, ao_hash, ao_key, req_to_sk(req), skb,
-			      hash_buf, hash_offset, sne);
-out:
-	kfree(hash_buf);
-	return err;
+	return tcp_ao_hash_skb(AF_INET, ao_hash, ao_key, req_to_sk(req), skb,
+			       tkey_buf, hash_offset, sne);
 }
 
 struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid)
@@ -867,13 +860,13 @@ int tcp_ao_prepare_reset(const struct sock *sk, struct sk_buff *skb,
 int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
 			struct tcp_ao_key *key, struct tcphdr *th,
 			__u8 *hash_location)
 {
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
+	u8 tkey_buf[TCP_AO_MAX_TRAFFIC_KEY_LEN];
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_ao_info *ao;
-	void *tkey_buf = NULL;
 	u8 *traffic_key;
 	u32 sne;
 
 	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info,
 				       lockdep_sock_is_held(sk));
@@ -881,13 +874,10 @@ int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
 		__be32 disn;
 
 		if (!(tcb->tcp_flags & TCPHDR_ACK)) {
 			disn = 0;
-			tkey_buf = kmalloc(tcp_ao_digest_size(key), GFP_ATOMIC);
-			if (!tkey_buf)
-				return -ENOMEM;
 			traffic_key = tkey_buf;
 		} else {
 			disn = ao->risn;
 		}
 		tp->af_specific->ao_calc_key_sk(key, traffic_key,
@@ -895,11 +885,10 @@ int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	}
 	sne = tcp_ao_compute_sne(READ_ONCE(ao->snd_sne), READ_ONCE(tp->snd_una),
 				 ntohl(th->seq));
 	tp->af_specific->calc_ao_hash(hash_location, key, sk, skb, traffic_key,
 				      hash_location - (u8 *)th, sne);
-	kfree(tkey_buf);
 	return 0;
 }
 
 static struct tcp_ao_key *tcp_ao_inbound_lookup(unsigned short int family,
 		const struct sock *sk, const struct sk_buff *skb,
@@ -961,54 +950,48 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		   const struct tcp_ao_hdr *aoh, struct tcp_ao_key *key,
 		   u8 *traffic_key, u8 *phash, u32 sne, int l3index)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	u8 maclen = tcp_ao_hdr_maclen(aoh);
-	void *hash_buf = NULL;
+	u8 hash_buf[TCP_AO_MAX_MAC_LEN];
 
 	if (maclen != tcp_ao_maclen(key)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
 		trace_tcp_ao_wrong_maclen(sk, skb, aoh->keyid,
 					  aoh->rnext_keyid, maclen);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 
-	hash_buf = kmalloc(tcp_ao_digest_size(key), GFP_ATOMIC);
-	if (!hash_buf)
-		return SKB_DROP_REASON_NOT_SPECIFIED;
-
 	/* XXX: make it per-AF callback? */
 	tcp_ao_hash_skb(family, hash_buf, key, sk, skb, traffic_key,
 			(phash - (u8 *)th), sne);
 	if (crypto_memneq(phash, hash_buf, maclen)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
 		trace_tcp_ao_mismatch(sk, skb, aoh->keyid,
 				      aoh->rnext_keyid, maclen);
-		kfree(hash_buf);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOGOOD);
 	atomic64_inc(&info->counters.pkt_good);
 	atomic64_inc(&key->pkt_good);
-	kfree(hash_buf);
 	return SKB_NOT_DROPPED_YET;
 }
 
 enum skb_drop_reason
 tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 		    unsigned short int family, const struct request_sock *req,
 		    int l3index, const struct tcp_ao_hdr *aoh)
 {
+	u8 tkey_buf[TCP_AO_MAX_TRAFFIC_KEY_LEN];
 	const struct tcphdr *th = tcp_hdr(skb);
 	u8 maclen = tcp_ao_hdr_maclen(aoh);
 	u8 *phash = (u8 *)(aoh + 1); /* hash goes just after the header */
 	struct tcp_ao_info *info;
-	enum skb_drop_reason ret;
 	struct tcp_ao_key *key;
 	__be32 sisn, disn;
 	u8 *traffic_key;
 	int state;
 	u32 sne = 0;
@@ -1112,18 +1095,13 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	} else {
 		WARN_ONCE(1, "TCP-AO: Unexpected sk_state %d", state);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 verify_hash:
-	traffic_key = kmalloc(tcp_ao_digest_size(key), GFP_ATOMIC);
-	if (!traffic_key)
-		return SKB_DROP_REASON_NOT_SPECIFIED;
-	tcp_ao_calc_key_skb(key, traffic_key, skb, sisn, disn, family);
-	ret = tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
-				 traffic_key, phash, sne, l3index);
-	kfree(traffic_key);
-	return ret;
+	tcp_ao_calc_key_skb(key, tkey_buf, skb, sisn, disn, family);
+	return tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
+				  tkey_buf, phash, sne, l3index);
 
 key_not_found:
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 	atomic64_inc(&info->counters.key_not_found);
 	trace_tcp_ao_key_not_found(sk, skb, aoh->keyid,
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 2dcfe9dda7f4..bf30b970181d 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -136,22 +136,15 @@ int tcp_v6_parse_ao(struct sock *sk, int cmd,
 
 int tcp_v6_ao_synack_hash(char *ao_hash, struct tcp_ao_key *ao_key,
 			  struct request_sock *req, const struct sk_buff *skb,
 			  int hash_offset, u32 sne)
 {
-	void *hash_buf = NULL;
+	u8 tkey_buf[TCP_AO_MAX_TRAFFIC_KEY_LEN];
 	int err;
 
-	hash_buf = kmalloc(tcp_ao_digest_size(ao_key), GFP_ATOMIC);
-	if (!hash_buf)
-		return -ENOMEM;
-
-	err = tcp_v6_ao_calc_key_rsk(ao_key, hash_buf, req);
+	err = tcp_v6_ao_calc_key_rsk(ao_key, tkey_buf, req);
 	if (err)
-		goto out;
+		return err;
 
-	err = tcp_ao_hash_skb(AF_INET6, ao_hash, ao_key, req_to_sk(req), skb,
-			      hash_buf, hash_offset, sne);
-out:
-	kfree(hash_buf);
-	return err;
+	return tcp_ao_hash_skb(AF_INET6, ao_hash, ao_key, req_to_sk(req), skb,
+			       tkey_buf, hash_offset, sne);
 }
-- 
2.54.0

