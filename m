Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9E51B85C5;
	Tue,  3 Jun 2025 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748994941; cv=none; b=Cc7YF0fIBp2VhqwtUUpJfb72pPaAs/JCcVFfdpg7SmRJxOmV/Acbw2bw1WhEPnczhhnoHXvxZhR8xyKdqdENFuZyaFoJWkGCtTd6RAIB8mww988ycmBWAxIEvRcIfsymiPqV+H2K2xfRmPBVxi1kybuzckJWKbDF/Znn11LD2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748994941; c=relaxed/simple;
	bh=+FY+J2/g1tr0ztOnEC0gjxjzFDNvy158f5kZGrEYGLM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=N4pjSANxzJMHot54swADguFCxLWoUgN45AbAi1FmtYUS/yqunPvCiPoJP2U+ybmkkVv5bED1znnHCuFbg/WOUo5tDMmlBYG2cWYtwZiXozIXfBeQxFukvtK53+uz/ZMmFdWQ9yziGUQJMS5Hxd1Ig0fwbO+WCgDUTCsmvS1OL+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHmd5GGV; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHmd5GGV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748994939; x=1780530939;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+FY+J2/g1tr0ztOnEC0gjxjzFDNvy158f5kZGrEYGLM=;
  b=HHmd5GGVTr3IxDzyR5nW+jlZ0UiHwBPVIydSYFLRRA0TqTzmGbOwBLAJ
   +MfHpTw0bbzSDUrskoNQdO5+aR19jb04e/C4kBKymGGiAwtZmq67pyMHc
   g/d40Aso1eGhYuUkYUNUo6uswcvo4bKEnlkaJYZKl0O5gbaR5ab2BXvXL
   XHgtsY+MG+8NWC2eSAXpdhCgsvVgcr2XYCkXfKz3CEIE0wDW87RKlcAz6
   9lHh7U0kypuRqTgqG06scOAJ9JOBno7CrKx1B5OM1254l7VTZUqLzK01W
   PL8smmbmwDiI6jmq+FXW+dLMaDaBpVtqWdhIyhBghYRjnlM8zDpbQ4x60
   w==;
X-CSE-ConnectionGUID: 6CjMWzDATKmKmnsy4e4Lwg==
X-CSE-MsgGUID: E09Z5Ph1SVe62QMPkFROrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50174300"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="50174300"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 16:55:39 -0700
X-CSE-ConnectionGUID: fpV5Al96Sced5f1AMukjDw==
X-CSE-MsgGUID: C8qxDrrKSTWR/2gCDxWEUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="150163152"
Received: from unknown (HELO vcostago-mobl3.jf.intel.com) ([10.241.226.49])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 16:55:39 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: iaa - Fix race condition when probing IAA devices
Date: Tue,  3 Jun 2025 16:55:31 -0700
Message-ID: <20250603235531.159711-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While adding new devices the per-cpu workqueue map are temporarily
cleared, if a user tries to use them at that point it may fail. That
is, code calling wq_table_next_wq() may race during probe when
rebalance_wq_table() is called, which clears before rebuilding the
workqueue map. Add a spinlock to protect serialize that.

Add some lockdep asserts to document when this new lock should be
held.

It was reported that running iaa-deflate selftests using a IAA device
while another is being probed could fail:

