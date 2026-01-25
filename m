Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2837A1F583D;
	Sun, 25 Jan 2026 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312148; cv=none; b=XgGM+3GRCBKOa553qk7GxcSm94KtsNoN4gXpeyjaC+nKQ/+kbHJvMMV8n0j4ahUwB948NdGDF/uBHO9AGC/qGsVEbpIiEUduKuPZ3c5faIc458McFqcb44tFDmNqUcEQDsMt/qfAB3j2AcCucPTmnnje73wP1v3Eov2nwSDSJ1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312148; c=relaxed/simple;
	bh=Ga/LFvuyxIePcPqTKFm42Hl1EgZPaVXAYLhv5aZYPh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BY8HP46FeBWXoWdxBdh6MLokPz3l8Qibp9Iee19gy+Ii+1FIStw27CXrQPzFNeY9WdQGa57vcC95cDOatS7wDd93jdFN6lZrluOxBB3xuCJ+vH/+iwZHsnTzJkj+GWAy9HVtFPXcd0mG3MjLN3AO9zpDTEjK+MUHJpbQWCx8hN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EwUGhtTe; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwUGhtTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312145; x=1800848145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ga/LFvuyxIePcPqTKFm42Hl1EgZPaVXAYLhv5aZYPh8=;
  b=EwUGhtTeP5fmUsVHktLIxkcksMAVlOAbwJJQG6/gAaB3hitmQfc3sCcL
   m8Sw/xTVyanK0uUpF1YP+4C8AZMBySOIM+fsX3Tx0GYspiXWTV43oiJWL
   hDDlssttksEIOhbaZ8wsDviWca9owDkEvu9GaS2wgrAXhsRrtsm0Y/c5N
   SfaegXcPVWbSkY5W0fQoG1w7puTYwQOMXK5W4YjF4xjhTg+esXC621oj0
   tf3Rb9mwZ7IssCL4mnSKZ2DKMwSlW0EXukHwNjbPFwQ5xDrFzp7w8gWZ9
   z3kUJcMJXRjILbp4IaVA1sMi8a5tdvthcyvS4f+kk2WyvsYFsGgyaUUSm
   g==;
X-CSE-ConnectionGUID: xoH5dJ2cQc+U43X0TThLGQ==
X-CSE-MsgGUID: yvc02UZJTCmSLkvq7VE4kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887332"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887332"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:44 -0800
X-CSE-ConnectionGUID: NHI4t9dxQWSX0SVtRlpR3w==
X-CSE-MsgGUID: a32SIFcZSm6JNS0m1D8/KQ==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:42 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 03/26] crypto: iaa - New architecture for IAA device WQ [de]comp usage & core mapping.
Date: Sat, 24 Jan 2026 19:35:14 -0800
Message-Id: <20260125033537.334628-4-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch re-architects the iaa_crypto driver in three main aspects, to
make it more robust, stable, generic and functionally versatile to
support zswap users on platforms with different number of cores/IAAs
running workloads with different swap characteristics, and most
importantly, for better performance.

 Summary of latency improvement for large folio compression:
 ===========================================================
 When measured in zswap using a simple madvise workload, where 64K
 Folios are stored using IAA batch compressions, this is how the
 per-page compress latency changes just by setting the
 "distribute_comps" driver parameter to "1":

   --------------------------------------------------------------
   zswap compressor: deflate-iaa
   64K Folios: zswap_store() latency normalized to per-page
   --------------------------------------------------------------
                                         p50 (ns)     p99 (ns)
   --------------------------------------------------------------
   Sequential store                         3,503        3,695
   Batch compress, distribute_comps=0       1,356        1,384
   Batch compress, distribute_comps=1         706          763
   --------------------------------------------------------------

The rearchitecting aspects are:

A) Map IAA devices/wqs to cores based on packages instead of NUMA.

B) The WQ rebalancing algorithm that is invoked as WQs are
   discovered/deleted has been made very general and flexible so that
   the user can control exactly how IAA WQs are used, for optimizing
   performance.

C) Additionally, the "iaa_crypto_enabled" driver global has been
   modified to be an atomic, and used for synchronization between
   dynamic/asynchronous WQ discovery/deletion and the fundamental
   routines comp_wq_table_next_wq() and decomp_wq_table_next_wq() that
   are queried by compress/decompress job submissions.

Description/motivation for (A):
===============================
This patch modifies the algorithm for mapping available IAA devices and
WQs to cores based on packages instead of NUMA nodes. This leads to a
more realistic mapping of IAA devices as compression/decompression
resources for a package, rather than for a NUMA node. This also resolves
problems that were observed during internal validation on Intel Granite
Rapids platforms with many more NUMA nodes than packages: for such
cases, the earlier NUMA based allocation caused some IAAs to be
over-subscribed and some to not be utilized at all.

As a result of this change from NUMA to packages, some of the core
functions used by the iaa_crypto driver's "probe" and "remove" API
have been re-written. The new infrastructure maintains a static mapping
of wqs per IAA device, in the "struct iaa_device" itself. The earlier
implementation would allocate memory per-cpu for this data, which never
changes once the IAA devices/wqs have been initialized.

Two main outcomes from this new iaa_crypto driver infrastructure are:

 1) Resolves "task blocked for more than x seconds" errors observed during
    internal validation on Intel systems with the earlier NUMA node based
    mappings, which was root-caused to the non-optimal IAA-to-core mappings
    described earlier.

 2) Results in a NUM_THREADS factor reduction in memory footprint cost of
    initializing IAA devices/wqs, due to eliminating the per-cpu copies of
    each IAA device's wqs. On a 384 cores Intel Granite Rapids server with
    8 IAA devices, this saves 140MiB.

An auxiliary change included in this patch is that the driver's "nr_iaa",
"nr_iaa_per_package" and "cpus_per_iaa" global variables are made
atomic, because iaa_crypto_probe() and iaa_crypto_remove() change the
values of these variables asynchronously and concurrently as wqs get
added/deleted and rebalance_wq_table() is called. This change allows the
rebalance_wq_table() code to see consistent values of the number of IAA
devices.

Description/motivation for (B):
===============================
This builds upon the package-based driver infrastructure, to provide
more flexibility in using particular WQs for compress-only or
decompress-only jobs. It also introduces the notion of using all the IAA
devices on a package as resources that are shared by all cores on the
package: this significantly improves batching (to be added in subsequent
patches) latency and compress/decompress throughput. sysfs driver
paramters provide configurability of these features.

Two main concepts are introduced as part of the rebalancing changes:

 1) An IAA WQ can be used for specific ops, that determines a WQ "type"
    for the iaa_crypto driver to submit compress/decompress jobs:

    - compress only
    - decompress only
    - generic, i.e, for both compresses and decompresses

    The WQ type is decided based on the number of WQs configured for a
    given IAA device, and the new "g_comp_wqs_per_iaa" driver parameter.

 2) An IAA WQ can be mapped to cores using either of the following
    balancing techniques:

    a) Shared by all cores on a package. The iaa_crypto driver will
       dispatch compress/decompress jobs to all WQs of the same type,
       across all IAA devices on the package:
       - IAA compress jobs will be distributed to all same-package IAA
         compress-only/generic WQs.
       - IAA decompress jobs will be distributed to all same-package IAA
         decompress-only/generic WQs.

    b) Handles compress/decompress jobs only from "mapped cores", i.e.,
       the cores derived by evenly dividing the number of IAAs among the
       number of cores, per package.

Server setups that are moderately to highly contended can benefit from
(2.a). When the mix of workloads running on a system need high compress
throughput, and have relatively lower decompress activity, (2.b) might
be more optimal for decompressions.

