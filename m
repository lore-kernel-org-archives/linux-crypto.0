Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D185970832;
	Sun,  3 Nov 2024 03:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604086; cv=none; b=OW1fctPWhoUH4rvz/nwxr/xSxkwY5ycXqAMWrJ2HglPD4x9TGgoxhpoQbjkjVzSWmPUmGjSkRSGaXHqVT3k+2qG7T4iOAh9WmBqlrO5/b4+fFhbjQBm7nTJ0owJ+Lrt1PKval6pKdojOfjEXiqASnbhaeJE0NwhQFfkcaS2xrcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604086; c=relaxed/simple;
	bh=LRgON0J+B8CkVFIt5Q3iyXtNXhdwK4RCB9NPlp2lvok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DdEYQVFH24AfT4X+NfMfGlIVeWh9yJXRLVGlC5NpSiiDGjUeRcSOKzMsdt30tKJmI/NRGhb2QIH7Ls5xOgYzlkrMtcwUSIKddDo66hTRNju/0MVS1+vi7NAUoJhjnGS2tyBr3x0aUjwZSEO8aHWSy0MFrYOzFafFRMQRzNFpZ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EF3mRQx4; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EF3mRQx4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604084; x=1762140084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LRgON0J+B8CkVFIt5Q3iyXtNXhdwK4RCB9NPlp2lvok=;
  b=EF3mRQx4uLp4Q9bXIL7LOLmVi6Khj9wU5Cb0Ldf/gYnhgxBC7rJG+VBQ
   EW7tSzu25WGncLrCLyFmPIa1k3rbcVye1IZOLvKuKwiZwMc1kpwtRb2cQ
   llH+ThbSoLybjvpf9goGtGZChR8KnBkXfWX18KannSolAFXcLM2BM+Zfn
   yLfkNBHpGF09kVcfPK+94CWtqfljPbAV7m9EwZ3SBQnZiADB+dBJ4NZW5
   kjNBESm6ycgD4ecnzBSuadQzViNjZBgZxuFnN5NkH5bCzI9aPxG9EIPn8
   ZKeEoE8iQ31VHoZ+dvAezIgxlgoQG73JrgrQuR4zwKtD132lP6ZHWxaLN
   A==;
X-CSE-ConnectionGUID: FkZmd7M8RLGjYSSgNdhNjg==
X-CSE-MsgGUID: 2eWy9EstQqCSVhcJrReZ8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548348"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548348"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:14 -0700
X-CSE-ConnectionGUID: Vry+ngz1T2CnvIoMfXY38w==
X-CSE-MsgGUID: NSoSHThITDqKrhfED8nBYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451906"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 02 Nov 2024 20:21:15 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	zanussi@kernel.org
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v2 12/13] mm: Add sysctl vm.compress-batching switch for compress batching during swapout.
Date: Sat,  2 Nov 2024 20:21:10 -0700
Message-Id: <20241103032111.333282-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sysctl vm.compress-batching parameter is 0 by default. If the platform
has Intel IAA, the user can run experiments with IAA compress batching of
large folios in zswap_store() as follows:

sysctl vm.compress-batching=1
echo deflate-iaa > /sys/module/zswap/parameters/compressor

This is expected to significantly improve zswap_store() latency of swapping
out large folios due to parallel compression of 8 pages in the large folio
at a time, in hardware.

Setting vm.compress-batching to "1" takes effect only if the zswap
compression algorithm's crypto_acomp registers implementations for the
batch_compress() and batch_decompress() API. In other words, compress
batching works only with the iaa_crypto driver, that does register these
new batching API. It is a no-op for compressors that do not register the
batching API.

The sysctl vm.compress-batching acts as a switch because it takes effect
upon future zswap_store() calls on any given core. If the switch is "1",
large folios will use parallel batched compression of the folio's pages.
If the switch is "0", zswap_store() will use sequential compression for
storing every page in a large folio.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/linux/mm.h | 2 ++
 kernel/sysctl.c    | 9 +++++++++
 mm/swap.c          | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 610653a8b0fe..c94ba5c36169 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -82,8 +82,10 @@ extern const int page_cluster_max;
 
 #ifdef CONFIG_SYSCTL
 extern int sysctl_legacy_va_layout;
+extern unsigned int compress_batching;
 #else
 #define sysctl_legacy_va_layout 0
+#define compress_batching 0
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 79e6cb1d5c48..e298857595b4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2064,6 +2064,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&page_cluster_max,
 	},
+	{
+		.procname	= "compress-batching",
+		.data		= &compress_batching,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{
 		.procname	= "dirtytime_expire_seconds",
 		.data		= &dirtytime_expire_interval,
diff --git a/mm/swap.c b/mm/swap.c
index 638a3f001676..bc4c9079769e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -47,6 +47,9 @@
 int page_cluster;
 const int page_cluster_max = 31;
 
+/* Enable/disable compress batching during swapout. */
+unsigned int compress_batching;
+
 struct cpu_fbatches {
 	/*
 	 * The following folio batches are grouped together because they are protected
@@ -1074,4 +1077,7 @@ void __init swap_setup(void)
 	 * Right now other parts of the system means that we
 	 * _really_ don't want to cluster much more
 	 */
+
+	/* Disable compress batching during swapout by default. */
+	compress_batching = 0;
 }
-- 
2.27.0

