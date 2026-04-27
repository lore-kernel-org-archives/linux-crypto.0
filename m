Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8582E3B389E
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 10:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286635; cv=none; b=kIuSk9TaaH5EhQZ03OvcbjfFrrWYVDFVKoUZ+HmRYCdMk24hb0yFszsWcpnLZjGlzYAi8rTryTDUedUUMYisdEKysyFfhG9lQGOd4tE1hVHUHZXsZYBojmTsF7UTGGxWJ3MuzsUni09nXSC7rAGC1GAJeh4UPeuSvGIVVqkYguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286635; c=relaxed/simple;
	bh=PbC3WlEl3mGGNaBVJjZlVBT9ieq3Nnh8JVV0OgTIrQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw8VKQgZLPb8ti4GhwkbWuV3JoyWp4jy6vm6AXTU2VTHTCztA56UBYZzZqffEwgrPIfmKTD5zhkOX0+3MJ/lekh5qYC0P4eyhWRYESr5B+AvrrKStW1Irm1bQf47TV1Y7+xczduKMFy7VYyQj+A7T+GwMFuOZL+eg5CB0eDZv2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nrQLjuHi; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nrQLjuHi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777286632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZxxToo/uo7ySdOD5im/aZqcXube9FxNxMZbscCrXgmw=;
	b=nrQLjuHiaWN7X82H6fkYgwss/io/TuiRpXmdlesln/m2D2Ua4tpxNzCkODCDdb3Kp50mYA
	mdwlN5Ps+vmTCE+tOXUhXBbRkb8/VSa3QhLSSg3rDG6MjIcCxnFm5knLSp2j9R4XXkvx7C
	nuXldRP23cIcukCOlHiXGLs3/UnKPk8=
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
Subject: [PATCH 3/6] crypto: algif_aead - use sock_kzalloc in aead_accept_parent_nokey
Date: Mon, 27 Apr 2026 12:41:32 +0200
Message-ID: <20260427104129.309982-9-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-7-thorsten.blum@linux.dev>
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=997; i=thorsten.blum@linux.dev; h=from:subject; bh=PbC3WlEl3mGGNaBVJjZlVBT9ieq3Nnh8JVV0OgTIrQM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvbeMONf7xE63IDyg/JWYxYx1H4BbnZadjZcLPhS3aV nCzeOrDjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZjILReG/x4Hnz17Zss0VaPV SLrS4WbqbK+jMazhsxLP8TpzTzr0WpiR4cde588TlhY1STzJ+GfKdHfJpI2RBpeFg9uW1JxTj8h PYQAA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify aead_accept_parent_nokey().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/algif_aead.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index f8bd45f7dc83..83bb9a6bf85e 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -402,17 +402,15 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 	unsigned int len = sizeof(*ctx);
 	unsigned int ivlen = crypto_aead_ivsize(tfm);
 
-	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
+	ctx = sock_kzalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
-	memset(ctx, 0, len);
 
-	ctx->iv = sock_kmalloc(sk, ivlen, GFP_KERNEL);
+	ctx->iv = sock_kzalloc(sk, ivlen, GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
-	memset(ctx->iv, 0, ivlen);
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