These approaches can be accomplished with the following new iaa_crypto
driver parameters. These parameters are global settings and will apply
to all IAAs on a package, interpreted in the context of the number of
WQs configured per IAA device.

 g_comp_wqs_per_iaa:
 ===================
   Number of compress-only WQs. The default is 1, but is applicable only
   if the device has more than 1 WQ. If the device has exactly 1 WQ
   configured, "g_comp_wqs_per_iaa" is a don't care.

   If the IAA device has more than "g_comp_wqs_per_iaa" WQs configured,
   the last "g_comp_wqs_per_iaa" number of WQs will be considered as
   "compress only". The remaining WQs will be considered as
   "decompress only".

   If the device has less than or equal to "g_comp_wqs_per_iaa" WQs, all
   the device's WQs will be considered "generic", i.e., the driver will
   submit compress and decompress jobs to all the WQs configured for the
   device.

   For e.g., if an IAA "X" has 2 WQs, this will set up 1 decompress WQ and
   1 compress WQ:

     echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa

     wqX.0: decompress jobs only.
     wqX.1: compress jobs only.

   This setting would typically benefit workloads that see a high
   level of compress and decompress activity.

   If an IAA has 1 WQ, that WQ will be considered "generic": the driver
   will submit compress and decompress jobs to the same WQ (this is
   independent of the "g_comp_wqs_per_iaa" setting):

     wqX.0: compress and decompress jobs.

   This would typically benefit workloads that see significant cold
   memory being reclaimed, and consequently, high swapout and low swapin
   activity.

 distribute_comps:
 =================
   Distribute compressions to all IAAs on package (default is Y).

   Assuming the WQ type has been established as
   compress-only/decompress-only/generic, this setting will determine if
   the driver will distribute compress jobs to all IAAs on a package
   (default behavior) or not.

   If this is turned off, the driver will dispatch compress jobs to a
   given IAA "compression enabled" WQ only from cores that are mapped to
   that IAA using an algorithm that evenly distributes IAAs per package
   to cores per package. For e.g., on a Sapphire Rapids server with
   56-physical-cores and 4 IAAs per package, with Hyperthreading, 28
   logical cores will be assigned to each IAA. With the
   "distribute_comps" driver parameter turned off, the driver will send
   compress jobs only to it's assigned IAA device.

   Enabling "distribute_comps" would typically benefit workloads in
   terms of batch compress latency and throughput.

 distribute_decomps:
 ===================
   Distribute decompressions to all IAAs on package (default is N).

   Assuming the WQ type has been established as
   compress-only/decompress-only/generic, this setting will determine if
   the driver will distribute decompress jobs to all IAAs on a package
   or not (default behavior).

   We recommend leaving this parameter at its default setting of "N".
   Enabling "distribute_decomps = Y" can be evaluated for workloads that
   are sensitive to p99 decompress latency, and see a high level of
   compress and decompress activity (for e.g. warm memory reclaim/swapin).

Recommended settings for best compress/decompress latency, throughput
and hence memory savings for a moderately contended server, are:

   2 WQs per IAA
   g_comp_wqs_per_iaa = 1 (separate WQ for comps/decomps per IAA)
   distribute_decomps = N
   distribute_comps = Y

For systems that have one IAA device, the distribute_[de]comps settings
will be a no-op. Even for such systems, as long as considerable swapout
and swapin activity is expected, we recommend setting up 2 WQs
for the IAA, one each for compressions/decompressions. If swapouts are
significantly more than swapins, 1 WQ would be a better configuration,
as mentioned earlier.

 Examples:
 =========
   For a Sapphire Rapids server with 2 packages, 56 cores and 4 IAAs per
   package, each IAA has 2 WQs, and these settings are in effect:

     echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
     echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
     echo 0 > /sys/bus/dsa/drivers/crypto/distribute_decomps

     wqX.0: decompress jobs only.
     wqX.1: compress jobs only.

   Compress jobs from all cores on package-0 will be distributed in
   round-robin manner to [iax1, iax3, iax5, iax7]'s wqX.1, to maximize
   compression throughput/latency/memory savings:

     wq1.1
     wq3.1
     wq5.1
     wq7.1

   Likewise, compress jobs from all cores on package-1 will be
   distributed in round-robin manner to [iax9, iax11, iax13, iax15]'s
   wqX.1, to maximize compression throughput/latency/memory savings for
   workloads running on package-1:

     wq9.1
     wq11.1
     wq13.1
     wq15.1

   Decompress jobs will be submitted from mapped logical cores only, as
   follows:

     package-0:

       CPU   0-13,112-125   14-27,126-139  28-41,140-153  42-55,154-167
       IAA:  iax1           iax3           iax5           iax7
       WQ:   wq1.0          wq3.0          wq5.0          wq7.0

     package-1:

       CPU   56-69,168-181  70-83,182-195  84-97,196-209   98-111,210-223
       IAA:  iax9           iax11          iax13           iax15
       WQ:   wq9.0          wq11.0         wq13.0          wq15.0

IAA WQs can be configured using higher level scripts as described in
Documentation/driver-api/crypto/iaa/iaa-crypto.rst. This documentation
has been updated for the above new sysfs parameters.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 .../driver-api/crypto/iaa/iaa-crypto.rst      | 136 +++
 drivers/crypto/intel/iaa/iaa_crypto.h         |  18 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c    | 905 ++++++++++++++----
 3 files changed, 884 insertions(+), 175 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index f815d4fd8372..0ff4ec603b43 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -290,6 +290,142 @@ The available attributes are:
     'sync' mode. This is to ensure correct iaa_crypto behavior until true
     async polling without interrupts is enabled in iaa_crypto.
 
+  - g_comp_wqs_per_iaa
+
+    Number of compress-only WQs. The default is 1, but is applicable only
+    if the device has more than 1 WQ. If the device has exactly 1 WQ
+    configured, "g_comp_wqs_per_iaa" is a don't care.
+
+    If the IAA device has more than "g_comp_wqs_per_iaa" WQs configured,
+    the last "g_comp_wqs_per_iaa" number of WQs will be considered as
+    "compress only". The remaining WQs will be considered as "decomp only".
+
+    If the device has less than or equal to "g_comp_wqs_per_iaa" WQs, all
+    the device's WQs will be considered "generic", i.e., the driver will
+    submit compress and decompress jobs to all the WQs configured for the
+    device.
+
+    For e.g., if an IAA "X" has 2 WQs, this will set up 1 decompress WQ and
+    1 compress WQ::
+
+      echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
+
+     wqX.0: decompress jobs only.
+     wqX.1: compress jobs only.
+
+    This setting would typically benefit workloads that see a high
+    level of compress and decompress activity.
+
+    If an IAA has 1 WQ, that WQ will be considered "generic": the driver
+    will submit compress and decompress jobs to the same WQ (this is
+    independent of the "g_comp_wqs_per_iaa" setting):
+
+     wqX.0: compress and decompress jobs.
+
+    This would typically benefit workloads that see significant cold
+    memory being reclaimed, and consequently, high swapout and low swapin
+    activity.
+
+  - distribute_comps
+
+    Distribute compressions to all IAAs on package (default is Y).
+
+    Assuming the WQ type has been established as
+    compress-only/decompress-only/generic, this setting will determine if
+    the driver will distribute compress jobs to all IAAs on a package
+    (default behavior) or not.
+
+    If this is turned off, the driver will dispatch compress jobs to a
+    given IAA "compression enabled" WQ only from cores that are mapped to
+    that IAA using an algorithm that evenly distributes IAAs per package
+    to cores per package. For e.g., on a Sapphire Rapids server with
+    56-physical-cores and 4 IAAs per package, with Hyperthreading, 28
+    logical cores will be assigned to each IAA. With the
+    "distribute_comps" driver parameter turned off, the driver will send
+    compress jobs only to it's assigned IAA device.
+
+    Enabling "distribute_comps" would typically benefit workloads in
+    terms of batch compress latency and throughput.
+
+  - distribute_decomps
+
+    Distribute decompressions to all IAAs on package (default is Y).
+
+    Assuming the WQ type has been established as
+    compress-only/decompress-only/generic, this setting will determine if
+    the driver will distribute decompress jobs to all IAAs on a package
+    (default behavior) or not.
+
+    Enabling "distribute_decomps" would typically benefit workloads that
+    see a high level of compress and decompress activity, especially
+    p99 decompress latency.
+
+    Recommended settings for best compress/decompress latency, throughput
+    and hence memory savings for a moderately contended server that
+    has more than 1 IAA device enabled on a given package:
+
+      2 WQs per IAA
+      g_comp_wqs_per_iaa = 1 (separate WQ for comps/decomps per IAA)
+      distribute_decomps = Y
+      distribute_comps = Y
+
+    For a system that has only 1 IAA device enabled on a given package,
+    the recommended settings are:
+
+      1 WQ per IAA
+      g_comp_wqs_per_iaa = 0 (same WQ for comps/decomps)
+      distribute_decomps = N
+      distribute_comps = N
+
+    Examples:
+
+    For a Sapphire Rapids server with 2 packages, 56 cores and 4 IAAs per
+    package, each IAA has 2 WQs, and these settings are in effect::
+
+      echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
+      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
+      echo 0 > /sys/bus/dsa/drivers/crypto/distribute_decomps
+
+    This enables the following behavior:
+
+      wqX.0: decompress jobs only.
+      wqX.1: compress jobs only.
+
+    Compress jobs from all cores on package-0 will be distributed in
+    round-robin manner to [iax1, iax3, iax5, iax7]'s wqX.1, to maximize
+    compression throughput/latency/memory savings:
+
+      wq1.1
+      wq3.1
+      wq5.1
+      wq7.1
+
+    Likewise, compress jobs from all cores on package-1 will be
+    distributed in round-robin manner to [iax9, iax11, iax13, iax15]'s
+    wqX.1, to maximize compression throughput/latency/memory savings for
+    workloads running on package-1:
+
+      wq9.1
+      wq11.1
+      wq13.1
+      wq15.1
+
+    Decompress jobs will be submitted from mapped logical cores only, as
+    follows:
+
+      package-0:
+
+        CPU   0-13,112-125   14-27,126-139  28-41,140-153  42-55,154-167
+        IAA:  iax1           iax3           iax5           iax7
+        WQ:   wq1.0          wq3.0          wq5.0          wq7.0
+
+      package-1:
+
+        CPU   56-69,168-181  70-83,182-195  84-97,196-209   98-111,210-223
+        IAA:  iax9           iax11          iax13           iax15
+        WQ:   wq9.0          wq11.0         wq13.0          wq15.0
+
+
 .. _iaa_default_config:
 
 IAA Default Configuration
diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index 56985e395263..549ac98a9366 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -46,6 +46,7 @@ struct iaa_wq {
 	struct idxd_wq		*wq;
 	int			ref;
 	bool			remove;
+	bool			mapped;
 
 	struct iaa_device	*iaa_device;
 
@@ -63,6 +64,13 @@ struct iaa_device_compression_mode {
 	dma_addr_t			aecs_comp_table_dma_addr;
 };
 
+struct wq_table_entry {
+	struct idxd_wq	**wqs;
+	unsigned int	max_wqs;
+	unsigned int	n_wqs;
+	unsigned int	cur_wq;
+};
+
 /* Representation of IAA device with wqs, populated by probe */
 struct iaa_device {
 	struct list_head		list;
@@ -73,19 +81,15 @@ struct iaa_device {
 	int				n_wq;
 	struct list_head		wqs;
 
+	struct wq_table_entry		*generic_wq_table;
+	struct wq_table_entry		*comp_wq_table;
+
 	atomic64_t			comp_calls;
 	atomic64_t			comp_bytes;
 	atomic64_t			decomp_calls;
 	atomic64_t			decomp_bytes;
 };
 
-struct wq_table_entry {
-	struct idxd_wq **wqs;
-	int	max_wqs;
-	int	n_wqs;
-	int	cur_wq;
-};
-
 #define IAA_AECS_ALIGN			32
 
 /*
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 8057e8d1571a..85944ff212e5 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -24,32 +24,86 @@
 #define pr_fmt(fmt)			"idxd: " IDXD_SUBDRIVER_NAME ": " fmt
 
 #define IAA_ALG_PRIORITY               300
+#define MAX_PKG_IAA   8
+#define MAX_IAA_WQ    8
 
 /**************************************
  * Driver internal global variables.
  **************************************/
 
 /* number of iaa instances probed */
-static unsigned int nr_iaa;
+static atomic_t nr_iaa = ATOMIC_INIT(0);
 static unsigned int nr_cpus;
-static unsigned int nr_nodes;
-static unsigned int nr_cpus_per_node;
+static unsigned int nr_packages;
+static unsigned int nr_cpus_per_package;
+static atomic_t nr_iaa_per_package = ATOMIC_INIT(0);
 
 /* Number of physical cpus sharing each iaa instance */
-static unsigned int cpus_per_iaa;
+static atomic_t cpus_per_iaa = ATOMIC_INIT(0);
 
-/* Per-cpu lookup table for balanced wqs */
-static struct wq_table_entry __percpu *wq_table;
+/* Per-cpu lookup table for decomp wqs. */
+static struct wq_table_entry __percpu *cpu_decomp_wqs;
+
+/* Per-cpu lookup table for comp wqs. */
+static struct wq_table_entry __percpu *cpu_comp_wqs;
+
+/* All decomp wqs from IAAs on a package. */
+static struct wq_table_entry **pkg_global_decomp_wqs;
+/* All comp wqs from IAAs on a package. */
+static struct wq_table_entry **pkg_global_comp_wqs;
 
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
 
-/* If enabled, IAA hw crypto algos are registered, unavailable otherwise */
-static bool iaa_crypto_enabled;
+/*
+ * If enabled, IAA hw crypto algos are registered, unavailable otherwise:
+ *
+ * We use the atomic @iaa_crypto_enabled to know if the per-CPU
+ * compress/decompress wq tables have been setup successfully.
+ * Since @iaa_crypto_enabled is atomic, the core functions that
+ * return a wq for compression/decompression, namely,
+ * comp_wq_table_next_wq() and decomp_wq_table_next_wq() will
+ * test this atomic before proceeding to query the per-cpu wq tables.
+ *
+ * These events will set @iaa_crypto_enabled to 1:
+ * - Successful rebalance_wq_table() after individual wq addition/removal.
+ *
+ * These events will set @iaa_crypto_enabled to 0:
+ * - Error during rebalance_wq_table() after individual wq addition/removal.
+ * - check_completion() timeouts.
+ * - @nr_iaa is 0.
+ * - module cleanup.
+ */
+static atomic_t iaa_crypto_enabled = ATOMIC_INIT(0);
+
+/*
+ * First wq probed, to use until @iaa_crypto_enabled is 1:
+ *
+ * The first wq probed will be entered in the per-CPU comp/decomp wq tables
+ * until the IAA compression modes are registered. This is done to facilitate
+ * the compress/decompress calls from the crypto testmgr resulting from
+ * calling crypto_register_acomp().
+ *
+ * With the new dynamic package-level rebalancing of WQs being
+ * discovered asynchronously and concurrently with tests
+ * triggered from device registration, this is needed to
+ * determine when it is safe for the rebalancing of decomp/comp
+ * WQs to de-allocate the per-package WQs and re-allocate them
+ * based on the latest number of IAA devices and WQs.
+ */
+static struct idxd_wq *first_wq_found;
+DEFINE_MUTEX(first_wq_found_lock);
+
 static bool iaa_crypto_registered;
 
 static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
 
+/* Distribute decompressions across all IAAs on the package. */
+static bool iaa_distribute_decomps;
+
+/* Distribute compressions across all IAAs on the package. */
+static bool iaa_distribute_comps = true;
+
 /* Verify results of IAA compress or not */
 static bool iaa_verify_compress = true;
 
@@ -87,6 +141,9 @@ static bool async_mode;
 /* Use interrupts */
 static bool use_irq;
 
+/* Number of compress-only wqs per iaa*/
+static unsigned int g_comp_wqs_per_iaa = 1;
+
 /**************************************************
  * Driver attributes along with get/set functions.
  **************************************************/
@@ -103,7 +160,7 @@ static ssize_t verify_compress_store(struct device_driver *driver,
 
 	mutex_lock(&iaa_devices_lock);
 
-	if (iaa_crypto_enabled)
+	if (atomic_read(&iaa_crypto_enabled))
 		goto out;
 
 	ret = kstrtobool(buf, &iaa_verify_compress);
@@ -167,7 +224,7 @@ static ssize_t sync_mode_store(struct device_driver *driver,
 
 	mutex_lock(&iaa_devices_lock);
 
-	if (iaa_crypto_enabled)
+	if (atomic_read(&iaa_crypto_enabled))
 		goto out;
 
 	ret = set_iaa_sync_mode(buf);
@@ -180,6 +237,87 @@ static ssize_t sync_mode_store(struct device_driver *driver,
 }
 static DRIVER_ATTR_RW(sync_mode);
 
+static ssize_t g_comp_wqs_per_iaa_show(struct device_driver *driver, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", g_comp_wqs_per_iaa);
+}
+
+static ssize_t g_comp_wqs_per_iaa_store(struct device_driver *driver,
+				   const char *buf, size_t count)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&iaa_devices_lock);
+
+	if (atomic_read(&iaa_crypto_enabled))
+		goto out;
+
+	ret = kstrtouint(buf, 10, &g_comp_wqs_per_iaa);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	mutex_unlock(&iaa_devices_lock);
+
+	return ret;
+}
+static DRIVER_ATTR_RW(g_comp_wqs_per_iaa);
+
+static ssize_t distribute_decomps_show(struct device_driver *driver, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", iaa_distribute_decomps);
+}
+
+static ssize_t distribute_decomps_store(struct device_driver *driver,
+					const char *buf, size_t count)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&iaa_devices_lock);
+
+	if (atomic_read(&iaa_crypto_enabled))
+		goto out;
+
+	ret = kstrtobool(buf, &iaa_distribute_decomps);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	mutex_unlock(&iaa_devices_lock);
+
+	return ret;
+}
+static DRIVER_ATTR_RW(distribute_decomps);
+
+static ssize_t distribute_comps_show(struct device_driver *driver, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", iaa_distribute_comps);
+}
+
+static ssize_t distribute_comps_store(struct device_driver *driver,
+				      const char *buf, size_t count)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&iaa_devices_lock);
+
+	if (atomic_read(&iaa_crypto_enabled))
+		goto out;
+
+	ret = kstrtobool(buf, &iaa_distribute_comps);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	mutex_unlock(&iaa_devices_lock);
+
+	return ret;
+}
+static DRIVER_ATTR_RW(distribute_comps);
+
 /****************************
  * Driver compression modes.
  ****************************/
