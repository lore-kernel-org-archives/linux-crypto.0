Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311B63E92BA;
	Tue, 10 Mar 2026 20:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173824; cv=none; b=eZx9MgTI6LGDoVm3mybr/i5aOxqRBan0dPrqsDayskxtyAIQ5FFsD8HTO3lft2q6it4rqZ4mQyV+AGqrYcYq5KVo0SNQi7tHmD13oZkfDyYsMd4DHYYecpwx2rP6d4LWJlTrtzPuTBCFbwJyry4fLs2i725fwBntPuyNy00Wflo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173824; c=relaxed/simple;
	bh=jFdJjnxFj1x6jOeoFXPK2pSRF9IhHkenvfRq3uNrzV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LIDKIuoaw7T49kmhuw7A94CzhCys9qPwdjoVBOJd4REb6/7OV/b+xw74Sn2uijzp34C94aMscmKvT7qAiLXx/OhuemdQ4zPuVTilPwGNqq4Q+BZPMM7Xiw+Fe5BdURQCano30ylfpB3dW6iESAVgjkquin78RiMcnPEHr+zkwcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+iz5fSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+iz5fSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750C7C19425;
	Tue, 10 Mar 2026 20:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773173823;
	bh=jFdJjnxFj1x6jOeoFXPK2pSRF9IhHkenvfRq3uNrzV8=;
	h=From:To:Cc:Subject:Date:From;
	b=d+iz5fSQAnuDHrDl14xN0w0JSLCmzMPx4xfjmi0oBM6RxfH1L1uK8kHV1j5vBklWU
	 tV1u/l2Mu3Kbz3InW/Vy1nBvNiS3IiKVPDWeEKlFYipiT9yH2Ykl2Z2zDE1AVn7bYw
	 Lu4OJdVsfQrqgRIJo52DnhqHVV9mjxSmwh9IKAfP4M6BWifvId/Ds+IUnswcxcCF/T
	 ZnvjDb4xzXm92Q5GyZf4AWK3cmIWmqPD/l+r5/DhXlL5mimlLbcPe6sjrTpuxpCaST
	 Zl5/IB72+8IQmetvKtyKc69tcK9wutL6VIt6z2JFQwH34zOUnTUUs4vVe+lWtEjOKN
	 48vrIz/ZRfbGA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6] net/tcp-md5: Fix MAC comparison to be constant-time
Date: Tue, 10 Mar 2026 13:17:01 -0700
Message-ID: <20260310201701.120016-1-ebiggers@kernel.org>
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
index 2bae34d63c3db..021e1bdbddcb8 100644
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
@@ -4554,11 +4555,11 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	else
 		genhash = tp->af_specific->calc_md5_hash(newhash,
 							 hash_expected,
 							 NULL, skb);
 
-	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+	if (genhash || crypto_memneq(hash_location, newhash, 16)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		if (family == AF_INET) {
 			net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
 					saddr, ntohs(th->source),
 					daddr, ntohs(th->dest),
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ab4be34e58bb2..c8d35f1c0ece2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -78,10 +78,11 @@
 #include <linux/seq_file.h>
 #include <linux/inetdevice.h>
 #include <linux/btf_ids.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -774,11 +775,11 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		if (!key)
 			goto out;
 
 
 		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
-		if (genhash || memcmp(hash_location, newhash, 16) != 0)
+		if (genhash || crypto_memneq(hash_location, newhash, 16))
 			goto out;
 
 	}
 
 	if (key) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 624ab1424eba7..2c579868fe81f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -62,10 +62,11 @@
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
 
 static void	tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb);
@@ -1033,11 +1034,11 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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

base-commit: 4fc00fe35d46b4fc8dac2eb543a0e3d44bb15f47
-- 
2.53.0

