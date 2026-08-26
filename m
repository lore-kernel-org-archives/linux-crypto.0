Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E45369990
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747177; cv=none; b=Cs1rxTJQ/uJO8Uk0Cj/hsDn76H/u8dKLdytMoWNkvB/Sp248xhSsMnvHQDYhO0a/REf/R6ukTs9h0C58FJsBbUxMt2qEvMdfsaz2sf00ygP3spdZ1eVhgiEYW5aD2dATOL3L7pQRDY5w7uVixpAd0/2h4OY4GducqCxrNdI7oSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747177; c=relaxed/simple;
	bh=BZqAr8wgA1GfptovH3WZSv+58S/1xQO04HUmim5i6wo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fIVsUWREsqOyqDnTMgluVRg0VwviP52tXa6+jf/jgLjIPVnqAKMWP90hsFI3OT8h51BGFp01/4apBGlcP7Zeu6xNyCrk/fMlX30JsDA9otE99p3QUEEB09orMd8nfNNw+7oOuspNCopj+hsOA44F74+ocnyJZrCFJ+ZsYaXQH90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sIbDCBXj; arc=none smtp.client-ip=95.215.58.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sIbDCBXj"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BZqAr8wgA1GfptovH3WZSv+58S/1xQO04HUmim5i6wo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787747173; v=1; x=1788351973;
 b=sIbDCBXji9Z/eWcjNW+0+xzfQdS8OOxsJai33h9eT3qlxBSHyRM4RmcfaWvmC9fVzSWP8RBI
 0i15kkgGg8izhb3uJu0O7vWou11JPx4HqZAgCHHuXpTf2QAKhhSp9RUe4m9G019TvMXC6HXpsfn
 gUq8Nn8KMusupkT1ljTJMsik=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (2a03:2880:10ff:24::)
	by mta12.migadu.com with ESMTPS id aba9a01887e87693;
	Wed, 26 Aug 2026 12:26:13 +0000
X-Mizu-Trace-ID: aba9a01887e87693
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
Subject: [PATCH 0/3] zstd: probe the CPU for BMI2 support once, not per context
Date: Wed, 26 Aug 2026 05:25:35 -0700
Message-ID: <20260826122558.2662013-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zstd picks between BMI2 and generic code paths at runtime, and issues
CPUID to decide every time a compression or decompression context is set
up. The answer cannot change while the kernel is running.

It is not a cold path: squashfs calls zstd_init_dstream() for every block
it decompresses, and erofs, btrfs, f2fs and crypto/zstd all initialise a
context per operation. Each probe is two serializing CPUID instructions
on x86.

Patch 1 routes ZSTD_initStaticCCtx() through ZSTD_cpuSupportsBmi2()
instead of open-coding the probe, which also fixes it testing for BMI2
without BMI1 - the bodies it selects are tagged
TARGET_ATTRIBUTE("lzcnt,bmi,bmi2"), so both are needed. No CPU in the
field implements BMI2 without BMI1, so this is latent. Patch 2 skips the
probe when DYNAMIC_BMI2 is 0, where every consumer ignores the flag
anyway. Patch 3 caches the result.

A 4 KiB crypto_acomp benchmark [1] in a one-vCPU KVM guest, twelve boots
of nine 30,000-operation rounds, median per-round mean over 108 rounds:

                    compress     decompress
  unpatched         16,756 ns     3,455 ns
  patched           13,646 ns     1,002 ns
                    -3,110 ns    -2,452 ns
                     (18.6%)      (71.0%)

The main reason is because CPUID is an unconditional VM exit.

[1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
 
Usama Arif (3):
  zstd: use ZSTD_cpuSupportsBmi2() in ZSTD_initStaticCCtx()
  zstd: skip the BMI2 probe when dynamic BMI2 dispatch is disabled
  zstd: probe the CPU for BMI2 support only once

 lib/zstd/common/zstd_internal.h   | 22 ++++++++++++++++++++--
 lib/zstd/compress/zstd_compress.c |  2 +-
 2 files changed, 21 insertions(+), 3 deletions(-)


base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
-- 
2.53.0-Meta

