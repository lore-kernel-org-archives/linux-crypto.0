Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B351B392824;
	Fri, 26 Jun 2026 04:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448767; cv=none; b=uka309d+HTcgZfH0hFy1ZAbbtFq7OmojSl6wS+FmgXbpF0IrymX0gYGD3WTp/TT92VivT26+ntnFFbobrMzEMDgCyNzlzfQNytnAINR7eSYpL5qgDf4Bpc2vum4hLKWNideXGvFAeFeT2wvfl798JTxP3tgAEoXwEDsA5/t0vbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448767; c=relaxed/simple;
	bh=Q/DMRtdqxaGO65Sg+egeKYiVC2FcUvSPzHwXRnlzicY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ63TBQal4TceM33MfAiiwPbQ6/ctyvcTQsqkRC2hkWFjBrX000vFqQ6WjPjE2KWMsbiTOLm1L6LWjVEEhRhSzAinfgUFeMEqQzoTbpYNx9OVMxL+3CPrBod+1nd+GTkAY7psxDMrOYyJOQquWM+goavaV1L1MWevWLB/cymOTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVLb1Na6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVLb1Na6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BC21F00ACF;
	Fri, 26 Jun 2026 04:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782448766;
	bh=2iQ1W2m2jf8sj+hQjMAm5tIGc8YEMfT2gTSRmmRaOPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVLb1Na6vRW/fQEpxj+xBekGf4TJSfmPUFKPvbVOcRIz4ei9eERfowt4+XRMABSFF
	 D7W2gMeJi0nl6yddDwo15rO/Jrpt92HL5e7cgAyXsi4ts8uGTTE39S8rfZ6MnkIbpK
	 qJIuxvWrn+vNnJUx38PUyXoM327Mqse/HH5pZl+u9BqSRUiSzZShh+xDUjA5csOnHr
	 jlRc1ZGtx5GgJg6sMqMO6dJOhukaAZKHDGZZCO4SdqnRWwm9QScpS7ev7DSClnxHLX
	 XTscV6I054J8b2JI/UyzrSlIx6OtYVq4AmqHalr5TXN7OQre9L5QW7h+86K6E5W3Kv
	 12J3YzI6Cn0ow==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7/8] lib/raid/xor: x86: Remove redundant X86_FEATURE_OSXSAVE check
Date: Thu, 25 Jun 2026 21:37:30 -0700
Message-ID: <20260626043731.319287-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626043731.319287-1-ebiggers@kernel.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

X86_FEATURE_AVX implies X86_FEATURE_OSXSAVE already.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/x86/xor_arch.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index 99fe85a213c6..991abe3f4bbd 100644
--- a/lib/raid/xor/x86/xor_arch.h
+++ b/lib/raid/xor/x86/xor_arch.h
@@ -16,12 +16,11 @@ extern struct xor_block_template xor_block_avx;
  *
  * 32-bit without MMX can fall back to the generic routines.
  */
 static __always_inline void __init arch_xor_init(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX) &&
-	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		xor_force(&xor_block_avx);
 	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
 		xor_register(&xor_block_sse);
 		xor_register(&xor_block_sse_pf64);
 	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
-- 
2.54.0

