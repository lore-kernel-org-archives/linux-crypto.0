Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9053B52FB
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 10:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286636; cv=none; b=SP87ZMLCMUz1BQgi+EgwsSGVJfHiZUIbUWNvMyeISjefxGRsF2BOKSWIZj4wCYUXhHATmjOX293dgNGEwkwIl4lQ1A2udVFg4rc9lo1lZU9iVHAWQJ7z0vgZvrViQQAcIa9VzfoIh46M4/yr1BaKQYjHwGUhww2I2lmvz4+UNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286636; c=relaxed/simple;
	bh=EZVlOsOc15/Mguif2LDeA3FQPmjujrA9n3XRe/s+Czc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFOyQU/5xCk6BgPMGhKrl7WCKunHtRAh6Lb60nPy3ErhCNJY93t32bk5h+UxY0mu1TkosaFgtGOQAQHgB3rf9qdLA09959HHPKEw2Kxi/p671TmRd+9gpzsjR7+koHw3elKEjh9JnCAndN7kyflqiRQUWZNjXp8HEfVA75VXRtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NYCD0eB0; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NYCD0eB0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777286633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twS3orO2YL7EbdAlpgkBIFlLKkLgo5IbUdAVj7FPQPI=;
	b=NYCD0eB0MJO5KcPZU+Nj60DiU7ntwD10x1bqjtGYy8zZ37sc6bV6NW+Va5pXFJTdnDo12Z
	6RyEjPfkGEo+u90uZE/stLqgzNA2/mrJcmj1zhwFVcXlFiU4g/I+rEEoS4FAxy3+yDc8qB
	bpUZ1VR8epHSrKRdX3uXJEdZwHkmEXQ=
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
Subject: [PATCH 4/6] crypto: af_alg - use sock_kzalloc in alloc_result + accept_parent_nokey
Date: Mon, 27 Apr 2026 12:41:33 +0200
Message-ID: <20260427104129.309982-10-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-7-thorsten.blum@linux.dev>
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1177; i=thorsten.blum@linux.dev; h=from:subject; bh=EZVlOsOc15/Mguif2LDeA3FQPmjujrA9n3XRe/s+Czc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvbeOm7bZveO0faHNzHltaQs4Hm+2Nle+cgla1vZIXF 9q3yEK/o5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACbinMPIsGXhmWi3vYdjXp2r 6rr2PLX0yG9F049zLxhOXuwYF1i0Zx8jw7KvFrb/DNmav5elMbX/7jJyWZ3reHneYqXgX5uVKoO kOAE=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify hash_alloc_result() and hash_accept_parent_nokey().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/algif_hash.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 4d3dfc60a16a..02c0e448390d 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -38,12 +38,10 @@ static int hash_alloc_result(struct sock *sk, struct hash_ctx *ctx)
 
 	ds = crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req));
 
-	ctx->result = sock_kmalloc(sk, ds, GFP_KERNEL);
+	ctx->result = sock_kzalloc(sk, ds, GFP_KERNEL);
 	if (!ctx->result)
 		return -ENOMEM;
 
-	memset(ctx->result, 0, ds);
-
 	return 0;
 }
 
@@ -412,11 +410,10 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
 	struct hash_ctx *ctx;
 	unsigned int len = sizeof(*ctx) + crypto_ahash_reqsize(tfm);
 
-	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
+	ctx = sock_kzalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	memset(ctx, 0, len);
 	ctx->len = len;
 	crypto_init_wait(&ctx->wait);
 
