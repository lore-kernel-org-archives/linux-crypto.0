Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0BB311597;
	Tue, 28 Jul 2026 02:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785205160; cv=none; b=GKgGRfbTQSPAhccG/EH0P6qgQ477Di20CPazroTyYgG/3BuD0/us8JheIrSzIZ1bu/rl3xt9WOsucWjBGQEocID6drvhl3W7I6Y/pqEUErJwBFFjLidLQMpoG7P4AlD7IRj7lkPyFn0CvFL881s8gEvWUQQP5AHLa7wsgFrzKew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785205160; c=relaxed/simple;
	bh=ZtVnZIjT5tA254I1eR/hQA3FOx2FRbBlcEU/WKQqNfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbshI6xli2DrJ8zch12Zb2SbJvc+gR+GcsA+6w3/a8AkQ5ToaknTJVARHncj5Ph6YgHIguXWkaKWVa9oIcWyBjIIwadS1w6YsCRD/JUgsiCynurfQNuf2fRnHcWd6vqDRg7SZCShZadkRa83RD8Rj7mDpBCJIPaNzNphcZ3dCZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QktIVMKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QktIVMKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29841F00A3E;
	Tue, 28 Jul 2026 02:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785205159;
	bh=YbsvO7a017HSUYN1vqL+XFp68grTBmz5BbENZ4uGlvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QktIVMKvztDt3mFWvdgLLApi1XcE2dNDQv4ahIWsDb+bnUPhQV38GyIx/rO9DH9JL
	 BaIzusTmYXQPzefowlkye+ch3SFusxN5nGrRMuJr4VJ14ysa8Zc1PSpZ4MnNm/w13z
	 44pyDOzkFERGiNMQlglPsbmR9PLx87vGMcPKxdnYWTaOh3LjLD6Zi9MJDyWs2B5q5I
	 nwt0Xi6sc5jgWelKU4/WRudYmHFl+Qf7yxWATGS3mtGNlRlaBEXw7YDt8bLYGu+SdO
	 6hQAsx47ncuxjj/nSAaJXjlC3tyXkKJii5cwdvvzMx+1VwHRjTe3X4rz0ngrTv9TTg
	 o/1tNw7547moQ==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 7/8] lib/raid/xor: x86: Remove redundant X86_FEATURE_OSXSAVE check
Date: Mon, 27 Jul 2026 19:16:02 -0700
Message-ID: <20260728021603.79870-8-ebiggers@kernel.org>
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

X86_FEATURE_AVX implies X86_FEATURE_OSXSAVE already.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/x86/xor_arch.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
index 99fe85a213c66..991abe3f4bbda 100644
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

