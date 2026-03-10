Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8B3E92B0;
	Tue, 10 Mar 2026 20:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173831; cv=none; b=FdohHFYRPTsMIkck1hO6tZKK5qIUqG8EO+zyqarrll+U0QHR+7maitLlBruSPoY37bfyn01RRP8I1c+YUOYuNn20Fbw/IcqlfWhNYQN5vuJHbsmeXFw3AL9sDxq/BGv/G9e1b+34TX+iLdMs1KNOMdzuvV5voUU4fHa8lc024Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173831; c=relaxed/simple;
	bh=foU1OAkBdvYLo564dfsPQ/XRQ9g0KRuxk4aQottRw6w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CxVEydc81fcp3J/cvoGwAj6mPG97tOzvFoDGFQbHZq7CgZ0/BRO3pl5LsgyTteAGckfWxk+viFntqNAdH7oGc03i4j0MkMwkLdQMXXCl5w4yDOmCbODL9hhZ9kURf+yp1YRoUE68+sVHw8TjbV2ax0xdFt3emhESQezGfjC3wBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGzsBDFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGzsBDFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15746C19423;
	Tue, 10 Mar 2026 20:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773173831;
	bh=foU1OAkBdvYLo564dfsPQ/XRQ9g0KRuxk4aQottRw6w=;
	h=From:To:Cc:Subject:Date:From;
	b=DGzsBDFN4oxaDlyrmS739aPfmcC41gN02+eCZSyIR5ctQxAp4q80tTWUx2ol57lDI
	 eNmJQW+2aEU4CLDFoboqPjojq/fEl0s2COJdapHG+usU95U5cJf7ofpLkwxZu6JIto
	 Dgcci3/bYLPSr+66hpGZ5Ps0EI6cWK76o+ifmQ6T40JSyf+f65p4vCbVHfopT9tGeI
	 9m/j0utMGGrLBvj2kPy925+UZdCOZcWbsGwG048GeuDPOCutz+LAopvf1xX8s0CFYl
	 95TERHODXpemUVYc4tHJrA6sOX2RLFzpzziEWm6RnHzhiox4h2kyj14RxnPsYzGfI9
	 rV0ny42Wlxk6g==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Tue, 10 Mar 2026 13:17:08 -0700
Message-ID: <20260310201708.120088-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 46d0d6f50dab706637f4c18a470aac20a21900d3 upstream.

To prevent timing attacks, MACs need to be compared in constant
time.  Use the appropriate helper function for this.

Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
Fixes: 658ddaaf6694 ("tcp: md5: RST: getting md5 key from listener")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/20260302203409.13388-1-ebiggers@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 5 +++--
 net/ipv6/tcp_ipv6.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3dfa856e99267..855cca214a021 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -76,10 +76,11 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/inetdevice.h>
 #include <linux/btf_ids.h>
 
+#include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
 
@@ -762,11 +763,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (!key)
 			goto out;
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(hash_location, newhash, 16))
 			goto out;
 
 	}
 
 	if (key) {
@@ -1449,11 +1450,11 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 	 */
 	genhash = tcp_v4_md5_hash_skb(newhash,
 				      hash_expected,
 				      NULL, skb);
 
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+	if (genhash || crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
 				     &iph->saddr, ntohs(th->source),
 				     &iph->daddr, ntohs(th->dest),
 				     genhash ? " tcp_v4_calc_md5_hash failed"
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8b9709420c052..523aa2efdc499 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -61,10 +61,11 @@
 #include <net/busy_poll.h>
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
+#include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
 
@@ -808,11 +809,11 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 	/* check the signature */
 	genhash = tcp_v6_md5_hash_skb(newhash,
 				      hash_expected,
 				      NULL, skb);
 
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+	if (genhash || crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
 				     genhash ? "failed" : "mismatch",
 				     &ip6h->saddr, ntohs(th->source),
 				     &ip6h->daddr, ntohs(th->dest), l3index);
@@ -1069,11 +1070,11 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		key = tcp_v6_md5_do_lookup(sk1, &ipv6h->saddr, l3index);
 		if (!key)
 			goto out;
 
 		genhash = tcp_v6_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(hash_location, newhash, 16))
 			goto out;
 	}
 #endif
 
 	if (th->ack)

base-commit: aed5c3b77cd53ba74f66767b03bfb9177662af4b
-- 
2.53.0

