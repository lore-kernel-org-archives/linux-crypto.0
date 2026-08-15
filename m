Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9199B42642D;
	Sat, 15 Aug 2026 18:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786817558; cv=none; b=MkEOsqJbUpnlkc2rzAr/onvqp9R8rcHF6gB1Z4mIXhirX+Fv8JBVaGeM0g2wWrFCHvpZ3wRXH/uni8iEmZnHX2XbO1epem7PZuV2+sMz9oXHv5t726BnICX8ekQb32HI0TT46aSIkGd6t46Hvpp7c23McccNpqCQ1HUZXbkjaR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786817558; c=relaxed/simple;
	bh=8EtIjUyWp+Owf958VUqMsdagPce6VSl8WYVhBIP0kNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNV6SArXfVDb0BlQM3Q8AXIvSg/5jlTmLdL0B70lmwemMlgVjxaYGDn8/OP7S5xWSqXX3nZ8SSEclbDzHiiSQsB6dwBBHKG3S9cH9G+nhPOXMJsySGPf2FfR3ki7UgXMx7hbV2oixzJuXqioFhXsnlZjdnDdx/AZxFXp/yX3NkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED6NroIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED6NroIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2757D1F00AC4;
	Sat, 15 Aug 2026 18:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786817555;
	bh=r4lrJRkT6oIO9uz4byVKnhiX3ckXssiVruBvq7U+FfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ED6NroIYBJzgy6GwIXX/cesOeyUD3VDuuZyQIjm2HwR6sb+3QteysdUjScX1ftRxI
	 Hgp14z/4FXsQ/2Uhuw/3GuxKs7HGwPtmLmt9Xxz8wTH8Oc7NBsOQxOdNlkTLKvAylE
	 JbpJJ6FoLsYjja1a88ouhRH2roiid2VsyU1Dyr0WuqGj3WJkJvulSIbyQPS01w4XsK
	 VgciHopL+mGOoS5XvwQymfKOW7tKjammPIxPKdTepdtZiYaK1v6bzbK8CuX2/FT01Q
	 tvBzaj6V9UyJnAsywJwSO5rVyybgfHgwfqeXMgg8XQLmUngpLhsias4TN0CMrFjBmV
	 UdNgCrnd5UTyg==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 5/8] lib/crc: x86: Stop using cpu_has_xfeatures()
Date: Sat, 15 Aug 2026 11:10:21 -0700
Message-ID: <20260815181024.28924-6-ebiggers@kernel.org>
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

Checking both boot_cpu_has() and cpu_has_xfeatures() has never really
been needed in practice, and it's never been universally done (e.g.,
lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both x86 and UML
now explicitly clear the AVX and AVX-512 flags if their xfeatures are
missing, which should remove any remaining doubts.

Thus, remove all the calls to cpu_has_xfeatures().

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/x86/crc-pclmul-template.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/crc/x86/crc-pclmul-template.h b/lib/crc/x86/crc-pclmul-template.h
index 02744831c6fa..893119bb7c07 100644
--- a/lib/crc/x86/crc-pclmul-template.h
+++ b/lib/crc/x86/crc-pclmul-template.h
@@ -27,16 +27,14 @@ DEFINE_STATIC_CALL(prefix##_pclmul, prefix##_pclmul_sse)
 static inline bool have_vpclmul(void)
 {
 	return boot_cpu_has(X86_FEATURE_VPCLMULQDQ) &&
-	       boot_cpu_has(X86_FEATURE_AVX2) &&
-	       cpu_has_xfeatures(XFEATURE_MASK_YMM, NULL);
+	       boot_cpu_has(X86_FEATURE_AVX2);
 }
 
 static inline bool have_avx512(void)
 {
 	return boot_cpu_has(X86_FEATURE_AVX512BW) &&
 	       boot_cpu_has(X86_FEATURE_AVX512VL) &&
-	       !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&
-	       cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL);
+	       !boot_cpu_has(X86_FEATURE_PREFER_YMM);
 }
 
 /*
-- 
2.55.0

