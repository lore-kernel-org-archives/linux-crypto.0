From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 0/6] crypto: SHA512 multibuffer implementation
Date: Mon, 27 Jun 2016 10:20:03 -0700
Message-ID: <1467048009-2826-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22953 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbcF0ROD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Jun 2016 13:14:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Megha Dey <megha.dey@linux.intel.com>

In this patch series, we introduce the multi-buffer crypto algorithm on
x86_64 and apply it to SHA512 hash computation.  The multi-buffer techn=
ique
takes advantage of the 8 data lanes in the AVX2 registers and allows
computation to be performed on data from multiple jobs in parallel.
This allows us to parallelize computations when data inter-dependency i=
n
a single crypto job prevents us to fully parallelize our computations.
The algorithm can be extended to other hashing and encryption schemes
in the future.

On multi-buffer SHA512 computation with AVX2, we see throughput increas=
e
up to 2x over the existing x86_64 single buffer AVX2 algorithm.

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

Also added, is a new mode in the tcrypt modules to calculate the speed =
of the
sha512_mb algorithm.

Megha Dey (6):
  crypto: sha512-mb - SHA512 multibuffer job manager and glue code
  crypto: sha512-mb - Enable SHA512 multibuffer support
  crypto: sha512-mb - submit/flush routines for AVX2
  crypto: sha512-mb - Algorithm data structures
  crypto: sha512-mb - Crypto computation (x4 AVX2)
  crypto: tcrypt - Add new mode for sha512_mb

 arch/x86/crypto/Makefile                           |    1 +
 arch/x86/crypto/sha512-mb/Makefile                 |   11 +
 arch/x86/crypto/sha512-mb/sha512_mb.c              | 1043 ++++++++++++=
++++++++
 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h          |  130 +++
 arch/x86/crypto/sha512-mb/sha512_mb_mgr.h          |  104 ++
 .../crypto/sha512-mb/sha512_mb_mgr_datastruct.S    |  281 ++++++
 .../crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S    |  291 ++++++
 .../x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c |   67 ++
 .../crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S   |  222 +++++
 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S         |  529 ++++++++++
 crypto/Kconfig                                     |   16 +
 crypto/tcrypt.c                                    |    4 +
 12 files changed, 2699 insertions(+)
 create mode 100644 arch/x86/crypto/sha512-mb/Makefile
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb.c
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr.h
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_datastruct.=
S
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.=
S
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2=
=2ES
 create mode 100644 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S

--=20
1.9.1
