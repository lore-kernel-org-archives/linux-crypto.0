Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB712003B3;
	Wed, 23 Oct 2024 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693895; cv=none; b=aQkPvS9nQRGBAd+jxtDLyIfSB7iFq4HiNqmKdQ7mqafYY1ogC3T8AZebk7wHy9v10SOcER/buEsp5lU8NoumCXFhJ05vXYQSA0zZFnERbTJ690e48CTL3GVl85q0SVCVLzIeTWCajkDayf9CTIg4O8lVQ0SqBeJFTSBRzyxIcGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693895; c=relaxed/simple;
	bh=i7Vx2jvVeicGfJ2NymrgScV9v1hM2Tf81UnUFphjNy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFaApW7o8uV863giskgTujEWJQ5/Tlq0ODlHwcv8jJ4M+FGIDlewmymOufQ16dGdh7JOX0ypkkQba43gsy7drf/FO2j6cUu6bPL+m9F3idgp/S5tNpxEG/44o6h8kPwUOhGqc6ScQGdHB4xFuWlNeCd4anfIh2+2X+pmcc5xbyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecaTg6/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecaTg6/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7463C4CEE8;
	Wed, 23 Oct 2024 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729693895;
	bh=i7Vx2jvVeicGfJ2NymrgScV9v1hM2Tf81UnUFphjNy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecaTg6/fefjuWk7EgBVZEQJxlolNlc2YmGMK860cWqtLCAtOhxdYMRtBZASiWbWE5
	 iuxX/WZ52Un5KVvqX5IZVhFaagyV/SaOXuiv//LYEbnspTR+h7NQr4KX8GQ2GvI0aO
	 UOegAhl8n7dn1R2H78aQg1yGHCzHxoIDTMN/mJbxyB/z7ZgWhZzcAMgkXTn2pYXxAY
	 ciNRR3q3FFs7YWyVDmZwWnYJLrf1ISO2a26ShGkmlHAN8PFlhxWcbMkhrhC9SelyXQ
	 k7CWx0I1XEmg/3GDQflZojtt5VAwGua1my0Pv0EHMfVpFnwla7G0LkwsDW77exOI0w
	 P4gHfoaoTZITA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 12/23] crypto: api - Fix liveliness check in crypto_alg_tested
Date: Wed, 23 Oct 2024 10:30:56 -0400
Message-ID: <20241023143116.2981369-12-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241023143116.2981369-1-sashal@kernel.org>
References: <20241023143116.2981369-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.58
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
index 85bc279b4233f..b3a6086042530 100644
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

