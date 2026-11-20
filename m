Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148358;
	b=FlvO2VERAoabvkXxndG/CQawY4VCQRi7eDgEWI9iuVZXEgD21LgmrrRXw+6yPcDpm/tb
	 Hwbrv4nVYM6QgtfkeLI+OajoP6bN85TPpY4jnIym0VodXjJM6ptleQUZyoyWemoJR4GqQ
	 blSBcInDuibEEKMzgciOwBKYWeTcyK0TIZua6VVPRAFtzUDf7brvjroarhIqG3jm/1buZ
	 E5mfSgHVETYSD3tUlDwHJ2K3kIbeQ6+/WqEr0WGtZ4jyaXE0cTQ32tjumCS3vn4g179Bd
	 uNCyordhuLqa1yaYJpCe5dfmLMb8tXz90kt9nO8dmYTxaOMtxvZv8+yLpuM7iTJqLvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148358;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UYrze/KXPKhgC9vTXcx7YCelJnkkGe6FzkVtDuZCdZE=;
	b=TXtO9/BnIEP0XlMClvLCy5AdTyxp6kWMK1HjHDAPatojXOW3tfMfhjXNOTSI13NORtH4
	 cPyHdB55SwJ0nAmIe8uCRJYu6IeEBTQwORKSkXdXE4xkICM7vxfNeRzr66ZGBhMH3a8VR
	 H2cSUQJk6FGo0MXRcOF4b5tz+26q8xYQuv/TPyOQlLE4MCpy46idy49ZNiXZ0yxFX1uFG
	 LCIpcISP1rCkRTLabvivAJSEHooiuuO3v3zBhDEOHy1fUesx+d9+i2k8KsOnuk4LPEk8G
	 YxsHeiLgz94czwMp3pG3jrttQ7OJg0SSFhuEu7/bHVOLwdQtxcnL9LK9MRaza7hmYig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OBtIKX2t;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9855B606A320
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9855B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OBtIKX2t
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1a2af4c8d00so976315c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148357; x=1795753157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UYrze/KXPKhgC9vTXcx7YCelJnkkGe6FzkVtDuZCdZE=;
        b=OBtIKX2t3DBNxNXd0+ecIPDMlmssclhYaiezTeM7XlRwsHbrZcrTByYBiS1BKPiCpG
         DYTteuPgpWh2Rp+fBHdQ59iY+BQY6Zz24/no8mRCDSn4B6oX+HVZY9mZdPUadfc+PnnK
         2BrstnAfe5ooRVuhKJUGD/YZJQ5e0yUpbKnXwojKdpVXhonqffvYNCeHiMSHfehplUnx
         cPBtbuPyr9ER0oQ/STq9q2yWBnum020JzzVATZQi5FlgQ+zE22N9mnpIFAyY7B9SiTq3
         Y78GNyTggsIrmeXm69AAc4nnsMwhHUKi3qjb7GPYZDfYO7BhY5pWoIeIxmTwARwqwbtf
         nyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148357; x=1795753157;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UYrze/KXPKhgC9vTXcx7YCelJnkkGe6FzkVtDuZCdZE=;
        b=R63/9vc3W9SOXfqANTfmXuNk6au2BDcdgNFzr3tU1Fqz/h1Nxx5ZsfjjjUyC8+iX/A
         VH+IhCx6Yhq2cxU3hKc+36ftULdxRmYvFG/wY1HvinZ8i8QCmBkg9grd20nf05cfyip3
         LQt5huWT6K8TQ+q/MfOJ6IimY9PAUG/+RgriTaUq6XEFtsglb+IQ3VTMRbbc/hCIUkAr
         NJiCImm90lp5WqWJyvZBW3nnH7N20pkAGCR65iySu2j23sHsEYGvVi7o17WZGtBO9h99
         4wM5afcrYf5KQwNHDZ0bFHIFWf/OEp8EoP//uutSfTov6nTMoZ7AcFyo8XRAg+T0ksTU
         s3SQ==
