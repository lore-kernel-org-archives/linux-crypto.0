From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/6] crypto: SHA1 multibuffer implementation
Date: Tue, 13 May 2014 16:19:39 -0700
Message-ID: <1400023179.2970.237.camel@schen9-DESK>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5921 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaEMXTn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 19:19:43 -0400
In-Reply-To: <cover.1399990803.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In this patch series, we introduce the multi-buffer crypto algorithm on
x86_64 and apply it to SHA1 hash computation.  The multi-buffer techniq=
ue
takes advantage of the 8 data lanes in the AVX2 registers and allows
computation to be performed on data from multiple jobs in parallel.
This allows us to parallelize computations when data inter-dependency i=
n
a single crypto job prevents us to fully parallelize our computations.
The algorithm can be extended to other hashing and encryption schemes
in the future.

On multi-buffer SHA1 computation with AVX2, we see throughput increase
up to 2.2x over the existing x86_64 single buffer AVX2 algorithm.

The multi-buffer crypto algorithm is described in the following paper:
Processing Multiple Buffers in Parallel to Increase Performance on
Intel=C2=AE Architecture Processors
http://www.intel.com/content/www/us/en/communications/communications-ia=
-multi-buffer-paper.html

The outline of the algorithm is sketched below:
Any driver requesting the crypto service will place an async
crypto request on the workqueue.  The multi-buffer crypto daemon will
pull request from work queue and put each request in an empty data lane
for multi-buffer crypto computation.  When all the empty lanes are fill=
ed,
computation will commence on the jobs in parallel and the job with the
shortest remaining buffer will get completed and be returned.  To preve=
nt
prolonged stall when there is no new jobs arriving, we will flush a cry=
pto
job if it has not been completed after a maximum allowable delay.

The multi-buffer algorithm necessitates mapping multiple scatter gather
buffers to linear addresses simultaneously. The crypto daemon may need
to sleep and yield the cpu to work on something else from time to time.
We made a change to not use kmap_atomic to do scatter-gather buffer
mapping and take advantage of the fact that we can directly translate
address the buffer's address to its linear address with x86_64.
To accommodate the fragmented nature of scatter-gather, we will keep
submitting the next scatter-buffer fragment for a job for multi-buffer
computation until a job is completed and no more buffer fragments remai=
n.
At that time we will pull a new job to fill the now empty data slot.
We call a get_completed_job function to check whether there are other
jobs that have been completed when we job when we have no new job arriv=
al
to prevent extraneous delay in returning any completed jobs.

The multi-buffer algorithm should be used for cases where crypto jobs
submissions are at a reasonable high rate.  For low crypto job submissi=
on
rate, this algorithm will not be beneficial. The reason is at low rate,
we do not fill out the data lanes before the maximum allowable latency,
we will be flushing the jobs instead of processing them with all the
data lanes full.  We will miss the benefit of parallel computation,
and adding delay to the processing of the crypto job at the same time.
Some tuning of the maximum latency parameter may be needed to get the
best performance.

Note that the tcrypt SHA1 speed test, we wait for a previous job to
be completed before submitting a new job.  Hence this is not a valid
test for multi-buffer algorithm as it requires multiple outstanding job=
s
submitted to fill the all data lanes to be effective (i.e. 8 outstandin=
g
jobs for the AVX2 case).

As this is the first algorithm in the kernel's crypto library
that we have tried to use multi-buffer optimizations, feedbacks=20
and testings will be much appreciated.

Tim Chen

---

Tim Chen (6):
  crypto: SHA1 multibuffer map scatter gather walk's buffer address
    directly for x86_64
  crypto: SHA1 multibuffer crypto hash infrastructure
  crypto: SHA1 multibuffer algorithm data structures
  crypto: SHA1 multibuffer submit and flush routines for AVX2
  crypto: SHA1 multibuffer crypto computation (x8 AVX2)
  crypto: SHA1 multibuffer scheduler

 arch/x86/crypto/Makefile                         |   2 +
 arch/x86/crypto/sha-mb/Makefile                  |  11 +
 arch/x86/crypto/sha-mb/sha1-mb.c                 | 931 +++++++++++++++=
++++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S  | 287 +++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S  | 327 ++++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c   |  64 ++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S | 228 ++++++
 arch/x86/crypto/sha-mb/sha1_x8_avx2.S            | 472 ++++++++++++
 arch/x86/crypto/sha-mb/sha_mb_ctx.h              | 136 ++++
 arch/x86/crypto/sha-mb/sha_mb_mgr.h              | 110 +++
 crypto/Kconfig                                   |  30 +
 crypto/Makefile                                  |   1 +
 crypto/ahash.c                                   |   6 +
 crypto/mcryptd.c                                 | 576 ++++++++++++++
 crypto/shash.c                                   |  48 ++
 include/crypto/internal/hash.h                   |   9 +
 include/crypto/mcryptd.h                         | 109 +++
 17 files changed, 3347 insertions(+)
 create mode 100644 arch/x86/crypto/sha-mb/Makefile
 create mode 100644 arch/x86/crypto/sha-mb/sha1-mb.c
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_datastruct.S
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
 create mode 100644 arch/x86/crypto/sha-mb/sha1_x8_avx2.S
 create mode 100644 arch/x86/crypto/sha-mb/sha_mb_ctx.h
 create mode 100644 arch/x86/crypto/sha-mb/sha_mb_mgr.h
 create mode 100644 crypto/mcryptd.c
 create mode 100644 include/crypto/mcryptd.h

--=20
1.7.11.7
