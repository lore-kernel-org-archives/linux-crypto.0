Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360481CCEFA;
	Wed, 23 Oct 2024 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693936; cv=none; b=tRDk6fPoLbMdbtzK5HwDB61jn7hLsiV9uUOcl5iwrzmk4s3efKlN+NYTUNyzVvbK9G2m0MfiMNUUQ9BiJT5knrOrPEJlnL+UuR/WuaS52aBAid5uPZ4PPQjG5NWDe4WkZA/xR660gaM/W6nNVUvATtUyh1Twc0CH7qtW66zf3Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693936; c=relaxed/simple;
	bh=L9OyeUVgZ66bxAtAd/htde4sCMtkLx5MhY33UuZvTto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5sp36pJNYcEfrfFn4P2Fp8DbwxETqcqQ/DQPW16M+QQXVKGu/lzPP4RNOZOB5jSoInVY4tvgGaa409gjpvWPjP+tOD5HkVvg1lcrkIy2CBQwtuiZFxKx25NoOh7XFkUWsYBTuY4HvXiv4HKyreleNQgxMifw/sSF20P44noCME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZywoOZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZywoOZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077DFC4CEC6;
	Wed, 23 Oct 2024 14:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729693935;
	bh=L9OyeUVgZ66bxAtAd/htde4sCMtkLx5MhY33UuZvTto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZywoOZ8andwfLMuk+8xncse3v2UswNga8LqDHl87ot3wHB3PrYXP7vROW0t12CKg
	 GCcY4HE4cktJTlXyH4fQTRmY+RAJHAYkFfbgh8qIULa5CoUMzrhw9PNXaJqJanRK/q
	 4oywwqSxg6xYQE/Y0ked08FRIY5qL5DSSYao5MMtCSvERYcCAm+HbIrqQ9YEsR8JqJ
	 rCv90F5LN9Mga5z8ECVlsqzlPSgm54RD9m2WxkFyFxztpFGlQB5kua1z7RhY6rUlve
	 YzAjMUy7J98+5TKbtpepbjsab5pwxMWBBcC/GIdnJa7rCraU4En3gKycJQdbtyk/oa
	 OEtTgpI5S7jww==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/17] crypto: api - Fix liveliness check in crypto_alg_tested
Date: Wed, 23 Oct 2024 10:31:48 -0400
Message-ID: <20241023143202.2981992-9-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241023143202.2981992-1-sashal@kernel.org>
References: <20241023143202.2981992-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.114
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit b81e286ba154a4e0f01a94d99179a97f4ba3e396 ]

As algorithm testing is carried out without holding the main crypto
lock, it is always possible for the algorithm to go away during the
test.

So before crypto_alg_tested updates the status of the tested alg,
it checks whether it's still on the list of all algorithms.  This
is inaccurate because it may be off the main list but still on the
list of algorithms to be removed.

Updating the algorithm status is safe per se as the larval still
holds a reference to it.  However, killing spawns of other algorithms
that are of lower priority is clearly a deficiency as it adds
unnecessary churn.

Fix the test by checking whether the algorithm is dead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5dc9ccdd5a510..206a13f395967 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -341,7 +341,7 @@ void crypto_alg_tested(const char *name, int err)
 	q->cra_flags |= CRYPTO_ALG_DEAD;
 	alg = test->adult;
 
-	if (list_empty(&alg->cra_list))
+	if (crypto_is_dead(alg))
 		goto complete;
 
 	if (err == -ECANCELED)
-- 
2.43.0

