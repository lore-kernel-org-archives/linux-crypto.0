Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B71C41D22C
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747182; cv=none; b=q8DGbD7Grw8EQrrCGuDI7c2+exImygBdRq6rJu5nZMwJXn/ILdw1FGZgqgiXnW+5IQO5gxw2O8O/1v4IygoOro5SEUHfbhAdg2ChnuD5zQTnbzz3WLF9K6ujLbBPWZZPhNmWcQn/CyFT8PhTXiW5yHAoICAsp6SqXvqwlfxzLA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747182; c=relaxed/simple;
	bh=c0pqy4XVDGw+0BiJFyaIQlWNslTBqgjLRS48kM+/rag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvbE1s5edxeC9cbuQOLYNS+MFenjapG4iQ+SYzXn4AkwXtVQDyZ4sY1bKCFwWi+7Q8MD/d9GLQBXf/MQ3HEJbOvB762x9hkDpXtwJtESzlL/mjdHwEzs8NJex1mr+wzJTQ255fdg3gHo9QEJV9Smj/lsoCfU34trT9nIOfL5arg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d24VJgJa; arc=none smtp.client-ip=91.218.175.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d24VJgJa"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=c0pqy4XVDGw+0BiJFyaIQlWNslTBqgjLRS48kM+/rag=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787747178; v=1; x=1788351978;
 b=d24VJgJaht/U8d7lAwLJKmQA9YbjD9S9kF9+wp/bowgjno4uV44gAJSiyIXtrkPqvSSdOWUa
 KQhZ288LPyzh4Js2XJEejahr8+WNiyDJkJ68x1fNPIh1CA58k86TUyK7SUtG74cMyqSAlNb64di
 sZa8lMnjs2mlpLyMlYZ9p2nA=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (2a03:2880:10ff:55::)
	by mta10.migadu.com with ESMTPS id 4c60a4187e1d0492;
	Wed, 26 Aug 2026 12:26:18 +0000
X-Mizu-Trace-ID: 4c60a4187e1d0492
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
Subject: [PATCH 2/3] zstd: skip the BMI2 probe when dynamic BMI2 dispatch is disabled
Date: Wed, 26 Aug 2026 05:25:37 -0700
Message-ID: <20260826122558.2662013-3-usama.arif@linux.dev>
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

When DYNAMIC_BMI2 is 0 - GCC older than 11, a non-x86 target, or a build
that already has BMI2 on globally - nothing reads the flag.
HUF_compress1X_usingCTable_internal(), FSE_decompress_wksp_bmi2(),
HUF_readStats_body() and the rest all resolve to the default body
without consulting it.  ZSTD_cpuSupportsBmi2() nevertheless issues
CPUID, which on x86 is two serializing instructions, and throws the
answer away.

ZSTD_initDCtx_internal() already wraps its assignment in
#if DYNAMIC_BMI2 - it has to, because the dctx->bmi2 field is itself
declared under that #if.  The two compress-side callers have no such
guard, and ZSTD_CCtx_s::bmi2 is unconditional, so they probe
unconditionally.

Put the test inside ZSTD_cpuSupportsBmi2() so every caller gets it
without having to remember.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 lib/zstd/common/zstd_internal.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/zstd/common/zstd_internal.h b/lib/zstd/common/zstd_internal.h
index 52a79435caf66..41f190b533209 100644
--- a/lib/zstd/common/zstd_internal.h
+++ b/lib/zstd/common/zstd_internal.h
@@ -311,8 +311,13 @@ size_t ZSTD_decodeSeqHeaders(ZSTD_DCtx* dctx, int* nbSeqPtr,
  */
 MEM_STATIC int ZSTD_cpuSupportsBmi2(void)
 {
+#if DYNAMIC_BMI2
     ZSTD_cpuid_t cpuid = ZSTD_cpuid();
     return ZSTD_cpuid_bmi1(cpuid) && ZSTD_cpuid_bmi2(cpuid);
+#else
+    /* Nothing looks at the flag in this configuration. */
+    return 0;
+#endif
 }
 
 #endif   /* ZSTD_CCOMMON_H_MODULE */
-- 
2.53.0-Meta

