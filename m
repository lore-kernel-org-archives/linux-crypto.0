Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79EE2D949F;
	Thu, 15 Jan 2026 18:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768502324; cv=none; b=l14MGbKNDGKnMYgrfiGDrz5xwqQB36O9KvmypmFLXg0/gDdnFGvLwDehR3ukzSTYoYnd3f1z43rEcoWTmcgle3md0WiqsAJbjX8DorJHh2SesLCVpthZzzdEBby5d86WBfNBXW4/zDuJgDD+AGE6vGTGNXi85ENUWyGJGmNWb98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768502324; c=relaxed/simple;
	bh=Gp0AiuGJb8iwRD62dzH3tmCz9rTuLX5BeVCUe8X98AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PPBCjw2mVyYgsawRsNGvIxQnC+r/O+nKsju2djlQ9alepR3mPyycjCekuOh4GD0UmdkFKPd/p4LisTXgtaV1BIdM76EaFKHJppUlhgKcNsZjWYbm/miLkyXUBJo5mZvYf9jYLBSf8M3UTUw6+XFF0JHw163T7ZCx3FeVTp+Po44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Whnc8dLC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Whnc8dLC"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FAcf34000949;
	Thu, 15 Jan 2026 18:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=uDJpqMCWU03M5UR9QoaruZlXE6B3b24uxJWWbjaVT
	w4=; b=Whnc8dLCd/W05l31P3mJ9idvu04yN+fcE4GqohNa3RQDfMGbnOojCapFA
	xoM1H+rlHdapozm4/N2TpWTxDpBfdyYBzuJjAP3KJywCcNLtPVUdrHoM/QZPSkED
	tXUKonQ6nwcaml7uS4kUAy42iAVSDhsZUkujOC11JcGClLqVh7o72TWIjHRR2sXd
	OXpaO89owGvVFlmmoicEr8Pa530KBXANyre3rnUPxoMoVF00Ztk25d94cEB5wAcv
	JO0VZVF/KbdS/mz5Lr3VBles7O27XAB9oiu18ordpvedTNo7Chx+e/x1Uc2KASWY
	hk/WRHsVZjYf+5Ek1CKb2VxRbXjyw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkc6hfv3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 18:38:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FHinus025566;
	Thu, 15 Jan 2026 18:38:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm23nhr3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 18:38:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FIcVW361211118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:38:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D75E420043;
	Thu, 15 Jan 2026 18:38:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70F9520040;
	Thu, 15 Jan 2026 18:38:31 +0000 (GMT)
Received: from ibm.com (unknown [9.111.195.181])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 18:38:31 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 0/1] lib/crypto: tests: KUnit test-suite for AES
Date: Thu, 15 Jan 2026 19:38:30 +0100
Message-ID: <20260115183831.72010-1-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wGS4CNLN9WWhELrz3Ycpmjh63Y9nAkVn
X-Proofpoint-ORIG-GUID: wGS4CNLN9WWhELrz3Ycpmjh63Y9nAkVn
X-Authority-Analysis: v=2.4 cv=TaibdBQh c=1 sm=1 tr=0 ts=6969342c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=26R-6R9DoGBErhHyASgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MSBTYWx0ZWRfXwiqGpyjV1BYB
 aaq0ZOcmIvrtvGk1TYyMsDHBZZH/bW2MSoOdMrgRGP2+OnyYJr8zAwTNIISH3KUmnl4yio2AmEV
 3+2xyqXaXzgc4TA6hPSwt5JbFIrJDJXI8ejC61RIbkSIegqcchJZKhQnm/ljgK2XqLBEUFQqFTj
 /b+C6hBl4QYbgy7WjG8ohzuVmVYNMcLyOA3/zBITfwjqrI022u8bhGO7eiBBNPHkrfyPTs00NDs
 dBypbZTStyTKGsfrJMYdLn+OWjLggWR0+w5qa4VZwyWwt2dGjUIYitP0kIzAbebtcDM9eksHBei
 9D5KAhYvFfXbre0jY0EZCVpGrq2BppGxDt1MBgOJ1GdoPmfNQlOGDwvXOZFRKfTe1LUDC8MEB2R
 /gWayEG2qCVX8X3QnNurVzLOj8kROQE+4nHikiyE+5u16bzolJ1nPjOt712o9MwgK9MCovGawwt
 UkkxDXlLSMz9TshaIKg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601150141

