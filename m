Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8732F1FC4
	for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 07:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768547919; cv=none; b=JXOR0C1bVDbpaxLepupFHZHBW7gGvFCNDPCe6QlFe3Ywu87wlrdlhEMrhmPX1t9WGSN0lY5AbsdmlLLD6lU7j+aPeoEE/NsPRSMBqR/+5XEhsOQfAOuqYfjDHVfEvOqgiEoCPyuP9J9DXbAbkR3iPy1DHVwIq8vY7FGW/Hp7X4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768547919; c=relaxed/simple;
	bh=v0x7Tl00N69zdFQOYwgGL+HdCcz3SahJeio4P92KUEA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D3wiB9DaOnJ+y8c0ZxpdDDxFj/YRcyTfK5V5PGVocggBHN7m8okiP6GNwXD9LS+M2NxkxbW/Ulo4Lf++AhQpL+LfDShrtZdGnmAdWbceYaAw0jGuzICHLkfmYofJg6MWW5Fn/DEHVpGyKWcJuyuDkebn8T0jkrASI3gsoNucU2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1768547909-1eb14e7c04194e0001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id Aub7iSLW4vrNTi0E (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 16 Jan 2026 15:18:29 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Fri, 16 Jan
 2026 15:18:29 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Fri, 16 Jan 2026 15:18:29 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from DESKTOP-A4I8D8T.zhaoxin.com (10.32.65.156) by
 ZXBJMBX02.zhaoxin.com (10.29.252.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.59; Fri, 16 Jan 2026 15:15:48 +0800
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <Jason@zx2c4.com>, <ardb@kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>
CC: <CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: [PATCH v3 0/3] lib/crypto: x86/sha: Add PHE Extensions support
Date: Fri, 16 Jan 2026 15:15:10 +0800
X-ASG-Orig-Subj: [PATCH v3 0/3] lib/crypto: x86/sha: Add PHE Extensions support
Message-ID: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 1/16/2026 3:18:22 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1768547909
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 6334
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.153108
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

This series adds support for PHE Extensions optimized SHA1 and SHA256
transform functions for Zhaoxin processors in lib/crypto, and disables
the padlock-sha driver on Zhaoxin platforms due to self-test failures.

The table below shows the benchmark results before and after this patch
series by using CRYPTO_LIB_BENCHMARK on Zhaoxin KX-7000 platform,
highlighting the achieved speedups.

+---------+-------------------------+--------------------------+
|         |         SHA1            |          SHA256          |
+---------+--------+----------------+--------+-----------------+
|   Len   | Before |      After     | Before |      After      |
+---------+--------+----------------+--------+-----------------+
|      1* |    3** |    8 (2.67x)   |    2   |    7 (3.50x)    |
|     16  |   52   |  125 (2.40x)   |   35   |  119 (3.40x)    |
|     64  |  114   |  318 (2.79x)   |   74   |  280 (3.78x)    |
|    127  |  154   |  440 (2.86x)   |   99   |  387 (3.91x)    |
|    128  |  160   |  492 (3.08x)   |  103   |  427 (4.15x)    |
|    200  |  189   |  605 (3.20x)   |  123   |  537 (4.37x)    |
|    256  |  199   |  676 (3.40x)   |  128   |  582 (4.55x)    |
|    511  |  223   |  794 (3.56x)   |  144   |  679 (4.72x)    |
|    512  |  225   |  833 (3.70x)   |  146   |  714 (4.89x)    |
|   1024  |  243   |  941 (3.87x)   |  157   |  796 (5.07x)    |
|   3173  |  259   | 1044 (4.03x)   |  167   |  883 (5.28x)    |
|   4096  |  257   | 1044 (4.06x)   |  166   |  876 (5.28x)    |
|  16384  |  261   | 1073 (4.11x)   |  169   |  899 (5.32x)    |
+---------+--------+----------------+--------+-----------------+
*: The length of each data block to be processed by one complete SHA
   sequence.
**: The throughput of processing data blocks, unit is Mb/s.

After applying this patch series, the KUnit test suites for SHA1 and
SHA256 pass successfully on Zhaoxin platforms. The following shows the
detailed test logs:

[    5.993700]     # Subtest: sha1
[    5.996813]     # module: sha1_kunit
[    5.996814]     1..11
[    6.003399]     ok 1 test_hash_test_vectors
[    6.012489]     ok 2 test_hash_all_lens_up_to_4096
[    6.028511]     ok 3 test_hash_incremental_updates
[    6.035766]     ok 4 test_hash_buffer_overruns
[    6.043445]     ok 5 test_hash_overlaps
[    6.050315]     ok 6 test_hash_alignment_consistency
[    6.054994]     ok 7 test_hash_ctx_zeroization
[    6.127778]     ok 8 test_hash_interrupt_context_1
[    6.774847]     ok 9 test_hash_interrupt_context_2
[    6.810745]     ok 10 test_hmac
[    6.835169]     # benchmark_hash: len=3D1: 8 MB/s
[    6.847167]     # benchmark_hash: len=3D16: 125 MB/s
[    6.862114]     # benchmark_hash: len=3D64: 318 MB/s
[    6.878173]     # benchmark_hash: len=3D127: 440 MB/s
[    6.893081]     # benchmark_hash: len=3D128: 492 MB/s
[    6.907976]     # benchmark_hash: len=3D200: 605 MB/s
[    6.922658]     # benchmark_hash: len=3D256: 676 MB/s
[    6.937558]     # benchmark_hash: len=3D511: 794 MB/s
[    6.951994]     # benchmark_hash: len=3D512: 833 MB/s
[    6.966262]     # benchmark_hash: len=3D1024: 941 MB/s
[    6.980295]     # benchmark_hash: len=3D3173: 1044 MB/s
[    6.994494]     # benchmark_hash: len=3D4096: 1044 MB/s
[    7.008728]     # benchmark_hash: len=3D16384: 1073 MB/s
[    7.014515]     ok 11 benchmark_hash
[    7.019628] # sha1: pass:11 fail:0 skip:0 total:11
[    7.023170] # Totals: pass:11 fail:0 skip:0 total:11
[    7.027916] ok 5 sha1

[    7.767257]     # Subtest: sha256
[    7.770542]     # module: sha256_kunit
[    7.770544]     1..15
[    7.777383]     ok 1 test_hash_test_vectors
[    7.788563]     ok 2 test_hash_all_lens_up_to_4096
[    7.806090]     ok 3 test_hash_incremental_updates
[    7.813553]     ok 4 test_hash_buffer_overruns
[    7.822384]     ok 5 test_hash_overlaps
[    7.829388]     ok 6 test_hash_alignment_consistency
[    7.833843]     ok 7 test_hash_ctx_zeroization
[    7.915191]     ok 8 test_hash_interrupt_context_1
[    8.362312]     ok 9 test_hash_interrupt_context_2
[    8.401607]     ok 10 test_hmac
[    8.415458]     ok 11 test_sha256_finup_2x
[    8.419397]     ok 12 test_sha256_finup_2x_defaultctx
[    8.424107]     ok 13 test_sha256_finup_2x_hugelen
[    8.451289]     # benchmark_hash: len=3D1: 7 MB/s
[    8.465372]     # benchmark_hash: len=3D16: 119 MB/s
[    8.481760]     # benchmark_hash: len=3D64: 280 MB/s
[    8.499344]     # benchmark_hash: len=3D127: 387 MB/s
[    8.515800]     # benchmark_hash: len=3D128: 427 MB/s
[    8.531970]     # benchmark_hash: len=3D200: 537 MB/s
[    8.548241]     # benchmark_hash: len=3D256: 582 MB/s
[    8.564838]     # benchmark_hash: len=3D511: 679 MB/s
[    8.580872]     # benchmark_hash: len=3D512: 714 MB/s
[    8.596858]     # benchmark_hash: len=3D1024: 796 MB/s
[    8.612567]     # benchmark_hash: len=3D3173: 883 MB/s
[    8.628546]     # benchmark_hash: len=3D4096: 876 MB/s
[    8.644482]     # benchmark_hash: len=3D16384: 899 MB/s
[    8.649773]     ok 14 benchmark_hash
[    8.655505]     ok 15 benchmark_sha256_finup_2x # SKIP not relevant
[    8.659065] # sha256: pass:14 fail:0 skip:1 total:15
[    8.665276] # Totals: pass:14 fail:0 skip:1 total:15
[    8.670195] ok 7 sha256

Changes in v3:
- Implement PHE Extensions optimized SHA1 and SHA256 transform functions
  using inline assembly instead of separate assembly files
- Eliminate unnecessary casts
- Add CONFIG_CPU_SUP_ZHAOXIN check to compile out the code when disabled
- Use 'boot_cpu_data.x86' to identify the CPU family instead of
  'cpu_data(0).x86'
- Only check X86_FEATURE_PHE_EN for CPU support, consistent with other
  CPU feature checks.
- Disable the padlock-sha driver on Zhaoxin processors with CPU family
  0x07 and newer.

Changes in v2:
- Add Zhaoxin support to lib/crypto instead of extending the existing
  padlock-sha driver

AlanSong-oc (3):
  crypto: padlock-sha - Disable for Zhaoxin processor
  lib/crypto: x86/sha1: PHE Extensions optimized SHA1 transform function
  lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform
    function

 drivers/crypto/padlock-sha.c |  7 +++++++
 lib/crypto/x86/sha1.h        | 25 +++++++++++++++++++++++++
 lib/crypto/x86/sha256.h      | 25 +++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

--=20
2.34.1

