Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359483596EB;
	Mon, 19 Jan 2026 12:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768824742; cv=none; b=jD6H1nly2DSAOuHFUCURHp4Y8K3k//f14CtYMQkZ2s7Y4biZqdYLRecM8Hco0LSWnnCUY2a4ny8JQqUmphnxl8YGpIw3M0ZqE6TAM8qNvHAW7up75hNTxj8+r1RHDpOXG4UMUILYHC9ZWUpbM5+ZnzhYABG7FMAlVAakcN1XliE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768824742; c=relaxed/simple;
	bh=5u9c1V+dg8IJ067D8G/PQyCBLwEK5tVx2fI/lU9yh4g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YKE4VbQhwKMCezWMVWFtOMViR9XcCkt3euDaInugCYwv6TEGN7+bHhvb1xKQbgONRX5qsKuNjEbhCWSeL52cpStdn60Xd8Q7Tj/RWBDuiUKUKRkL4YKn0r4LGhB6PZzUMsPOrCe69sR3zU4AkRu2UCXJmdbCx1zaTSRBAg4YT7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MnfZAd6J; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MnfZAd6J"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60ILlD69027362;
	Mon, 19 Jan 2026 12:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=mU2qTNeVPMeZ9eEF2dj3vCu8GXcgQX96+7u8gPQI0
	SU=; b=MnfZAd6Jq04CkOoOygqAemJzYLW5gQvGt245xaTYyakG0XfS6zAPjzi7u
	4zQ5eXOhXoVesxglE35cR4cRHUX+Wlx7s1JdB2x3voZxubQo5g7CBnYaGYG7ncvU
	HVpTDFpyxfj6r/97/jX9Me2/Mrh8x8eGRxykSwlib32RyNLJSAipyqLbA0995d98
	Smpr4JplKtVFUTiSvk386iggdFrZJp5PXp5tcBpfjVYl4I6XzLgIHf+bWsadaId+
	Hwhl2wGaH3ILYczEgrarcs5hNhidZBO6ag1YNJrtKgDVbSsLe/hLji/WXXqA6SH+
	bFZ4zfwbgY4XqhAvluAMWSK2oaqcA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br0uf7jtu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 12:12:15 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60JC6jfY007456;
	Mon, 19 Jan 2026 12:12:15 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br0uf7jtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 12:12:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60JA1wfp024610;
	Mon, 19 Jan 2026 12:12:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4brxarcx5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 12:12:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60JCCAP547645132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 12:12:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45E7220043;
	Mon, 19 Jan 2026 12:12:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CE5F20040;
	Mon, 19 Jan 2026 12:12:10 +0000 (GMT)
Received: from ibm.com (unknown [9.111.163.233])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 Jan 2026 12:12:09 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>,
        David Laight <david.laight.linux@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/1] lib/crypto: tests: KUnit test-suite for AES
Date: Mon, 19 Jan 2026 13:12:09 +0100
Message-ID: <20260119121210.2662-1-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XkADxooyrlSRI-PE07fbsG9i_x3nMtwn
X-Proofpoint-ORIG-GUID: QgSSW2wn3xCzW5AuZ-eJ5NED4TQfXp0j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDA5NyBTYWx0ZWRfXwOnQBHvFbdjG
 zTeSnZHAM0Oh8bTH+ghCngp+al/kmCEmzWT/Oj1/iwwzlvveIcftRZIEnCJ4ZyX3yEp6Db3Qe20
 xulA7KPUGJ+diSJF+lzG189NGUx+9IGsiSuAu11jo5VzZz3wWZkbyoMqApCfkI1Joba+0bu8Uit
 voozQTpzR0pN9xr+qBKiiydFOZFswoxa7tEXSEjrRmjqINuET1OnB8PHNcTkfqikEulBB7uOreQ
 KGgRQkotz2RFY3jyxO/JNQ/d564q05g1n4hYu9wyGRzugwkXYHpRg8eLaBUHO79HQRTYqAZyOqO
 BYIvCuXBeO2GIKpJtbW+ZQhm+FE24iOeLoUonix1FL64xQxQ7jzSK9xLj5S0GL7pRZUqsakIipo
 qncoFbVpuEpYY6XkEVbhWraRSQSUl9FrdEcmTpKNUmJVNGzBhju7DecKK8aqeuCqTzrK4bVMmuU
 z45+5kHimAWZjl47jvQ==
X-Authority-Analysis: v=2.4 cv=bopBxUai c=1 sm=1 tr=0 ts=696e1f9f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=26R-6R9DoGBErhHyASgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_02,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601190097

The following patch adds a kunit tests for the aes library.

Changes since v1 [1]:
- move information from cover-letter to commit message
- remove unused struct buf
- add reference to the KAT source
- restructure the benchmark
  - reduce the number of iterations for warm-up and benchmark
  - measure each aes operation and take the minimal measurement for the
    bandwidth calculation
  - normalize bandwidth to MB (power of 10) instead of MiB (power of 2)

Changes since RFC [2]:
- reorder entries in Kconfig/Makefile alphabetically
- fail (instead of skip) in case of failures in key preparation
- replace local constant definitions
- replace macros with helper functions

[1] https://lore.kernel.org/linux-crypto/20260115183831.72010-1-dengler@linux.ibm.com
[2] https://lore.kernel.org/linux-crypto/20260114153138.4896-1-dengler@linux.ibm.com

Example output of the aes_kunit test-suite:

[  316.380919] KTAP version 1
[  316.380923] 1..1
[  316.380964]     KTAP version 1
[  316.380965]     # Subtest: aes
[  316.380966]     # module: aes_kunit
[  316.380968]     1..9
[  316.381071]     ok 1 test_aes128_encrypt
[  316.381129]     ok 2 test_aes128_decrypt
[  316.381186]     ok 3 test_aes192_encrypt
[  316.381248]     ok 4 test_aes192_decrypt
[  316.381309]     ok 5 test_aes256_encrypt
[  316.381367]     ok 6 test_aes256_decrypt
[  316.381411]     # benchmark_aes128: enc (len=16): 500 MB/s
[  316.381414]     # benchmark_aes128: dec (len=16): 500 MB/s
[  316.381447]     ok 7 benchmark_aes128
[  316.381491]     # benchmark_aes192: enc (len=16): 500 MB/s
[  316.381494]     # benchmark_aes192: dec (len=16): 484 MB/s
[  316.381529]     ok 8 benchmark_aes192
[  316.381572]     # benchmark_aes256: enc (len=16): 484 MB/s
[  316.381574]     # benchmark_aes256: dec (len=16): 484 MB/s
[  316.381608]     ok 9 benchmark_aes256
[  316.381610] # aes: pass:9 fail:0 skip:0 total:9
[  316.381612] # Totals: pass:9 fail:0 skip:0 total:9
[  316.381614] ok 1 aes

Holger Dengler (1):
  lib/crypto: tests: Add KUnit tests for AES

 lib/crypto/tests/Kconfig        |  12 +++
 lib/crypto/tests/Makefile       |   1 +
 lib/crypto/tests/aes-testvecs.h |  77 ++++++++++++++++
 lib/crypto/tests/aes_kunit.c    | 150 ++++++++++++++++++++++++++++++++
 4 files changed, 240 insertions(+)
 create mode 100644 lib/crypto/tests/aes-testvecs.h
 create mode 100644 lib/crypto/tests/aes_kunit.c


base-commit: 47753e09a15d9fd7cdf114550510f4f2af9333ec
-- 
2.51.0

