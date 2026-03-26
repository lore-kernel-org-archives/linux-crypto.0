Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5BE249E5;
	Thu, 26 Mar 2026 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484213; cv=none; b=VuG0/tCyRnRevhY7YFVAn5g2UTJn+K1UgdHvzK7w1W9t62FYrFW4KWEep6zlAIOVd+bZ0Mp/FxTluGOtYeXdJ1aP9TJ6m858xBl8EHZqPh3tLDf94+M2l5vQNHIkLeLayvrBtFMjHkH/6Cy191KfBYHYJdBk0FaN3oq1W4Di11U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484213; c=relaxed/simple;
	bh=tVSbQtwKB+tbe5aaUg9tEfJjGXDQd/Olsy6HwfILhb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qszvrAY7sHt7OZgbOn/i9hplL0TUgZSOkEY7RY2xzqCUzr7LzI9vqsCsg8jCjGLEBCAlMp/Ma2MytT5EyG2mvwFLDqMc/yco6ahn4sfHNXSKugdUR0zDIxqg38pb3iYmoZhAZZoGIL1ZdWrN1n7B9L0e4ubwjtcDd0QUjuobBDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAlnVUgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAlnVUgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DC5C4CEF7;
	Thu, 26 Mar 2026 00:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484211;
	bh=tVSbQtwKB+tbe5aaUg9tEfJjGXDQd/Olsy6HwfILhb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAlnVUgNHYFqC7MwgFg6MoDvQd6ASPmUWbP8ZR1e3ha+GNQu1mkyyeHoO7/ex1XMp
	 P104PR0o8zYCVbBLOPrPt7yxdbxik69x9B9KnQUPMjZ7rjc7eb1wEmOIX5bIyGoO//
	 hVRt4bfuou/UH/j1E3ID8FmxprtdS7KiBzp8EnUbSnE5LRKX1vhQ9h/SsHCgTEw+1O
	 0JLEBPTbshbOZf1RgwjMpGLbmXUL/j4os7UnUOy336UM7auzl47qE2NpneikkwfM9W
	 T5zWyLK1wRwHeVRnGw6RmI8LxWT1+fH9xeTm1DXMDX0Gyi47RPczBBMPFIZrvX+uik
	 o5CNOwEYmjldQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 07/11] net: tipc: Use crypto_stdrng_get_bytes()
Date: Wed, 25 Mar 2026 17:15:03 -0700
Message-ID: <20260326001507.66500-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326001507.66500-1-ebiggers@kernel.org>
References: <20260326001507.66500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the sequence of crypto_get_default_rng(),
crypto_rng_get_bytes(), and crypto_put_default_rng() with the equivalent
helper function crypto_stdrng_get_bytes().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/tipc/crypto.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d3046a39ff72..6d3b6b89b1d1 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -365,21 +365,12 @@ int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info)
  *
  * Return: 0 in case of success, otherwise < 0
  */
 static int tipc_aead_key_generate(struct tipc_aead_key *skey)
 {
-	int rc = 0;
-
-	/* Fill the key's content with a random value via RNG cipher */
-	rc = crypto_get_default_rng();
-	if (likely(!rc)) {
-		rc = crypto_rng_get_bytes(crypto_default_rng, skey->key,
-					  skey->keylen);
-		crypto_put_default_rng();
-	}
-
-	return rc;
+	/* Fill the key's content with a random value via stdrng */
+	return crypto_stdrng_get_bytes(skey->key, skey->keylen);
 }
 
 static struct tipc_aead *tipc_aead_get(struct tipc_aead __rcu *aead)
 {
 	struct tipc_aead *tmp;
-- 
2.53.0

