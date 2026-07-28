Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9894E2FDC28;
	Tue, 28 Jul 2026 02:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785205159; cv=none; b=V8PpoSufKyBOWV4ah1A0zUPO3AsZKgxGBDs2/DR1BY4U6riYgzsUHwFPHUPJwciXmOs5kqixK4QLawmounzC2FQwr0OLbSSQn0v/DsARjjw2/XdE8ig+WtMw5vXavXssykbt6BkXKCZreNYyx3Vd/1u0yR2h5vTo0oSGRTmVpjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785205159; c=relaxed/simple;
	bh=G077jUrItJXVIm8a3rGBd58QsRrFmmpeQhQZ4FcNXGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXihjhjI3FfVEoXnRDjsUwezXdqWz9UlQLPmJRlsgV1NszUT+tfN884Wra42X20aCc9QIXgCiLuKCDX6/4yKgijIgVRKNd6t037hOnbArJnLbU2xwoDbdNNKwFdarcSsVuJAgvvqWvOP4FuLqv0Jjq5Qo7RwLzhLoLhaKdF8EVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuI8fwhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuI8fwhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316C51F00A3F;
	Tue, 28 Jul 2026 02:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785205158;
	bh=HMiKFAZj2EqdrOBqduG8yVaf68o12cJkn4oOC9yg500=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuI8fwhJNrbxGysASEL1aCkLjr58cW54O1pC+RCnMxd5IvQotVhNN53FSu/HI+e4K
	 QQ71rkC8FMX53FYK/2U3CM1MW5iCKFtWsq1Z004UuivFLKy+AYUPDNrY+UNR7p0xm/
	 xMSVirmembNvJPL+PWaCC93usJUEI9HMUY8QTKFOfCd66sBWHFYCIpqFpiZm0BVPeC
	 z+NpjOe4TZ/Ue7Bbjt8wI9MkW15PKxurtwVz3VdbhQjh7fyxWK8/AtUHjGDX8YTOjr
	 Al74Lr3tgywUZP0zro6q+a3rO+Cr7Oh0Oe4344I5MPin+VzET8O1hYhKD44q45L2Cv
	 uxop0WQo1tahQ==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 5/8] lib/crc: x86: Stop using cpu_has_xfeatures()
Date: Mon, 27 Jul 2026 19:16:00 -0700
Message-ID: <20260728021603.79870-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728021603.79870-1-ebiggers@kernel.org>
References: <20260728021603.79870-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/x86/crc-pclmul-template.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/crc/x86/crc-pclmul-template.h b/lib/crc/x86/crc-pclmul-template.h
index 02744831c6fac..893119bb7c077 100644
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