@@ -465,32 +603,81 @@ static void remove_device_compression_modes(struct iaa_device *iaa_device)
  * allocate/init/query/deallocate devices/wqs.
  ***********************************************************/
 
-static struct iaa_device *iaa_device_alloc(void)
+static struct iaa_device *iaa_device_alloc(struct idxd_device *idxd)
 {
 	struct iaa_device *iaa_device;
+	struct wq_table_entry *wqt;
 
 	iaa_device = kzalloc(sizeof(*iaa_device), GFP_KERNEL);
 	if (!iaa_device)
-		return NULL;
+		goto err;
+
+	iaa_device->idxd = idxd;
+
+	/* IAA device's generic/decomp wqs. */
+	iaa_device->generic_wq_table = kzalloc(sizeof(struct wq_table_entry), GFP_KERNEL);
+	if (!iaa_device->generic_wq_table)
+		goto err;
+
+	wqt = iaa_device->generic_wq_table;
+
+	wqt->wqs = kcalloc(iaa_device->idxd->max_wqs, sizeof(struct idxd_wq *), GFP_KERNEL);
+	if (!wqt->wqs)
+		goto err;
+
+	wqt->max_wqs = iaa_device->idxd->max_wqs;
+	wqt->n_wqs = 0;
+
+	/*
+	 * IAA device's comp wqs (optional). If the device has more than
+	 * "g_comp_wqs_per_iaa" WQs configured, the last "g_comp_wqs_per_iaa"
+	 * number of WQs will be considered as "comp only". The remaining
+	 * WQs will be considered as "decomp only".
+	 * If the device has <= "g_comp_wqs_per_iaa" WQs, all the
+	 * device's WQs will be considered "generic", i.e., cores can submit
+	 * comp and decomp jobs to all the WQs configured for the device.
+	 */
+	iaa_device->comp_wq_table = kzalloc(sizeof(struct wq_table_entry), GFP_KERNEL);
+	if (!iaa_device->comp_wq_table)
+		goto err;
+
+	wqt = iaa_device->comp_wq_table;
+
+	wqt->wqs = kcalloc(iaa_device->idxd->max_wqs, sizeof(struct idxd_wq *), GFP_KERNEL);
+	if (!wqt->wqs)
+		goto err;
+
+	wqt->max_wqs = iaa_device->idxd->max_wqs;
+	wqt->n_wqs = 0;
 
 	INIT_LIST_HEAD(&iaa_device->wqs);
 
 	return iaa_device;
+
+err:
+	if (iaa_device) {
+		if (iaa_device->generic_wq_table) {
+			kfree(iaa_device->generic_wq_table->wqs);
+			kfree(iaa_device->generic_wq_table);
+		}
+		kfree(iaa_device->comp_wq_table);
+		kfree(iaa_device);
+	}
+
+	return NULL;
 }
 
 static struct iaa_device *add_iaa_device(struct idxd_device *idxd)
 {
 	struct iaa_device *iaa_device;
 
-	iaa_device = iaa_device_alloc();
+	iaa_device = iaa_device_alloc(idxd);
 	if (!iaa_device)
 		return NULL;
 
-	iaa_device->idxd = idxd;
-
 	list_add_tail(&iaa_device->list, &iaa_devices);
 
-	nr_iaa++;
+	atomic_inc(&nr_iaa);
 
 	return iaa_device;
 }
@@ -510,7 +697,7 @@ static void del_iaa_device(struct iaa_device *iaa_device)
 {
 	list_del(&iaa_device->list);
 
-	nr_iaa--;
+	atomic_dec(&nr_iaa);
 }
 
 static void free_iaa_device(struct iaa_device *iaa_device)
@@ -519,6 +706,17 @@ static void free_iaa_device(struct iaa_device *iaa_device)
 		return;
 
 	remove_device_compression_modes(iaa_device);
+
+	if (iaa_device->generic_wq_table) {
+		kfree(iaa_device->generic_wq_table->wqs);
+		kfree(iaa_device->generic_wq_table);
+	}
+
+	if (iaa_device->comp_wq_table) {
+		kfree(iaa_device->comp_wq_table->wqs);
+		kfree(iaa_device->comp_wq_table);
+	}
+
 	kfree(iaa_device);
 }
 
@@ -568,16 +766,16 @@ static void del_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
 	struct idxd_device *idxd = iaa_device->idxd;
 	struct pci_dev *pdev = idxd->pdev;
 	struct device *dev = &pdev->dev;
-	struct iaa_wq *iaa_wq;
+	struct iaa_wq *iaa_wq, *next_iaa_wq;
 
