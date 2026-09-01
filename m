Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA095412C0D;
	Tue,  1 Sep 2026 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274696; cv=none; b=MX/AwEjn4P3/VpBOrAPm3FQejIHjxdGAk3aTZszm2AeBrAe6/UK1jCC32KIWXlVLQksPZ0SY7A1FkyF2lmPTTE4Pf35Zhg8LCBTOvsz4bkX/ISgT1/JR99wvcJOla5Dxpcr1/En9MWX8pNs2wBRGy7fqun4zXgWnnX4CK9CznRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274696; c=relaxed/simple;
	bh=8EtIjUyWp+Owf958VUqMsdagPce6VSl8WYVhBIP0kNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjFkrE+MM3HWaWRk4aLrNhuz65SkaIcEefRS9pt8zO7DYqfaUj7TcxNtwiOn06xR071k96nVkyc1dd6cZGlq6+HevxTSTOrpcW+Lu/xuPv6SrJgOqZh4qXYXcYemLTt/5eHImlg6qnmGOVFULTyh7as8vziotMhGjIqHCh37oek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YawVhUJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YawVhUJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2676D1F00A3F;
	Tue,  1 Sep 2026 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274694;
	bh=r4lrJRkT6oIO9uz4byVKnhiX3ckXssiVruBvq7U+FfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YawVhUJAl4XJC+0lJg0JqnzvyLoGpclba5vFqMseu8aQdeAfRNCqF/n89C5BFnRn4
	 ZMgZnt00svTZ7gKmJhtJ04BvxTdeX+//rW59BNZmOABb8rXM8WE4tuFSRJOTY0O+a3
	 wzlzCcKF1wjNushRp8DgVQU/dXj39smX7CyBzSJH1YujqkwHIJgLd/5F0hTLEiXvwp
	 rpILnJjIGoK4ZqXwRp1daZvUbnKwICqiVWNfsFNqVZML5vihbF6lJP71+QoQZ6nnn8
	 cGO6BziajnHnrbES/E803CCkdcHeqva1iZHlGmQ767J9u+QH407m0Ng6QB+EJcNiWk
	 vNW9n5eYCeh4w==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 5/8] lib/crc: x86: Stop using cpu_has_xfeatures()
Date: Tue,  1 Sep 2026 07:57:37 -0700
Message-ID: <20260901145740.42337-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901145740.42337-1-ebiggers@kernel.org>
References: <20260901145740.42337-1-ebiggers@kernel.org>
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

