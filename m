Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448FF3B6BF0
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 10:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286638; cv=none; b=OO7YywvnA9HL177afnC0PierSS6FVIwLU57FB66RDjDhmn1mjK7kZii2dUzvvP4Gl1MGk09Rb1J+9hg+/IpCeYRIHpLkm4T+ZpbfQ6jf7AG4dsGXeODSItxXaEW5yXI0HS4Gw6J1zGFzb6WMirwCmMLFBeOJJNf/1jlnVc3+avo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286638; c=relaxed/simple;
	bh=MVL7w4odwYRdFOFCXbJGohhaqU2HOCvYXcNuqrBeT3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osMXOwHJKVpBler2VAVnLxO1ntW1ZdiRaml2MAowxwdsCCPceGmaD7kViWZLRBfg+4/MKOEakl1CWY8ZJ3wnD67Nu3X3DlTKl84gDd0HvAwlvhdwmE3qoGKCDmxSpDtj2cJNOuAzdJ5Gh36IRdEZ6oZCUPNTX7z6rUxaZtTImuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=naErNNbe; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="naErNNbe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777286635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9oaV+wvWiP2Lg5OBa4T6H8KEc8iSJk48YzUgmjw5WXY=;
	b=naErNNberVdzL3S5UBCZnKguaqsDJuiCASblF2pJ1WeQABwncIp5cYHgXrly+FPrpTeRTw
	G4odejNm7/YoAvIQrokn4u5QbLCSmPGUUC/cFkyEDvRdEXDhl/XcBBwThTKfXeJXBy8Mr1
	5K1qyloyW6TT+LSNe/sG1fjwOXlfhvg=
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
Subject: [PATCH 6/6] crypto: algif_skcipher - use sock_kzalloc in accept_parent_nokey
Date: Mon, 27 Apr 2026 12:41:35 +0200
Message-ID: <20260427104129.309982-12-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-7-thorsten.blum@linux.dev>
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1097; i=thorsten.blum@linux.dev; h=from:subject; bh=MVL7w4odwYRdFOFCXbJGohhaqU2HOCvYXcNuqrBeT3Q=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvbeOWan+tvS/05a2y7ff0fyf93jB7hxx/nl1UeFdS+ si2yRUMHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjARoU8M/yw8Tr06v83024G8 H62Nbxabv0hIeucod7PYv1B4xiIJw3ZGhqWf/CyZubUmhBcEKrzYFKKl3Co2Yb+d+so/s8u0b1l w8wMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify skcipher_accept_parent_nokey().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/algif_skcipher.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ba0a17fd95ac..f29a304e1268 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -383,18 +383,15 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	struct crypto_skcipher *tfm = private;
 	unsigned int len = sizeof(*ctx);
 
-	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
+	ctx = sock_kzalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
-	memset(ctx, 0, len);
 
-	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(tfm),
-			       GFP_KERNEL);
+	ctx->iv = sock_kzalloc(sk, crypto_skcipher_ivsize(tfm), GFP_KERNEL);
 	if (!ctx->iv) {
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
-	memset(ctx->iv, 0, crypto_skcipher_ivsize(tfm));
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
