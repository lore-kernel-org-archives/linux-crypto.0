Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E85351815C;
	Wed, 30 Sep 2026 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788028; cv=none; b=gj6euJZIWOH3ZNNDTYPwcbZLj1aKKpr1bNMdp4qP2ft4VKSeHqOOTTq4GhwisLxu0wp2DzT/tcYcImXI2dwuPpHIjTiMc1JZamU6/SGi1PAKmgXXIoYRoEBOn9rqtr+zmYXbrsH7/OqNBn4C4ow74J2uBmdP5Ontk5XLRbbEL+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788028; c=relaxed/simple;
	bh=ZmrDdIg+ZoXhKuR99woep/PXPG1hgSacAEHztW5FGpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+WyKcm0wUZlIXx4vs0YrvPOvRhjV+rX47v/bK9icidi1aqsWDy0jrXVEFqzTJO7YswAnpmjRWace6qZoT87gDyEtPfLSp6E4tjLuYfT2tYSuAb9UJVh0CVgsotXlTejH5vqxJRR0PUE+nTXFcCpQZz514MnQmnYcP/9rP8MR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIW+SxV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIW+SxV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0286A1F0089A;
	Wed, 30 Sep 2026 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790788027;
	bh=kTyKxbqKrbZQtW/eSj/KfL3UTibFKh9LcRgnCQn6lFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIW+SxV36zVCWkE5M5eCqN5pZF+W2/vH3Iu1wCHzEUAhGZApiW2MHBlf3zzQwzCV2
	 wjDrk/a+Fxrk1al0fuXL3aT8/WTFA/WpoeZKOCfCRQWZ/kfcGrQJ/GO/FCV+pF1y1E
	 ZMSlc/N+Gf0a3sL3ES6JTi1KGpIbIePx0nuxuIqjPMEe1G1yVeC+9CwPPpoCCqI8+R
	 U9dxWxX1YIV5kOWEO7MtJphgIxqyKk1IzlLQFzyOyK/Se8QnyLbVsw5y4D3BzjcZ9Q
	 Icz4V07YZGJFnOuueGZTC2KTLZ3S6TEp0VAVV+hNOFHfJJlHOdWPnSQw1gwbuc4yl+
	 svP8Es1n5XwhQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] crypto: aes - Boost priority of encryption modes further
Date: Wed, 30 Sep 2026 10:05:41 -0700
Message-ID: <20260930170542.140403-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930170542.140403-1-ebiggers@kernel.org>
References: <20260930170542.140403-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a regression where drivers/crypto/ccp/ (priority 300) and
drivers/crypto/padlock-aes.c (priority 400) started being able to
override the AES-NI and/or VAES optimized code (previously priority
400-800).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/aes.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/aes.c b/crypto/aes.c
index fe1f68a38daa..73f3aa856be4 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -611,7 +611,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "ecb(aes)",
 		.base.cra_driver_name = "ecb-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
-				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
+				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
@@ -627,7 +627,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "cbc(aes)",
 		.base.cra_driver_name = "cbc-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
-				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
+				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
@@ -655,7 +655,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "cts(cbc(aes))",
 		.base.cra_driver_name = "cts-cbc-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
-				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
+				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
@@ -672,7 +672,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "ctr(aes)",
 		.base.cra_driver_name = "ctr-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
-				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
+				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = 1,
 		.base.cra_ctxsize = sizeof(struct aes_enckey),
 		.base.cra_module = THIS_MODULE,
@@ -689,7 +689,7 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "xctr(aes)",
 		.base.cra_driver_name = "xctr-aes-lib",
-		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
+		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 500 : 110,
 		.base.cra_blocksize = 1,
 		.base.cra_ctxsize = sizeof(struct aes_enckey),
 		.base.cra_module = THIS_MODULE,
@@ -713,7 +713,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "xts(aes)",
 		.base.cra_driver_name = "xts-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
-				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
+				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_xts_key),
 		.base.cra_module = THIS_MODULE,
-- 
2.55.0

