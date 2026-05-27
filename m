Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D643DE456
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2026 08:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779870366; cv=none; b=jT/Tnywj4Vgq7du4Sz/SJ3v1UuH6Z1mzD1az+rHASrQcD9LuYHyQwY3UNuTv9yj9xGnBOQC0NN0xaNj5hP0ngUZRoz+zIe7eZk9BfNbSxA0ViGSFgzvg0PzDMkTiMuwUxQNKB4CfEVOtvw7QEQr873VjroziNo7dr8VaTLzfkY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779870366; c=relaxed/simple;
	bh=7BpKPspgoo5nW+mSqH5uYZJNBecq065JZMJ4642Iuvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dz4shc0yxie4eDnpD6oEWZ6dt0gS1hVUZHa68oP2VueK0PQ07pX+ZDPI5GjQMCqNr2hYFJy+r3cHU6gslQnu2lW/ysXIk5JkCsewGgBlzw0VEfupLPNzyi97LLFLxwAkK7EvzLBaFHuNFbYnmupTl3LM2VyUHTCRXN8GtH3P300=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nJivxGDR; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nJivxGDR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779870361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XzRKXyVvWFIBlmQWw546l6ZchldmgJ+7MD/dVHG44m0=;
	b=nJivxGDRervO6vfj1N6KqFk5GfFLaSj9Ee24agSDgps/ZKEpZbIupE0rXeoFikWyaf6hOS
	2VYjA3AlLtAF1NsLM/S1MFHVKgfS2fgvXBR55CZZqB2Jpf9+faYMUBMB8yTrzRRskQ0cTr
	Q18MdyJOG4rUrj8mc0ylU+enqJOWY88=
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
Subject: [PATCH RESEND 6/6] crypto: algif_skcipher - use sock_kzalloc in accept_parent_nokey
Date: Wed, 27 May 2026 10:25:16 +0200
Message-ID: <20260527082509.1133816-13-thorsten.blum@linux.dev>
In-Reply-To: <20260527082509.1133816-8-thorsten.blum@linux.dev>
References: <20260527082509.1133816-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1149; i=thorsten.blum@linux.dev; h=from:subject; bh=7BpKPspgoo5nW+mSqH5uYZJNBecq065JZMJ4642Iuvg=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFliq/I2sSy+JDO75pwJR1Lt/k9b/u1aXyZd1jvLifvUA W0x/aMaHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRdRMYGb7P+dCeP0PoqHWv 47l1myzNileHSJ1pmhtmzdpos79oig0jw5mSHTrVVm17s/fPjD90soO/UefsjwbHI6WFQnnrd/U LMwAA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memset(0) with sock_kzalloc() to
simplify skcipher_accept_parent_nokey().

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
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
