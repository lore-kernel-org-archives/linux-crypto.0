Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CF41D8DEA;
	Tue,  5 Nov 2024 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730815123; cv=none; b=RsWtrH1U/iai+TsNi4izrgRWkEn3pLIJr9bgUbNmYCcZbdG4KUvxH+Bj3+bOLfK7Ftd+uGK4ou2z5ettt6Yq8VuPgJYUiVLG16WFPM0w6btXCYKco4IN81+l6/9JFD6FxtoHESebssWZ9nkceS6bFMae0i95NTrr/8i0r7fGUTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730815123; c=relaxed/simple;
	bh=4o4WTqHExdXhZZfYXrCAXtbfOpJ9ED+z4tuuZIof0X8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hD5WM83lC62VAbeSZHC5fpfEWtiQ1yqZ094E2HzohcekmVhGnyVOYw9gSqE6oGa97ViwgaF0jtMNnvxSlrKmwKLW6rYOONg3N/LVszAY1WtHhCZE/E2gTUFBssDM11/pnmLR2cGGa82kZQcgaTtPb5B+fLaFiIGoeojQVDv/RXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TGz4xz5K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TGz4xz5K"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5De74l025051;
	Tue, 5 Nov 2024 13:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ZBixBGZfXBY4UzPm2T4CaA/YfqIuhYuQbJOUEYaN9
	ys=; b=TGz4xz5K8KTHmJbvevLDL7NzwDCwOH8e6jB41O8d/YMgTRZpQw2KHJ4H3
	l3RZhVh5IL4yrfUT+nDyMwl8MSRvCsdkNSNqCc1mP1YkzKWpPMMPanSMgcGZWpG7
	WgwHzZ/ygET6N+57HUajnhj6nyrvaTHd8bmKd8M9tNJFB60R7cYbt4qIxxXzR3FK
	os4T412AbDTk3D3OvAegWG8rs4xGahm40fenXD998LBwtt/yD1rBFxI04wfdFj0s
	+JnU09fp5j/t+hOsWFPtMIp0jytV1IUXsc6bDEplM3OuiHyF17/+0/doYOK/P2Y3
	IjJiZfRsXJeznNEm33RAdf7M4RMhg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42qmepg3n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:58:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A58EJCs019503;
	Tue, 5 Nov 2024 13:58:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42p0mj465k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:58:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A5DwXh920054518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Nov 2024 13:58:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F98A20043;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55A7620040;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/3] New s390 specific protected key hmac
Date: Tue,  5 Nov 2024 14:58:29 +0100
Message-ID: <20241105135833.391957-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XHmYwHvhlMXsNcHXUka86gYI1J6AxcJb
X-Proofpoint-GUID: XHmYwHvhlMXsNcHXUka86gYI1J6AxcJb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=546
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 clxscore=1011
 suspectscore=0 priorityscore=1501 malwarescore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411050105

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

Holger Dengler (3):
  crypto: api - Adjust HASH_MAX_DESCSIZE for s390-phmac context
  s390/crypto: Add protected key hmac subfunctions for KMAC
  s390/crypto: New s390 specific shash phmac

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 468 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 drivers/crypto/Kconfig            |  12 +
 include/crypto/hash.h             |   5 +-
 7 files changed, 489 insertions(+), 3 deletions(-)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.43.0