X-Forwarded-Encrypted: i=1; AL+hErHwNjZlxF4CXeHJpOBKhjs00Wyeyt7Ixgx4qCMWweLFMPYf8tEMd77s1ZaCQu6N5vUWU4knG4X3kUIOPro=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4IEgCwr8EiJSIU+DXExak53j69jLI4lT42Lekb3/JwItGtY3q
	PfeJY9vzAbqmXqlM3v8hKD4/+/BBhwq/5RmCdvfcKULcgAjDJhNP/Lc1
X-Gm-Gg: AYBFou0wmiN2Mk7irfLBBPu/CQKREVfeK0PYcEecAKvCALmDImGuuOPRcGouh+KBdDQ
	26k9Oj4sbdkpVFs6ZhFjRYz7A6c8d4NlL/tBcQc46T47sAmjM8isXqqkeJ7hbcUxNnoam/AeMKQ
	YXle7scXT6ZstOHPMtL7faQKtPtYwcZ13Z3M5U3yoEfFqZ336mMTJRmJ0BLPdjNTjAS9I+S9sLH
	+r2dnwwv1z61PGQqdWnnelqxk2OodWmThB5pIg1+rlhObBPmwecvg7qR7KwO65Bv20v1+foXqYR
	CsaLoXHLStq/aNRVdxGs4ETz++OBW7NAx0r7Zy7dC7ILQ51mXvEnAGvYt3rs1xiYKxfFeThAh6w
	jcGUD+6PIMwnUGmI+/Y3ZYbIoWbkHTkVNZFsBLRfRgQOCNhD7pukr6LAbjETb7KPysYmXIXMPva
	xIhcrl25yqJxxL1mlA+KFGE/HAej/He99lpLEXimQSRaUNf9MBjGkFIPa3CWe55xxKEaO1J2ngW
	bNFe/u5ysso3gqCo/YoQdN8wCu/6a1A6sfpTHaHMgqBcyGh8XYF4S+SgnVpPC+IYv5o9mdqMmuJ
	QJYWKq6Vxk2ijvssbB2CXO3rnrk6f5UwSlchyKdI3w==
X-Received: by 2002:a05:701b:260e:b0:1a9:c52f:655c with SMTP id a92af1059eb24-1b556900476mr1869170c88.36.1795148356366;
        Thu, 19 Nov 2026 20:19:16 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:15 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
Date: Thu, 19 Nov 2026 20:18:58 -0800
Message-Id: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


v4: Batched zswap_store() framework with compression batching
=============================================================

This series is a spin-off of "v14: zswap compression batching with optimized
iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
compression batching enablers. Resuming work on this series following a gap
since v14 (January 2026). Please note that my email address and affiliation have
changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
have retained the original Intel sign-offs on prior patches for historical
attribution while signing off v4 of this series with my current address.

The main focus of v4 was to establish a performance measurement methodology to
quantify the benefits to high level metrics by using zswap compression
batching. This was done using an Intel Sapphire Rapids bare-metal instance with
48 physical cores and by running "usemem30", i.e., 30 concurrent usemem
processes, each of which allocates 10G, in a 150G memory.high contrained cgroup,
for 10 iterations. The environment was set up to minimize performance jitter so
we can understand the system-level/workload-level advantages of zswap
compression batching when running workloads at scale.

To summarize the main contribution of this patch series: Batching is introduced
in zswap_store() of large folios: we carve out a large folio into batches of
ZSWAP_MAX_BATCH_SIZE (4 pages) for software compressors, and store each
batch. Moving the fundamental operations that need to be happen to store a page
to now work at the granularity of a batch offers opportunities to optimize them
from these perspectives:

1) Utilize existing kernel API that minimize obtaining locks for bulk
   operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().

2) We keep the working set for each of the core store functionalities
   (alloc/initialize zswap entries, compress pages, store pages in zsmalloc,
   pool/objcg reference increments, objcg charging) to be focused on a
   batch, thereby minimizing cache evictions and benefiting from cache
   locality.

3) Along the lines of (1), the main zswap_compress() batching routine obtains
   the comp_ctx mutex lock once per batch, and releases it after it has
   processed all pages in that batch.

4) Any zswap store functionality that works on a batch can potentially be
   optimized via bulk-processing/parallelized as a next step, to further improve
   performance.

Performance testing: usemem30 with 100% over-commit:
=====================================================
Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
866f761fd414) and with this patch series.

