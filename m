Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF6C42A155;
	Sat, 15 Aug 2026 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786817559; cv=none; b=Tv2tznzpP99qK+ZpzPD1rr64cpDP8Q564i+VlMyfo8YFxhI9zpINz4wYHA/hHdHoi0jq7kJQO3mic0lgLsy1VnYO8ZhxRMnJaffN0XMimJdxM6VC2YUgWL65y8NQcFqSLzJUfiAN6sSFd58OBXsjwtIg7fR66MHtA3mWw/YPf/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786817559; c=relaxed/simple;
	bh=bURSDeOHD7BeXhOUO95qSmh0YND+CXXzB5NqaBliqI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpASUIBT7sbxWYI6OWadWt+2qnBVRuWjc14WTXjjOIgVTMYxRdxUgfyg1O7XsDm/fEClYrsM1h+RR3PVeooTj+kmt54dLC0ShRHnBwdI+qRvsv8lqy/oCKgnI5IjFyAPQH3jG8JbtdBWofe6UUsoxZQISeihgzEfsQNnPwE9Tmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldjMJ+im; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldjMJ+im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EFA1F00ACA;
	Sat, 15 Aug 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786817556;
	bh=CGFmBktDb18Ou8jdzee9BRhN2jpwroPuYWGDnSphFl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldjMJ+impcxexn1BTzwXKM0ieYKC+W9D1FQGgpAGZUCFZjnldAnVMlyHPjyd6kNrm
	 ceUwaoE+eHz3jmAd+5aWvSLW3jYxwFVNyhz4QlmLOe2jpgpE5UOhNI1UFJYLY2uDTv
	 1CvCina8Qp/l4r1TlhDDl9CsjMNgxUDvTR8ifzaIwj3qs1/6ky561iQcv8QTbCfHRL
	 jHIYGO/67OninbV3QcYvCqjkgngQsw2u2QzfB82dHTArMxdSkbQOQ6UxLALx2HruZV
	 JV80HbZQ0+Pt6j7jR/ahsiWXylADEMLCz5UMMWTlwWkuh3UfIm6YRRXTl5juK85zrJ
	 v1da6pUA1ddxA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 7/8] xor: Remove redundant X86_FEATURE_OSXSAVE check
Date: Sat, 15 Aug 2026 11:10:23 -0700
Message-ID: <20260815181024.28924-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815181024.28924-1-ebiggers@kernel.org>
References: <20260815181024.28924-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

X86_FEATURE_AVX implies X86_FEATURE_OSXSAVE already.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/x86/xor_arch.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index 99fe85a213c6..991abe3f4bbd 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -18,8 +18,7 @@ extern struct xor_block_template xor_block_avx;
  */
 static __always_inline void __init arch_xor_init(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		xor_force(&xor_block_avx);
 	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
 		xor_register(&xor_block_sse);
-- 
2.55.0

