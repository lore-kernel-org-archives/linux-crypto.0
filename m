Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B495B1CF5F7;
	Wed, 23 Oct 2024 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693839; cv=none; b=GZdycmYjP25vscXaTBcIecdhhqkY7OeB2VSsybHe8Y7BvIU4vZGm9b7YYjmVFTQW5puyUDdwvyVVXZu58hw9PUE9C+vNvrNjJ5+/9+bDcRPy4FqAdX2V63qS54G80BPKQAhpYEu3QGdpWU9j7lJGtZJFQFpPfpyF9YhHiLmHfAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693839; c=relaxed/simple;
	bh=mfJRy+rYwPbNCeTCcqg3cZQ1W1UA6uLvQa3fW+Ha6cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/ifdW5uQloHJfYEGXS4gj29ySmQ/pCwxPJfiUGg9bI20BXnXvVVaPi6D6WsnAMtQtDjDcQ/r8whPHBvaLsXSTskf4rjCnkWgQ9HMBoUoepHl4ZwH6GMTqeEfvRKWgVjIZozADEbPOUjx0qnWVZGt28/rHki9Z/jgkU8bdkqti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrvXcTqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrvXcTqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A015C4CEC6;
	Wed, 23 Oct 2024 14:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729693839;
	bh=mfJRy+rYwPbNCeTCcqg3cZQ1W1UA6uLvQa3fW+Ha6cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrvXcTqE8Z68eUpHWqnA3YKTIKTpIpUCap+D6FYpvSU6maM68fR+qnZtnm6nDeu3r
	 WcRymjTzwbU2SomEc8eavbVOVYk5rCHho5CQc4hCtfykBG0IhZLDfYuw6t64VXww04
	 Xr+Hy9T3G8hAQuz2knAdQZEkEIVrrEPxZVG914hcll2u/15PDJwOVEmQB7X7oTej5q
	 IwQFOMzoCJVh0vYQs8J83McljkK1HYgWxMHwrDPoIsRRYb3oFHerTc6O+IxNkrEUMr
	 x+1VcHROFhX6aD2NzoaxffJaXJ8XrgouNID1DlMtlM64Wb2y9lhZYjoDKxpuWHFoiL
	 hr9HHna52Cp8A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 16/30] crypto: marvell/cesa - Disable hash algorithms
Date: Wed, 23 Oct 2024 10:29:41 -0400
Message-ID: <20241023143012.2980728-16-sashal@kernel.org>
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

[ Upstream commit e845d2399a00f866f287e0cefbd4fc7d8ef0d2f7 ]

Disable cesa hash algorithms by lowering the priority because they
appear to be broken when invoked in parallel.  This allows them to
still be tested for debugging purposes.

Reported-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 8d84ad45571c7..f150861ceaf69 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -947,7 +947,7 @@ struct ahash_alg mv_md5_alg = {
 		.base = {
 			.cra_name = "md5",
 			.cra_driver_name = "mv-md5",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1018,7 +1018,7 @@ struct ahash_alg mv_sha1_alg = {
 		.base = {
 			.cra_name = "sha1",
 			.cra_driver_name = "mv-sha1",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1092,7 +1092,7 @@ struct ahash_alg mv_sha256_alg = {
 		.base = {
 			.cra_name = "sha256",
 			.cra_driver_name = "mv-sha256",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1302,7 +1302,7 @@ struct ahash_alg mv_ahmac_md5_alg = {
 		.base = {
 			.cra_name = "hmac(md5)",
 			.cra_driver_name = "mv-hmac-md5",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1373,7 +1373,7 @@ struct ahash_alg mv_ahmac_sha1_alg = {
 		.base = {
 			.cra_name = "hmac(sha1)",
 			.cra_driver_name = "mv-hmac-sha1",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1444,7 +1444,7 @@ struct ahash_alg mv_ahmac_sha256_alg = {
 		.base = {
 			.cra_name = "hmac(sha256)",
 			.cra_driver_name = "mv-hmac-sha256",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-- 
2.43.0

