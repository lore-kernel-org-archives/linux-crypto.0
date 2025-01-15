Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C114D599;
	Wed, 15 Jan 2025 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736958159; cv=none; b=uMPxWq7dDSal/F8CHH996kleKsntgG4b1X37dRn1ZuvN/pdCU7kAiFELi21f4uL1v6v6250IO8JL8qMiMMmwyi+YqsVe6Dea9OlSL0VrKJ+a/1n88D8muQWfKavGJn4u7BQsc6ZtquEg8vAmkWLN+cGWGD43uc9mWgIChrsZheA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736958159; c=relaxed/simple;
	bh=O1u1+KMYnSCZQhbmL0uFi3Ar52EETgd6/T40tG7FjF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KCcl+RVIsJmKbLBXaJWapENoSk4TrYXWEEODSCKzGTkMy4/+LLWUZZ/llTYXo+NaQbR01SFJ8MPjLMsjOb5aOCexJbS3vAXnT07it7czlE6H1L1mKl8JysWBkl4gng2hUerSNFavB3+7fFnHSeS4MnCHOzd+D4GelPsYr34BtXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DhMKYRka; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DhMKYRka"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FGK93B031977;
	Wed, 15 Jan 2025 16:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=vZzre1O+M7RglHycufFbLsjY2KhmL6GOs8AD1Xj5W
	mg=; b=DhMKYRkavy/pRXr1Fr+1y/gmt6pH9gMeHKQK49hEtDm8S6+zq1rnGpCHS
	8kqwua68Wi83NZvFvKBB+VYnjiRFffLnxuVvyZrRNkVJCSIGhBLqjaouYM8unUAB
	DQW/DQZhGqkr/of84yZTksmixJKtWFrn1OrXVlt7QZFi1NYOmGYQFNi/1WdQlTWX
	iloCCaFRD6kA71yvjEo/jAr2gi/IuApYMYFPteAZ+7Tc5yhQDpeg4WGCD8oQB6G+
	g8lv2N59jUiSbYHk5Z9h2s2VZoBeLLdGtRfbN9KGEuAjPM3bsQ2Hw6zcMCrHmFuY
	wNJ93nbezaV9py/BMKPRq27m9eI2w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4465gbu9ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FFG8JL001089;
	Wed, 15 Jan 2025 16:22:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k104n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:34 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FGMWfh33882846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 16:22:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66CA32004B;
	Wed, 15 Jan 2025 16:22:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 307EC20040;
	Wed, 15 Jan 2025 16:22:32 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.28.131])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 16:22:32 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: New s390 specific protected key hmac
Date: Wed, 15 Jan 2025 17:22:26 +0100
Message-ID: <20250115162231.83516-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bcfo8TPHbWggQ5_O9n96FbejuCM4hyR3
X-Proofpoint-ORIG-GUID: Bcfo8TPHbWggQ5_O9n96FbejuCM4hyR3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_07,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 mlxlogscore=737 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501150119

Add support for protected key hmac ("phmac") for s390 arch.

With the latest machine generation there is now support for
protected key (that is a key wrapped by a master key stored
in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
for the s390 specific CPACF instruction kmac.

This patch adds support via 4 new hashes registered as
phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).

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
v9: As suggested by Herbert use ahash_request_complete() and surround it
    with local_bh_disable().
v10: Split the pkey selftest patch into 3 patches. Slight rework of the
     setkey function as suggested by Holger: When selftest is running
     as much as possible of the production code should run. So now the
     key prep with selftest is one additional if/then block instead of
     an if/then/else construct.
     Code is ready for integration and well tested.

Harald Freudenberger (4):
  s390/crypto: New s390 specific protected key hash phmac
  crypto: api - Add crypto_tfm_alg_get_flags() helper inline function
  s390/crypto: Add selftest support for phmac
  crypto: testmgr - Enable phmac selftest

Holger Dengler (1):
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 995 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 crypto/testmgr.c                  |  30 +
 drivers/crypto/Kconfig            |  12 +
 include/linux/crypto.h            |   5 +
 8 files changed, 1049 insertions(+)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.43.0

