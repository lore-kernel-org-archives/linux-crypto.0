Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F179359714;
	Tue, 10 Mar 2026 20:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173821; cv=none; b=rVObPpLkxuj1CsiobDJtUulxspNYyTAPPD4ZNZqkC5r8PTn8RbdlCQm3oLLGPsOaHAfUzIX0am4DaLI5tEvjtgoxsCDhYKiN+ClU9N20K19h1KtaaeggEA927OST5DpUSU9oBXMdDpynww+MVdk9tJBwlX8pYy1fVPZAwbn2Xu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173821; c=relaxed/simple;
	bh=JOGMuDIw9U165/TpOnYOC4ieHfusL328CtWW2a23Dqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OeBntxSkGTbHHgbodhXthKfH+mdbb9XnuZgXJckcYq7xOKt9k+HNh109nhsbgBdu8NdeZGelYBnl1acXY5qg25TtMUaeM20dvdpu1JxoS/sFrjIpwGhk3rGFkmIIBVRgy1Lroj7U0nPyRFKq5FTmm/4kcvhFJpVPNqBEMjZ8s20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/y33qxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/y33qxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BE9C2BCB9;
	Tue, 10 Mar 2026 20:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773173820;
	bh=JOGMuDIw9U165/TpOnYOC4ieHfusL328CtWW2a23Dqk=;
	h=From:To:Cc:Subject:Date:From;
	b=t/y33qxFn5pqAQYNmcC5u9qPdhjLGqAfZj6Qr9Wb7fL4LcUyTjPpl7LTTksWtmfqG
	 N7oWCJBlrUzL5jp7354N79w6/hfOjsZfuRuVHGsUSkmvMghjFkX3JXLBeQ7/6cqpl/
	 T3qz1vtXUbv64PCGv9YFFloCxo/7hiss2fiTgGMBHo0cqv1VTTjxS6gt7Ralby8xmN
	 yTAgjXaQN5RwASuV0JRAvETn1MEmjpJnaGpG+DL71wg5UNAA0BfBe1zUiaBURem0kZ
	 b3ljuYkZ/qPcqxI84GYv0EPZIZBUyx9vFm/733LTUUjjY+CA9sqdqxvf3D2qujbS6z
	 q2MBCQWqGXofw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Tue, 10 Mar 2026 13:16:57 -0700
Message-ID: <20260310201657.119992-1-ebiggers@kernel.org>
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
 net/ipv4/tcp.c      | 3 ++-
 net/ipv4/tcp_ipv4.c | 3 ++-
 net/ipv6/tcp_ipv6.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4090107b0c4d5..c532803b9957b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -242,10 +242,11 @@
  */
 
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/poll.h>
@@ -4781,11 +4782,11 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	if (family == AF_INET)
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 	else
 		genhash = tp->af_specific->calc_md5_hash(newhash, key,
 							 NULL, skb);
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+	if (genhash || crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		trace_tcp_hash_md5_mismatch(sk, skb);
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
 	return SKB_NOT_DROPPED_YET;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1572562b0498c..6e896f1641afb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -80,10 +80,11 @@
 #include <linux/inetdevice.h>
 #include <linux/btf_ids.h>
 #include <linux/skbuff_ref.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -837,11 +838,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb,
 		if (!key)
 			goto out;
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 
 	}
 
 	if (key) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c90b20c218bff..a79cd20d3d31c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -64,10 +64,11 @@
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
 
 static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
@@ -1082,11 +1083,11 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 		if (!key.md5_key)
 			goto out;
 		key.type = TCP_KEY_MD5;
 
 		genhash = tcp_v6_md5_hash_skb(newhash, key.md5_key, NULL, skb);
-		if (genhash || memcmp(md5_hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 	}
 #endif
 
 	if (th->ack)

base-commit: 39b686f8d57d7506af7789e915fe7fd103b0fe57
-- 
2.53.0

