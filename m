Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE22227BB5
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 10:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286634; cv=none; b=PZf9wzKhi74Ynw00ATo13sW2FdkmxNVS35wb5ikfjqcZ3ncxChYjCeTRluTur0mG59lm5CfNEjZER3mW4F4dQMKGkEqvzA2ofzP+GN4Jkpdn8Yo3YLZUlc8NrYr67mkPcM31zcH0VxBIZpuR73Gu3b7BOkgXuns5rmN+n2hW1RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286634; c=relaxed/simple;
	bh=bQWG+qN8icNlR0X5uFr60vuQvIiOynEzbpmZSt3OO+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JrdFxalJ9RnOat44U17etkx7abCH3i7G7jfLPunk43etTMd4TgbUi/wIKE/5gVaV33+30KsF3NURfqXnqLwsoZUiEIRBCQS9MkIIviE9caApDO0M8N8cl/yDMU501jg/B4L5rn0vv4eEQqoCLzxwxe5aNZpqqXTefiuPFyfKZIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zdqp2vA+; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zdqp2vA+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777286629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7rYseZ4eht52voV7AmzJkTSJULGqiBoD242Wz9u7MCk=;
	b=Zdqp2vA+zu6hX55mW2UUlS32t5ZSKn2sPX6kK/3xbnCX6/qkkM3I0MngeQwytfq0OlVIZA
	2dR6b7oUXk2EpbEmcuRJgRj4Xps11VViMeHr620z+5rsa1YwxSmNBUTtkti6OJDp/3fGz8
	Wwx38ihyGY5PFalUw6OfsiO8wvQ9UDI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 1/6] sock: add sock_kzalloc helper
Date: Mon, 27 Apr 2026 12:41:30 +0200
Message-ID: <20260427104129.309982-7-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=774; i=thorsten.blum@linux.dev; h=from:subject; bh=bQWG+qN8icNlR0X5uFr60vuQvIiOynEzbpmZSt3OO+I=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvbSM9d0y+NWmFl4uBuYg4f8WU7Zv2xF9yt1y3cr2Gg aqHi+2RjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAbjJlxn+8DKv+P255nayT8yK jQyrFr97eKv72LcP/Y9PpKRemTg3biUjw/3V/w4u3KG4K+PKma8z5zM+/RG4YsmPhdvXv1p4aLZ /VhUjAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add sock_kzalloc() helper - the sock equivalent to kzalloc().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/net/sock.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index dccd3738c368..20bf406dff2d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1904,6 +1904,11 @@ void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
 void sk_send_sigurg(struct sock *sk);
 
+static inline void *sock_kzalloc(struct sock *sk, int size, gfp_t priority)
+{
+	return sock_kmalloc(sk, size, priority | __GFP_ZERO);
+}
+
 static inline void sock_replace_proto(struct sock *sk, struct proto *proto)
 {
 	if (sk->sk_socket)
