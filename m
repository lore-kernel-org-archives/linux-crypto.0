Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814E73DDDD3;
	Wed, 27 May 2026 08:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779870364; cv=none; b=HZ7Mp+eJKlpBOmFdrl5Qhn9Buz2R/VCebAd4SYzMqxTqSf/+AE+REqJkarZcKwUYNAPlkZlOOL0dElP58trObumMNgB1WgYykcu5BFUwiAtv873wpVYDuoNght7GRz5eUkaMVwQBmfxVjVWs7h3sRGCrMB6PSRLAh4/Bb9ZViA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779870364; c=relaxed/simple;
	bh=4ZDdfunSOYjbYgeldm3GYKaP+rN9Vs55rGEdl/45ogY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEd9TpMstoyW1NEX4DraiOhqVs7uZy5RQePdnwVlzXffTdqaXIgOHhGolRhvCyhko/tVWKXl5gBog9/tnBJULblOhxm9lo37quGlW9c/BOw9TtO3Ml92K0q6hVyzQlxDPQ032Y4TEk4XPi/pQULjd+gojZY6Q0i9EbqhcFIm/lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xKGfD53z; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xKGfD53z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779870359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hc1xawfwnd7scbSik+dGMphjPZAj0ZJMCx6yMVuY1Zw=;
	b=xKGfD53zVJCYuh0DFnUiGzshJLed7ajW2eENX2DzyRYQZwdIpp0BATMRdebZN1CVPJBWIr
	nCgU/NVmCbcdySjnYlK1unC+wvxj0qdP8ziC8Or736QDfI1Q8b3J0Bti8BwjyQjSZA8U9H
	df5KuR+eRuuNgUenyigJ1djWfj3Fpy0=
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
Subject: [PATCH RESEND 4/6] crypto: af_alg - use sock_kzalloc in alloc_result + accept_parent_nokey
Date: Wed, 27 May 2026 10:25:14 +0200
Message-ID: <20260527082509.1133816-11-thorsten.blum@linux.dev>
In-Reply-To: <20260527082509.1133816-8-thorsten.blum@linux.dev>
References: <20260527082509.1133816-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1229; i=thorsten.blum@linux.dev; h=from:subject; bh=4ZDdfunSOYjbYgeldm3GYKaP+rN9Vs55rGEdl/45ogY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFliq3L9L3+u3NNdb2EvweTUYL3g584T+vKaq7mKfBe8u DdJZNW/jlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiI+QdGhv1CPsKam5eUZpVs 4s58tbz80IeldqHqOpuPSNVMKDGpLWJkWC3y7FSTjHjpAbMJB67ZnDMUFsgWEZoavXDOHreAA49 reQE=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify hash_alloc_result() and hash_accept_parent_nokey().

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
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
 