-	list_for_each_entry(iaa_wq, &iaa_device->wqs, list) {
+	list_for_each_entry_safe(iaa_wq, next_iaa_wq, &iaa_device->wqs, list) {
 		if (iaa_wq->wq == wq) {
 			list_del(&iaa_wq->list);
 			iaa_device->n_wq--;
 
 			dev_dbg(dev, "removed wq %d from iaa_device %d, n_wq %d, nr_iaa %d\n",
 				wq->id, iaa_device->idxd->id,
-				iaa_device->n_wq, nr_iaa);
+				iaa_device->n_wq, atomic_read(&nr_iaa));
 
 			if (iaa_device->n_wq == 0)
 				del_iaa_device(iaa_device);
@@ -588,21 +786,30 @@ static void del_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
 
 static void remove_iaa_wq(struct idxd_wq *wq)
 {
-	struct iaa_device *iaa_device;
+	struct iaa_device *iaa_device, *next_iaa_device;
+	unsigned int num_pkg_iaa = 0;
 
-	list_for_each_entry(iaa_device, &iaa_devices, list) {
+	list_for_each_entry_safe(iaa_device, next_iaa_device, &iaa_devices, list) {
 		if (iaa_has_wq(iaa_device, wq)) {
 			del_iaa_wq(iaa_device, wq);
 			break;
 		}
 	}
 
-	if (nr_iaa) {
-		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-		if (!cpus_per_iaa)
-			cpus_per_iaa = 1;
-	} else
-		cpus_per_iaa = 1;
+	if (atomic_read(&nr_iaa)) {
+		atomic_set(&cpus_per_iaa, (nr_packages * nr_cpus_per_package) / atomic_read(&nr_iaa));
+		if (!atomic_read(&cpus_per_iaa))
+			atomic_set(&cpus_per_iaa, 1);
+
+		num_pkg_iaa = atomic_read(&nr_iaa) / nr_packages;
+		if (!num_pkg_iaa)
+			num_pkg_iaa = 1;
+	} else {
+		atomic_set(&cpus_per_iaa, 1);
+		num_pkg_iaa = 1;
+	}
+
+	atomic_set(&nr_iaa_per_package, num_pkg_iaa);
 }
 
 static void __free_iaa_wq(struct iaa_wq *iaa_wq)
@@ -636,6 +843,7 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	struct pci_dev *pdev;
 	struct device *dev;
 	int ret = 0;
+	unsigned int num_pkg_iaa = 0;
 
 	list_for_each_entry(iaa_device, &iaa_devices, list) {
 		if (iaa_device->idxd == wq->idxd) {
@@ -688,12 +896,19 @@ static int save_iaa_wq(struct idxd_wq *wq)
 		}
 	}
 
-	if (WARN_ON(nr_iaa == 0))
+	if (WARN_ON(atomic_read(&nr_iaa) == 0))
 		return -EINVAL;
 
-	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-	if (!cpus_per_iaa)
-		cpus_per_iaa = 1;
+	atomic_set(&cpus_per_iaa, (nr_packages * nr_cpus_per_package) / atomic_read(&nr_iaa));
+	if (!atomic_read(&cpus_per_iaa))
+		atomic_set(&cpus_per_iaa, 1);
+
+	num_pkg_iaa = atomic_read(&nr_iaa) / nr_packages;
+	if (!num_pkg_iaa)
+		num_pkg_iaa = 1;
+
+	atomic_set(&nr_iaa_per_package, num_pkg_iaa);
+
 out:
 	return ret;
 }
@@ -749,105 +964,290 @@ static int iaa_wq_put(struct idxd_wq *wq)
  * Mapping IAA devices and wqs to cores with per-cpu wq_tables.
  ***************************************************************/
 
-static void wq_table_free_entry(int cpu)
+/*
+ * Given a cpu, find the closest IAA instance.
+ */
+static inline int cpu_to_iaa(int cpu)
 {
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+	int package_id, base_iaa, iaa = 0;
 
-	kfree(entry->wqs);
-	memset(entry, 0, sizeof(*entry));
+	if (!nr_packages || !atomic_read(&nr_iaa_per_package) || !atomic_read(&nr_iaa))
+		return -1;
+
+	package_id = topology_logical_package_id(cpu);
+	base_iaa = package_id * atomic_read(&nr_iaa_per_package);
+	iaa = base_iaa + ((cpu % nr_cpus_per_package) / atomic_read(&cpus_per_iaa));
+
+	pr_debug("cpu = %d, package_id = %d, base_iaa = %d, iaa = %d",
+		 cpu, package_id, base_iaa, iaa);
+
+	if (iaa >= 0 && iaa < atomic_read(&nr_iaa))
+		return iaa;
+
+	return (atomic_read(&nr_iaa) - 1);
 }
 
-static void wq_table_clear_entry(int cpu)
+static void free_wq_tables(void)
 {
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+	if (cpu_decomp_wqs) {
+		free_percpu(cpu_decomp_wqs);
+		cpu_decomp_wqs = NULL;
+	}
 
-	entry->n_wqs = 0;
-	entry->cur_wq = 0;
-	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
+	if (cpu_comp_wqs) {
+		free_percpu(cpu_comp_wqs);
+		cpu_comp_wqs = NULL;
+	}
+
+	pr_debug("freed comp/decomp wq tables\n");
 }
 
-static void clear_wq_table(void)
+static void pkg_global_wqs_dealloc(void)
 {
-	int cpu;
+	int i;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++)
-		wq_table_clear_entry(cpu);
+	if (pkg_global_decomp_wqs) {
+		for (i = 0; i < nr_packages; ++i) {
+			kfree(pkg_global_decomp_wqs[i]->wqs);
+			kfree(pkg_global_decomp_wqs[i]);
+		}
+		kfree(pkg_global_decomp_wqs);
+		pkg_global_decomp_wqs = NULL;
+	}
 
-	pr_debug("cleared wq table\n");
+	if (pkg_global_comp_wqs) {
+		for (i = 0; i < nr_packages; ++i) {
+			kfree(pkg_global_comp_wqs[i]->wqs);
+			kfree(pkg_global_comp_wqs[i]);
+		}
+		kfree(pkg_global_comp_wqs);
+		pkg_global_comp_wqs = NULL;
+	}
 }
 
-static void free_wq_table(void)
+static bool pkg_global_wqs_alloc(void)
 {
-	int cpu;
+	int i;
+
+	pkg_global_decomp_wqs = kcalloc(nr_packages, sizeof(*pkg_global_decomp_wqs), GFP_KERNEL);
+	if (!pkg_global_decomp_wqs)
+		return false;
+
+	for (i = 0; i < nr_packages; ++i) {
+		pkg_global_decomp_wqs[i] = kzalloc(sizeof(struct wq_table_entry), GFP_KERNEL);
+		if (!pkg_global_decomp_wqs[i])
+			goto err;
+
+		pkg_global_decomp_wqs[i]->wqs = kcalloc(MAX_PKG_IAA * MAX_IAA_WQ, sizeof(struct idxd_wq *), GFP_KERNEL);
+		if (!pkg_global_decomp_wqs[i]->wqs)
+			goto err;
+
+		pkg_global_decomp_wqs[i]->max_wqs = MAX_PKG_IAA * MAX_IAA_WQ;
+	}
+
+	pkg_global_comp_wqs = kcalloc(nr_packages, sizeof(*pkg_global_comp_wqs), GFP_KERNEL);
+	if (!pkg_global_comp_wqs)
+		goto err;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++)
-		wq_table_free_entry(cpu);
+	for (i = 0; i < nr_packages; ++i) {
+		pkg_global_comp_wqs[i] = kzalloc(sizeof(struct wq_table_entry), GFP_KERNEL);
+		if (!pkg_global_comp_wqs[i])
+			goto err;
+
+		pkg_global_comp_wqs[i]->wqs = kcalloc(MAX_PKG_IAA * MAX_IAA_WQ, sizeof(struct idxd_wq *), GFP_KERNEL);
+		if (!pkg_global_comp_wqs[i]->wqs)
+			goto err;
+
+		pkg_global_comp_wqs[i]->max_wqs = MAX_PKG_IAA * MAX_IAA_WQ;
+	}
 
-	free_percpu(wq_table);
+	return true;
 
-	pr_debug("freed wq table\n");
+err:
+	pkg_global_wqs_dealloc();
+	return false;
 }
 
 static int alloc_wq_table(int max_wqs)
 {
-	struct wq_table_entry *entry;
-	int cpu;
-
-	wq_table = alloc_percpu(struct wq_table_entry);
-	if (!wq_table)
+	cpu_decomp_wqs = alloc_percpu_gfp(struct wq_table_entry, GFP_KERNEL | __GFP_ZERO);
+	if (!cpu_decomp_wqs)
 		return -ENOMEM;
 
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		entry = per_cpu_ptr(wq_table, cpu);
-		entry->wqs = kcalloc(max_wqs, sizeof(*entry->wqs), GFP_KERNEL);
-		if (!entry->wqs) {
-			free_wq_table();
-			return -ENOMEM;
-		}
+	cpu_comp_wqs = alloc_percpu_gfp(struct wq_table_entry, GFP_KERNEL | __GFP_ZERO);
+	if (!cpu_comp_wqs)
+		goto err;
 
-		entry->max_wqs = max_wqs;
-	}
+	if (!pkg_global_wqs_alloc())
+		goto err;
 
 	pr_debug("initialized wq table\n");
 
 	return 0;
+
+err:
+	free_wq_tables();
+	return -ENOMEM;
+}
+
+/*
+ * The caller should have established that device_iaa_wqs is not empty,
+ * i.e., every IAA device in "iaa_devices" has at least one WQ.
+ */
+static void add_device_wqs_to_wq_table(struct wq_table_entry *dst_wq_table,
+				       struct wq_table_entry *device_wq_table)
+{
+	int i;
+
+	for (i = 0; i < device_wq_table->n_wqs; ++i)
+		dst_wq_table->wqs[dst_wq_table->n_wqs++] = device_wq_table->wqs[i];
 }
 
