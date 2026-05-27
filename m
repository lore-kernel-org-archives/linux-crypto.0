Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE863DC4A4
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2026 08:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779870363; cv=none; b=Tb8rAYoBOgluUfvcf0g06MIopSOkjLWFnRYyIkJ2exiPd2os25K8vsrk6GuMbZA4TWS7EH5c0Lp0T7xdMlm/0WrlJDfEKZp6Nfo7zhlCw3lHpqIPdTH/q5Ck1KotrtUXxfCP5V8jXlqXy1EKyVDWPQYS7oxycSBDndXvYCFKS04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779870363; c=relaxed/simple;
	bh=pXsaBe/DX+bmuWgfpHOj82KXHDpeCQDoShpwd1I1FlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyRTcVyceXMXphibXsEdQyWltAYk5Xs0KN2d7plY1JX6TCnLL3XSxlzvsynfLYIvnj1WMZ4pu45v1Mo5T05cJEeTUDb5fbcKF8xqJmADZm6aheuI6L3YMootzQSgb4TtEovXZC3XWI0+Ss+ZtOGXivcc5eQ3e4gR8A/TXmYP4kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lAYpkNsF; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lAYpkNsF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779870358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZaApiEnL503TPKxh+wW2ax7xXEM7GJ/OqN5QETWuPo=;
	b=lAYpkNsFldI0Zy3axe1E+jFXSXTiE5XSE2E0grFehFc1+sSs4+KDsJ+EJsjMl0yfkquWRC
	q86qEaBu+0b5HBYh/Iwd324hIVLj8PYvOPZasQSFG8E9LuHmcM/SRpry3rZmurzXNZD0py
	M55RMdJ2nRjiD0ryE+YoYKtFGtzJRQM=
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
Subject: [PATCH RESEND 3/6] crypto: algif_aead - use sock_kzalloc in aead_accept_parent_nokey
Date: Wed, 27 May 2026 10:25:13 +0200
Message-ID: <20260527082509.1133816-10-thorsten.blum@linux.dev>
In-Reply-To: <20260527082509.1133816-8-thorsten.blum@linux.dev>
References: <20260527082509.1133816-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1049; i=thorsten.blum@linux.dev; h=from:subject; bh=pXsaBe/DX+bmuWgfpHOj82KXHDpeCQDoShpwd1I1FlI=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFliq3JXhR488iSif07qkTW3GefevHsweYlkkvHH6bKmP NE7Z3GVdpSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEQrcx/GJm0TW4Wvplip+T 50vJzc9niptqayw7p78nRidM0u7Sm5eMDPeN3BmaDc6q+t0XfuA65+KnjE8LDt6/3VS+6ltrXUV 7GD8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify aead_accept_parent_nokey().

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/algif_aead.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index c6c2ce21895d..6ebc2f9f741d 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -408,17 +408,15 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
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
