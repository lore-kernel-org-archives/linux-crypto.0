Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9565628ECEF;
	Fri,  9 May 2025 10:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746786259; cv=none; b=GA0k3cmWPp0X+roNuVlUuR1+3TZvO8l+Z3lYZ3xxsYqOD8O2s8+uxJ/w04shWHQbts5cgDkJeUBNrqiyDtskhEQacjcKIYFPU+ipyAVUA6NkM3w4XpGYnO1HvNULJil9U594EIViFfYfj2PbFzQ2GxK5YF99II8DLQdSN/KE38k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746786259; c=relaxed/simple;
	bh=Iln99DE/Wxn5nXHgsAsO0isIHyjPf02ve5AgSB1/Gmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4Z6obqaDDzCfx1IaFI+eD+Dh0kj68DJSP8z5IuavU+Cdo9OjnF0OqIthCYVXj8GUSQckrFlPY6lSlvIDI5hADEHaHjzz7+70NyPmQMFNWvWRv7hTnm3d/62kHWaCwZabDpl2+MhmwlS1aT7cfddVC1kMVmvcCM50v5BZnNBCVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FdyZGie7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FdyZGie7"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 549A4H02026667;
	Fri, 9 May 2025 10:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=XZjkn5H0guqNlMVeV9dg9Wm1G80xzZ+GfBT/1uNnw
	fs=; b=FdyZGie7AS2TnUJt8fucgfETlz8C6MFPjGr4PToLhkWaxVvduNoGIHvyk
	dHTPnFBhXePQE+gOORg6kGWYMkHOA/SCqzxT1iTuCEeDl7F2B027a44zUkvbAbsH
	45fhf/r2A2g9sm6hulIe64V2QpZNm24lz4N1jkiAM61YPQ00JuNQJBu4xJgQszji
	3wH59fTpy970JcCsBYBxFl2z3XfjfSnFe/QpsrD0ZHCqcuQm+o8cCpKxSUOfzO7y
	Kf03tuYzb/xZ22H2wVNaVTC2oNpKBWm2wI/GbYnx5VN70EhPxVnSOccF0lpUlIB4
	lME8/K2AdEFjI3ScwhH1YECfUjsbQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46hfmn82jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 10:24:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5497tR1u001313;
	Fri, 9 May 2025 10:24:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46dwftu1f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 10:24:06 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 549AO24J53019134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 May 2025 10:24:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D83EE2004D;
	Fri,  9 May 2025 10:24:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97B7120040;
	Fri,  9 May 2025 10:24:02 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.70.163])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 May 2025 10:24:02 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 0/3] Rework protected key AES for true asynch support
Date: Fri,  9 May 2025 12:23:59 +0200
Message-ID: <20250509102402.27287-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RO6zH5i+ c=1 sm=1 tr=0 ts=681dd7c7 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=P6K9oCenzVjz27GQCyoA:9
X-Proofpoint-GUID: a1pG87DTbFIsm_lvpwdkkq2yE5Dv3YXd
X-Proofpoint-ORIG-GUID: a1pG87DTbFIsm_lvpwdkkq2yE5Dv3YXd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDA5NyBTYWx0ZWRfX7k2lKq2gIEKn jq0hPm+75VQkrLZu+4zD6zRbR887Y3ZSzQtSZ35odurj0lfurnzv7HNNbmHwwo0ycE0iUe9si+g +AfDVJV4yB1L3ujukM7HoE9L3QaiHPQ2gT6giyfjIYjWhXgrU0b0lMIguqsMyuu6c/mIH761NuM
 iKpIHyy49Ump0vu3SO6u6NqI/RQXb6ThuNE21CPgcOONLXuDorVGOJNMy5RkkgnibnL5xeXA/YV SZyYJsN/Ynqc1dPdaUGi/QDPNNfiqHfO6+RbgAbZV/SlAmZb9XQTXoRm8SF+YhirQybimV+ohlF UzHqEcm9cuncRxKgr/CCFMOh4M7Bj932bl4l3BJGBRibaxVeRWEYeHp4NOc2yfyQZIxbDr1TZDp
 C7NQIg5fHZ3f82qJyDZYmsmC+ekgm01CDkgOsM+LPjN9+6jjtO/7VU5UhP8QPqxJtdUDvZe9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=994 malwarescore=0 impostorscore=0 adultscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090097

This is a complete rework of the protected key AES (PAES) implementation.
The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, xts)
in a real asynchronous fashion:

- init(), exit() and setkey() are synchronous and don't allocate any memory.
- the encrypt/decrypt functions first try to do the job in a synchronous
  manner. If this fails, for example the protected key got invalid caused
  by a guest suspend/resume or guest migration action, the encrypt/decrypt
  is transferred to an instance of the crypto engine (see below) for
  asynchronous processing.
  These postponed requests are then handled by the crypto engine by
  invoking the do_one_request() callback but may of course again run into
  a still not converted key or the key is getting invalid. If the key is
  still not converted, the first thread does the conversion and updates
  the key status in the transformation context. The conversion is
  invoked via pkey API with a new flag PKEY_XFLAG_NOMEMALLOC.
  Note that once there is an active requests enqueued to get async
  processed via crypto engine, further requests also need to go via
  crypto engine to keep the request sequence.

This patch together with the pkey/zcrypt/AP extensions to support
the new PKEY_XFLAG_NOMEMMALOC should toughen the paes crypto algorithms
to truly meet the requirements for in-kernel skcipher implementations
and the usage patterns for the dm-crypt and dm-integrity layers.
The new flag PKEY_XFLAG_NOMEMALLOC tells the PKEY layer (and
subsidiary layers) that it must not allocate any memory causing IO
operations. Note that the patches for this pkey/zcrypt/AP extensions
are currently in the features branch but may be seen in the master
branch with the next merge.

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
v4 - With feedback from Holger and Herbert Xu. Holger gave some good
     hints about better readability of the code and I picked nearly
     all his suggestions. Herbert noted that once a request goes via
     engine to keep the sequence as long as there are requests
     enqueued the following requests should also go via engine. This
     is now realized via a via_engine_ctr atomic counter in the tfm
     context.
     Stress tested with lots of debug code to run through all the
     failure paths of the code. Looks good.

Harald Freudenberger (3):
  s390/cpacf: Rework cpacf_pcc() to return condition code
  s390/crypto: Rework protected key AES for true asynch support
  Documentation: crypto_engine: Update and extend crypto engine doc

 Documentation/crypto/crypto_engine.rst |   78 +-
 arch/s390/crypto/paes_s390.c           | 1812 +++++++++++++++++-------
 arch/s390/include/asm/cpacf.h          |   18 +-
 3 files changed, 1321 insertions(+), 587 deletions(-)


base-commit: 3919600d32b92e67f1d28376bd63152306e99452
--
2.43.0

