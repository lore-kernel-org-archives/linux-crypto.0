Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AEF39C655;
	Wed, 14 Jan 2026 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404713; cv=none; b=XgThJd489hzXqLNe2L8lAohRlC9xLX2MW71IWUQ4x1GJODHrLJ0DDy683GjS1KmGD+PyEvZE3rUd73UvVN17dTYmEBTe1y2eCWlNeM6Vu94vR64tl0v0ijNUtmIrJXzRChv1gNS2u/mcfFgkjbgbf3VsAb3OBaB/nGudnzVWSec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404713; c=relaxed/simple;
	bh=BqArBCZzS1gdQ2JMTKv2mYzBQ7rYuJ84GBGSa1R7Hfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/HLaszPZoOBjNM3/AtEHvgY/xbuJfXRe5WvgZsbBYNtDWOz6dA2orkWrl0cBxxrYkL1Xd7uSqV4PYe5NZiOnkI3DfyKjPyIG17xDPu3IWaBN5PAhyzaIRM59QdiQTILL3ZIxp8yGGu5Riv8nhUYfxXeyhaPiUkcQp8wXsunNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZbBMijlE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZbBMijlE"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60EChtJQ009381;
	Wed, 14 Jan 2026 15:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Sads6KpcJdmaRytw5
	2gEAjq3nrqfh4g7+8MA6F5KbNQ=; b=ZbBMijlEZYAloFDTYyQHIndWdbCTEPUNS
	vJ1Eh/ZXdvyj9VEj9C2jqxkjagJAiR+MR/ofbovekRX2HJsMe3vrreNrwykI0vW4
	LYNe+nLoS6xAgctpujpMD5S2SzrA3135El5lPOBbehrKIrsJ1yl88BYWrzOyO1/q
	3mTurhOGyMvaVXeS50RP6BJAwm3Etag7yoLEdq10vJgztZq5dq3jlEdv7m+U4h3W
	1PoEsqPuV05LJTbR9CVTCq5S6psRHK+GAg5cpjIkPcwfTTTGq3WUq82FgZHl2fad
	6bLczSJc16eEftDcAaDeORQXz+hJaBTgZUoZKfV+nBQ0+0I2I/cDQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bke93239b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 15:31:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60EEZpbO025546;
	Wed, 14 Jan 2026 15:31:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm23nas14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 15:31:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60EFVdQW49283420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 15:31:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 81CA12004B;
	Wed, 14 Jan 2026 15:31:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CA9F20040;
	Wed, 14 Jan 2026 15:31:39 +0000 (GMT)
Received: from ibm.com (unknown [9.111.193.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jan 2026 15:31:39 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Holger Dengler <dengler@linux.ibm.com>
Subject: [RFC PATCH 0/1] lib/crypto: tests: KUnit test-suite for AES
Date: Wed, 14 Jan 2026 16:31:37 +0100
Message-ID: <20260114153138.4896-1-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192035.10427-35-ebiggers@kernel.org>
References: <20260112192035.10427-35-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TvskhBazrSmbZizJ2f3Lr9rOB_gJ7xH1
X-Authority-Analysis: v=2.4 cv=dYyNHHXe c=1 sm=1 tr=0 ts=6967b6e2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1ZQgD_nUnpj53eAcsNIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEyOCBTYWx0ZWRfX+z4sEth2e8Ik
 5VNxINe/TkDGVBTI7FT3pnyvrjmvDPNWDlWcBQ+giVdEWMiO1bKNRCfwlf5v/PjGd3Z/M28EW/a
 dFJn/+YcMpLwAdzICik81e4IcZhha31fNnJHqQVbk4WaUEuV/UqdKfkPbt28NwbGU/07L/CZgQT
 GGO8Mqrvw+VQGlV1tZs+AqD3/BXT297ohQ7yIGXFvQRoQH8CmN5Fid/iXXTfHRcZW/UbkUnA08/
 2xJ1CzPOnmG5EiT++7tdsQultafD3kAoI46b1+04N07s2VvDz3kcBC+UoEaJs+d8jHw97FXD/vh
 NfvkcGNiQUeAe7/WuQQT6s1G492PNJp1eQjUvt+VMXMzsgtBXRVey3CgO1m2JW0LZAoF8W4Kifi
 EW9hH0G33Lz5kqzUDf70Mgzeabj8VNZRfP3camQHTHt5fMK3WZzASdQwmvu8H/X5uEvJvJ1yv/Y
 usfaR3rGf0khDxZ6dag==
X-Proofpoint-GUID: TvskhBazrSmbZizJ2f3Lr9rOB_gJ7xH1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601140128

The following patch adds a kunit tests for the aes library. It does a very
minimal verification of the aes operation for all key-sizes. The benchmarks,
which are also part of the test-suite, can be used to get some rough
performance measurements of the aes encrypt and decrypt functions. The
aes_prepare*key() APIs are not covered by the benchmarks.

Example output of the aes_kunit test-suite:

[   44.748194] KTAP version 1
[   44.748199] 1..1
[   44.748240]     KTAP version 1
[   44.748241]     # Subtest: aes
[   44.748242]     # module: aes_kunit
[   44.748244]     1..9
[   44.748304]     ok 1 aes128_kat_encrypt
[   44.748365]     ok 2 aes128_kat_decrypt
[   44.748417]     ok 3 aes192_kat_encrypt
[   44.748482]     ok 4 aes192_kat_decrypt
[   44.748528]     ok 5 aes256_kat_encrypt
[   44.748583]     ok 6 aes256_kat_decrypt
[   45.466878]     # aes128_benchmark: enc (iter. 10000000, duration 359887225ns)
[   45.466881]     # aes128_benchmark: enc (len=16): 423 MB/s
[   45.466883]     # aes128_benchmark: dec (iter. 10000000, duration 358322328ns)
[   45.466885]     # aes128_benchmark: dec (len=16): 425 MB/s
[   45.466921]     ok 7 aes128_benchmark
[   46.205717]     # aes192_benchmark: enc (iter. 10000000, duration 367953960ns)
[   46.205720]     # aes192_benchmark: enc (len=16): 414 MB/s
[   46.205722]     # aes192_benchmark: dec (iter. 10000000, duration 370756491ns)
[   46.205724]     # aes192_benchmark: dec (len=16): 411 MB/s
[   46.205752]     ok 8 aes192_benchmark
[   46.974536]     # aes256_benchmark: enc (iter. 10000000, duration 386414949ns)
[   46.974539]     # aes256_benchmark: enc (len=16): 394 MB/s
[   46.974541]     # aes256_benchmark: dec (iter. 10000000, duration 382280549ns)
[   46.974542]     # aes256_benchmark: dec (len=16): 399 MB/s
[   46.974716]     ok 9 aes256_benchmark
[   46.974719] # aes: pass:9 fail:0 skip:0 total:9
[   46.974721] # Totals: pass:9 fail:0 skip:0 total:9
[   46.974724] ok 1 aes

Holger Dengler (1):
  lib/crypto: tests: Add KUnit tests for AES

 lib/crypto/tests/Kconfig        |  12 ++++
 lib/crypto/tests/Makefile       |   1 +
 lib/crypto/tests/aes-testvecs.h |  78 ++++++++++++++++++++++
 lib/crypto/tests/aes_kunit.c    | 115 ++++++++++++++++++++++++++++++++
 4 files changed, 206 insertions(+)
 create mode 100644 lib/crypto/tests/aes-testvecs.h
 create mode 100644 lib/crypto/tests/aes_kunit.c

-- 
2.51.0

