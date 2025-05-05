Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F1827E1B9;
	Mon,  5 May 2025 22:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485336; cv=none; b=oFuM/efwUgb197vaXvgEK0c80Yb6ZCfB2UANuVDYVOiHGMUe1xn4+VpvRaHCUKEh5P73G2d9gCDguwyrzn0W/Kx1+uhYCHP3a60La9F2O+doJuG3YY+39EYw0GGdzXYU8rXnNCAOlel9XPrQ4tVZZGU0H4EwLyk4m3cSZ2sp0hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485336; c=relaxed/simple;
	bh=/mKFx5viPFoF5Ky+BMphwtbxYYArj+29lYGDeKjow/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z8jN+kOTnJSOCI9WkyN78N3APOhoZMWrwlvnKUN5sTA5F6qdY3UUa1bTrEWQYsgxQLijQ9g6tRMkKiZsjROcpK384a4hYQOMduYGQB3TV2ZXP3Mmo4s99GBYQBDIpzrawdeYaq8ZljDjBFj5tgMHJAURbhzCcStTxtQnQnZd30I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZHGcSmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZHGcSmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151AFC4CEED;
	Mon,  5 May 2025 22:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485334;
	bh=/mKFx5viPFoF5Ky+BMphwtbxYYArj+29lYGDeKjow/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZHGcSmpFlz8qbCEQFpIQ5JCBynOAP/mlc63bAvThH2f+Hk1v7ymZpL/B28AqHVV9
	 gkirVGkVFFta9770ujPz3WKqHng6UnlMvXR5TSBYAunhNK8UGsRV2dnogXjScysaYo
	 PR80lJ6xILL4a6TyBDhgJ2PPEUdE5EBvdy5VhUng2UoHV13rWgPkTxAt5HhBArM6hj
	 UKGKDnUfMqENoxU/n5t/uZYhcf5/5C8yG0DMqTPyU0aiHssWorLFV0mmDKwLpg6L5P
	 yh/u0sOi5MwEA6jFQPq529682YfbLuo8QRciZAfOiQS3nGG++jfLucHIRZ5J9Z/XkF
	 9/ybh5nTg9d1A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 273/486] crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
Date: Mon,  5 May 2025 18:35:49 -0400
Message-Id: <20250505223922.2682012-273-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ee509efc74ddbc59bb5d6fd6e050f9ef25f74bff ]

The type needs to be zeroed as otherwise the user could use it to
allocate an asynchronous sync skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/skcipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index ceed7f33a67ba..fd3273b519dc0 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -844,6 +844,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
+	type &= ~(CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
-- 
2.39.5