The following patch adds a kunit tests for the aes library. It does a very
minimal verification of the aes operation for all key-sizes. The benchmarks,
which are also part of the test-suite, can be used to get some rough
performance measurements of the aes encrypt and decrypt functions. The
aes_prepare*key() APIs are not covered by the benchmarks.

Changes since RFC [1]:
- reorder entries in Kconfig/Makefile alphabetically
- fail (instead of skip) in case of failures in key preparation
- replace local constant definitions
- replace macros with helper functions

[1] https://lore.kernel.org/linux-crypto/20260114153138.4896-1-dengler@linux.ibm.com

Example output of the aes_kunit test-suite:

[  178.640161] KTAP version 1
[  178.640167] 1..1
[  178.642268]     KTAP version 1
[  178.642269]     # Subtest: aes
[  178.642270]     # module: aes_kunit
[  178.642272]     1..9
[  178.642330]     ok 1 test_aes128_encrypt
[  178.642378]     ok 2 test_aes128_decrypt
[  178.642427]     ok 3 test_aes192_encrypt
[  178.642477]     ok 4 test_aes192_decrypt
[  178.642531]     ok 5 test_aes256_encrypt
[  178.642584]     ok 6 test_aes256_decrypt
[  179.345355]     # benchmark_aes128: enc (iter. 10000000, duration 351128093ns)
[  179.345359]     # benchmark_aes128: enc (len=16): 434 MB/s
[  179.345361]     # benchmark_aes128: dec (iter. 10000000, duration 351541596ns)
[  179.345363]     # benchmark_aes128: dec (len=16): 434 MB/s
[  179.345398]     ok 7 benchmark_aes128
[  180.082939]     # benchmark_aes192: enc (iter. 10000000, duration 370559483ns)
[  180.082942]     # benchmark_aes192: enc (len=16): 411 MB/s
[  180.082944]     # benchmark_aes192: dec (iter. 10000000, duration 366888529ns)
[  180.082946]     # benchmark_aes192: dec (len=16): 415 MB/s
[  180.082982]     ok 8 benchmark_aes192
[  180.810447]     # benchmark_aes256: enc (iter. 10000000, duration 363703684ns)
[  180.810450]     # benchmark_aes256: enc (len=16): 419 MB/s
[  180.810452]     # benchmark_aes256: dec (iter. 10000000, duration 363671689ns)
[  180.810454]     # benchmark_aes256: dec (len=16): 419 MB/s
[  180.810490]     ok 9 benchmark_aes256
[  180.810495] # aes: pass:9 fail:0 skip:0 total:9
[  180.810498] # Totals: pass:9 fail:0 skip:0 total:9
[  180.810500] ok 1 aes

Holger Dengler (1):
  lib/crypto: tests: Add KUnit tests for AES

 lib/crypto/tests/Kconfig        |  12 +++
 lib/crypto/tests/Makefile       |   1 +
 lib/crypto/tests/aes-testvecs.h |  78 +++++++++++++++++
 lib/crypto/tests/aes_kunit.c    | 149 ++++++++++++++++++++++++++++++++
 4 files changed, 240 insertions(+)
 create mode 100644 lib/crypto/tests/aes-testvecs.h
 create mode 100644 lib/crypto/tests/aes_kunit.c


base-commit: 47753e09a15d9fd7cdf114550510f4f2af9333ec
-- 
2.51.0

