Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01C93DE44C
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2026 08:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779870364; cv=none; b=iC4By9hOgsSoOHLR9s7gzJE5eg88w14nRHVS4qdHYSqBW447QTOVKhZQP03JiMkSY189wuFxtL/HwhDZjEiNYjp57cz3YZCWkk+9EN/H4R3s6qxXWqlwAIS9MkeiFm0f/0sIP6BlmANklfrzjHMM7ITj7zu/60RoZkCGSB4+9+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779870364; c=relaxed/simple;
	bh=ZvfXWR5k1r7TzSLddYu+UEUvINjvO91+Xxhh/ScI/tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEFsOnFeVG6ovEAqr/FzldnquSXpXZ7i1Gnf2ebqWch0uzIRtGmwg1F0EaPuVFHKyQ73xjX6cog3gqUnEwgUsh4JbcmhgFqpu5th21I/+zbc0LdNzbmnSUw4kFp2sXayWb2V52g2B641ECjghy3rgUn2T2a8kbWUPafCNG6+xBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wplAlSjv; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wplAlSjv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779870360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pq9EXOiDNg6EPoIk3Z3sQS7nI7pVh35u0o+CMtBzT28=;
	b=wplAlSjvoBCLkP0RWZoNS+ac0heamApqdVbtYDvPPLSnH/n+b/4/aVJMlvc9WN3KLqdUYU
	5PBpn7gyokF8IiWrTtN28TNW+xwtBmBHTpBR+qlxaJgGZVu4keiGTXLbGRi2l8lifT9ZCE
	//svJoO1HBigrvjZflq4sVtM2epsp1U=
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
Subject: [PATCH RESEND 5/6] crypto: algif_rng - use sock_kzalloc in rng_accept_parent
Date: Wed, 27 May 2026 10:25:15 +0200
Message-ID: <20260527082509.1133816-12-thorsten.blum@linux.dev>
In-Reply-To: <20260527082509.1133816-8-thorsten.blum@linux.dev>
References: <20260527082509.1133816-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=779; i=thorsten.blum@linux.dev; h=from:subject; bh=ZvfXWR5k1r7TzSLddYu+UEUvINjvO91+Xxhh/ScI/tw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFliq/KYZgpsNo6Y55vMvrNqx2oV1ZnC8euZfXpVAzyiZ VXPu+V1lLIwiHExyIopsjyY9WOGb2lN5SaTiJ0wc1iZQIYwcHEKwETCTjL8symYd9jgevYJL+77 UYsOO+4QvTEp+3yPwbVFOyQUVar9HRj+Fy++vMdKtM2swHv70sMK6/xiZm83yD/S9P1Q09wQeTZ 1RgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify rng_accept_parent().

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/algif_rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index a9fb492e929a..f609463f9e14 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -244,11 +244,10 @@ static int rng_accept_parent(void *private, struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	unsigned int len = sizeof(*ctx);
 
-	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
+	ctx = sock_kzalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	memset(ctx, 0, len);
 	ctx->len = len;
 
 	/*
