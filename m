Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007B439150F;
	Mon,  2 Mar 2026 20:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483748; cv=none; b=kHjXV5IWF53vBLpEIkizlxs7yOhGH2eMDY8oXZyeyWdR4S+08oteEEHrHr3lGsG/d5nYURqJ0kDXP7wv2LObXAujX77Cx9MDJq5keEeZE3EzaU63o0HZSXZVhgLSx10rAmYCLO9mdpkP1XLWDG7XavWKaAjzniswVCaaocuNits=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483748; c=relaxed/simple;
	bh=S5U+nwWUo/YnHQ0SZdVhUDJM12nU0GQ5riZpJ10XbZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mFyzMOZijhrAQQ4S3R5L5ZzwltBU8U/An1nwZdp01454Wcvs6lt4LoYh/YK19bHqFBK+1Z/4kY+gteOvAAnLqmcX7DRItuZEqiY+ZPgH1hH2synk7w1W9VEHgcVsDrcshOM0AjcqaCW9lg50bnmTJnEFPO4Q9XmNcRFYOnAkbK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p7H+cHSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7H+cHSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5390AC19423;
	Mon,  2 Mar 2026 20:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483747;
	bh=S5U+nwWUo/YnHQ0SZdVhUDJM12nU0GQ5riZpJ10XbZc=;
	h=From:To:Cc:Subject:Date:From;
	b=p7H+cHSVsjHeIxOS0kYtWolV9OZyHx4WpNP8CseckZ6OI1zW/CM6vJN12OuSxt42v
	 cqbyNQayItg/RWluGatL/h7gkrQcbHua7vvMdFlhr+tqA7v/TDoWxTTNLYS3bqmB3C
	 Mkmt5aVQCtZNeuI7LMY/AoGKni78sQe57NTF4I3QEYjUOgWCBwL7Jv9wRzz3mVyHE9
	 +8Fwi7JOeLbEtUj0IxR7stizRXol+axM6Idxw8mZIwYd9tV4BzgWO44HHeThLDJX/9
	 XxDYAsKd9wV4KXEOHnUFek7etut8gykh55Vgf0XfggjMq/vMQu5xreqHWQJSXyEjYp
	 1H/jYqbWwhcYg==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH net] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Mon,  2 Mar 2026 12:34:09 -0800
Message-ID: <20260302203409.13388-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent timing attacks, MACs need to be compared in constant
time.  Use the appropriate helper function for this.

Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
Fixes: 658ddaaf6694 ("tcp: md5: RST: getting md5 key from listener")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/ipv4/Kconfig    | 1 +
 net/ipv4/tcp.c      | 3 ++-
 net/ipv4/tcp_ipv4.c | 3 ++-
 net/ipv6/tcp_ipv6.c | 3 ++-
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index b71c22475c515..45f5d401460c5 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -759,10 +759,11 @@ config TCP_AO
 	  If unsure, say N.
 
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO_LIB_MD5
+	select CRYPTO_LIB_UTILS
 	help
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
 	  on the Internet.
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8cdc26e8ad689..202a4e57a2188 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -242,10 +242,11 @@
  */
 
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/md5.h>
+#include <crypto/utils.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/poll.h>
@@ -4968,11 +4969,11 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 */
 	if (family == AF_INET)
 		tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 	else
 		tp->af_specific->calc_md5_hash(newhash, key, NULL, skb);
-	if (memcmp(hash_location, newhash, 16) != 0) {
+	if (crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		trace_tcp_hash_md5_mismatch(sk, skb);
 		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
 	return SKB_NOT_DROPPED_YET;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d53d39be291a5..910c25cb24e10 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -86,10 +86,11 @@
 #include <linux/inetdevice.h>
 #include <linux/btf_ids.h>
 #include <linux/skbuff_ref.h>
 
 #include <crypto/md5.h>
+#include <crypto/utils.h>
 
 #include <trace/events/tcp.h>
 
 #ifdef CONFIG_TCP_MD5SIG
 static void tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
@@ -837,11 +838,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb,
 		key = tcp_md5_do_lookup(sk1, l3index, addr, AF_INET);
 		if (!key)
 			goto out;
 
 		tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (memcmp(md5_hash_location, newhash, 16) != 0)
+		if (crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 	}
 
 	if (key) {
 		rep.opt[0] = htonl((TCPOPT_NOP << 24) |
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e46a0efae0123..5195a46b951ea 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -66,10 +66,11 @@
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 #include <crypto/md5.h>
+#include <crypto/utils.h>
 
 #include <trace/events/tcp.h>
 
 static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 			      enum sk_rst_reason reason);
@@ -1046,11 +1047,11 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 		if (!key.md5_key)
 			goto out;
 		key.type = TCP_KEY_MD5;
 
 		tcp_v6_md5_hash_skb(newhash, key.md5_key, NULL, skb);
-		if (memcmp(md5_hash_location, newhash, 16) != 0)
+		if (crypto_memneq(md5_hash_location, newhash, 16))
 			goto out;
 	}
 #endif
 
 	if (th->ack)

base-commit: 9439a661c2e80485406ce2c90b107ca17858382d
-- 
2.53.0

