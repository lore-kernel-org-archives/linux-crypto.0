Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0894274FEB;
	Tue,  5 Aug 2025 13:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399465; cv=none; b=aw0/+UnHQCvCciApddAQcI/4i2VMT5z+EXrpxmrlc2mQaAc33YJaIl+Hdzg6q3mSZVPIN3zvh/mioYasnuxBuNLw7CQ6ZYKUWQkwfnKV9LfKvj2MrZJOMYbWch9nrZTk2xRaQ6De9tM9JTcbGayvKzj6TtJCAjuJoqvAqG1lslw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399465; c=relaxed/simple;
	bh=X0gOUKeAzbeMAL2QL4SnN2/yOMfwzAbHB8kdOdPSVuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n4dVxL/wUoJQly51oKxrlhvXOekY7HB1V3niPg9dpy/eFtF2Y1EzXNHjP/bhckuOxGyO7ZUO8bZjnVsmqGnrC9DqyqRfRCqMfafmXyRMJ9C0smzXO1ehH+gCR+lPOKRh3nWTNSl8sZxfWGCRPH+zd+U8xQ/rvAgTvSS27jtEpHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFzTL3+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFzTL3+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3B0C4CEF4;
	Tue,  5 Aug 2025 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399465;
	bh=X0gOUKeAzbeMAL2QL4SnN2/yOMfwzAbHB8kdOdPSVuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFzTL3+tRzgXHGqfMgCOoi8jQXgTuGI8u3NzLFH+9EfdYII1rZpwFhn5E5ZjoY2Tt
	 cbk+AXBXDwjG9O+ai2P9xwfVIr8Q1iZ+UsDCzl/Nz+P+cTqWshRYb07bihnRC7LkeA
	 j0GACb7PXr7GXOD4n/DjSxp58R+RqmCoCDn1UUQxhokXZIyaIakI1LDj3I/LUZZT2D
	 G5l0vz81ov5tJxI2Kjl0iVuELHQ1OYiCdWzdwZu2itcUiO2P0li5Wr287q19Yvy26L
	 8wgEK7rFhPyB5S8JtK7qSgoacixfzn05vMnCYWgwfbor0t+VR/VPG1KFxCP6K3tHm4
	 /EWb4y8pe2GXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Markus Theil <theil.markus@gmail.com>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.6] crypto: jitter - fix intermediary handling
Date: Tue,  5 Aug 2025 09:09:11 -0400
Message-Id: <20250805130945.471732-36-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Markus Theil <theil.markus@gmail.com>

[ Upstream commit 735b72568c73875269a6b73ab9543a70f6ac8a9f ]

The intermediary value was included in the wrong
hash state. While there, adapt to user-space by
setting the timestamp to 0 if stuck and inserting
the values nevertheless.

Acked-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Markus Theil <theil.markus@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Status: **YES**

This commit should be backported to stable kernel trees. Here's the
detailed analysis:

### Bug Analysis

1. **Critical Bug Fix**: The commit fixes a bug where the intermediary
   hash value was being updated to the wrong hash state descriptor.
   Looking at line 147 in the original code (before the fix):
  ```c
  ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
  ```
  This was updating the temporary `desc` instead of `hash_state_desc`.
  The fix correctly changes this to:
  ```c
  ret = crypto_shash_update(hash_state_desc, intermediary,
  sizeof(intermediary));
  ```

2. **Security Impact**: This is in the jitterentropy random number
   generator, which is a critical security component used for entropy
   collection in the kernel's crypto subsystem. Using the wrong hash
   descriptor means the intermediary values weren't being properly mixed
   into the entropy pool, potentially reducing the quality of
   randomness.

3. **SP800-90B Compliance**: The second part of the fix addresses
   SP800-90B compliance (NIST standard for entropy sources). The
   original code would skip inserting the timestamp when stuck:
  ```c
  if (!stuck) {
  ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
  sizeof(__u64));
  }
  ```
  The fix changes this to always insert a value (0 when stuck) to
  maintain consistent input data size as required by SP800-90B section
  3.1.5:
  ```c
  if (stuck) {
  time = 0;
  }
  ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
  sizeof(__u64));
  ```

### Backport Criteria Met

1. **Fixes a real bug**: Yes - incorrect hash state usage affecting
   entropy pool quality
2. **Small and contained**: Yes - only 5 lines changed in a single
   function
3. **No architectural changes**: Yes - simple logic fix, no API changes
4. **Critical subsystem**: Yes - affects kernel crypto/RNG subsystem
5. **Low regression risk**: Yes - straightforward fix with clear
   correctness
6. **Security relevance**: Yes - fixes entropy generation which is
   security-critical
7. **Standards compliance**: Yes - fixes SP800-90B compliance issue

The bug could potentially lead to weaker random number generation, which
is a serious security concern. The fix is minimal, clearly correct, and
has been acked by the subsystem maintainer (Stephan Mueller). This makes
it an excellent candidate for stable backporting.

 crypto/jitterentropy-kcapi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index c24d4ff2b4a8..1266eb790708 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -144,7 +144,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * Inject the data from the previous loop into the pool. This data is
 	 * not considered to contain any entropy, but it stirs the pool a bit.
 	 */
-	ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
+	ret = crypto_shash_update(hash_state_desc, intermediary, sizeof(intermediary));
 	if (ret)
 		goto err;
 
@@ -157,11 +157,12 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * conditioning operation to have an identical amount of input data
 	 * according to section 3.1.5.
 	 */
-	if (!stuck) {
-		ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
-					  sizeof(__u64));
+	if (stuck) {
+		time = 0;
 	}
 
+	ret = crypto_shash_update(hash_state_desc, (u8 *)&time, sizeof(__u64));
+
 err:
 	shash_desc_zero(desc);
 	memzero_explicit(intermediary, sizeof(intermediary));
-- 
2.39.5

