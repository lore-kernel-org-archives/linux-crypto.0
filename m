Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A413343D72;
	Thu, 13 Aug 2026 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786587622; cv=none; b=WeZ5zdFHAQX2Y7I92+vNryNsYK3QbESDtinr7sjp1s4pzznbnbTU5dvEU7Gyyodi7j353P6eUfEAq65Q2NlBEuMKpG8nbXL2e5XP87peym4T0z1j9vuzMiMTzu8vhWR0KNLzL9Hqa5Klj529enxpcCmgDd5x+eSorlj+BI4wYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786587622; c=relaxed/simple;
	bh=bURSDeOHD7BeXhOUO95qSmh0YND+CXXzB5NqaBliqI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABeLUD6mN5JXtQiTvL65G4wLLWcb2nX40VHrjjSF8oHT7Qx0lFYrY2W+X69TO1RC2IRYwdh9DhaKIpp+vFt7iDdLUEQ9vrfQ1baT4vFn9xBnELHbfwDg7BJRkBja2Myx3JD/NHsBn/sbpZTCdLMg9texR/JDl0RnTNCbsadCT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtDbgGp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtDbgGp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3151F00A3E;
	Thu, 13 Aug 2026 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786587621;
	bh=CGFmBktDb18Ou8jdzee9BRhN2jpwroPuYWGDnSphFl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtDbgGp6IL8GZ8uJj1u1T7P4Uc1PgQXdz1qtwXGQ5moJuYQoOjFBNKqxKWrhENLVs
	 KMg+sJomVyF5ueu4LHaO2EjLI4lylQOCQSQi2Y6+yBU9MVv3i+hYymm6z214Fh+4gv
	 3tdkqQ9/QekaowLkneojwQCIIdAi+qnhMZy8l274Z6oyVxomgJ58j+dmWcaiSj4wiH
	 Yc9Sz3gpmA0BojOuppbwB6EvwDHAxpN29jtbq2lRDRzQHjeCywZHdt0v3P8lqIFe6P
	 q2VIxg1ZH4hMmzRC4l7gUtom3XA6m0+nY9cnr+svy2rtGr4NQmhdBP7AZaF/uOvFOQ
	 7DxF3aiAGO3pQ==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 7/8] xor: Remove redundant X86_FEATURE_OSXSAVE check
Date: Wed, 12 Aug 2026 19:15:05 -0700
Message-ID: <20260813021506.55129-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260813021506.55129-1-ebiggers@kernel.org>
References: <20260813021506.55129-1-ebiggers@kernel.org>
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