v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance with
48 cores.

 Bare-metal instance specs:
 --------------------------
 - 48 physical cores
 - 190G RAM
 - 200G SWAP disk partition

 Workload: 30 concurrent usemem processes, each allocates 10G:
 -------------------------------------------------------------
 The vm-scalability "usemem" test (unmodified version) was run in a
 cgroup with memory.high fixed at 150G. There is no swap limit set for the
 cgroup.

 To quantify the performance benefit of zswap compress batching at scale,
 30 usemem processes were run ("usemem30"), each allocating and writing 10G of
 memory, and sleeping for 10 sec before exiting.

  usemem -w -O -b 5 -s 10 -n 30 10g
  echo 0 > /sys/module/zswap/parameters/shrinker_enabled

 Performance validation methodology:
 -----------------------------------
 These settings were used to minimize variation:

 - All cores were fixed to run at 2.4GHz with "performance" scaling governor.
 - Turbo boost was disabled.
 - CPU power-saving C-states restricted with:

     GRUB_CMDLINE_LINUX_DEFAULT="intel_idle.max_cstate=1 processor.max_cstate=1"

 The usemem30 experiments were run with the baseline mm-unstable as of
 11-17-2026 (commit 866f761fd414) and with this patch-series.

 After booting into each kernel:

  1) Constrain the cgroup's memory.high to 150G.

  2) Run 2 warm-up iterations of usemem30. Don't use this data for benchmarking
     since sys time typically skews higher for initial runs.

  3) Next, run 10 benchmarking iterations of usemem30:
     - Log these high-level metrics: Sys time and individual usemem throughput.

  4) Sys time and Throughput metrics were gathered for three mTHP settings:

     - 2048kB
     - 1024kB
     - 64kB

  5) Benchmark summary data includes Sys time and Throughput components from the
     10 iterations of usemem30:

     - Total Samples
     - Mean Value
     - Std Deviation
     - CoV (Variance): Coefficient of variation (relative standard deviation)
       measures spread relative to the mean rather than statistical variance.

 An LLM was used to help generate the benchmarking and data processing scripts.

usemem30 Benchmarking Summary:
==============================

 ---------------------------------------------------
    Improvement with v4 zswap compress batching
 ---------------------------------------------------
  mTHP enabled:       2048kB     1024kB       64kB
 ---------------------------------------------------
      Sys time:      -13.87%     -2.64%     -1.72%
    Throughput:       +3.85%     +0.42%     +1.31%
 ---------------------------------------------------

