Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A173DDDBD
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2026 08:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779870361; cv=none; b=hehYF/NqSW1EUEE0+yQmePaDH0LSvgiORHV071QGTVyh7aq/iMiork7aVDL4ATWpGsTbPsLSU//BhNKBLjqlk+UyVBH+Tj1CVN9NEaQ7Q7idSk7tnGzh7nTveW5OWup39xpAcD/stY53F0JJSlaUUQDYEMyXFGA0IV3W4gsk2/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779870361; c=relaxed/simple;
	bh=dorb39L1hm609iNx5qGNHtSqrBXFtt+eSbo1jj5NOnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkZdxbyqMrKZsdEoPM86RE/wEuj6NhmvWV8jw+zRkQY6pZKW7rpf0Np4sBzu+/ebG5sbcOi6cM6VzNkYAlBFIRAeP+VtcIJV4DwssYhfYhTicmjBRNc0tHTvm6JStgPDzeLR8FI3x6lpCY+lR1YiqjXjDN+scvMkTYeuzQnAcu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CopY1Ofa; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CopY1Ofa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779870357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTCgQE0RalUvAfxSt+nEuguijFHud6dRjiDoCjUKHlE=;
	b=CopY1OfarvXOxMgbBLftwcznVz6AOEGFK27SS/Q6mJX1d9zJKFKSg9vdjX7fxGfkEXSubk
	EhmFQcyzwd/L+kdPDLBhleqS0fLl17PWReQcvNIVOC6LhLMIBiN/JPtC16FXxvuNfUfU7r
	41SgjUZUzjfuirOKqonRoyqhjAKJP3M=
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
Subject: [PATCH RESEND 2/6] crypto: af_alg - use sock_kzalloc in af_alg_alloc_areq
Date: Wed, 27 May 2026 10:25:12 +0200
Message-ID: <20260527082509.1133816-9-thorsten.blum@linux.dev>
In-Reply-To: <20260527082509.1133816-8-thorsten.blum@linux.dev>
References: <20260527082509.1133816-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=808; i=thorsten.blum@linux.dev; h=from:subject; bh=dorb39L1hm609iNx5qGNHtSqrBXFtt+eSbo1jj5NOnY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFliq3LnmR/dlNHBFu5Y9PFKp8Dn+Noze/O7s9grpketa //W47O+o5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACaiOIeR4YZIQb6wyWVL/4Jf k3ytvRseKHfdP1y0UDqP8WJf9kambQz/XVX22t9m3Cb3U3dyS8+HwNgdi0ouGM1Rz/s4uyNlE6M aCwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify af_alg_alloc_areq().

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/af_alg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 48c53f488e0f..9438a874c1f1 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1158,12 +1158,10 @@ struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 	if (ctx->inflight)
 		return ERR_PTR(-EBUSY);
 
-	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
+	areq = sock_kzalloc(sk, areqlen, GFP_KERNEL);
 	if (unlikely(!areq))
 		return ERR_PTR(-ENOMEM);
 
-	memset(areq, 0, areqlen);
-
 	ctx->inflight = true;
 
 	areq->areqlen = areqlen;
