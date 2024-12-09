Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B174144D1A;
	Mon,  9 Dec 2024 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733761774; cv=none; b=rJ2D+NRb3aXIBurWIhND1MfBE8rigRxFdlIi4bgp6nTcUGIYU/cyqKeHAxgQi9KG3kz78T/MVSV6ZpDGh4RJL6ZZ5OO/Vu6CJfYU0pQVkhvPAyPzQ95cHqL/DqXo3GFDIVBcsh24acVD8QoQuUoX+61VaElB4Nj5/3LM4+9CKfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733761774; c=relaxed/simple;
	bh=AEq8Kx+pbGUBWIi5sQg0Xafxs932nQS5nXHYeQIxfxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fqpHJV3R+TSPj74F033LFzu24LyrPahs80M6wJxy7Le/hTLRPTHKoEdDMpvnUSMOdpdH8p18onZZC2b8uxSJiqtbZy1HN651ehDG7cTYrl1qqwrK9YM/UeeimkyxKtnxImLa5uw5mN+biOqTjJRIj6IJafu9ucDZjTaO319LCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Mb/wzSa3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Mb/wzSa3"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9FRQpZ006993;
	Mon, 9 Dec 2024 16:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=e7V2L1A7xBmp/2HgrfMC9BWVEuI/UCUZ2SXxWiT9W
	+g=; b=Mb/wzSa3T+aZp6ijKvjOqxHZQ+ZIu+VJNizGOZlRA32iSs65UIjY1Troa
	BlUZ81SavqL2aHo93qifKbcDBX72N149xR3Kehn8vMM5TW5O69N7+WNcEuSS5CJB
	BtAvHeFDaK1dE5ZlFZYZ2LJKi+haUt2NYAmyZBVDGlQjQ5FlZlZ1jhECl6oYPw+H
	TWK3q9NdSaKNye2GCW2jz9Xy9ydemWUPVMhAglrxXYS3DNo0N9zjmqXJMLA+bGX5
	bnqMKvsO7LvBosQ8Wcdp5kEv8q5QZ0uRjrBCUNeZM5hJM8BHRTBjy3NSL9DtfTVL
	9Zs4tVwnMfL3t67btTQahxXM0PXkA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cdv8jf7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 16:29:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9E3AYR016952;
	Mon, 9 Dec 2024 16:29:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12xymkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 16:29:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B9GTA8151970488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Dec 2024 16:29:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 625072005A;
	Mon,  9 Dec 2024 16:29:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EA3E2004F;
	Mon,  9 Dec 2024 16:29:10 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.3.73])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Dec 2024 16:29:10 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v7 0/2] New s390 specific protected key hmac
Date: Mon,  9 Dec 2024 17:29:07 +0100
Message-ID: <20241209162909.758753-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PZJMf3vIGh4qato8FaZHObgLeT-xEmXF
X-Proofpoint-ORIG-GUID: PZJMf3vIGh4qato8FaZHObgLeT-xEmXF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=767
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090128

Add support for protected key hmac ("phmac") for s390 arch.

With the latest machine generation there is now support for
protected key (that is a key wrapped by a master key stored
in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
for the s390 specific CPACF instruction kmac.

This patch adds support via 4 new hashes registered as
phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).

Please note that as of now, there is no selftest enabled for
these shashes, but the implementation has been tested with
testcases via AF_ALG interface. However, there may come an
improvement soon to use the available clear key hmac selftests.

Changelog:
v1: Initial version
v2: Increase HASH_MAX_DESCSIZE generic (not just for arch s390).
    Fix one finding to use kmemdup instead of kmalloc/memcpy from test
    robot. Remove unneeded cpacf subfunctions checks. Simplify
    clone_tfm() function. Rebased to s390/features.
v3: Feedback from Herbert: Use GFP_ATOMIC in setkey function.
    Feedback from Holger: rework tfm clone function, move convert key
    invocation from setkey to init function. Rebased to updated
    s390/features from 11/7/2024. Ready for integration if there are
    no complains on v3.
v4: Rewind back more or less to v2. Add code to check for non-sleeping
    context. Non-sleeping context during attempt to derive the
    protected key from raw key material is not accepted and
    -EOPNOTSUPP is returned (also currently all derivation pathes
    would in fact never sleep). In general the phmac implementation is
    not to be used within non-sleeping context and the code header
    mentions this. Tested with (patched) dm-integrity - works fine.
v5: As suggested by Herbert now the shashes have been marked as
    'internal' and wrapped by ahashes which use the cryptd if an
    atomic context is detected. So the visible phmac algorithms are
    now ahashes. Unfortunately the dm-integrity implementation
    currently requests and deals only with shashes and this phmac
    implementation is not fitting to the original goal any more...
v6: As suggested by Herbert now a pure async phmac implementation.
    Tested via AF_ALG interface. Untested via dm-integrity as this layer
    only supports shashes. Maybe I'll develop a patch to switch the
    dm-integrity to ahash as it is anyway the more flexible interface.
v7: Total rework of the implementation. Now uses workqueues and triggers
    asynch requests for key convert, init, update, final and digest.
    Tested with instrumented code and with a reworked version of
    dm-integrity which uses asynchronous hashes. A patch for dm-integrity
    is on the way but yet needs some last hone work.

Harald Freudenberger (1):
  s390/crypto: New s390 specific protected key hash phmac

Holger Dengler (1):
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 754 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 drivers/crypto/Kconfig            |  12 +
 6 files changed, 773 insertions(+)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
--
2.43.0