[   45.432348] ------------[ cut here ]------------
[   45.432350] alg: self-tests for deflate using deflate-iaa failed (rc=-19)
[   45.432372] WARNING: CPU: 43 PID: 1402 at crypto/testmgr.c:6026 alg_test.part.0+0x493/0x570
[   45.432387] Modules linked in: iaa_crypto(+) mlx5_core qat_4xxx sr_mod ast igb mlxfw intel_qat cdrom drm_shmem_helper pci_hyperv_intf idxd
[   45.432405]  dca dh_generic crc8 rpcrdma rdma_cm iw_cm ib_cm sunrpc ib_core
[   45.432426] CPU: 43 UID: 0 PID: 1402 Comm: cryptomgr_test Not tainted 6.14.0-cwf.bkc.6.14.4.4.6.x86_64 #1
[   45.432436] RIP: 0010:alg_test.part.0+0x493/0x570
[   45.432442] Code: ef 8b 48 28 48 8b 50 20 e8 2a f9 ff ff 41 89 c0 e9 10 fe ff ff 44 89 c1 4c 89 e2 4c 89 ee 48 c7 c7 b8 86 3d 83 e8 dd 90 88 ff <0f> 0b 44 8b 44 24 04 e9 a9 fc ff ff 44 8d 7b 01 e9 90 fe ff ff 48
[   45.432458] RSP: 0018:ffffc90024bb3de8 EFLAGS: 00010286
[   45.432464] RAX: 0000000000000000 RBX: 000000000000004c RCX: 0000000000000000
[   45.432469] RDX: 0000000000000002 RSI: ffffffff834ee543 RDI: 00000000ffffffff
[   45.432472] RBP: 000000000000004d R08: 0000000000003d0e R09: ffffffff833d86e6
[   45.432476] R10: 0000000000000001 R11: 0000000000000004 R12: ffff88a099be1000
[   45.432480] R13: ffff88a099be1080 R14: 000000000000004d R15: 0000000000001340
[   45.432483] FS:  0000000000000000(0000) GS:ffff88bfff8c0000(0000) knlGS:0000000000000000
[   45.432488] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.432492] CR2: 00007fd70ad9c4e0 CR3: 000000000ce36001 CR4: 0000000108f70ef0
[   45.432495] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   45.432497] DR3: 0000000000000000 DR6: 00000000ffff07f0 DR7: 0000000000000400
[   45.432501] PKRU: 55555554
[   45.432504] Call Trace:
[   45.432508]  <TASK>
[   45.432513]  ? __warn+0x81/0x130
[   45.432524]  ? alg_test.part.0+0x493/0x570
[   45.432529]  ? report_bug+0x1c7/0x1d0
[   45.432540]  ? handle_bug+0x53/0x90
[   45.432546]  ? exc_invalid_op+0x18/0x70
[   45.432550]  ? asm_fred_entrypoint_kernel+0x45/0x60
[   45.432562]  ? alg_test.part.0+0x493/0x570
[   45.432570]  ? alg_test.part.0+0x493/0x570
[   45.432574]  ? _raw_spin_unlock+0x18/0x40
[   45.432583]  ? finish_task_switch.isra.0+0x97/0x290
[   45.432594]  ? __schedule+0x2fc/0x7a0
[   45.432603]  ? preempt_count_add+0x6d/0xa0
[   45.432611]  ? __pfx_cryptomgr_test+0x10/0x10
[   45.432619]  cryptomgr_test+0x24/0x40
[   45.432628]  kthread+0x10f/0x250
[   45.432636]  ? finish_task_switch.isra.0+0x97/0x290
[   45.432644]  ? __pfx_kthread+0x10/0x10
[   45.432650]  ? __pfx_kthread+0x10/0x10
[   45.432648] initcall iaa_crypto_init_module+0x0/0x2b0 [iaa_crypto] returned 0 after 2388 usecs
[   45.432657]  ret_from_fork+0x31/0x50
[   45.432668]  ? __pfx_kthread+0x10/0x10
[   45.432675]  ret_from_fork_asm+0x1a/0x30
[   45.432685]  </TASK>
[   45.432688] ---[ end trace 0000000000000000 ]---

Fixes: 2ec6761df889 ("crypto: iaa - Add support for deflate-iaa compression algorithm")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 48 ++++++++++++++++++----
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 23f585219fb4..2185c101bef3 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -35,28 +35,39 @@ static unsigned int cpus_per_iaa;
 
 /* Per-cpu lookup table for balanced wqs */
 static struct wq_table_entry __percpu *wq_table;
