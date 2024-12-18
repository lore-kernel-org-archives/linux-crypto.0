Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827DD1B043B;
	Wed, 18 Dec 2024 14:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734530738; cv=none; b=TpBTHpHlVQtUOy9iRiyydGN2Xh9oyZA4cwRVOyfBCu4OwwsqJrbBK2i39RFJo1gCI/28lJjil3us15lSyTPPHx4Ejq1Ho+XZpThVRpxIx4DI6I3MO7YAwY9qPxhvAw5dTxWNVTwMdQJ/m+8bA0n6c0s6D7f7YpqNHHbJpqgdgL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734530738; c=relaxed/simple;
	bh=FmAJy8EHXECB4X71ReOya1rEXYmpCxR+bZxYvDghPIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XhfLiTEfzsq3bgC2dk9zgA6PiYejnAWmUqpdPr5a0IQRLktCMulnZqTTPsucegCWP4ARvm01HBikcE5fakWGpM3v4Y1OYpgzeiDXTmNmGt0fZnvP2TW7Y981Rw7Flb7RuAGWY2KSi3IvSWFJ6L7+8/OoRqM4/GKBo+7EUFcZEF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=J80933pB; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J80933pB"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI3s9TV032304;
	Wed, 18 Dec 2024 14:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=AvQAVp2aA6E8JK4Oz3c7NI98qrvnbRu1D778CXfXO
	w8=; b=J80933pBcpLbSKLU5Zs23tFKMhhr/n8BTZfXE5yik8RW7gs6FFrtUyOUX
	JsYo5IYWulgO9m2Fy1jqsdHAo92WQxGvnRtza3UiWxpySnda0GyDn9dRD6qJL+dy
	NOIa8CUKV2wPoD3lbkbz1zIPyuuZHozyn3x57ydhwF52sXmMFwPLfy8dCAX6gOdv
	eZlfLeLQP4tVhPVbhUeR2XqQ1P+qNq1zkqWZ5OfYX0vOC1Bf8RWGi2jMfUP3rkhe
	Mjjwx0siJCghJVXPfq9X6FseSdaiVVpP84/js0HfOjOEPVK9F7b1MzoyylofY85q
	hR45/B2NrsShtLoNRq7SiWHyBWNXQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43kpvgtk2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 14:05:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIDoSlj014451;
	Wed, 18 Dec 2024 14:05:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hq21qt7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 14:05:32 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BIE5Uht56033630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 14:05:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1C912004B;
	Wed, 18 Dec 2024 14:05:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 750CD2004D;
	Wed, 18 Dec 2024 14:05:30 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.1.162])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Dec 2024 14:05:30 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v8 0/3] New s390 specific protected key hmac
Date: Wed, 18 Dec 2024 15:05:26 +0100
Message-ID: <20241218140530.82581-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WbZ-rjk8BKAroNv5gcGaOSRgixBOzt2M
X-Proofpoint-ORIG-GUID: WbZ-rjk8BKAroNv5gcGaOSRgixBOzt2M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=789 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412180109

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
v8: Added selftest. With the selftest comes some code which wraps the
    clear key into a "clear key token" digestible by PKEY. The
    selftest also uses import() and export(), so these are now also
    implemented. Furthermore a finup() implementation is now also
    available. Tested with AF_ALG testcases and dm-integrity, also
    tested with some instrumented code to check that the asynch
    workqueue functions do their job correctly. Coding is complete!

Harald Freudenberger (2):
  s390/crypto: New s390 specific protected key hash phmac
  s390/crypto: Enable phmac selftest invocation

Holger Dengler (1):
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 976 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 crypto/testmgr.c                  |  30 +
 drivers/crypto/Kconfig            |  12 +
 include/linux/crypto.h            |   5 +
 8 files changed, 1030 insertions(+)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.43.0

