Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157CC1CEEB5;
	Wed, 23 Oct 2024 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693837; cv=none; b=eu2B5x7IbzdCpJpkb4Hu3Kcb7b1+iQB385bEyVMGcSZH5LdAOYtrFZkyKhPyBUzNdrCvnOYBzQz+FTh2Q9A6vo2L6T6gzoN9fzVogZeSyd88OJXFgBNxNtDnZDhTKGenpey1W2szRVoGqexOHKSR9RbVi4RbuJun9bZx93D3QgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693837; c=relaxed/simple;
	bh=KsChw0SNkfC6arHsxQUUrWq4HXZae29iDQEnEqKZJQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igt2/chOtpjDzfk0hH9KgUa1EkQx1zdNWwnUSGht1eOP/4wZWZ8jbaOJvfUMAgFPYnaWfJrAaPAcYJ5qauVkw01D81ZAWmlm1EhzaD5YesnR60By0DP+We1BiA2clqKSNpZSo7G7dhv6mum5QRhQ96sAH5TOKtE4JeO47vXtScc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sWk4Cd/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sWk4Cd/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECABC4CEE6;
	Wed, 23 Oct 2024 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729693836;
	bh=KsChw0SNkfC6arHsxQUUrWq4HXZae29iDQEnEqKZJQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWk4Cd/bpg6iqA7WGuw2dEfGMhYvfYhx3zBDpSvAmWyKYwry7Apturw80WqP69/y5
	 uRO7EEPWs0ElJig1QEUVc0bcYMFMZNMJh9mHpqboqp8wq97CQE+vn2eNI4uiF6EfF+
	 KOuYFGutmSoXPurFw7au2sNMGpPV28pwC5TBIJ2bDtjqixkF78fpHIOJnjXDrmDM2b
	 hvHsCEcOzbVm/YViO++29FpR/7scMHQxEcZ8oVuMM+4mesz0RziZHgT5yJcaDUcRvx
	 CWX5/wuGsLHrY5qSy8IYIm5eDuomDKsO3E2mL65zkzP3texg23S6Y2hnzvFNQJFHdA
	 i08iYZuDt+sWw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 15/30] crypto: api - Fix liveliness check in crypto_alg_tested
Date: Wed, 23 Oct 2024 10:29:40 -0400
Message-ID: <20241023143012.2980728-15-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241023143012.2980728-1-sashal@kernel.org>
References: <20241023143012.2980728-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.5
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
index 122cd910c4e1c..192ea14d64ce6 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -396,7 +396,7 @@ void crypto_alg_tested(const char *name, int err)
 	q->cra_flags |= CRYPTO_ALG_DEAD;
 	alg = test->adult;
 
-	if (list_empty(&alg->cra_list))
+	if (crypto_is_dead(alg))
 		goto complete;
 
 	if (err == -ECANCELED)
-- 
2.43.0

