Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D88B41D106
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747189; cv=none; b=YeYrpNLf3tGZeTXl7hhIgpwRXoUnxDLxddA+dDt1Gkc3XdyUKZXtRisdRpyocf+Wmn0EWFP0cP28bKYwGHoAbCxK1EFFmK3kB9Mb1MmjQ+pQ1x34QQeFqL0wpSTUVchOGfEOYM1yq25h6LiQQ9/u8W55n6PhZOvBK26fuN+aPfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747189; c=relaxed/simple;
	bh=sTe+fYRuhgrZdEVDlpsG1pnfBxhxGZuM+7Lo4jhTagQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBSzj/0VzIkffMnI5MtCTWZoJBMttjLT3RYN2tKHDWsH+yC14t9LrH1SjTBK+gJRNK4dtUBRGOZnlcZmCJlCa1Mnpah5lGDPQTTDt6czvZ+pnhogPZVrcig11anjb0gHBkafUpJVfF6CBT/LyjQTX22KkoCpa93hnPMOJy7olqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ta99Bdv3; arc=none smtp.client-ip=91.218.175.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ta99Bdv3"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sTe+fYRuhgrZdEVDlpsG1pnfBxhxGZuM+7Lo4jhTagQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787747184; v=1; x=1788351984;
 b=ta99Bdv3WURZwh63HHZ3aIHtWSpxTRsrsSFcZvL2yOeNDh0AumnNK5RnXHteCXzh9HEZLU7d
 pFv/HuDPsOc8h16NKmOXgkGRNtjEF0tHFCZHCgXVUQnZmwAUSqFyTbinFnvwlCGBROX5BmNe8+x
 p1o57545rilOOosaNvLJiCTQ=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (2a03:2880:10ff:14::)
	by mta10.migadu.com with ESMTPS id f3a616fa6cd3bc9b;
	Wed, 26 Aug 2026 12:26:24 +0000
X-Mizu-Trace-ID: f3a616fa6cd3bc9b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	terrelln@fb.com,
	linux-crypto@vger.kernel.org,
	yosry@kernel.org
Cc: hannes@cmpxchg.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 3/3] zstd: probe the CPU for BMI2 support only once
Date: Wed, 26 Aug 2026 05:25:38 -0700
Message-ID: <20260826122558.2662013-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260826122558.2662013-1-usama.arif@linux.dev>
References: <20260826122558.2662013-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ZSTD_cpuSupportsBmi2() issues CPUID on every context setup for an answer
that cannot change while the kernel is running.  On x86 that is two
serializing CPUID instructions, and the callers are not rare:
squashfs, erofs, btrfs, f2fs and crypto/zstd all initialise a context
per operation, so a busy squashfs or zswap workload pays for it per
block or per page.  Under KVM it is worse, because CPUID is an
unconditional VM exit.

Cache the result.  Keeping the cache as a single int with a negative
sentinel, rather than a copy of ZSTD_cpuid_t, keeps it to one word: a
racing pair of probes computes the same value from the same CPUID leaf,
so the unsynchronized access is benign, and READ_ONCE()/WRITE_ONCE()
keep the compiler and KCSAN in agreement about that.

ZSTD_cpuSupportsBmi2() is MEM_STATIC, so each translation unit that
inlines it gets its own cache - three in a modular build, plus one in
each preboot decompressor.  That is a handful of ints in bss and one
extra probe apiece, not worth avoiding.

The cached answer is the one the probing CPU reported.  zstd could
already be migrated between the probe and the use of the flag, so this
does not introduce a heterogeneity question that was not there before.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 lib/zstd/common/zstd_internal.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/zstd/common/zstd_internal.h b/lib/zstd/common/zstd_internal.h
index 41f190b533209..b179f44753598 100644
--- a/lib/zstd/common/zstd_internal.h
+++ b/lib/zstd/common/zstd_internal.h
@@ -312,8 +312,21 @@ size_t ZSTD_decodeSeqHeaders(ZSTD_DCtx* dctx, int* nbSeqPtr,
 MEM_STATIC int ZSTD_cpuSupportsBmi2(void)
 {
 #if DYNAMIC_BMI2
-    ZSTD_cpuid_t cpuid = ZSTD_cpuid();
-    return ZSTD_cpuid_bmi1(cpuid) && ZSTD_cpuid_bmi2(cpuid);
+    /*
+     * The answer cannot change over the life of the kernel, so probe
+     * once.  Racing probes compute the same value, so the unsynchronized
+     * access is benign; the annotations are there to keep it that way.
+     */
+    static int supported = -1;
+    int s = READ_ONCE(supported);
+
+    if (s < 0) {
+        ZSTD_cpuid_t const cpuid = ZSTD_cpuid();
+
+        s = ZSTD_cpuid_bmi1(cpuid) && ZSTD_cpuid_bmi2(cpuid);
+        WRITE_ONCE(supported, s);
+    }
+    return s;
 #else
     /* Nothing looks at the flag in this configuration. */
     return 0;
-- 
2.53.0-Meta

