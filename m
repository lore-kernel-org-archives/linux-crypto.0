Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B671135B92E;
	Mon,  5 May 2025 23:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486138; cv=none; b=MdCRqFyuAG47SSZSGMGW3MqeH83/8jbxQiCCUdszq3yDXdk+biohIbVlbLNyR9W+oJ/wVpiu4y9FFxPl22QNYphMJnqgxf4xtvDZd8K7TUicL1IbuFmE3M2CFNA137LUdekVefWfMaGkBx1E9vb/Ar+4Lva4ctuw23LKTPRlHi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486138; c=relaxed/simple;
	bh=V88aNIaWiSEb+uXYq12/yLYHfrK/r/sRZOY2QArhhQo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C8ocqbmCstXHdI04gu25vhVfx/s7hJ7u45BzhmzqCld4/rqhXrrCfvCLM+crOSh15PF3Q262FMCYxNY0crSbBciWZrSpHpWAiP74TVoECoO/U9z0+T8Rkw34ONxjKhGCNI4fkMyzCXTqJeHqqrZm5C/t1Mpl+/ggCSSikSEkTZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuQGFzIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuQGFzIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E021CC4CEEE;
	Mon,  5 May 2025 23:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486137;
	bh=V88aNIaWiSEb+uXYq12/yLYHfrK/r/sRZOY2QArhhQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuQGFzIwGjx1po7pGQfL5FoLhybFrZS/Mqh5FJgAVtN4S3zGlT4WCRvIi14fVIjq7
	 Ul7g5xCNNr6/iJCMTzqyn8E04kePscdDvDejmdtyzFlTawEPfa1Fu8Jr9Cs5Jjzt3E
	 l1yfo0NsTp5Zp1AjfStqGG7Cl01AN8WnMX7GDfloGK9TyEBxew66+Wa6kHQb/0Zh+3
	 RoWQ16JO+29OmZVMUQf4XH7C3JBSw8lwbCYzudUiFBeOCYZ/vwZ/KiJKRREZnww5e+
	 Cs0RnNKmLm0+a8u6vB+QUkoLE82goqPJcm2v8TLGrfQsOMuwvZYKaA9tJSi8qi/aJF
	 WgTjX3MQWWSIA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 171/294] crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
Date: Mon,  5 May 2025 18:54:31 -0400
Message-Id: <20250505225634.2688578-171-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index 7b275716cf4e3..acc879ed6031a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -811,6 +811,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
+	type &= ~(CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
-- 
2.39.5

