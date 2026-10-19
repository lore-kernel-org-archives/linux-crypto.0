Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451200;
	b=jS2RKuDNYLznNeVQJ28WqYv/UbjOw2zN7p2eCrD+5D+pS3WGlvNwUxTWVWdMS6FYs9GE
	 qiqwawHF+iwLLFy/3158PVoz3ClSwAQpMRilW0+Va6afrr2k2xEL5/EfhyLUlrW5vnd5R
	 aM2xs29O6dqPsmH02LRp3zlDWzDy4MxBiBbbAZpTCFavg5dMSY4SMOAGzXgH2kGZSR5HE
	 Xiekf7c2vgY/3rfB+6E60kWwCq5FQEnfuK/rCsddJ1yDAw7+qqNlJuUNwYn9IjlOeWyNW
	 0crts98HHk9LCDDdrnHOayZVc3MTeTlSpt967xvUSO7ffWJVJX6CX3bCf1Q4xo85apA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451200;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=7cJoLE2Lypc2jiiuJXJQynyzOM3YS0iRe94GL9RodWU=;
	b=QZGxF60ZJwerbLfeJH062hK1tGQEmIWw9wFdCY8ue02N9mCVPMHFvCIbqTxBUBTFlzTU
	 xIO8J9AcQdMEOhZHJCpnQ1Le1/Iy4dgD2PK/AUh1ap0SfGA+WqWtIMZgwRvXll9cOY/+v
	 tki2ITLAKc+9bziM3RnPd7SeJdtBSVlVLewU8gBaNs1SFgHcavwMDAw2XD/hWBOASZxib
	 /uAzk6ZMJpzHEiH4kwmBo8DylP76ZQVIZdHcmmDWf3U0JTP+uLr+63uHu+OmUSMytruI9
	 YvX6jOmd5fTbv9mJHXwsyfgJ45fjMGBfCz7rN/BCdPgtb+uVn6SVA7q8wWNsB5QkgmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=C4uIFey7;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6943E606A328;
	Mon, 19 Oct 2026 23:06:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6943E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=C4uIFey7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792451200; x=1823987200;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=m547TdJwh+U4Jqv2xDPq6WBIWUFuCcjPrAL3helEQa0=;
  b=C4uIFey7GvPEkvfepcEsUWvK2P42fsImxn3OjPfzBd/Fsh9NVaihPvcu
   MGHOQbYdF4xFwUaQcAkE8wJ8dxSUJyPvoCI4Sgvc0dnpsB5qhxRgMVyi3
   jirG1Oxri0qaYBmzvspTXmPUOglfafyJ4iUxEttBk/sfstLtFSetaN5bq
   hk3EZRjbInT51GPd8BdNMzpOEoHD7wYZ4NTpuGYtqK794S4y1VH3oAgby
   XabQ94TcEWv2Cp9YKwXgaG6k06aWKedumBx03OgjIL7tpijLL727P/yws
   +iPeJAkVqp+fYjeUJ2hDIzUCz/l2GGNhjSWKq/+JBYPG4Wc80B+93a+/e
   A==;