-static void wq_table_add(int cpu, struct idxd_wq *wq)
+static bool reinit_pkg_global_wqs(bool comp)
 {
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+	int cur_iaa = 0, pkg = 0;
+	struct iaa_device *iaa_device;
+	struct wq_table_entry **pkg_wqs = comp ? pkg_global_comp_wqs : pkg_global_decomp_wqs;
+
+	for (pkg = 0; pkg < nr_packages; ++pkg)
+		pkg_wqs[pkg]->n_wqs = 0;
+
+	pkg = 0;
+
+one_iaa_special_case:
+	/* Re-initialize per-package wqs. */
+	list_for_each_entry(iaa_device, &iaa_devices, list) {
+		struct wq_table_entry *device_wq_table = comp ?
+			((iaa_device->comp_wq_table->n_wqs > 0) ?
+				iaa_device->comp_wq_table : iaa_device->generic_wq_table) :
+			iaa_device->generic_wq_table;
+
+		if (pkg_wqs[pkg]->n_wqs + device_wq_table->n_wqs > pkg_wqs[pkg]->max_wqs) {
+			pkg_wqs[pkg]->wqs = krealloc(pkg_wqs[pkg]->wqs,
+						     ksize(pkg_wqs[pkg]->wqs) +
+						     max((MAX_PKG_IAA * MAX_IAA_WQ), iaa_device->n_wq) * sizeof(struct idxd_wq *),
+						     GFP_KERNEL | __GFP_ZERO);
+			if (!pkg_wqs[pkg]->wqs)
+				return false;
+
+			pkg_wqs[pkg]->max_wqs = ksize(pkg_wqs[pkg]->wqs)/sizeof(struct idxd_wq *);
+		}
+
+		add_device_wqs_to_wq_table(pkg_wqs[pkg], device_wq_table);
+
+		pr_debug("pkg_global_%s_wqs[%d] has %u n_wqs %u max_wqs",
+			 (comp ? "comp" : "decomp"), pkg, pkg_wqs[pkg]->n_wqs, pkg_wqs[pkg]->max_wqs);
+
+		if (++cur_iaa == atomic_read(&nr_iaa_per_package)) {
+			if (++pkg == nr_packages)
+				break;
+			cur_iaa = 0;
+			if (atomic_read(&nr_iaa) == 1)
+				goto one_iaa_special_case;
+		}
+	}
+
+	return true;
+}
+
+static void create_cpu_wq_table(int cpu, struct wq_table_entry *wq_table, bool comp)
+{
+	struct wq_table_entry *entry = comp ?
+		per_cpu_ptr(cpu_comp_wqs, cpu) :
+		per_cpu_ptr(cpu_decomp_wqs, cpu);
+
+	if (!atomic_read(&iaa_crypto_enabled)) {
+		mutex_lock(&first_wq_found_lock);
+
+		if (WARN_ON(!first_wq_found && !wq_table->n_wqs)) {
+			mutex_unlock(&first_wq_found_lock);
+			return;
+		}
+
+		if (!first_wq_found)
+			first_wq_found = wq_table->wqs[0];
 
-	if (WARN_ON(entry->n_wqs == entry->max_wqs))
+		mutex_unlock(&first_wq_found_lock);
+
+		entry->wqs = &first_wq_found;
+		entry->max_wqs = 1;
+		entry->n_wqs = 1;
+		entry->cur_wq = 0;
+		pr_debug("%s: cpu %d: added %u first_wq_found for %s wqs up to wq %d.%d\n", __func__,
+			 cpu, entry->n_wqs, comp ? "comp":"decomp",
+			 entry->wqs[entry->n_wqs - 1]->idxd->id,
+			 entry->wqs[entry->n_wqs - 1]->id);
+		return;
+	}
+
+	entry->wqs = wq_table->wqs;
+	entry->max_wqs = wq_table->max_wqs;
+	entry->n_wqs = wq_table->n_wqs;
+	entry->cur_wq = 0;
+
+	if (entry->n_wqs)
+		pr_debug("%s: cpu %d: added %u iaa %s wqs up to wq %d.%d: entry->max_wqs = %u\n", __func__,
+			 cpu, entry->n_wqs, comp ? "comp":"decomp",
+			 entry->wqs[entry->n_wqs - 1]->idxd->id, entry->wqs[entry->n_wqs - 1]->id,
+			 entry->max_wqs);
+}
+
+static void set_cpu_wq_table_start_wq(int cpu, bool comp)
+{
+	struct wq_table_entry *entry = comp ?
+		per_cpu_ptr(cpu_comp_wqs, cpu) :
+		per_cpu_ptr(cpu_decomp_wqs, cpu);
+	unsigned int num_pkg_iaa = atomic_read(&nr_iaa_per_package);
+
+	if (!num_pkg_iaa)
 		return;
 
-	entry->wqs[entry->n_wqs++] = wq;
+	int start_wq = (entry->n_wqs / num_pkg_iaa) * (cpu_to_iaa(cpu) % num_pkg_iaa);
+
+	if ((start_wq >= 0) && (start_wq < entry->n_wqs))
+		entry->cur_wq = start_wq;
+}
+
+static void create_cpu_wq_table_from_pkg_wqs(bool comp)
+{
+	int cpu;
 
-	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
-		 entry->wqs[entry->n_wqs - 1]->idxd->id,
-		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
+	/*
+	 * All CPU on the same package share the same "package global"
+	 * [de]comp_wqs.
+	 */
+	for (cpu = 0; cpu < nr_cpus; cpu += nr_cpus_per_package) {
+		int package_id = topology_logical_package_id(cpu);
+		struct wq_table_entry *pkg_wq_table = comp ?
+			((pkg_global_comp_wqs[package_id]->n_wqs > 0) ?
+				pkg_global_comp_wqs[package_id] : pkg_global_decomp_wqs[package_id])
+			: pkg_global_decomp_wqs[package_id];
+		int pkg_cpu;
+
+		for (pkg_cpu = cpu; pkg_cpu < cpu + nr_cpus_per_package; ++pkg_cpu) {
+			/* Initialize decomp/comp wq_table for CPU. */
+			create_cpu_wq_table(pkg_cpu, pkg_wq_table, comp);
+			/* Stagger the starting WQ in the package WQ table, for each CPU. */
+			set_cpu_wq_table_start_wq(pkg_cpu, comp);
+		}
+	}
 }
 
