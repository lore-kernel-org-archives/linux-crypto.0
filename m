Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3495D39A073;
	Mon,  2 Mar 2026 20:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483769; cv=none; b=X2TirDD4J7fr+Z6v+ws6+bjMj0mTq0n1BiQEk5gN27WsiqXN6U7PFm322gynTtrDIQX5Op6oUz/h2wPIUrnnAt3sqUF4qXP6XiDNjanrXmODiR6zZTik8arskRFwSCm7AXGlKusA4If+g8MS+LVn74clUC8PP+hykmEhyoRhuTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483769; c=relaxed/simple;
	bh=yUOzZwoaUnAI2MDcEdhdi6+VTNYTtn0k7bRlSgoxklA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ct3mI32xZXjggtCfxbSWqPNMqihmlq2zkTTYiooyurWpnxoBFYnvMeWu5u5uxqVjbX2D1pSAI3l4gZBxH/GuMU7B3xWll3jxEkj+TwGl3eK70GtET+S6D35oPByOU47zU/EhL0fg387mhCsVfawtdkNj/EzW3yImFiO2LZd7tmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mG02Re/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mG02Re/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785DBC2BC87;
	Mon,  2 Mar 2026 20:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483769;
	bh=yUOzZwoaUnAI2MDcEdhdi6+VTNYTtn0k7bRlSgoxklA=;
	h=From:To:Cc:Subject:Date:From;
	b=mG02Re/KaRem0x/EwCMT8L2Q4SflumAv+SIicV2DFI2ey3WfZkVwzvD+mPXEIq/0k
	 ATgK+HxoIN9zKVw0l6JgYcK/UB0HYDG181aJ6UzdletCUp/4ofhDC+TeZlh4uZbQaW
	 Vgj/Bjh4EZw2Y2ARsdsXMbP09Gk4+2thKOIqngS7PoExDtUmUrLQs/jFpoAf95q/fs
	 JJvYmBc+tM023G1c26BkOyL6d7d/S1mxQp/XJA2OEXFbRUXCqvz5oJMsYahl0zgxYS
	 bP0cnkZa2iXwIJbobyuqYBxsLxwHcS34X12wyizvJ/UYbOHFJCuvPG2/YFdl6OmwJo
	 BA0ORNOuklxQQ==
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
	stable@vger.kernel.org,
	Dmitry Safonov <0x7f454c46@gmail.com>
Subject: [PATCH net] net/tcp-ao: Fix MAC comparison to be constant-time
Date: Mon,  2 Mar 2026 12:36:00 -0800
Message-ID: <20260302203600.13561-1-ebiggers@kernel.org>
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

Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
Cc: stable@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/ipv4/Kconfig  | 1 +
 net/ipv4/tcp_ao.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index b71c22475c515..3ab6247be5853 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -746,10 +746,11 @@ config TCP_SIGPOOL
 	tristate
 
 config TCP_AO
 	bool "TCP: Authentication Option (RFC5925)"
 	select CRYPTO
+	select CRYPTO_LIB_UTILS
 	select TCP_SIGPOOL
 	depends on 64BIT && IPV6 != m # seq-number extension needs WRITE_ONCE(u64)
 	help
 	  TCP-AO specifies the use of stronger Message Authentication Codes (MACs),
 	  protects against replays for long-lived TCP connections, and
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 4980caddb0fc4..a97cdf3e6af4c 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -8,10 +8,11 @@
  *		Salam Noureddine <noureddine@arista.com>
  */
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/inetdevice.h>
 #include <linux/tcp.h>
 
 #include <net/tcp.h>
 #include <net/ipv6.h>
@@ -920,11 +921,11 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		return SKB_DROP_REASON_NOT_SPECIFIED;
 
 	/* XXX: make it per-AF callback? */
 	tcp_ao_hash_skb(family, hash_buf, key, sk, skb, traffic_key,
 			(phash - (u8 *)th), sne);
-	if (memcmp(phash, hash_buf, maclen)) {
+	if (crypto_memneq(phash, hash_buf, maclen)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
 		trace_tcp_ao_mismatch(sk, skb, aoh->keyid,
 				      aoh->rnext_keyid, maclen);

base-commit: 9439a661c2e80485406ce2c90b107ca17858382d
-- 
2.53.0

