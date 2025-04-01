Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FCA2054ED;
	Tue,  1 Apr 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743519059; cv=none; b=d1VtRsMUweMWwbe9F/a9tTPCO8p4z3X/EoA1vxcD7+FqoAivlmEL6LOL2b4qFOMx6S6lMTLWg1zcfDFzvmlOvXwsXp5DhP2FkPm6mDUi7+BKkBtbC9oBjnAc7m8Vc7cxXX2/+fy/5KNeZjwqBiiS/zg8WfD0VS1lSDz22MSDRUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743519059; c=relaxed/simple;
	bh=knEnWKr1RLKeMazEKJCv57y2jf6RjGVrNW6mYybuP7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jQdSe67JUc7k3bWarHbxM9MxdOsBaQ8KiriVPmK2P6WXGQu9Xc9Ieu7iDYnJMEEfbpq2Mlrru3S9/8HR7fBR6bzx/HEWPf077jTbwOtZ3xUB8RfQoLxol+z+qLlhi4+vIl6KThSh77887u0e+gtXVQbWEv4b9LrIxU7FS2rT2Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Zi91CDh2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zi91CDh2"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53190DYC030115;
	Tue, 1 Apr 2025 14:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=oRswy2m2KQgwvrhfciRi8pzc1LRJVsz5sbI9aLKXh
	dI=; b=Zi91CDh2hSZcZRrroGeK3K57ZasIdrbriQswsAw6zJcYNhhVRxm1VGuNK
	5bJ8mNFinX6tdFPJqOuMsPKBFsdXL574HtiD23UcqPAaedNyyfq0vTivdDUFlsVh
	ZyvpRFSMpu+bcujH/U4hg0BpX1MwWAMU26ve1IZy4w12bu5DaBJJkMqwXjKptNwD
	PKvBIvviZksP1kp/YQbuThfSZcgN0kuJONffasds1iyZPHBsS5OZwDrR6zXBqRv9
	ELmh/BN7yitPl+Fm9kaA2NBLRlMDOFnyEyC1PdpFXlA47e36ntcSKf2v/pyPbBl6
	VhbSnpv2rPa5r61rYFAAVYcdlXxKQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45r27q4atf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 14:50:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 531DHg6H014598;
	Tue, 1 Apr 2025 14:50:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45pvpm2wcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Apr 2025 14:50:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 531Eom5B46465442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Apr 2025 14:50:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6813A2004B;
	Tue,  1 Apr 2025 14:50:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 460DE20043;
	Tue,  1 Apr 2025 14:50:48 +0000 (GMT)
Received: from funtu2.boeblingen.de.ibm.com (unknown [9.152.224.229])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Apr 2025 14:50:48 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 0/3] Rework protected key AES for true asynch support
Date: Tue,  1 Apr 2025 16:50:45 +0200
Message-ID: <20250401145048.52564-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AauGE_GgWwwBUzYf3HdToUWBeE2H85mT
X-Proofpoint-GUID: AauGE_GgWwwBUzYf3HdToUWBeE2H85mT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-01_05,2025-04-01_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=915
 impostorscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502280000 definitions=main-2504010090

This is a complete rework of the protected key AES (PAES) implementation.
The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, xts)
in a real asynchronous fashion:

- init(), exit() and setkey() are synchronous and don't allocate any memory.
- the encrypt/decrypt functions first try to do the job in a synchronous
  manner. If this fails, for example the protected key got invalid caused
  by for example a guest suspend/resume or guest migration action, the
  encrypt/decrypt is transfered to an instance of the crypto engine (see
  below) for asynchronous processing.
  These via crypto engine postponed requests are then handled via the
  do_one_request() callback but may of course again run into a still
  not converted key or the key is getting invalid. If the key is
  still not converted, the first thread does the conversion and updates
  the key status in the transformation context. The conversion is
  invoked via pkey API with a new flag PKEY_XFLAG_NOMEMALLOC.

The pkey API used here - the function pkey_key2protkey() - uses
a new version of this in-kernel-API. A new flag PKEY_XFLAG_NOMEMALLOC
tells the PKEY layer (and subsidiary layers) that it must not allocate
any memory causing IO operations. Note that the patches for this
pkey/zcrypt/AP extensions are currently under review and yet not
upstream available. SO THIS PATCH DOES NOT COMPILE YET !!!