X-CSE-ConnectionGUID: 6+hpYw3USEuDikHLyCZzcQ==
X-CSE-MsgGUID: cpz0vo2CRAOMn2Xnz2Kk3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1249183"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1249183"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:36 -0700
X-CSE-ConnectionGUID: Vyehzfw9QneijvvPUyjILw==
X-CSE-MsgGUID: I6AAMIRnTrO7tZ/MMXWM0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2989981"
Received: from vcostago-desk1.jf.intel.com (HELO [10.98.24.84]) ([10.98.24.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 16:06:35 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 19 Oct 2026 16:06:23 -0700
Subject: [PATCH 4/4] crypto: iaa - keep each CPU on one WQ for
 decompression
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-iaa-crypto-wq-tables-v1-4-fab67b2a1538@intel.com>
References: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
In-Reply-To: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
To: Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
X-Mailer: b4 0.17-dev-6be7c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792451190; l=4435;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=m547TdJwh+U4Jqv2xDPq6WBIWUFuCcjPrAL3helEQa0=;
 b=sZhQFGq9WSl+lCp7VD7Xo1z0tgFKDtlfPTuWeXEyRGTjxU+ANGStwnPLXLggsu6xQKSZ3P7W1
 a8agC5QiEyBAnlxUHNkb94LvFpIicxZWS0YneSPOJgiMSO/XDwQWAlh
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

Decompressions round-robin over the package's WQs like compressions
do. Decompressions are latency-sensitive, and do better staying on a
warm engine.

Have each CPU pick one WQ of its package's table the first time it
decompresses, spread over the table by a per-table counter, and stay on
it.

The CPU caches the index, not the WQ, so it cannot outlive the table it
came from; rebalance makes every CPU pick again.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 40 +++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 2ce545e8df42..4f2c99c099df 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -35,12 +35,15 @@ static unsigned int nr_iaa;
 struct iaa_pkg_table {
 	struct rcu_head	rcu;
 	int		n_wqs;
+	atomic_t	decomp_next;
 	struct idxd_wq	*wqs[];
 };
 
 /* Indexed by logical package id, the count is fixed at boot */
 static struct iaa_pkg_table __rcu **iaa_pkg_tables;
 static DEFINE_PER_CPU(unsigned int, iaa_wq_idx);
+/* The WQ of its package's table a CPU decompresses on, -1 until it picks */
+static DEFINE_PER_CPU(int, iaa_decomp_wq_idx) = -1;
 
 static int iaa_cpu_pkg(int cpu)
 {
@@ -49,16 +52,35 @@ static int iaa_cpu_pkg(int cpu)
 	return (pkg >= 0 && pkg < topology_max_packages()) ? pkg : 0;
 }
 
-/* Round-robins over the WQs of the caller's package */
-static struct idxd_wq *iaa_next_wq(void)
+/* Pick the idx of the WQ on first usage on each CPU */
+static unsigned int iaa_decomp_wq_pick(struct iaa_pkg_table *table)
+{
+	int idx = this_cpu_read(iaa_decomp_wq_idx);
+
+	/* An index left over from a wider table just means picking again */
+	if (unlikely(idx < 0 || idx >= table->n_wqs)) {
+		idx = (unsigned int)atomic_inc_return(&table->decomp_next) %
+		      table->n_wqs;
+		this_cpu_write(iaa_decomp_wq_idx, idx);
+	}
+
+	return idx;
+}
+
+/* Compression round-robins over the package's WQs, decompression keeps one */
+static struct idxd_wq *iaa_next_wq(bool decomp)
 {
 	struct iaa_pkg_table *table;
+	unsigned int idx;
 
 	table = rcu_dereference(iaa_pkg_tables[iaa_cpu_pkg(raw_smp_processor_id())]);
 	if (!table)
 		return NULL;
 
-	return table->wqs[this_cpu_inc_return(iaa_wq_idx) % table->n_wqs];
+	idx = decomp ? iaa_decomp_wq_pick(table) :
+		       this_cpu_inc_return(iaa_wq_idx) % table->n_wqs;
+
+	return table->wqs[idx];
 }
 
 LIST_HEAD(iaa_devices);
@@ -779,7 +801,7 @@ static int rebalance_pkg_tables(void)
 	struct iaa_pkg_table **tables, *table, *first = NULL;
 	struct iaa_device *iaa_device;
 	struct iaa_wq *iaa_wq;
-	int pkg, n_wqs = 0;
+	int cpu, pkg, n_wqs = 0;
 
 	if (nr_iaa == 0) {
 		publish_pkg_tables(NULL);
@@ -820,6 +842,10 @@ static int rebalance_pkg_tables(void)
 	publish_pkg_tables(tables);
 	kfree(tables);
 
+	/* Have every CPU pick its decompression WQ again, from the new table */
+	for_each_possible_cpu(cpu)
+		WRITE_ONCE(per_cpu(iaa_decomp_wq_idx, cpu), -1);
+
 	return 0;
 err:
 	for (pkg = 0; pkg < topology_max_packages(); pkg++)
@@ -1412,6 +1438,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	struct iaa_compression_ctx *compression_ctx;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
+	bool decomp = false;
 	int ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct idxd_wq *wq;
@@ -1439,7 +1466,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 	/* The table, and its WQs until iaa_wq_get() returns, need RCU */
 	rcu_read_lock();
-	wq = iaa_next_wq();
+	wq = iaa_next_wq(decomp);
 	ret = wq ? iaa_wq_get(wq) : -ENODEV;
 	rcu_read_unlock();
 	if (ret) {
@@ -1512,6 +1539,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
 	bool use_bounce_src = false;
+	bool decomp = true;
 	int ret = 0;
 	struct iaa_wq *iaa_wq;
 	struct device *dev;
@@ -1544,7 +1572,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 
 	/* The table, and its WQs until iaa_wq_get() returns, need RCU */
 	rcu_read_lock();
-	wq = iaa_next_wq();
+	wq = iaa_next_wq(decomp);
 	ret = wq ? iaa_wq_get(wq) : -ENODEV;
 	rcu_read_unlock();
 	if (ret) {

-- 
2.56.0

