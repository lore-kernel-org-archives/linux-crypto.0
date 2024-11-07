Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D3638DC8;
	Thu,  7 Nov 2024 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730991632; cv=none; b=XZJhnvBBJjFWSFbaPvsGxqQBetRGUa9h3EoM3RrPvChkjiJfvzJHAI3TFsc9wCyMQcISxdYj/Vrq2FkLcXNJtFUJBGWpK6zIAcBjn9Rpspq+5l89T/hcGYoAg8MPwAcgzPYP4IbeeMUcuYCp3P72nFs5TwAq6b0+hBKUngIWnoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730991632; c=relaxed/simple;
	bh=kGIqEsjJeRE4L0Z8UyrRY5i9b3nrwjoA8HoBw9wB+f8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qrY0SeFSgZrdc+3AV32VLd5ihvxTX2E7Pbmb+dh1/M+qW/v9OPY550C5gSkr4215m6gj64glm9oNx7jpkH/JRgZlK2Q4dywVjigQ18UJS0i4y9Rrx4qYOUtS0YDoMRCMS19jNZUK+BenaAU1MfePIlCbDWNAs19uU6wfltA5pd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XItLjkxS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XItLjkxS"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A7EeMKO027829;
	Thu, 7 Nov 2024 14:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=fiW+i4oTWkMPGEZqZL54PWwQfeWhc47bF1sdX8iU8
	0s=; b=XItLjkxSCT3eb6+wgKBvbMxtYQeXXPXwYeQwDyd9WjW8IJRAHJl8ZTvtb
	snZtKCTCZhJU4qxTLjGupsW8yx7KhOWYkYn0NphaOTA7LUXQThUxJI/AX0JWUyOM
	t9Pd3jR7+PGzZeJbFuh2/urLxcgSY2F8BuAYO0vWVkb3opkBywbfTA4sKa6XC8Si
	DIyoqU7q3PwtZDVGRLMSP7xn36WYJOpApKMqjnE9eEVtwuvGI9in5zUCCDxmf84Z
	izly6dFaomTbYiCCzp3CEgv1DAixPvKRWiRWEYFYnPWGzL/nOuYQ8plBYhUEUTYd
	OCWDHyATScbGw8OFnzJwyhox86gtQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42rygs82cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 14:55:26 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A75iOd2023412;
	Thu, 7 Nov 2024 14:55:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42p1410a7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Nov 2024 14:55:25 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A7EtMXF55443736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Nov 2024 14:55:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25C972004B;
	Thu,  7 Nov 2024 14:55:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEB3E20040;
	Thu,  7 Nov 2024 14:55:21 +0000 (GMT)
Received: from funtu2.boeblingen.de.ibm.com (unknown [9.152.224.229])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Nov 2024 14:55:21 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v3 0/3] New s390 specific protected key hmac
Date: Thu,  7 Nov 2024 15:55:18 +0100
Message-ID: <20241107145521.424769-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XM9cVqSVqV61RFcgdBfhe9kDGYqvuyvM
X-Proofpoint-GUID: XM9cVqSVqV61RFcgdBfhe9kDGYqvuyvM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=577 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2409260000 definitions=main-2411070114

Add support for protected key hmac ("phmac") for s390 arch.

With the latest machine generation there is now support for
protected key (that is a key wrapped by a master key stored
in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
for the s390 specific CPACF instruction kmac.

This patch adds support via 4 new shashes registered as
phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).

Please note that as of now, there is no selftest enabled for
these shashes, but the implementation has been tested with
testcases via AF_ALG interface. However, there may come an
improvement soon to use the available clear key hmac selftests.

Changelog:
v1: Initial version
v2: Increase HASH_MAX_DESCSIZE generic (not just for arch s390).
    Fix one finding to use kmemdup instead of kmalloc/memcpy
    from test robot. Remove unneeded cpacf subfunctions checks.
    Simplify clone_tfm() function.
    Rebased to s390/features.
v3: Feedback from Herbert: Use GFP_ATOMIC in setkey function.
    Feedback from Holger: rework tfm clone function, move
    convert key invocation from setkey to init function.
    Rebased to updated s390/features from 11/7/2024.
    Ready for integration if there are no complains on v3.

Holger Dengler (3):
  crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
  s390/crypto: Add protected key hmac subfunctions for KMAC
  s390/crypto: New s390 specific shash phmac

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 473 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 drivers/crypto/Kconfig            |  12 +
 include/crypto/hash.h             |   5 +-
 7 files changed, 494 insertions(+), 3 deletions(-)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: de786f0f83824eaa12aa92603be8655ec5d1a5bf
--
2.43.0