This patch together with the pkey/zcrypt/AP extensions should
toughen the paes crypto algorithms to truly meet the requirements
for in-kernel skcipher implementations and the usage patterns for
the dm-crypt and dm-integrity layers.

There is still some confusion about the way how paes treats the key
within the transformation context. The tfm context may be shared by
multiple requests running en/decryption with the same key. So the tfm
context is supposed to be read-only.
The s390 protected key support is in fact an encrypted key with the
wrapping key sitting in the firmware. On each invocation of a
protected key instruction the firmware unwraps the pkey and performs
the operation. Part of the protected key is a hash about the wrapping
key used - so the firmware is able to detect if a protected key
matches to the wrapping key or not. If there is a mismatch the cpacf
operation fails with cc 1 (key invalid). Such a situation can occur
for example with a kvm live guest migration to another machine where
the guest simple awakens in a new environment. As the wrapping key is
NOT transfered, after the reawakening all protected key cpacf
operations fail with "key invalid". There exist other situations
where a protected key cpacf operation may run into "key invalid" and
thus the code needs to be prepared for such cpacf failures.
The recovery is simple: via pkey API the source key material (in real
cases this is usually a secure key bound to a HSM) needs to generate
a new protected key which is the wrapped by the wrapping key of the
current firmware.
So the paes tfms hold the source key material to be able to
re-generate the protected key at any time. A naive implementation
would hold the protected key in some kind of running context (for
example the request context) and only the source key would be stored
in the tfm context. But the derivation of the protected key from the
source key is an expensive and time consuming process often involving
interaction with a crypto card. And such a naive implementation would
then for every tfm in use trigger the derivation process individual.
So why not store the protected key in tfm context and only the very
first process hitting the "invalid key" cc runs the derivation and
updates the protected key stored in the tfm. The only really important
thing is that the protected key update and cloning from this value
needs to be done in a atomic fashion.
Please note that there are still race conditions where the protected
key stored in the tfm may get updated by an (outdated) protected key
value. This is not an issue and the code handles this correctly by
again re-deriving the protected key. The only fact that matters, is
that the protected key must always be in a state where the cpacf
instructions can figure out if it is valid (the hash part of the
protected key matches to the hash of the wrapping key) or invalid
(and refuse the crypto operation with "invalid key").

Changelog:
v1 - first version. Applied and tested on top of the mentioned
     pkey/zcrypt/AP changes. Selftests and multithreaded testcases
     executed via AP_ALG interface run successful and even instrumented
     code (with some sleeps to force asynch pathes) ran fine.
     Code is good enough for a first code review and collecting feedback.
v2 - A new patch which does a slight rework of the cpacf_pcc() inline
     function to return the condition code.
     A rework of the paes implementation based on feedback from Herbert
     and Ingo:
     - the spinlock is now consequently used to protect updates and
       changes on the protected key and protected key state within
       the transformation context.
     - setkey() is now synchronous
     - the walk is now held in the request context and thus the
       postponing of a request to the engine and later processing
       can continue at exactly the same state.
     - the param block needed for the cpacf instructions is constructed
       once and held in the request context.
     - if a request can't get handled synchronous, it is postponed
       for asynch processing via an instance of the crpyto engine.
     With v2 comes a patch which updates the crypto engine docu
     in Documentation/crypto. Feel free to use it or drop it or
     do some rework - at least it needs some review.
     v2 was only posted internal to collect some feedback within IBM.
v3 - Slight improvements based on feedback from Finn.

Harald Freudenberger (3):
  s390/cpacf: Rework cpacf_pcc() to return condition code
  s390/crypto: Rework protected key AES for true asynch support
  Documentation: crypto_engine: Update and extend crypto engine doc

 Documentation/crypto/crypto_engine.rst |   78 +-
 arch/s390/crypto/paes_s390.c           | 1725 ++++++++++++++++--------
 arch/s390/include/asm/cpacf.h          |   18 +-
 3 files changed, 1234 insertions(+), 587 deletions(-)

-- 
2.43.0