Detailed usemem30 benchmarking data:
====================================

 1) 2048kB mTHP:
 ===============
 
 ------------------------------------------------------------------
 2048kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                              (sec)        (sec)
 ------------------------------------------------------------------
 [Run 1/10]  Sys Time:    1581.414s    1356.252s 
 [Run 2/10]  Sys Time:    1642.874s    1478.929s 
 [Run 3/10]  Sys Time:    1594.458s    1411.252s 
 [Run 4/10]  Sys Time:    1580.988s    1380.959s 
 [Run 5/10]  Sys Time:    1579.654s    1380.609s 
 [Run 6/10]  Sys Time:    1627.765s    1345.582s 
 [Run 7/10]  Sys Time:    1593.872s    1334.485s 
 [Run 8/10]  Sys Time:    1623.189s    1405.471s 
 [Run 9/10]  Sys Time:    1661.954s    1433.365s 
 [Run 10/10] Sys Time:    1602.098s    1329.813s
 ------------------------------------------------------------------
 
 ------------------------------------------------------------------
 METRIC: System CPU Time (Sys Time) : 2048kB mTHP
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                              (sec)            (sec)
 ------------------------------------------------------------------
 Total Samples    :              10               10        
 Mean Value       :        1,608.83         1,385.67
 Std Deviation    :           28.67            47.47
 CoV (Variance)   :           1.78%            3.43%       
 ------------------------------------------------------------------
 METRIC: Per-Process Throughput : 2048kB mTHP
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                             (KB/s)           (KB/s)
 ------------------------------------------------------------------
 Total Samples    :             300              300       
 Mean Value       :         292,261          303,508  
 Std Deviation    :          12,946           20,806  
 CoV (Variance)   :           4.42%            6.86% 
 ------------------------------------------------------------------


 2) 1024kB mTHP:
 ===============
 
 ------------------------------------------------------------------
 1024kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                              (sec)        (sec)
 ------------------------------------------------------------------
 [Run 1/10]  Sys Time:    1567.639s    1594.696s 
 [Run 2/10]  Sys Time:    1537.577s    1456.113s 
 [Run 3/10]  Sys Time:    1538.562s    1521.887s 
 [Run 4/10]  Sys Time:    1626.176s    1531.962s 
 [Run 5/10]  Sys Time:    1593.955s    1528.733s 
 [Run 6/10]  Sys Time:    1643.519s    1558.482s 
 [Run 7/10]  Sys Time:    1510.613s    1480.177s 
 [Run 8/10]  Sys Time:    1632.018s    1584.093s 
 [Run 9/10]  Sys Time:    1569.424s    1528.915s 
 [Run 10/10] Sys Time:    1552.747s    1570.451s
 ------------------------------------------------------------------
 
 ------------------------------------------------------------------
 METRIC: System CPU Time (Sys Time) : 1024kB mTHP
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                              (sec)            (sec)
 ------------------------------------------------------------------
 Total Samples    :             10                10        
 Mean Value       :       1,577.22          1,535.55
 Std Deviation    :          45.13             43.79
 CoV (Variance)   :          2.86%             2.85%       
 ------------------------------------------------------------------
 METRIC: Per-Process Throughput : 1024kB mTHP
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                             (KB/s)           (KB/s)
 ------------------------------------------------------------------
 Total Samples    :            300               300       
 Mean Value       :        289,904           291,114  
 Std Deviation    :         15,385            14,553  
 CoV (Variance)   :          5.31%             5.00% 
 ------------------------------------------------------------------


 3) 64kB mTHP:
 =============
 
 ------------------------------------------------------------------
 64kB mTHP usemem30 benchmark suite: 10 runs (Limit: 150G).
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                              (sec)        (sec)
 ------------------------------------------------------------------
 [Run 1/10]  Sys Time:    1914.525s    1878.483s 
 [Run 2/10]  Sys Time:    1869.412s    1863.177s 
 [Run 3/10]  Sys Time:    1944.049s    1863.502s 
 [Run 4/10]  Sys Time:    1942.757s    1900.144s 
 [Run 5/10]  Sys Time:    1866.505s    1887.285s 
 [Run 6/10]  Sys Time:    1877.716s    1861.668s 
 [Run 7/10]  Sys Time:    1861.741s    1868.788s 
 [Run 8/10]  Sys Time:    1904.735s    1816.372s 
 [Run 9/10]  Sys Time:    1891.074s    1850.435s 
 [Run 10/10] Sys Time:    1893.366s    1849.747s
 ------------------------------------------------------------------
 
 ------------------------------------------------------------------
 METRIC: System CPU Time (Sys Time) : 64kB mTHP
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                              (sec)            (sec)
 ------------------------------------------------------------------
 Total Samples    :              10               10        
 Mean Value       :        1,896.59         1,863.96
 Std Deviation    :           29.86            22.96 
 CoV (Variance)   :           1.57%            1.23%       
 ------------------------------------------------------------------
 METRIC: Per-Process Throughput : 64kB mTHP
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
                             (KB/s)           (KB/s)
 ------------------------------------------------------------------
 Total Samples    :            300               300       
 Mean Value       :        239,114           242,254   
 Std Deviation    :          9,090             6,419   
 CoV (Variance)   :          3.80%             2.65% 
 ------------------------------------------------------------------


