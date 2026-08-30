Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B175B1EB
	for <linux-crypto@vger.kernel.org>; Sun, 30 Aug 2026 22:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788128504; cv=none; b=KtDy/xZd2qT51WVgBsNzmO5xJYRrcsqlbqwAJyHyzlxpZsLDdXtZVriWPTOunnimB2BKl//97+2xTaG9hFnExvVVSzFEnyTQPW6ZvBMvY685gdqFvz/4M+ml4Ijfznp5rqwqsry96cdIUDA59vEuDyMX+cHVnpbjsvwjRHPzVPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788128504; c=relaxed/simple;
	bh=P3Pfsspw/iZhTjaE9APEnxcrvItJXiFZcT0e29q+vrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EZXGdpiszKeGx+iAnjIyG6cO51GsRZjKZolTNhio878iQu2WvCuTsF3rgnL2il86FWIjH45HPjMdCWeVaSKCRAgw8MJ2XFEZYcBdQ8GV13iSysYRLLeVKdv3nLQJMBrm652pglbKgThH+uJNUUcwI6y6mWDA60sFtLEGd6CGGX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WsOpqdfu; arc=none smtp.client-ip=91.218.175.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WsOpqdfu"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=P3Pfsspw/iZhTjaE9APEnxcrvItJXiFZcT0e29q+vrg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788128499; v=1; x=1788733299;
 b=WsOpqdfutGoXB6uhPJGuvhxz/Y18qijNdES1dysJY0U/izeNXJAFq419KJt/me6ThoxxZGro
 +ZurjAvro6p/d4C4Xzr2HG8ywFsF15c7/rcxgMYhl7B3FLhemm4LsuTGYhARn9TdJ3+7wXWcaCx
 QPJhotRXhJWCHVeIP0WZ/4DE=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 5d2b57443428d443;
	Sun, 30 Aug 2026 22:21:39 +0000
X-Mizu-Trace-ID: 5d2b57443428d443
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	terrelln@fb.com,
	terrelln@meta.com,
	linux-crypto@vger.kernel.org,
	yosry@kernel.org,
	ebiggers@kernel.org,
	torvalds@linux-foundation.org
Cc: hannes@cmpxchg.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 0/2] zstd: use x86 feature infrastructure for BMI2 dispatch
Date: Sun, 30 Aug 2026 15:20:23 -0700
Message-ID: <20260830222100.2706175-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zstd currently probes CPUID whenever a compression or decompression
context is initialized, stores the result in the context, and tests that
value at each BMI2 dispatch site. For normal x86 kernel builds this
duplicates the kernel's CPU feature infrastructure, bypasses its feature
policy, and leaves an ordinary runtime test in the dispatch path.

Use cpu_feature_enabled(X86_FEATURE_BMI2) directly at the dispatch sites
for normal x86 kernel objects. This uses the x86 alternatives-backed
static CPU feature mechanism, allowing the feature test to be resolved at
boot instead of loading and testing a value stored in each context.

ZSTD_USE_BMI2() keeps the other build modes working as before. It expands
to the caller-provided flag for standalone builds and to false when
DYNAMIC_BMI2 is disabled. The x86 preboot decompressor is built outside
lib/zstd/Makefile, so it continues to use Zstd's raw CPUID detection.

Patch 1 adds aliases from BMI2 function names to their default
implementations when the BMI2 variants are not compiled. This is a
no-functional-change preparation: after patch 2 removes the affected
selector-level preprocessor guards, the compiler must still resolve the
function named in an if (0) branch before eliminating it.

Patch 2 adds ZSTD_USE_BMI2(), converts the runtime selectors, and avoids
Zstd's private CPUID probes in normal x86 kernel objects. The BMI2 members
remain in the context structures so their layouts do not change.

A 4 KiB zstd-generic crypto_acomp benchmark [1] in a one-vCPU KVM guest
gave these median results:

                    Before      After     Change
  Compression      16,634 ns   13,394 ns   -19.5%
  Decompression     3,480 ns      963 ns   -72.3%

The improvement is especially large in a guest because raw CPUID causes
a VM exit.

[1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c

v1 -> v2: https://lore.kernel.org/all/20260826122558.2662013-1-usama.arif@linux.dev/
- Replace the proposed cached feature value with cpu_feature_enabled(X86_FEATURE_BMI2)
  at each dispatch site. (Eric Biggers and Linus Torvalds)
- Check only X86_FEATURE_BMI2 instead of BMI1, BMI2, and ABM. (Linus Torvalds)
- Split the fallback aliases into a separate no-functional-change patch.

Usama Arif (2):
  lib/zstd: add fallback aliases for disabled BMI2 variants
  zstd: use cpu_feature_enabled() for in-kernel BMI2 dispatch

 lib/zstd/Makefile                             |  1 +
 lib/zstd/common/compiler.h                    |  8 +++++
 lib/zstd/common/entropy_common.c              | 16 ++++++----
 lib/zstd/common/fse_decompress.c              |  9 ++++--
 lib/zstd/compress/huf_compress.c              |  7 +++-
 lib/zstd/compress/zstd_compress.c             | 12 ++++---
 lib/zstd/compress/zstd_compress_internal.h    |  9 ++++++
 lib/zstd/compress/zstd_compress_sequences.c   | 12 +++++--
 lib/zstd/compress/zstd_compress_superblock.c  |  2 +-
 lib/zstd/decompress/huf_decompress.c          | 23 +++++++------
 lib/zstd/decompress/zstd_decompress.c         |  4 +++
 lib/zstd/decompress/zstd_decompress_block.c   | 32 ++++++++++++-------
 .../decompress/zstd_decompress_internal.h     |  2 +-
 13 files changed, 97 insertions(+), 40 deletions(-)


base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
-- 
2.53.0-Meta

