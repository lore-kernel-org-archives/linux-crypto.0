Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79C6369990
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747179; cv=none; b=nRcog1Jj6JG+cjJQfswYMO47n//tu6sYr/JHohe2HXfzvyb+FkeW8KkzctXUwF31FK2RjKsRwZ2rBqaGzmIHEf9zqTOeVEvQLT4eJ674l5mDHCddBJ5C3p8ZX6WoOBgpZz8nKn5xrWNiYUd1y9Kjl4nXLQhZTaXDuWk4VH7DKCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747179; c=relaxed/simple;
	bh=l6nTEFp0UV9ZvkvD6VZyygRqqcTl8rulFcr+21jrYx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CU1A3JcbuV1BeLCcZZ+R4k2sFqhttj7jnVx/PTQRUT1jZBHk4vnXZW4p+U81ZLHGI9Msvjl+xHny1BkcP4GQFdrzXcCyKF45Yaqoe5zEhTchLPaz59rT6nKsnVA8sz+/i7IJV7kCyKG33T+hcR6aWRHuELKJyGm4DCicuJbq0Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HHPT098t; arc=none smtp.client-ip=91.218.175.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HHPT098t"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=l6nTEFp0UV9ZvkvD6VZyygRqqcTl8rulFcr+21jrYx8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787747175; v=1; x=1788351975;
 b=HHPT098tDWJ4r04hQ9nyQ30iXd+b18zHORfGJ2rpa4LHxMrxiD5wTMEm0090YK8uxw6WCtAw
 L1i7kTvnp+STUcDg20/Ny1/5UojIcd1qG05oEkLkQhOWfwrT61qFRrqg7DZ8ss5tXEi4gXZM9fZ
 6HilZcoxLfuO74iRaXq/oJ4I=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (2a03:2880:10ff:2e::)
	by mta11.migadu.com with ESMTPS id d057031fdbaecd4f;
	Wed, 26 Aug 2026 12:26:15 +0000
X-Mizu-Trace-ID: d057031fdbaecd4f
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
Subject: [PATCH 1/3] zstd: use ZSTD_cpuSupportsBmi2() in ZSTD_initStaticCCtx()
Date: Wed, 26 Aug 2026 05:25:36 -0700
Message-ID: <20260826122558.2662013-2-usama.arif@linux.dev>
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

ZSTD_initStaticCCtx() open-codes its BMI2 probe as
ZSTD_cpuid_bmi2(ZSTD_cpuid()).  Every other context setup -
ZSTD_initCCtx() and ZSTD_initDCtx_internal() - goes through
ZSTD_cpuSupportsBmi2(), which requires BMI1 as well as BMI2.

Requiring both is the correct test.  The alternate function bodies the
flag selects are tagged BMI2_TARGET_ATTRIBUTE, which is
TARGET_ATTRIBUTE("lzcnt,bmi,bmi2"), so the compiler may emit BMI1 and
LZCNT instructions in them; BMI2 alone does not make that safe.  No
shipping x86 CPU implements BMI2 without BMI1, so this is a latent
inconsistency rather than an observed failure.

Route the static path through the same helper.  That also leaves a
single place where the probe is issued, which the following patches
build on.

No functional change on any CPU in the field.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 lib/zstd/compress/zstd_compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/zstd/compress/zstd_compress.c b/lib/zstd/compress/zstd_compress.c
index c41a747413e01..4ab67d679bb63 100644
--- a/lib/zstd/compress/zstd_compress.c
+++ b/lib/zstd/compress/zstd_compress.c
@@ -142,7 +142,7 @@ ZSTD_CCtx* ZSTD_initStaticCCtx(void* workspace, size_t workspaceSize)
     cctx->blockState.nextCBlock = (ZSTD_compressedBlockState_t*)ZSTD_cwksp_reserve_object(&cctx->workspace, sizeof(ZSTD_compressedBlockState_t));
     cctx->tmpWorkspace = ZSTD_cwksp_reserve_object(&cctx->workspace, TMP_WORKSPACE_SIZE);
     cctx->tmpWkspSize = TMP_WORKSPACE_SIZE;
-    cctx->bmi2 = ZSTD_cpuid_bmi2(ZSTD_cpuid());
+    cctx->bmi2 = ZSTD_cpuSupportsBmi2();
     return cctx;
 }
 
-- 
2.53.0-Meta