+static DEFINE_SPINLOCK(wq_table_lock);
 
 static struct idxd_wq *wq_table_next_wq(int cpu)
 {
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+	struct wq_table_entry *entry;
+	struct idxd_wq *wq;
+	int id;
+
+	guard(spinlock)(&wq_table_lock);
+
+	entry = per_cpu_ptr(wq_table, cpu);
 
 	if (++entry->cur_wq >= entry->n_wqs)
 		entry->cur_wq = 0;
 
-	if (!entry->wqs[entry->cur_wq])
+	id = entry->cur_wq;
+	wq = entry->wqs[id];
+
+	if (!wq)
 		return NULL;
 
 	pr_debug("%s: returning wq at idx %d (iaa wq %d.%d) from cpu %d\n", __func__,
-		 entry->cur_wq, entry->wqs[entry->cur_wq]->idxd->id,
-		 entry->wqs[entry->cur_wq]->id, cpu);
+		 id, wq->idxd->id, wq->id, cpu);
 
-	return entry->wqs[entry->cur_wq];
+	return wq;
 }
 
 static void wq_table_add(int cpu, struct idxd_wq *wq)
 {
 	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
 
+	lockdep_assert_held(&wq_table_lock);
+
 	if (WARN_ON(entry->n_wqs == entry->max_wqs))
 		return;
 
@@ -71,6 +82,8 @@ static void wq_table_free_entry(int cpu)
 {
 	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
 
+	lockdep_assert_held(&wq_table_lock);
+
 	kfree(entry->wqs);
 	memset(entry, 0, sizeof(*entry));
 }
@@ -79,6 +92,8 @@ static void wq_table_clear_entry(int cpu)
 {
 	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
 
+	lockdep_assert_held(&wq_table_lock);
+
 	entry->n_wqs = 0;
 	entry->cur_wq = 0;
 	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
@@ -702,14 +717,23 @@ static int iaa_wq_put(struct idxd_wq *wq)
 	return ret;
 }
 
-static void free_wq_table(void)
+static void __free_wq_table(void)
 {
 	int cpu;
 
+	lockdep_assert_held(&wq_table_lock);
+
 	for (cpu = 0; cpu < nr_cpus; cpu++)
 		wq_table_free_entry(cpu);
 
 	free_percpu(wq_table);
+}
+
+static void free_wq_table(void)
+{
+	guard(spinlock)(&wq_table_lock);
+
+	__free_wq_table();
 
 	pr_debug("freed wq table\n");
 }
@@ -719,15 +743,17 @@ static int alloc_wq_table(int max_wqs)
 	struct wq_table_entry *entry;
 	int cpu;
 
-	wq_table = alloc_percpu(struct wq_table_entry);
+	guard(spinlock)(&wq_table_lock);
+
+	wq_table = alloc_percpu_gfp(struct wq_table_entry, GFP_ATOMIC);
 	if (!wq_table)
 		return -ENOMEM;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		entry = per_cpu_ptr(wq_table, cpu);
-		entry->wqs = kcalloc(max_wqs, sizeof(*entry->wqs), GFP_KERNEL);
+		entry->wqs = kcalloc(max_wqs, sizeof(*entry->wqs), GFP_ATOMIC);
 		if (!entry->wqs) {
-			free_wq_table();
+			__free_wq_table();
 			return -ENOMEM;
 		}
 
@@ -836,6 +862,8 @@ static int wq_table_add_wqs(int iaa, int cpu)
 	struct pci_dev *pdev;
 	struct device *dev;
 
+	lockdep_assert_held(&wq_table_lock);
+
 	list_for_each_entry(iaa_device, &iaa_devices, list) {
 		idxd = iaa_device->idxd;
 		pdev = idxd->pdev;
@@ -902,6 +930,8 @@ static void rebalance_wq_table(void)
 	pr_debug("rebalance: nr_nodes=%d, nr_cpus %d, nr_iaa %d, cpus_per_iaa %d\n",
 		 nr_nodes, nr_cpus, nr_iaa, cpus_per_iaa);
 
+	guard(spinlock)(&wq_table_lock);
+
 	clear_wq_table();
 
 	if (nr_iaa == 1) {
-- 
2.49.0

