Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65E8305066;
	Mon, 10 Nov 2025 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762771502; cv=none; b=m6AIOhh2xUOol0HkFLXVKJMJIoAK5ct6n48IZJ3VL+pgQH8GVSeKVbjGMbwLICqUESG9DVzUsCKHBMcAB0OywbgetNncfye9VdOCYmTP3X0hgwQDj6szJ6SZne7GIX9533/ATDXAeLI94INYUaMY6WtnVH82gIybcLxKu4DAKV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762771502; c=relaxed/simple;
	bh=D4tyGM1CQgI1ziG0RQbhNZECmbMmY5A11qAo6a2a2e4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ItGQ5GHyjkGQt44pgPkFc3sp3qT82QGBfDVFM10Z9nOgXEO26o4c+MvONlyVO5FODim3/jQIznOFzSFQwFOd7FVhIHxJONtd23fu0b+FgPLYR/GuL5osnKSPJTv33cP4hwDXpNAehomzjGSmq/vczI7nc9fQ3O0cfIZitsGkXiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tC88qsCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tC88qsCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291B8C4CEF5;
	Mon, 10 Nov 2025 10:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762771502;
	bh=D4tyGM1CQgI1ziG0RQbhNZECmbMmY5A11qAo6a2a2e4=;
	h=Date:From:To:Cc:Subject:From;
	b=tC88qsCi9k6L11GefVVW93h2kX10rCM4CGhI/FrZelUkSG+DGSi5jA07TGBQsILya
	 E//UR9X52n4YzJrPtXggzh259gXb+zfHkquUgkQgwDmvdUem2AJFBhcnOujHTKdmQ1
	 KZScj0QcQ/Jh4Ru34+n4Amw/rDjWqSTi1XGoeXJMl4hulRv/i0GoJGjQOVA0cuo7D9
	 CiegkGp2nycTepeZww+v7I37a+UQgQhv2AeXjE6gsywxJSzLQLggjHmxj28JUAee++
	 RYP3OwlRmX/PROMxPhVIK6OKyFCTNukVRmpQCUUMYCt1eJ6nt+osHf7TaaCtK1EJBk
	 grAKquaynQtNg==
Date: Mon, 10 Nov 2025 19:44:56 +0900
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] crypto: drbg - Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <aRHCKMGDbWkXIY8f@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Use the new TRAILING_OVERLAP() helper to fix the following warning:

crypto/drbg.c:1445:27: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

This helper creates a union between a flexible-array member (FAM) and a
set of MEMBERS that would otherwise follow it.

This overlays the trailing MEMBER char ctx[]; onto the FAM struct
shash_desc::__ctx,[] while keeping the FAM and the start of MEMBER
aligned.

The static_assert() ensures this alignment remains, and it's
intentionally placed inmediately after the corresponding structures --no
blank line in between.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 crypto/drbg.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 511a27c91813..e9f9775c237f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1442,9 +1442,12 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 
 #if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
 struct sdesc {
-	struct shash_desc shash;
-	char ctx[];
+	/* Must be last as it ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct shash_desc, shash, __ctx,
+		char ctx[];
+	);
 };
+static_assert(offsetof(struct sdesc, shash.__ctx) == offsetof(struct sdesc, ctx));
 
 static int drbg_init_hash_kernel(struct drbg_state *drbg)
 {
-- 
2.43.0

