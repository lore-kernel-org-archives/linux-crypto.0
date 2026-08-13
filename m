Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDED33B96B;
	Thu, 13 Aug 2026 02:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786587621; cv=none; b=kCrW2KnrXhg2TkV0PrOSL4e63Mqaj1PxX/WVBtmRUFjvRmTM8S6RZXNKgA7QqYxF+oNE6QcyimoZp2XOI3jLEsbNu1UprJWY3IiT9By8H6HgQH9NbZ5fGSnriuia/M1uQDE4Zzp9qJMu2ckPEsRD/95x88EB3+Bdl5flX5nczQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786587621; c=relaxed/simple;
	bh=8EtIjUyWp+Owf958VUqMsdagPce6VSl8WYVhBIP0kNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDkT0Y8E2kWcclS8QLM1YHVjBeBN8S9lJ0N064Z4cW1ft089b/QI1KIN5aN60jvO7BUKYDdWl0UpzkdL3WZc1nhaVyxNg1eOHLg9iS9rUpYPjDyt9zQVzEoGwI60zaIP+wZ4rrVJpk3CZljzhbU0gv3ht7Q04839houEDluQF2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgiWjcmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgiWjcmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7461F00A3A;
	Thu, 13 Aug 2026 02:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786587620;
	bh=r4lrJRkT6oIO9uz4byVKnhiX3ckXssiVruBvq7U+FfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgiWjcmVhU1gKXdR+1IvaeAgk+3vKhkKAgCls+SdvY1Tl+fuzFVGuERmu/8/5/3HY
	 bHrmDIWanBHy3f2c8rMsmLqWeUZwgU0coN5CVoWDwvvqvXW7z30hQIwWK12f0DIF2u
	 HhxzF4M1x4q4dhxl2cbfE4LH4QOgE0XDwWuT/CPangnuSbxr6G6YvYobfLgA0lt2zb
	 Xd8uulN7c2B868pVEU2hPJMnJyyiHScfLtFb79BjSIxb8ufNfzCuk/TqvjG/2nCDhZ
	 kD0k8awSpCP+jC6+fvdcUzbeOeh+fz6h93yD1A01DFetYFFPf5s3ChMqEESbT6bpGT
	 s6hav4GzWX3KA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 5/8] lib/crc: x86: Stop using cpu_has_xfeatures()
Date: Wed, 12 Aug 2026 19:15:03 -0700
Message-ID: <20260813021506.55129-6-ebiggers@kernel.org>
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

