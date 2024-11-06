Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFF320C47A;
	Wed,  6 Nov 2024 19:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920879; cv=none; b=Qleg8629UPTx28DB3M9CrmoYXHwEgO9/n69ec3w04jJxGl0qB3zabi3+tTGuT5EWO3arsnkMnaxk/53BbrhZgfN9FPmhljmpavhKcwoDMvnAViLiM9RQLkXiyd9Fz2Bo69OR6PcrTYr5dyfufjwoWMEFtDV+EVhwUYel09fZSOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920879; c=relaxed/simple;
	bh=RvYO56c7H8o1E9i8DrptIuQN+cu6z6PTo04ljSRvTjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WOcYgiHgg5UE1s5F/ZQLaKV2KLafw+N+qDeLI52YTRvdpy16gNXaTWwqYAIdFt3ZrguqfLPHxUJtrzZHQNWMCofVCFlpxREF8VHJR1G0n6Rg6J/2LlcRQ+g8uBofKAmyYnqs4rjayqzuLlRBkYMQfOYHsHDh5fgUFfdxwf/JSNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dlTC/1mW; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dlTC/1mW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920878; x=1762456878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RvYO56c7H8o1E9i8DrptIuQN+cu6z6PTo04ljSRvTjY=;
  b=dlTC/1mWGkQ60vDWqRqa4cLt0r68H56VaoTLRMs9HWeVATrwX0tvR5tE
   cLx+WFi68JPNKYkY9amJ5a01bDklNKNZbrtYyC8xrG3DnYE5QKGxOOAUm
   D0/Hpk6xrlqY6W4wWAufATkbMqSb0NJBYccBEGmHuDjEc6BiHB+4XbaMv
   P6Qh8SIDo3bE1e2zpGWIcstE/SZyAxfv/UUMwuJjqnUinhT8ZMZBsoEEq
   ACpMMF3thIBMo8SQrOxNRnGYKs7HY3bvGGLyeptxvE4R3hSouHrDcstAL
   NT9yU3AEuJH5782Whfgli+GWBgSzCaT6oFUVTRj2PrM2lomAuQwb7AEYM
   g==;
X-CSE-ConnectionGUID: 1RpJw0rvRX6t+IUIKAm17Q==
X-CSE-MsgGUID: xdm+40cCQR6mPKP8/efdGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41292072"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41292072"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:14 -0800
X-CSE-ConnectionGUID: nN2+UNtXTT6rc/74ttu3rw==
X-CSE-MsgGUID: KjGO/gTnShy76yRTS9Bp3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695422"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 11:21:13 -0800
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
Subject: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for compress batching during swapout.
Date: Wed,  6 Nov 2024 11:21:04 -0800
Message-Id: <20241106192105.6731-13-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
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
index fecd47239fa9..f61915aa2f37 100644
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

