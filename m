Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F720CCEC;
	Wed, 23 Oct 2024 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693938; cv=none; b=eJj6XpI4wUm2Zp0dn0RWBTo+tT4jMeXQ8Z49a6sGBor4mDEzi3tKreql+Zo56EKmp3BbYDBo6rh0/V/WYgPCaCJU8eWCLw/Z0LxcCiVL60Hmk2iYsbEJ8UDM/7vfyitKkJbBGrojWHG8PFRjyBlI1L7kHgSlOH0iLBddnMVOlqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693938; c=relaxed/simple;
	bh=Fz39czHg0aX+V1rwZPzj22yzjG8Oyw065s614BD0V4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDqHSqQ0YiqPaO/7MUeXJrfg5fmPBVl0fdFzoQ43hkQqG+jSZG1A4OTilfdqmRPD4zztGXlifHNT37WzxG6sPfKRQJVeHimR4MCdhFEh13qeNpOgVhYQHSnc0Y7KrA7QSF9aEySEGON49knWVgJd62+FM1GiTG67b1G90SvToiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7lEhSY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7lEhSY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416C4C4CECD;
	Wed, 23 Oct 2024 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729693938;
	bh=Fz39czHg0aX+V1rwZPzj22yzjG8Oyw065s614BD0V4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7lEhSY4xYcCGBoAq8WG6l+1esYes3rHLoGDV44rDUw9R409WmvE6WdQKTAsk5dQa
	 tQGEPCb7uGUZQaleQiZt03nED+/mGIlYZ3YdGqM0H+wEouDZU7s1JI8mI7oGT5nPaS
	 Ez0CA/aWw7kPsB7ltvAAPJEcqnVF5yZFAAK+anvEM8g2PSFLi4Nobaxs/h9QeurrT6
	 XNJ398YXFTGTi0XICiJqfE0RVftwjluxIvbul+0iTrNZ7qDX3cfdxlriar9Fh7LAuq
	 S9Pv1Xp+Ez+erLJwemX1NEKY5Qp1jPrJdNuaYhEE+KtXp4od07FW+G2OsRA3zUwrB+
	 YJi2TpragwV/A==
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
Subject: [PATCH AUTOSEL 6.1 10/17] crypto: marvell/cesa - Disable hash algorithms
Date: Wed, 23 Oct 2024 10:31:49 -0400
Message-ID: <20241023143202.2981992-10-sashal@kernel.org>
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
index c72b0672fc710..84c1065092796 100644
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
@@ -1327,7 +1327,7 @@ struct ahash_alg mv_ahmac_md5_alg = {
 		.base = {
 			.cra_name = "hmac(md5)",
 			.cra_driver_name = "mv-hmac-md5",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1398,7 +1398,7 @@ struct ahash_alg mv_ahmac_sha1_alg = {
 		.base = {
 			.cra_name = "hmac(sha1)",
 			.cra_driver_name = "mv-hmac-sha1",
-			.cra_priority = 300,
+			.cra_priority = 0,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
@@ -1469,7 +1469,7 @@ struct ahash_alg mv_ahmac_sha256_alg = {
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

