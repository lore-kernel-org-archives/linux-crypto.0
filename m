From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 0/7] crypto: SHA256 multibuffer implementation
Date: Thu, 23 Jun 2016 18:40:41 -0700
Message-ID: <1466732448-27856-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:15303 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbcFXBen (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 21:34:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Megha Dey <megha.dey@linux.intel.com>

In this patch series, we introduce the multi-buffer crypto algorithm on
x86_64 and apply it to SHA256 hash computation.  The multi-buffer techn=
ique
takes advantage of the 8 data lanes in the AVX2 registers and allows
computation to be performed on data from multiple jobs in parallel.
This allows us to parallelize computations when data inter-dependency i=
n
a single crypto job prevents us to fully parallelize our computations.
The algorithm can be extended to other hashing and encryption schemes
in the future.

On multi-buffer SHA256 computation with AVX2, we see throughput increas=
e
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

Note that the tcrypt SHA256 speed test, we wait for a previous job to
be completed before submitting a new job.  Hence this is not a valid
test for multi-buffer algorithm as it requires multiple outstanding job=
s
submitted to fill the all data lanes to be effective (i.e. 8 outstandin=
g
jobs for the AVX2 case). An updated version of the tcrypt test is also
included which would contain a more appropriate test for this scenario.

As this is the first algorithm in the kernel's crypto library
that we have tried to use multi-buffer optimizations, feedbacks
and testings will be much appreciated.

Megha Dey (7):
  crypto: sha256-mb - SHA256 multibuffer job manager and glue code
  crypto: sha256-mb - Enable multibuffer support
  crypto: sha256-mb - submit/flush routines for AVX2
  crypto: sha256-mb - Algorithm data structures
  crypto: sha256-mb - Crypto computation (x8 AVX2)
  crypto: tcrypt - Add speed tests for SHA multibuffer algorithms
  crypto: sha1-mb - rename sha-mb to sha1-mb

 arch/x86/crypto/Makefile                           |    3 +-
 arch/x86/crypto/{sha-mb =3D> sha1-mb}/Makefile       |    0
 arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_mb.c      |    2 +-
 .../{sha-mb/sha_mb_ctx.h =3D> sha1-mb/sha1_mb_ctx.h} |    2 +-
 .../{sha-mb/sha_mb_mgr.h =3D> sha1-mb/sha1_mb_mgr.h} |    0
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_datastruct.S   |    0
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_flush_avx2.S   |    0
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_init_avx2.c    |    2 +-
 .../{sha-mb =3D> sha1-mb}/sha1_mb_mgr_submit_avx2.S  |    0
 arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_x8_avx2.S |    0
 arch/x86/crypto/sha256-mb/Makefile                 |   11 +
 arch/x86/crypto/sha256-mb/sha256_mb.c              | 1027 ++++++++++++=
++++++++
 arch/x86/crypto/sha256-mb/sha256_mb_ctx.h          |  136 +++
 arch/x86/crypto/sha256-mb/sha256_mb_mgr.h          |  108 ++
 .../crypto/sha256-mb/sha256_mb_mgr_datastruct.S    |  304 ++++++
 .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |  304 ++++++
 .../x86/crypto/sha256-mb/sha256_mb_mgr_init_avx2.c |   65 ++
 .../crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S   |  215 ++++
 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S         |  593 +++++++++++
 crypto/Kconfig                                     |   16 +
 crypto/tcrypt.c                                    |  118 +++
 21 files changed, 2902 insertions(+), 4 deletions(-)
 rename arch/x86/crypto/{sha-mb =3D> sha1-mb}/Makefile (100%)
 rename arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_mb.c (99%)
 rename arch/x86/crypto/{sha-mb/sha_mb_ctx.h =3D> sha1-mb/sha1_mb_ctx.h=
} (99%)
 rename arch/x86/crypto/{sha-mb/sha_mb_mgr.h =3D> sha1-mb/sha1_mb_mgr.h=
} (100%)
 rename arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_mb_mgr_datastruct.S =
(100%)
 rename arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_mb_mgr_flush_avx2.S =
(100%)
 rename arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_mb_mgr_init_avx2.c (=
99%)
 rename arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_mb_mgr_submit_avx2.S=
 (100%)
 rename arch/x86/crypto/{sha-mb =3D> sha1-mb}/sha1_x8_avx2.S (100%)
 create mode 100644 arch/x86/crypto/sha256-mb/Makefile
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_mb.c
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_ctx.h
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr.h
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_datastruct.=
S
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.=
S
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_init_avx2.c
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2=
=2ES
 create mode 100644 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S

--=20
1.9.1
