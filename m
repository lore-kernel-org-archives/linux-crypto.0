Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F8813AA4E;
	Fri, 22 Nov 2024 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732286378; cv=none; b=Irq6VUMerBGfkfb8QY2Jh8AxXVufcaJKIZhfbrrojw/Jkmw1HccWJIY0Ea3knlU5HjDSTwdGya53f82KofEliQK9uS3mflUCYf3B+0jaLy8t2VZ+KYcgEc5IBWy1tadhCzs+SuY9O1Rfj4pmHvQ7QnbyC68Npo446SxDiG5Gq/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732286378; c=relaxed/simple;
	bh=mOKwCslIG7bQ2IcYM1y0ZOAHuZ7R3r24lc8GHKE9gBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OISqsUzjhjN2h+o+PgRFxFn9HTl3IyslPzAp+X3Yi756xZVJ3R4HM7HIsMQitKF5hIfnam9DkXQBrfQX+06V3ipnH9CxP639UyT48gfjiiftEaKsioyihvnlsyXSCXm1NkBzgWdoW2xA0dQ3vQwcZ8efD6Q5BtIpOptJ1WHiKR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dNhZUamb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dNhZUamb"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMCU0KL001142;
	Fri, 22 Nov 2024 14:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=clLENGNOsbBJlNLmlpKKYu13xNB4UDxCgXAabcpmY
	qw=; b=dNhZUambBu4xMNXXxZdvps4SkGSTJ747NBjJ/+Jo0nNP+kf6y7X+jKDY9
	4QDFMeBJ2d3YFKgyVbYDtsx6DKmvz3z93xWSnvKhlnvK5nTG3DqVUt52RRbiE82/
	NzFeEzgIZOA8aJ8KoFlJpt2K4AYZrcCD5IZpa/bBmTluO5rrO7shZ2vLO3HfVBYl
	ztHsBPsi6i1rPr8QL6XAMhfGkJc97Yjg1kd6DowBMbXamOtmwyXUnhybyyN2wYz9
	bKi0uOPCF4OFj9IW7ywbD8Xa2JRNHVfnnJTvDtEtHbl1Q/oO6vtMSsk2GuIFW6sn
	adcOb/14oahSjUzKKAlPUjBkL/0yg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4313gt07gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 14:34:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AMDvt9o025841;
	Fri, 22 Nov 2024 14:34:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42y6qn39r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 14:34:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AMEYSIv64487818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Nov 2024 14:34:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 506F82004F;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 119562004B;
	Fri, 22 Nov 2024 14:34:28 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.82.52])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 Nov 2024 14:34:27 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v5 0/3] New s390 specific protected key hmac
Date: Fri, 22 Nov 2024 15:34:24 +0100
Message-ID: <20241122143427.135682-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e9OaT6h7AQY2apVlWNRXCpGVVRPCehJX
X-Proofpoint-ORIG-GUID: e9OaT6h7AQY2apVlWNRXCpGVVRPCehJX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 adultscore=0 mlxlogscore=768 mlxscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411220122

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

Harald Freudenberger (1):
  s390/crypto: New s390 specific protected key hash phmac

Holger Dengler (2):
  crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 661 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 drivers/crypto/Kconfig            |  12 +
 include/crypto/hash.h             |   5 +-
 7 files changed, 682 insertions(+), 3 deletions(-)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: 3f020399e4f1c690ce87b4c472f75b1fc89e07d5
--
2.43.0

