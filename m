Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A44827B32C;
	Mon, 20 Apr 2026 06:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667019; cv=none; b=oRuc3KxcF98flTwG39A8OX1XqkYzw58a6v2oC9bWWxg1LjByYdnT42yS0KO3QW5BlNgcb1NyA5foSixyllA0EC94MVkWjh4u4D6dXZtnw0BU64a4Vu7ZSjxVLWg38452EUY67MDU6wou8tYsvjf3zSTGpkTXnpq9x5ZDOpOVQCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667019; c=relaxed/simple;
	bh=tQILfFsL/hnHLqwLNvwZxnBt0aOuhm1HIFoJHd3wkJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESD+mPS6oyBg1R8p3Ppr7y8I+spSajHcxa22nJlLjPVG9TGoAC5Yqlg94Bo00V13YF2PGubshUaT6a+UFeLrytEaMaro9UhBuzq+FOhOol3FwXDdehuC1wwxgN16eDlmlisBEa3HbqbPa6vGma9/or2Ltj9BVYACrNpwRVbU6pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENAlfXXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENAlfXXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C0CC2BCB7;
	Mon, 20 Apr 2026 06:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667019;
	bh=tQILfFsL/hnHLqwLNvwZxnBt0aOuhm1HIFoJHd3wkJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENAlfXXsjCwKN3UqOcvb8RiWx7eUrIBgcJfcc4IcDnmCqF5D7j3dWXcGzVuuHIqvB
	 GPycKy+PztdVaxnU9bZJ5c3r3PUWijKtUAHgPuyDxftrgOhtsAheIGgtNWAQZ5smlI
	 D/USVxC/5FhcclC90v+KDyV2i75tDZAWWSNvpCrdPEEM9Ca8SQuj8XG+NJu7AB2wmf
	 RFhiNzMrupj1ud+x6tbCAgPndNg9tW08RjFa5b0R0w8An+DmjumBJHya9KPhzhBB2j
	 6u82jmK6HdddYa02h4+u5pHn08DazQMw8SCiVr8B9DlHamUp3hKFQKOJepmUnTOb+X
	 M/dLdzjzAQh2g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 01/38] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Sun, 19 Apr 2026 23:33:45 -0700
Message-ID: <20260420063422.324906-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

drbg_ctr_generate() sometimes returns success when it fails, leaving the
output buffer uninitialized.  Fix it.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9204e6edb426..e4eb78ed222b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -375,11 +375,11 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 
 	/* 10.2.1.5.2 step 2 */
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */
 	ret = drbg_kcapi_sym_ctr(drbg, NULL, 0, buf, len);
 	if (ret)

base-commit: c1f49dea2b8f335813d3b348fd39117fb8efb428
-- 
2.53.0

