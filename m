Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A84E3DE442
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2026 08:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779870369; cv=none; b=Yn825Dw+dN2tcAZEFplnniaazUzNeSQF6Aw2r0RDMnNsUbubYbv9Gm7zaQd4NecjXlP+bjhim7k7p2Dxwz5NraRgEDNN+a+56Tv4zfM1i3KBQM5wYC/dgetQ458WlCbyZtd7KTW8ii82nwyFNNvMr0qZmLcxvPQaSIftzy6tyhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779870369; c=relaxed/simple;
	bh=ESrw4SGAqzCL4bn6LlJpxgD5khphsnGMCRBdtqzdIYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OpFr/YN//x9SMRSOd6mmij8yIMB8xVqYVc2ebD1kwdqG84htna1WdM9R167gjf9uWGLxA8Y76TuDkGHeHb4sfYlpnciMYnIstqXAfXzb6XggTo1JWFb9GwShRl/HZu5CUyN0HeRp/9B7on2SaHOKGMXlo18/mhTpIBdIRwxmW8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N6pzCxFT; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N6pzCxFT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779870355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iCvyh7BN3nBELcLlZRzlv7xyQaQ0PKVlw652adkjVZU=;
	b=N6pzCxFTyHbBFDGx/bl29YCsA7L2iyfc3290ijGeMNn2fskRQ7B/JrtzS+Shp/Dq6S4bAA
	WyfmW6swmTWfQBufj0AWh368bc9BFzbUW7ShMr3IRpt9G00iD8Tuo63HrACAjuk+rQqG9e
	2f5lMtpSDteGwCtzmsrPL5WHzkun+bs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH RESEND 1/6] sock: add sock_kzalloc helper
Date: Wed, 27 May 2026 10:25:11 +0200
Message-ID: <20260527082509.1133816-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1006; i=thorsten.blum@linux.dev; h=from:subject; bh=ESrw4SGAqzCL4bn6LlJpxgD5khphsnGMCRBdtqzdIYE=; b=kA0DAAoWXqtxINjMdS4ByyZiAGoWqmWiDQJ7ajXt/CE1w+vjBDoeib64KWy/9l2bx39IwV0ZB Ih1BAAWCgAdFiEE4Jr4mE11fHmyNFi5XqtxINjMdS4FAmoWqmUACgkQXqtxINjMdS7X2AD+I/8P Xb/FMUAmBl/FcJcQKiff+umsd3tYwhqHj2cvSIAA/0mnr1iv85mGCjYLhpneTC3diRBeAVEYDc9 X6c8ufRsP
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add sock_kzalloc() helper - the sock equivalent to kzalloc().

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Patch 1/6 needs an Acked-by: from netdev maintainers for the series to
go through Herbert's crypto tree:
https://lore.kernel.org/lkml/ahVkZOxZtFes6Huf@gondor.apana.org.au/
---
 include/net/sock.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 76bfd3e56d63..b521bd34ac9f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1913,6 +1913,11 @@ void sock_kfree_s(struct sock *sk, void *mem, int size);
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