-static int wq_table_add_wqs(int iaa, int cpu)
+static int add_mapped_device_wq_table_for_cpu(int iaa, int cpu, bool comp)
 {
 	struct iaa_device *iaa_device, *found_device = NULL;
-	int ret = 0, cur_iaa = 0, n_wqs_added = 0;
-	struct idxd_device *idxd;
-	struct iaa_wq *iaa_wq;
-	struct pci_dev *pdev;
-	struct device *dev;
+	struct wq_table_entry *device_wq_table;
+	int ret = 0, cur_iaa = 0;
 
 	list_for_each_entry(iaa_device, &iaa_devices, list) {
-		idxd = iaa_device->idxd;
-		pdev = idxd->pdev;
-		dev = &pdev->dev;
-
 		if (cur_iaa != iaa) {
 			cur_iaa++;
 			continue;
 		}
 
 		found_device = iaa_device;
-		dev_dbg(dev, "getting wq from iaa_device %d, cur_iaa %d\n",
+		dev_dbg(&found_device->idxd->pdev->dev,
+			"getting wq from iaa_device %d, cur_iaa %d\n",
 			found_device->idxd->id, cur_iaa);
 		break;
 	}
@@ -862,93 +1262,219 @@ static int wq_table_add_wqs(int iaa, int cpu)
 		}
 		cur_iaa = 0;
 
-		idxd = found_device->idxd;
-		pdev = idxd->pdev;
-		dev = &pdev->dev;
-		dev_dbg(dev, "getting wq from only iaa_device %d, cur_iaa %d\n",
+		dev_dbg(&found_device->idxd->pdev->dev,
+			"getting wq from only iaa_device %d, cur_iaa %d\n",
 			found_device->idxd->id, cur_iaa);
 	}
 
-	list_for_each_entry(iaa_wq, &found_device->wqs, list) {
-		wq_table_add(cpu, iaa_wq->wq);
-		pr_debug("rebalance: added wq for cpu=%d: iaa wq %d.%d\n",
-			 cpu, iaa_wq->wq->idxd->id, iaa_wq->wq->id);
-		n_wqs_added++;
+	device_wq_table = comp ?
+		((found_device->comp_wq_table->n_wqs > 0) ?
+			found_device->comp_wq_table : found_device->generic_wq_table) :
+		found_device->generic_wq_table;
+
+	create_cpu_wq_table(cpu, device_wq_table, comp);
+
+out:
+	return ret;
+}
+
+static void create_cpu_wq_table_from_mapped_device(bool comp)
+{
+	int cpu, iaa;
+
+	for_each_possible_cpu(cpu) {
+		iaa = cpu_to_iaa(cpu);
+		pr_debug("rebalance: cpu=%d iaa=%d\n", cpu, iaa);
+
+		if (WARN_ON(iaa == -1)) {
+			pr_debug("rebalance (cpu_to_iaa(%d)) failed!\n", cpu);
+			return;
+		}
+
+		if (WARN_ON(add_mapped_device_wq_table_for_cpu(iaa, cpu, comp))) {
+			pr_debug("could not add any wqs of iaa %d to cpu %d!\n", iaa, cpu);
+			return;
+		}
+	}
+}
+
+static int map_iaa_device_wqs(struct iaa_device *iaa_device)
+{
+	struct wq_table_entry *generic, *for_comps;
+	int ret = 0, n_wqs_added = 0;
+	struct iaa_wq *iaa_wq;
+
+	generic = iaa_device->generic_wq_table;
+	for_comps = iaa_device->comp_wq_table;
+
+	list_for_each_entry(iaa_wq, &iaa_device->wqs, list) {
+		if (iaa_wq->mapped && ++n_wqs_added)
+			continue;
+
+		pr_debug("iaa_device %p: processing wq %d.%d\n", iaa_device, iaa_device->idxd->id, iaa_wq->wq->id);
+
+		if ((!n_wqs_added || ((n_wqs_added + g_comp_wqs_per_iaa) < iaa_device->n_wq)) &&
+			(generic->n_wqs < generic->max_wqs)) {
+
+			generic->wqs[generic->n_wqs++] = iaa_wq->wq;
+			pr_debug("iaa_device %p: added decomp wq %d.%d\n", iaa_device, iaa_device->idxd->id, iaa_wq->wq->id);
+		} else {
+			if (WARN_ON(for_comps->n_wqs == for_comps->max_wqs))
+				break;
+
+			for_comps->wqs[for_comps->n_wqs++] = iaa_wq->wq;
+			pr_debug("iaa_device %p: added comp wq %d.%d\n", iaa_device, iaa_device->idxd->id, iaa_wq->wq->id);
+		}
+
+		iaa_wq->mapped = true;
+		++n_wqs_added;
 	}
 
-	if (!n_wqs_added) {
-		pr_debug("couldn't find any iaa wqs!\n");
+	if (!n_wqs_added && !iaa_device->n_wq) {
+		pr_debug("iaa_device %d: couldn't find any iaa wqs!\n", iaa_device->idxd->id);
 		ret = -EINVAL;
-		goto out;
 	}
-out:
+
 	return ret;
 }
 
+static void map_iaa_devices(void)
+{
+	struct iaa_device *iaa_device;
+
+	list_for_each_entry(iaa_device, &iaa_devices, list) {
+		WARN_ON(map_iaa_device_wqs(iaa_device));
+	}
+}
+
 /*
- * Rebalance the wq table so that given a cpu, it's easy to find the
- * closest IAA instance.  The idea is to try to choose the most
- * appropriate IAA instance for a caller and spread available
- * workqueues around to clients.
+ * Rebalance the per-cpu wq table based on available IAA devices/WQs.
+ * Three driver parameters control how this algorithm works:
+ *
+ * - g_comp_wqs_per_iaa:
+ *
+ *   If multiple WQs are configured for a given device, this setting determines
+ *   the number of WQs to be used as "compress only" WQs. The remaining WQs will
+ *   be used as "decompress only WQs".
+ *   Note that the comp WQ can be the same as the decomp WQ, for e.g., if
+ *   g_comp_wqs_per_iaa is 0 (regardless of the # of available WQs per device), or,
+ *   if there is only 1 WQ configured for a device (regardless of
+ *   g_comp_wqs_per_iaa).
+ *
+ * - distribute_decomps, distribute_comps:
+ *
+ *   If this is enabled, all [de]comp WQs found from the IAA devices on a
+ *   package, will be aggregated into pkg_global_[de]comp_wqs, then assigned to
+ *   each CPU on the package.
+ *
+ * Note:
+ * -----
+ * rebalance_wq_table() will return true if it was able to successfully
+ * configure comp/decomp wqs for all CPUs, without changing the
+ * @iaa_crypto_enabled atomic. The caller can re-enable the use of the wq
+ * tables after rebalance_wq_table() returns true, by setting the
+ * @iaa_crypto_enabled atomic to 1.
+ * In case of any errors, the @iaa_crypto_enabled atomic will be set to 0,
+ * and rebalance_wq_table() will return false.
  */
-static void rebalance_wq_table(void)
+static bool rebalance_wq_table(void)
 {
-	const struct cpumask *node_cpus;
-	int node_cpu, node, cpu, iaa = 0;
+	int cpu;
 
-	if (nr_iaa == 0)
-		return;
+	if (atomic_read(&nr_iaa) == 0)
+		goto err;
 
-	pr_debug("rebalance: nr_nodes=%d, nr_cpus %d, nr_iaa %d, cpus_per_iaa %d\n",
-		 nr_nodes, nr_cpus, nr_iaa, cpus_per_iaa);
+	map_iaa_devices();
 
-	clear_wq_table();
+	pr_info("rebalance: nr_packages=%d, nr_cpus %d, nr_iaa %d, nr_iaa_per_package %d, cpus_per_iaa %d\n",
+		nr_packages, nr_cpus, atomic_read(&nr_iaa),
+		atomic_read(&nr_iaa_per_package), atomic_read(&cpus_per_iaa));
 
-	if (nr_iaa == 1) {
-		for_each_possible_cpu(cpu) {
-			if (WARN_ON(wq_table_add_wqs(0, cpu)))
-				goto err;
-		}
+	if (iaa_distribute_decomps) {
+		/* Each CPU uses all IAA devices on package for decomps. */
+		if (!reinit_pkg_global_wqs(false))
+			goto err;
+		create_cpu_wq_table_from_pkg_wqs(false);
+	} else {
+		/*
+		 * Each CPU uses the decomp WQ on the mapped IAA device using
+		 * a balanced mapping of cores to IAA.
+		 */
+		create_cpu_wq_table_from_mapped_device(false);
+	}
 
-		return;
+	if (iaa_distribute_comps) {
+		/* Each CPU uses all IAA devices on package for comps. */
+		if (!reinit_pkg_global_wqs(true))
+			goto err;
+		create_cpu_wq_table_from_pkg_wqs(true);
+	} else {
+		/*
+		 * Each CPU uses the comp WQ on the mapped IAA device using
+		 * a balanced mapping of cores to IAA.
+		 */
+		create_cpu_wq_table_from_mapped_device(true);
 	}
 
-	for_each_node_with_cpus(node) {
-		cpu = 0;
-		node_cpus = cpumask_of_node(node);
+	/* Verify that each cpu has comp and decomp wqs.*/
+	for_each_possible_cpu(cpu) {
+		struct wq_table_entry *entry = per_cpu_ptr(cpu_decomp_wqs, cpu);
 
-		for_each_cpu(node_cpu, node_cpus) {
-			iaa = cpu / cpus_per_iaa;
-			if (WARN_ON(wq_table_add_wqs(iaa, node_cpu)))
-				goto err;
-			cpu++;
+		if (!entry->wqs || !entry->n_wqs) {
+			pr_err("%s: cpu %d does not have decomp_wqs", __func__, cpu);
+			goto err;
+		}
+
+		entry = per_cpu_ptr(cpu_comp_wqs, cpu);
+		if (!entry->wqs || !entry->n_wqs) {
+			pr_err("%s: cpu %d does not have comp_wqs", __func__, cpu);
+			goto err;
 		}
 	}
 
-	return;
+	pr_debug("Finished rebalance decomp/comp wqs.");
+	return true;
+
 err:
-	pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
+	atomic_set(&iaa_crypto_enabled, 0);
+	pr_debug("Error during rebalance decomp/comp wqs.");
+	return false;
 }
 
 /***************************************************************
  * Assign work-queues for driver ops using per-cpu wq_tables.
  ***************************************************************/
 
-static struct idxd_wq *wq_table_next_wq(int cpu)
+static struct idxd_wq *decomp_wq_table_next_wq(int cpu)
 {
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+	struct wq_table_entry *entry = per_cpu_ptr(cpu_decomp_wqs, cpu);
+	struct idxd_wq *wq;
+
+	if (!atomic_read(&iaa_crypto_enabled))
+		return NULL;
+
+	wq = entry->wqs[entry->cur_wq];
 
-	if (++entry->cur_wq >= entry->n_wqs)
+	if (++entry->cur_wq == entry->n_wqs)
 		entry->cur_wq = 0;
 
-	if (!entry->wqs[entry->cur_wq])
+	return wq;
+}
+
+static struct idxd_wq *comp_wq_table_next_wq(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(cpu_comp_wqs, cpu);
+	struct idxd_wq *wq;
+
+	if (!atomic_read(&iaa_crypto_enabled))
 		return NULL;
 
-	pr_debug("%s: returning wq at idx %d (iaa wq %d.%d) from cpu %d\n", __func__,
-		 entry->cur_wq, entry->wqs[entry->cur_wq]->idxd->id,
-		 entry->wqs[entry->cur_wq]->id, cpu);
+	wq = entry->wqs[entry->cur_wq];
 
-	return entry->wqs[entry->cur_wq];
+	if (++entry->cur_wq == entry->n_wqs)
+		entry->cur_wq = 0;
+
+	return wq;
 }
 
 /*************************************************
@@ -986,7 +1512,7 @@ static inline int check_completion(struct device *dev,
 			dev_err(dev, "%s completion timed out - "
 				"assuming broken hw, iaa_crypto now DISABLED\n",
 				op_str);
-			iaa_crypto_enabled = false;
+			atomic_set(&iaa_crypto_enabled, 0);
 			ret = -ETIMEDOUT;
 			goto out;
 		}
@@ -1502,18 +2028,13 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	compression_ctx = crypto_tfm_ctx(tfm);
 
-	if (!iaa_crypto_enabled) {
-		pr_debug("iaa_crypto disabled, not compressing\n");
-		return -ENODEV;
-	}
-
 	if (!req->src || !req->slen) {
 		pr_debug("invalid src, not compressing\n");
 		return -EINVAL;
 	}
 
 	cpu = get_cpu();
-	wq = wq_table_next_wq(cpu);
+	wq = comp_wq_table_next_wq(cpu);
 	put_cpu();
 	if (!wq) {
 		pr_debug("no wq configured for cpu=%d\n", cpu);
@@ -1600,18 +2121,13 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	struct device *dev;
 	struct idxd_wq *wq;
 
-	if (!iaa_crypto_enabled) {
-		pr_debug("iaa_crypto disabled, not decompressing\n");
-		return -ENODEV;
-	}
-
 	if (!req->src || !req->slen) {
 		pr_debug("invalid src, not decompressing\n");
 		return -EINVAL;
 	}
 
 	cpu = get_cpu();
-	wq = wq_table_next_wq(cpu);
+	wq = decomp_wq_table_next_wq(cpu);
 	put_cpu();
 	if (!wq) {
 		pr_debug("no wq configured for cpu=%d\n", cpu);
@@ -1726,6 +2242,8 @@ static int iaa_register_compression_device(void)
 
 static int iaa_unregister_compression_device(void)
 {
+	atomic_set(&iaa_crypto_enabled, 0);
+
 	if (iaa_crypto_registered)
 		crypto_unregister_acomp(&iaa_acomp_fixed_deflate);
 
@@ -1747,10 +2265,13 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 	if (data->type != IDXD_TYPE_IAX)
 		return -ENODEV;
 
+	mutex_lock(&iaa_devices_lock);
+
 	mutex_lock(&wq->wq_lock);
 
 	if (idxd_wq_get_private(wq)) {
 		mutex_unlock(&wq->wq_lock);
+		mutex_unlock(&iaa_devices_lock);
 		return -EBUSY;
 	}
 
@@ -1772,8 +2293,6 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 		goto err;
 	}
 
-	mutex_lock(&iaa_devices_lock);
-
 	if (list_empty(&iaa_devices)) {
 		ret = alloc_wq_table(wq->idxd->max_wqs);
 		if (ret)
@@ -1785,24 +2304,33 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 	if (ret)
 		goto err_save;
 
-	rebalance_wq_table();
+	if (!rebalance_wq_table()) {
+		dev_dbg(dev, "%s: IAA rebalancing device wq tables failed\n", __func__);
+		goto err_register;
+	}
+	atomic_set(&iaa_crypto_enabled, 1);
 
 	if (first_wq) {
-		iaa_crypto_enabled = true;
 		ret = iaa_register_compression_device();
 		if (ret != 0) {
-			iaa_crypto_enabled = false;
 			dev_dbg(dev, "IAA compression device registration failed\n");
 			goto err_register;
 		}
+
+		if (!rebalance_wq_table()) {
+			dev_dbg(dev, "%s: Rerun after registration: IAA rebalancing device wq tables failed\n", __func__);
+			goto err_register;
+		}
+		atomic_set(&iaa_crypto_enabled, 1);
+
 		try_module_get(THIS_MODULE);
 
 		pr_info("iaa_crypto now ENABLED\n");
 	}
 
-	mutex_unlock(&iaa_devices_lock);
 out:
 	mutex_unlock(&wq->wq_lock);
+	mutex_unlock(&iaa_devices_lock);
 
 	return ret;
 
@@ -1811,9 +2339,8 @@ static int iaa_crypto_probe(struct idxd_dev *idxd_dev)
 	free_iaa_wq(idxd_wq_get_private(wq));
 err_save:
 	if (first_wq)
-		free_wq_table();
+		free_wq_tables();
 err_alloc:
-	mutex_unlock(&iaa_devices_lock);
 	idxd_drv_disable_wq(wq);
 err:
 	wq->type = IDXD_WQT_NONE;
@@ -1828,13 +2355,17 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	struct iaa_wq *iaa_wq;
 	bool free = false;
 
+	atomic_set(&iaa_crypto_enabled, 0);
 	idxd_wq_quiesce(wq);
 
-	mutex_lock(&wq->wq_lock);
 	mutex_lock(&iaa_devices_lock);
+	mutex_lock(&wq->wq_lock);
 
 	remove_iaa_wq(wq);
 
+	if (!rebalance_wq_table())
+		pr_debug("%s: IAA rebalancing device wq tables failed\n", __func__);
+
 	spin_lock(&idxd->dev_lock);
 	iaa_wq = idxd_wq_get_private(wq);
 	if (!iaa_wq) {
@@ -1857,18 +2388,24 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	}
 
 	idxd_drv_disable_wq(wq);
-	rebalance_wq_table();
 
-	if (nr_iaa == 0) {
-		iaa_crypto_enabled = false;
-		free_wq_table();
+	if (atomic_read(&nr_iaa) == 0) {
+		atomic_set(&iaa_crypto_enabled, 0);
+		pkg_global_wqs_dealloc();
+		free_wq_tables();
+		WARN_ON(!list_empty(&iaa_devices));
+		INIT_LIST_HEAD(&iaa_devices);
 		module_put(THIS_MODULE);
 
 		pr_info("iaa_crypto now DISABLED\n");
+	} else if (rebalance_wq_table()) {
+		atomic_set(&iaa_crypto_enabled, 1);
+	} else {
+		pr_debug("%s: IAA re-rebalancing device wq tables failed\n", __func__);
 	}
 out:
-	mutex_unlock(&iaa_devices_lock);
 	mutex_unlock(&wq->wq_lock);
+	mutex_unlock(&iaa_devices_lock);
 }
 
 static enum idxd_dev_type dev_types[] = {
@@ -1891,16 +2428,12 @@ static struct idxd_device_driver iaa_crypto_driver = {
 static int __init iaa_crypto_init_module(void)
 {
 	int ret = 0;
-	int node;
+
+	INIT_LIST_HEAD(&iaa_devices);
 
 	nr_cpus = num_possible_cpus();
-	for_each_node_with_cpus(node)
-		nr_nodes++;
-	if (!nr_nodes) {
-		pr_err("IAA couldn't find any nodes with cpus\n");
-		return -ENODEV;
-	}
-	nr_cpus_per_node = nr_cpus / nr_nodes;
+	nr_cpus_per_package = topology_num_cores_per_package();
+	nr_packages = topology_max_packages();
 
 	ret = iaa_aecs_init_fixed();
 	if (ret < 0) {
@@ -1914,6 +2447,27 @@ static int __init iaa_crypto_init_module(void)
 		goto err_driver_reg;
 	}
 
+	ret = driver_create_file(&iaa_crypto_driver.drv,
+				&driver_attr_g_comp_wqs_per_iaa);
+	if (ret) {
+		pr_debug("IAA g_comp_wqs_per_iaa attr creation failed\n");
+		goto err_g_comp_wqs_per_iaa_attr_create;
+	}
+
+	ret = driver_create_file(&iaa_crypto_driver.drv,
+				 &driver_attr_distribute_decomps);
+	if (ret) {
+		pr_debug("IAA distribute_decomps attr creation failed\n");
+		goto err_distribute_decomps_attr_create;
+	}
+
+	ret = driver_create_file(&iaa_crypto_driver.drv,
+				 &driver_attr_distribute_comps);
+	if (ret) {
+		pr_debug("IAA distribute_comps attr creation failed\n");
+		goto err_distribute_comps_attr_create;
+	}
+
 	ret = driver_create_file(&iaa_crypto_driver.drv,
 				 &driver_attr_verify_compress);
 	if (ret) {
@@ -1939,6 +2493,15 @@ static int __init iaa_crypto_init_module(void)
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_verify_compress);
 err_verify_attr_create:
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_distribute_comps);
+err_distribute_comps_attr_create:
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_distribute_decomps);
+err_distribute_decomps_attr_create:
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_g_comp_wqs_per_iaa);
+err_g_comp_wqs_per_iaa_attr_create:
 	idxd_driver_unregister(&iaa_crypto_driver);
 err_driver_reg:
 	iaa_aecs_cleanup_fixed();
@@ -1957,6 +2520,12 @@ static void __exit iaa_crypto_cleanup_module(void)
 			   &driver_attr_sync_mode);
 	driver_remove_file(&iaa_crypto_driver.drv,
 			   &driver_attr_verify_compress);
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_distribute_comps);
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_distribute_decomps);
+	driver_remove_file(&iaa_crypto_driver.drv,
+			   &driver_attr_g_comp_wqs_per_iaa);
 	idxd_driver_unregister(&iaa_crypto_driver);
 	iaa_aecs_cleanup_fixed();
 
-- 
2.27.0

