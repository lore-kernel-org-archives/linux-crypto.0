Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D485381D6
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jan 2024 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705866940; cv=none; b=HvpsbBlp5EMAaXZLzoyu7ZNKf9bOzsqB3OvTw5TA3TTueOgWqwwkIDUeqAQJm56QNEzzL2xnsbMNz8zDnPXRSQEay+028piJ9Zwb53HwGBAOslYi/vZnYZ7OoKKWAkwAXyAmSv+W8VxoP0ALJgv9uYr+qRxmzxJan5yQOwFck/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705866940; c=relaxed/simple;
	bh=rHPHm0xObjT2NtCPtrdvPtIg4iqTQK37oTm2oSjkp4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nL25KVgtrxkMEh7vS3zJM4P8h271+7wo3sgxGA4pPAS6Gkjp+FjIZ7VoqiF1RbRLtoZIOHyeuSzrl3NLf8bHqyIMnRMOXULXAzkz1KKd/W4I4yuIw2Jru+Rui7Wn3AqmfsuA0A1Yv3eNC3b7rkiWIgZhjLSyJxNcxfjCUt+Z9f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=ojW8akAD; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="ojW8akAD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1705866344; bh=rHPHm0xObjT2NtCPtrdvPtIg4iqTQK37oTm2oSjkp4k=;
	h=From:To:Cc:Subject:Date;
	b=ojW8akADdnlSbJx/EHyR36Lkhl7124tJzu6TjP67ghixousUiGBH7ZlkQiDtO5vD/
	 ZQOOZTy9XQ80WCtpgoNMODtTn0xMfClQPtN32Sf+Khk+3llVeCPO4XkaK/dI8Ymv5i
	 RvVYJk4YnBfRdD2LSmrejv1dwMSD6Zmkmyd/m1OlQQqWY1MsyfLvBdDAVWINo3Dvbe
	 7nCFZpPtFMZSIKN9H2Lol2RUfamhyeqj/tbAB20Xss3sKF0c4EQ3UzA9OKvXNFbv6f
	 9KpDrwC/Kqv8rQk1k+XBVOfjDeKtKsPeEaDWtqJd4b6FS2M55OeBJoGCj/RjjUUPK/
	 ewk/IUGm7hGKw==
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH] crypto: remove unused xts4096 and xts512 algorithms from testmgr.c
Date: Sun, 21 Jan 2024 13:45:26 -0600
Message-ID: <20240121194526.344007-1-git@jvdsn.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a93492cae30a ("crypto: ccree - remove data unit size support")
removed support for the xts512 and xts4096 algorithms, but left them
defined in testmgr.c. This patch removes those definitions.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/testmgr.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c26aeda85787..3dddd288ca02 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5720,14 +5720,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 #endif
-		.alg = "xts4096(paes)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "xts512(paes)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
 		.alg = "xxhash64",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
-- 
2.43.0

