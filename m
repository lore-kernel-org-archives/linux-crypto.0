Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D4918F2D8;
	Fri, 15 Nov 2024 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682358; cv=none; b=gBlPMB1vm1n8Gk85cdjS53AgeChmw1e3ClLSLnBy5c3a6yhUxgB41m2KV0pmDua+9eKXenPbqNRR+HzfsPLilg40A7Ggk+DVLhkqdeHMD83f7Bl3zT+TpVwkoXgAwxGaZrBCXMktOeVRZcfUdGIjpF4s0+Zx8wBW6BWYLfLTD2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682358; c=relaxed/simple;
	bh=b2aThIvp129jGBy0/9pfdfJcgK5nB4fektwyDV6+P5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I9xgvliEGhdhY/0fzqs46etMDpW8ZCH9uC+GAkvL4Ic7I58CnHRliFLnUQCYlnH/DYj05NvjrXFdQszvbuO2HILc+gWu5PE1Gb2O4y3Emt4YhRVHp1g7O5qmvJhLwCkhdBGNzu2wRTvnrfcdhlE+yF4LTZBmHZqqA0sldGWhHfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XlUhbwPR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XlUhbwPR"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAYZLl007813;
	Fri, 15 Nov 2024 14:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=bfmBHEcCqigfqRiZKm/54mhqCrWHCxxI9c0qDmX/s
	uw=; b=XlUhbwPRZg+tTnApykoINOsSTsTUzdM7zSrmqDEm6cBVpF9m6N9nyf0xn
	wf3M3mO3WjNPkiRur1qrDvgVeYJjtKTSH3HOVTCnPzNjRaJ2ROBzzAoVJBEnOHlJ
	ruJlC4+2dUxn1msIvWbwvmCtzoOYPpRSReONDu1nmWjg2/inRNTV5y+ZiFsvq5JI
	ejG8NksuVpMU85srANgAqHvfW9CsFiR9zVOnl+vI1yNl0TRUvfWIRb4tIxY60XLY
	gN6p75mSNZtV3ubNj2rQ2v44Z8IvKIlOKNIPP1UCF2ISUY3Jid6ic5o+qFd9BxCe
	FZe+tdYBVRq79azVPuA/ufEPcKz+A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42wt6wbvss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFELDEL008243;
	Fri, 15 Nov 2024 14:47:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tjf0k42f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AFElPEu58786080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 14:47:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C32E2004B;
	Fri, 15 Nov 2024 14:47:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C6AC20043;
	Fri, 15 Nov 2024 14:47:25 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.73.203])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Nov 2024 14:47:25 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v4 0/3] New s390 specific protected key hmac
Date: Fri, 15 Nov 2024 15:47:21 +0100
Message-ID: <20241115144724.12146-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pJRjyubmpa6hD9vNlsLbKbiWNyj29DnB
X-Proofpoint-GUID: pJRjyubmpa6hD9vNlsLbKbiWNyj29DnB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=556 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150124

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
v4: Rewind back more or less to v2. Add code to check for
    non-sleeping context. Non-sleeping context during attempt to
    derive the protected key from raw key material is not accepted
    and -EOPNOTSUPP is returned (also currently all derivation
    pathes would in fact never sleep). In general the phmac
    implementation is not to be used within non-sleeping context
    and the code header mentions this. Tested with (patched)
    dm-integrity - works fine.

Holger Dengler (3):
  crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
  s390/crypto: Add protected key hmac subfunctions for KMAC
  s390/crypto: New s390 specific shash phmac

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 481 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 drivers/crypto/Kconfig            |  12 +
 include/crypto/hash.h             |   5 +-
 7 files changed, 502 insertions(+), 3 deletions(-)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: e200565d434b66e5b2bfc3b143b66b8ca29666ad
-- 
2.43.0