usemem30 vmstats and zswap stats collected after benchmarking runs finish:
==========================================================================

 -----------------------------------------------------------------------
                              2048kB mTHP
 -----------------------------------------------------------------------
                     Baseline mm-unstable   v4 zswap compress batching
 -----------------------------------------------------------------------
 pswpin                                 0                          0
 pswpout                                0                          0
 thp_swpout                             0                          0
 thp_swpout_fallback                    6                          5
 zswpin                              4030                       4342
 zswpout                        430976801                  429712411
 zswpwb                                 0                          0
 pgmajfault                          6198                       6529
 2048kB-alloc                     1540507                    1536772
 2048kB-zswpout                    838683                     832643
 2048kB-swpout                          0                          0
 2048kB-swpout-fallback                 6                          5
 2048kB-swpin                           0                          0
 zswap_pool_total_size            4919296                    4882432
 zswap_pool_limit_hit                   0                          0
 zswap_written_back_pages               0                          0
 zswap_stored_pages                  4047                       3818
 memory.current                         0                          0
 memory.swap.current                    0                          0
 -----------------------------------------------------------------------


 -----------------------------------------------------------------------
                              1024kB mTHP
 -----------------------------------------------------------------------
                      Baseline mm-unstable   v4 zswap compress batching
 -----------------------------------------------------------------------
 pswpin                                  0                       0
 pswpout                                 0                       0
 thp_swpout                              0                       0
 thp_swpout_fallback                     0                       0
 zswpin                               4806                    4691
 zswpout                         429599479               429010497
 zswpwb                                  0                       0
 pgmajfault                           7117                    6993
 1024kB-alloc                      3192334                 3190121
 1024kB-zswpout                    1633939                 1625770
 1024kB-swpout                           0                       0
 1024kB-swpout-fallback                 11                       0
 1024kB-swpin                            0                       0
 zswap_pool_total_size             7577600                 6418432
 zswap_pool_limit_hit                    0                       0
 zswap_written_back_pagess               0                       0
 zswap_stored_incompressible_pages      12                       9
 zswap_stored_pages                   6798                    5175
 memory.current                          0                       0
 memory.swap.current                     0                       0
 ------------------------------------------------------------------


 ------------------------------------------------------------------
                             64kB mTHP
 ------------------------------------------------------------------
               Baseline mm-unstable   v4 zswap compress batching
 ------------------------------------------------------------------
 pswpin                           0                        0
 pswpout                          0                        0
 thp_swpout                       0                        0
 thp_swpout_fallback              0                        0
 zswpin                        4906                     4444
 zswpout                  431480331                430606606
 zswpwb                           0                        0
 pgmajfault                    7233                     6669
 64kB-alloc                56263335                 56231864
 64kB-zswpout              26950511                 26901497
 64kB-swpout                      0                        0
 64kB-swpout-fallback             0                        0
 64kB-swpin                       0                        0
 zswap_pool_total_size      5648384                  5050368
 zswap_pool_limit_hit             0                        0
 zswap_written_back_pages         0                        0
 zswap_stored_pages            4175                     3652
 memory.current                   0                        0
 memory.swap.current              0                        0
 ------------------------------------------------------------------

