Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD7E25B08E
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 11:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260937; cv=none; b=uDzkSzUgSHrQqe2xOFgf2dEbIYJYWDdgyRyhZXR7gIOBUfY4ZgzhmadLQdjMDGLMAawph2RUbHgX6MuSjJu7ODV5ESYBlBzXthWf6gTbKrNL9wF3f46hX/gYPaglchVHCkglv7OdPOUfZlv5Jj5jeE1Q9Dt4ytHgVL8tL38qLLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260937; c=relaxed/simple;
	bh=NGIiPq72QIAq/398f4PecY3glDArqj+VPub/xKcw/bw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D1kwIe7lj4AmINk4XmRzqTmFq3OJDZ3rwgQIQJtkX/SklQtjuVZNzS9d+es6j/pQlZ77cbAMDAED94SJyoUXlvu4pisPH5pgUw2xRI2D8dShnFwArhNZebsTR6/irCUteexIW2NKA6QJLoxGHl7mhzDJ7kc8IYUU3qf1oIv8z+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v2VK9EN3; arc=none smtp.client-ip=95.215.58.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v2VK9EN3"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NGIiPq72QIAq/398f4PecY3glDArqj+VPub/xKcw/bw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788260933; v=1; x=1788865733;
 b=v2VK9EN3GDkMN4lGqdd/p/eR1O33REUddkMZPv8z2yn8elfNH00BugQR5tNZ6kiHjR2UYs0T
 wIGH8LO0oDrgKV1pWnX0mmeuwDLUaseNx6GzsLcLSqV1eyNb2OIw5NTazhcnwcceqE/XqgSIYLt
 5BsfDbyAu8dfOBxkckguccWo=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 19666a9344a0270b;
	Tue, 01 Sep 2026 11:08:53 +0000
X-Mizu-Trace-ID: 19666a9344a0270b
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
Subject: [PATCH v3 0/2] zstd: use x86 feature infrastructure for BMI2 dispatch
Date: Tue,  1 Sep 2026 04:07:55 -0700
Message-ID: <20260901110850.1805747-1-usama.arif@linux.dev>
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
to the caller-provided flag for standalone and preboot builds and to false
when DYNAMIC_BMI2 is disabled. ZSTD_SET_BMI2() similarly stores the
caller-provided state only when it will be used, avoiding preprocessor
conditionals at the context initialization sites.

Patch 1 adds aliases from BMI2 function names to their default
implementations when the BMI2 variants are not compiled. This is a
no-functional-change preparation: after patch 2 removes the affected
selector-level preprocessor guards, the compiler must still resolve the
function named in an if (0) branch before eliminating it.

Patch 2 adds ZSTD_USE_BMI2() and ZSTD_SET_BMI2(), converts the runtime
selectors, and avoids Zstd's private CPUID probes in normal x86 kernel
objects. The kernel-specific policy lives in zstd_deps.h. Preboot builds
are excluded because the normal alternatives infrastructure is not
available there, so they retain the existing raw-CPUID dispatch.

A 4 KiB zstd-generic crypto_acomp benchmark [1] in a one-vCPU KVM guest
gave these median results:

                    Before      After     Change
  Compression      16,634 ns   13,394 ns   -19.5%
  Decompression     3,480 ns      963 ns   -72.3%

The improvement is especially large in a guest because raw CPUID causes
a VM exit.

[1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c

v2 -> v3: https://lore.kernel.org/all/20260830222100.2706175-1-usama.arif@linux.dev/
- Add ZSTD_SET_BMI2() and use it at the context initialization sites.
  (Linus Torvalds)
- Move ZSTD_USE_KERNEL_CPU_FEATURES from Makefile define into zstd_deps.h.
  (Linus Torvalds)

v1 -> v2:
https://lore.kernel.org/all/20260826122558.2662013-1-usama.arif@linux.dev/
- Replace the proposed cached feature value with
  cpu_feature_enabled(X86_FEATURE_BMI2) at each dispatch site.
  (Eric Biggers and Linus Torvalds)
- Check only X86_FEATURE_BMI2 instead of BMI1, BMI2, and ABM.
  (Linus Torvalds)
- Split the fallback aliases into a separate no-functional-change patch.
 
Usama Arif (2):
  lib/zstd: add fallback aliases for disabled BMI2 variants
  zstd: use cpu_feature_enabled() for in-kernel BMI2 dispatch

 lib/zstd/common/compiler.h                    | 12 +++++++
 lib/zstd/common/entropy_common.c              | 16 ++++++----
 lib/zstd/common/fse_decompress.c              |  9 ++++--
 lib/zstd/common/zstd_deps.h                   |  5 +++
 lib/zstd/compress/huf_compress.c              |  6 +++-
 lib/zstd/compress/zstd_compress.c             | 12 +++----
 lib/zstd/compress/zstd_compress_internal.h    |  9 ++++++
 lib/zstd/compress/zstd_compress_sequences.c   | 12 +++++--
 lib/zstd/compress/zstd_compress_superblock.c  |  2 +-
 lib/zstd/decompress/huf_decompress.c          | 22 +++++++------
 lib/zstd/decompress/zstd_decompress.c         |  4 +--
 lib/zstd/decompress/zstd_decompress_block.c   | 31 ++++++++++++-------
 .../decompress/zstd_decompress_internal.h     |  2 +-
 13 files changed, 97 insertions(+), 45 deletions(-)


base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
-- 
2.53.0-Meta

