Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AAA3BCD19
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356566; cv=none; b=LcQgXjDyaIsX2RVl5zG9F+pV6/1HNGvGXhiEubt8ATpBT5vBZXilg4xucmlv/bhsy+2e4GTkPAGXII7CEuKyUBP3JHj99G5clxVI5bLEIU2Q9kE+tym990V4Xg/GgCXtO4aiZg5ZWkdWgjzEq2alCJfW4lKSOeZu+FyYoc7FcfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356566; c=relaxed/simple;
	bh=wA2DFP5QYre8UE8luaUhdeKRaZd7iVH2ulh0OWK2pVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYs2Bxhwx8vjlCRjJUczz17vYnbAh5l6APZLM27AaEuu2UQm3VfJOgKR/01c+pqyB4excrXASYCqoBc9q6A9GLqPjeuDut28Lok86vL/hXafdo6boCFdQmgLYOm2N4k/goG2i4dO2WC2VHBTYm+IP+TwrB/Iu5RL/x3GB9ipN/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iDtHmqHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iDtHmqHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9262A1F000C6;
	Sun, 18 Oct 2026 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356565;
	bh=JeCT5NvK+IWUBxjdMWuYjQpmsHpXZJuz/GpDmh15CV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDtHmqHPxZYoV+yj/frcHZ13cpwYMAG8TVWM943p9DTLLrViOXwxkCKcDD3MdRfx6
	 sJCjb71zcEQpfyAtBjhUnuH20a0ChvocHWrO1xKrN+qgbnlHOC6h/+739Cyt5m8fCq
	 XELln2hHqTf98YuYez1eGrhJ0tKqgVsB9geedLeVIrPGdHgGypqzcomUaeYO5B4byG
	 39ANW9F+Ptp/jSJTXQKEGi+4/kBuqXVnnD42ApJweTYYmSSJ8dPJ8gvbcpK+Eu+bpH
	 WQuFDLWOO5No3F2Z0sO42+O9vZZboh7itvV5qqREXOsc2394RwSAYG/wZpkP6L5J9c
	 /Tmr7t5+dyZsQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 01/14] crypto: drbg - Don't use uninitialized stack data
Date: Sun, 18 Oct 2026 13:46:05 -0700
Message-ID: <20261018204618.104876-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>
References: <20261018204618.104876-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If jitterentropy fails, then uninitialized stack data is mixed into the
DRBG.  While theoretically okay, this is undefined behavior and isn't
allowed by KMSAN.  Fix it by zero-initializing the buffer.

Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B compliant noise source")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index d66c7211d6bb0..e057b00e74f5b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -230,7 +230,7 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 	__must_hold(&drbg->drbg_mutex)
 {
 	int ret;
-	u8 entropy_buf[(32 + 16) * 2];
+	u8 entropy_buf[(32 + 16) * 2] = {};
 	size_t entropylen;
 	const u8 *entropy;
 
-- 
2.56.0