Conclusions based on the data:
==============================

 v3 demonstrated that the batching of zswap_store() phases and compress
 batching optimizations benefit zswap_store() and zswap_compress_per_page()
 median and tail latencies for PMD folios and base 4K folios.

 v4 demonstrates how these low-level bptrace savings obtained in v3 translate
 to performance improvements at the system level and workload level. v4's
 performance validation is done at scale with 30 concurrent usemem processes,
 with Sys time and Throughput being the key high-level metrics. We further study
 this for PMD THP, 1024kB and 64kB folios.

 Sys time measured across 10 consecutive iterations of usemem30 improves
 significantly with zswap compress batching, -13.87% lower than mm-unstable for
 PMD THP. Per-process Throughput increases by 3.85% for PMD folios. As this
 patch-series impacts batching within folios, the Sys time savings reduces
 for lower order folios.

 The immediate benefit of zswap compress batching is saving CPU compute
 cycles, that can imply lower power consumption and existing kernel
 optimizations with reduced CPU compute cycles spent in critical
 paths. There are also modest throughput improvements that this
 patch-series delivers.

 As other kernel components related to mTHP become more efficient, the net
 realized performance benefit can only be better with this patch-series than
 without, given the significant Sys time reduction with zswap store and compress
 batching.

 The batching framework established in this series allows us to make
 locking and bulk-processing improvements in each stage of zswap_store(). One of
 the ideas that has shown very promising results is to replace zsmalloc with
 SLUB compressed caches and will be submitted separately. This is expected to
 resolve the p50 batch compress latency issue seen in v3's bpftrace data, since
 it will be directly optimizing zswap_update_entries(), where compressed buffers
 can be binned based on size and bulk allocated from SLUB.
 
 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the higher-order folio vmstat v4 data shows. This enables
 other mm components that are optimized for large folios, such as munmap(),
 folio refcounts/mapcounts updates, PTE invalidation upon freeing memory,
 zswap_invalidate(); which benefit from xarray offsets/range continuity. As a
 result, subsequent large folio swapouts are more likely to find contiguous swap
 slots, there are fewer large folio splits during reclaim and the cycle
 continues. As the data demonstrates, this directly contributes to more memory
 over-commit opportunity.

 The benefits are attributable to the store batching framework added in patches
 6-7, that is fully utilized to improve zswap_compress() latency by giving it a
 batch of pages to be compressed. As the bpftrace data shows, patches 6-7 alone
 are not sufficient for the gains. Batch compression added in patch 8 benefits
 latency significantly, for these reasons:

  1) Per-CPU sg_table with ZSWAP_MAX_BATCH_SIZE scatterlists that are statically
     mapped to compression dst buffers for that CPU, thereby minimizing local SG
     lists initialization, and using compact new crypto_acomp API introduced in
     patches 1-4 that set up an acomp_req's src/dst to be SG lists.

  2) Patch 6 allocates ZSWAP_MAX_BATCH_SIZE destination buffers in the per-CPU
     acomp_ctx, for an added memory overhead of ~12 KB per-CPU. The trade-off pays
     off in significant latency improvements which can potentially be used to
     drive higher memory over-commit in data center setups.

  3) A one-shot zswap_update_entries() does all the zsmalloc handle allocation
     and copying for the batch. The key concept driving efficiency is that the
     working set is kept focused on batch-centric data pertaining to a handful
     of operations on the batch, to minimize cache evictions and benefit from
     cache locality.

  4) By making zswap_compress() more efficient, we are able to lock the comp
     mutex per batch of ZSWAP_MAX_BATCH_SIZE (4) pages instead of per-page.
     
 The exceptions are p50/p95 batch compress latencies (normalized per-page), even
 though the p99 batch compress latency improves significantly, by 15% over
 mm-unstable. Batch compress latency can be optimized further in subsequent
 patches.

[1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334628-1-kanchana.p.sridhar@intel.com/


Changes since v3:
=================
1) Rebased to latest mm-unstable as of 11-17-2026, commit 866f761fd414.

2) Sashiko's v3 code review comments addressed in v4:

   - Patch 7:
     - Modified obj_cgroup_charge_zswap() to call obj_cgroup_charge_zswap_many()
       to avoid the charging code duplication.
     - memcontrol.c: Added a stub for obj_cgroup_get_many() in the #else section
       of the #ifdef CONFIG_MEMCG block.
     - We skip the incompressible page updates in zswap_tree_stores() and
       obj_cgroup_charge_zswap_many() if the nr_incomp_pages is 0.

  - Patch 8:
    - Clamp nr_batch_pages to zc->nr_pages - batch_start on each
      iteration over zc->nr_pages in zswap_compress(). Calculate slen
      accordingly, before proceeding to use slen for the subsequent crypto()
      API calls.
    - In the post-crypto_acomp_compress() !wb_enabled block that checks for
      negative errors codes in sg->length, cast sg->length to (int) before
      checking for sg->length <= 0.

3) Gathered high-level metrics (Sys time, throughput) as suggested by Yosry.


Changes since v2:
=================

Resolved v2 code review issues highlighted by Sashiko. Baseline mm-unstable as
of 10-25-2026, commit a2abad0d7f45.

1) Patch 3:
  - Re-wrote the fast path conditional to be !acomp_is_async(tfm) instead of
    !acomp_req_on_stack(req).
  - Moved the state-flag changes from acomp_save_req() back to
    acomp_virt_to_sg().

2) Patch 4:
  - Replaced the ambiguous use of "cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS" with
    directly checkinf for "cra_type == &crypto_acomp_type" to detect an
    acomp_alg.

3) Patch 5:
  - Fixed the off-by-one bitfield width by modifying
    ZSWAP_MAX_COMPR_LENGTH_SHIFT to 19U and the build time assertion check for
    BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <= PAGE_SHIFT)).

