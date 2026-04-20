Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830F3382F12;
	Mon, 20 Apr 2026 06:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667020; cv=none; b=FP+5RrhLRyMq69/E6SE/BL2t5tTSW14VEnIoUAPNmlwPzVVpVKaL8UlBGjP/LbEhZK1R2z1pOwSPG3O1GF984iD+7hrRJzEdiNafSx4eEUo/DOCNsI0CWpHR7PE2HWdsMSmoDI1m77+5ElnjH6VJ7cWcO02EtKwmvnEpU2dWAtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667020; c=relaxed/simple;
	bh=othQOxd/3rop0A1viyxlHVjq78QZgCky3GUdxbIdsWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLJU2pPFWpw2UgnJ/vhwqsTv5ojMR+x1mlZULfYwfMU3yswyr1a/2ayoP9J5mG+pF+EqMKczhl+T2B8QjAZptNqtAFlgQYmQ5mStGbV3c848mPyY38P8ZSZm4KUtuBfJp57OtKMDFxXx90Ka5deNlqEO4gzTpqyRE5M8w4DgMOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJkyWjsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJkyWjsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3398C2BCB6;
	Mon, 20 Apr 2026 06:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667020;
	bh=othQOxd/3rop0A1viyxlHVjq78QZgCky3GUdxbIdsWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJkyWjsge9nNgsM4ouS1BF0MkQbnaTRg19SJoXXbZFg1R39cdEgnlpjlTlEhO6omQ
	 dCn89o8oqkAB8uCt6dfK/ZtlKNeEwARet31mQUXdQPo3lY+NGRTNk8+quwcN6Ni4aA
	 8uAd2GAgDMHsri5pPcR/UMdph6TLhyg9CF2/Ns6O8U74QGzwSUb/QsOM+EBksUNXHC
	 Os2Pm/if1CEnnNYlrwgp/G2EF9PHXG1RE9BM903ecxwYz3dChVeSc/zejAwC6H6eRI
	 RbFIDhAnLcWPAzOHDVGJF7WjQk5LyS4iONicUuNgoHejNXKg0skqFoEI7cBwNdUw0W
	 1kA5tpRqF0QuQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 03/38] crypto: drbg - Fix ineffective sanity check
Date: Sun, 19 Apr 2026 23:33:47 -0700
Message-ID: <20260420063422.324906-4-ebiggers@kernel.org>
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

Fix drbg_healthcheck_sanity() to correctly check the return value of
drbg_generate().  drbg_generate() returns 0 on success, or a negative
errno value on failure.  drbg_healthcheck_sanity() incorrectly assumed
that it returned a positive value on success.

This didn't make the sanity check fail, but it made it ineffective.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index de4c69032155..f23b431bd490 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1735,11 +1735,10 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
  * Note 2: There is no sensible way of testing the reseed counter
  * enforcement, so skip it.
  */
 static inline int __init drbg_healthcheck_sanity(void)
 {
-	int len = 0;
 #define OUTBUFLEN 16
 	unsigned char buf[OUTBUFLEN];
 	struct drbg_state *drbg = NULL;
 	int ret;
 	int rc = -EFAULT;
@@ -1780,15 +1779,15 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 	max_addtllen = drbg_max_addtl(drbg);
 	max_request_bytes = drbg_max_request_bytes(drbg);
 	drbg_string_fill(&addtl, buf, max_addtllen + 1);
 	/* overflow addtllen with additional info string */
-	len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
-	BUG_ON(0 < len);
+	ret = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
+	BUG_ON(ret == 0);
 	/* overflow max_bits */
-	len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
-	BUG_ON(0 < len);
+	ret = drbg_generate(drbg, buf, max_request_bytes + 1, NULL);
+	BUG_ON(ret == 0);
 
 	/* overflow max addtllen with personalization string */
 	ret = drbg_seed(drbg, &addtl, false);
 	BUG_ON(0 == ret);
 	/* all tests passed */
-- 
2.53.0

