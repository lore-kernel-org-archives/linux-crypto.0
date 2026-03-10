Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C723E9580;
	Tue, 10 Mar 2026 20:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173828; cv=none; b=hy9J2shTDzwprH33pGp54IUIlBGlLssp6BoThm4IkY6MYkHIZduOHg4QaPs3AgIKvqxysC8PnVuWvtL0tTxmrNRrTjbQKungiHtpdlXQCC4409kDZQVXbP+BerGlIV9WRwLy9+xJAJiulclV4F8EFzG7hV+rKgyU6abTia8auxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173828; c=relaxed/simple;
	bh=HP/aRJrj4OXmn7uTB6kAMSFHhhaPUWj6nnwMfzC5T1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rFzoPiXgFlxJ+snesgHUIhfCwPOj8IlERwQOnKk3LMI9m1QJ01I+cT+2lvh+4u+qRJ/p50R/J14FJ1/neGK5Pnl4UCOQzldvzvarulHTTlQBSAA7rUDpf9jUIziTR4HUpfQ6kwxvSx4YdZtU5OrojD1uOgwMeZKns5CkaDVt7kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtSAQUdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtSAQUdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F45C19423;
	Tue, 10 Mar 2026 20:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773173828;
	bh=HP/aRJrj4OXmn7uTB6kAMSFHhhaPUWj6nnwMfzC5T1c=;
	h=From:To:Cc:Subject:Date:From;
	b=CtSAQUdAsmTzVWBT/O3Hz6sFKQ43RrFTmpm87I9jV4p5nbwedMMxO45wuiY5I561d
	 Th7R6Fn37F6+esqBudBL/jSLxRI21iE0lzIkxg4uNYCzRfTcBkH/co+xOxY2fC3iFi
	 lA+27Pi1EMueklWJOEljIJofSbiP7eSOtXr+C/ErITK6MudGr/iQa9O48Sj7NlrEpW
	 pC4t6UBx/jvmdJHBRw+ZCQUn8VCah6iqFH+FHGYxKZ8umZHuv3PlTaElKT14610Avu
	 13mlccMzD4o9y8O3S5N3DuEvj1r4BIr5w1J0pbYVciWQZuL6nNk+9i2Kg7+otS6lVI
	 f69qYk3GJjiWg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Tue, 10 Mar 2026 13:17:06 -0700
Message-ID: <20260310201706.120064-1-ebiggers@kernel.org>
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
index 43415de60d7f0..7e4a9090abd70 100644
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
 
@@ -761,11 +762,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (!key)
 			goto out;
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(hash_location, newhash, 16))
 			goto out;
 
 	}
 
 	if (key) {
@@ -1465,11 +1466,11 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
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
index e1ca8b73ec08c..e972bbb754189 100644
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
@@ -1086,11 +1087,11 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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

base-commit: 91d48252ad4b17577cf8cc8d3e1353402e4da8f1
-- 
2.53.0