4) Patch 6:
  - Moved the "u8 compr_batch_size" to struct zswap_comp_ctx, which is
    per-CPU to address the "unsynchronized write to pool->compr_batch_size on
    CPU hotplug" issue Sashiko highlighted.

5) Patch 7:
  - The special casing for comp_ret=0 with dlen == PAGE_SIZE (among other
    end-cases) when writeback is disabled, is replicated in the batched
    version of zswap_compress() as well.

6) Patch 8:
  - Added obj_cgroup_charge_zswap_many() to correctly account for MEMCG_ZSWAP*
    counters with bulk-charging total compressed bytes to zswap.
  - Resolved zsmalloc() handles leak issue in case of compress batch failures
    in zswap_update_entries().
  - Deleted zswap_pool_get().


Changes since v1:
=================
1) Rebased to mm-unstable as of 10-25-2026, commit a2abad0d7f45.

2) Addressed Herbert's comments on checking for the req->unit_size being equal
   to the req->slen to identify singleton acomp_reqs and to quickly
   short-circuit with setting the dst SG list length instead of going through
   the request chaining flow. Further, the most common code path is the very
   first check, with the short-circuit, in crypto_acomp_compress().
   
3) Addressed Yosry's comments wrt:
   - struct zswap_entry "length" field build-time assertion to have sufficient
     bit-fields for the architecture's PAGE_SIZE.
   - Use kmem_cache_alloc() instead of kmem_cache_alloc_node() in
     zswap_entry_cache_alloc().

4) Established a reliable and accurate performance validation methodology, based
   on Yosry's comments.

5) Refactored the sub-components of zswap_store_pages() where each routine
   processes a batch. The new zswap_account_stores() gets refs, updates
   statistics and charges cgroup for the batch, rather than for a page at a
   time. zswap_store_pages() is more readable and maintainable. This batching
   framework can be immediately useful for implementing more ideas such as SLUB
   bulk allocation of compressed data, reclaiming a batch of folios from
   shrink_folio_list(), etc.


Changes since [1]:
==================
1) Better cacheline placement of struct zswap_pool and struct zswap_entry
   members for temporal memory access efficiency in zswap store/load hot paths,
   while minimizing holes.

2) Refactored the core compression batching functionality to a separate
   __zswap_compress() function, which is called by zswap_compress(), as per
   Nhat's and Yosry's comments. Hopefully this helps explain the outer "store
   batching" zswap_compress() vis-a-vis the inner "compress batching"
   __zswap_compress() distinction.

3) The acomp_ctx is locked once and is passed to the routine that compresses a
   batch, per the algorithm's batch-size. Similarly, the folio's node id and
   writeback_enabled status are computed once and passed to the routines that
   implement the different store functionalities, to save latency by avoid
   localized recomputes of information that doesn't change.

4) Moved the folio node id being stored in zswap_entry to a separate patch, per
   Yosry's comment.

5) Addressed the kunmap_local() issue flagged by Jixin He in the
   IS_ERR_VALUE(handle) error path
   (https://patchwork.kernel.org/comment/27095925) - thanks!

6) Moved comments inline, per Yosry's suggestions.


Thanks,
Kanchana


Kanchana P. Sridhar (8):
  crypto: acomp - Define a unit_size in struct acomp_req to enable
    batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
  crypto: acomp - Add bit to indicate segmentation support.
  crypto: acomp - Add trivial segmentation wrapper.
  crypto: acomp - Add API to get a compression algorithm's batch-size.
  mm: zswap: Store the folio's node id in the zswap_entry.
  mm: zswap: Store large folios in batches.
  mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
  mm: zswap: Batched zswap_compress() for storing large folios in
    batches.

 crypto/acompress.c                  |  48 +-
 include/crypto/acompress.h          |  66 ++-
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |  10 +-
 include/linux/crypto.h              |   5 +-
 include/linux/memcontrol.h          |  12 +
 mm/memcontrol.c                     |  23 +-
 mm/zswap.c                          | 667 +++++++++++++++++++++-------
 8 files changed, 662 insertions(+), 174 deletions(-)

-- 
2.39.5

