Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE931A254E;
	Thu,  2 Jan 2025 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735811185; cv=none; b=ONlvXrCL9AcKcIu15aOblscqU4ARbjyHhncnLGbNoQjJbDaQWMBT4NG7bNCgbcY0HK+pvHncBAj01DdEQr7Q+cSSsTJWpidjaxL0exkqM3wD5FvFXKRzGzVIzsp0WC0EWz+FSrsHehsv+vtPzouv28qk7mtUpVA7mB8MTHNJTZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735811185; c=relaxed/simple;
	bh=O8kqaxHe7hqKIZWCi3LT60SOTHAGWvKkXVMi2ObD0nU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PmCC3P243fXedY7XgqPkcqgQtfZ848CTHas1VFhH+q+8r208fwU7xZ4L7ojjCX0+C3IqUKj1K4gzJpaRtoQUPl2qPqfNLyJXx/5lrL0H5INH00mmZluGIG3FYpSzNoLlYfcmjSnj8Bda1t97CE2TW6qwBwyp/4ARYIQ8MwEfFkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iRiOp9Bh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iRiOp9Bh"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5023qgfq000530;
	Thu, 2 Jan 2025 09:46:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=BuoaGvGBQ2J1OxY2nopde7uFw0xcEyUDuIX69RzLy
	6I=; b=iRiOp9BhobCnIyF/khBnnn/ck4u48GI0Ofte5G2TBva0KGs2hbRbyOQ6u
	PCMQaN1+MbwGHI6UHDCE1MS96IJAp51gmDTtTkY21eTkZ/uBpnKxTBR3dES4TBRh
	1BZdGuERyg0txvGBm8BfIwb5DFrhxlsaw3OrK/eTAesz6kOd3KQeB41Qe/pCscSy
	CqoADcGChrteTtY39xIJuTrdkmtjmI2Q+b4LCnfBEXe0/fKcRjaAWPJ1pfdSKXHR
	+NTunLhZYt8r7v2lnjdIh6ncsaMKs3dGMhdrV0xReokJO+CRxTDOSSxdgWIURndo
	GGhp1VIVeqkx8nTzY+LdU/Eg2cF2g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43wk9gh2dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jan 2025 09:46:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5024biDG014022;
	Thu, 2 Jan 2025 09:46:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43tv1y9mp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jan 2025 09:46:18 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5029kGMx50659586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Jan 2025 09:46:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AF942004E;
	Thu,  2 Jan 2025 09:46:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 022CE2004B;
	Thu,  2 Jan 2025 09:46:16 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.11.208])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Jan 2025 09:46:15 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v9 0/3] New s390 specific protected key hmac
Date: Thu,  2 Jan 2025 10:46:12 +0100
Message-ID: <20250102094615.99181-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UfTC1RL2OnVuB4S1Bu0aOquZ6KpeUuHf
X-Proofpoint-ORIG-GUID: UfTC1RL2OnVuB4S1Bu0aOquZ6KpeUuHf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 malwarescore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=821 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501020081

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

Harald Freudenberger (2):
  s390/crypto: New s390 specific protected key hash phmac
  s390/crypto: Enable phmac selftest invocation

Holger Dengler (1):
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 986 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 crypto/testmgr.c                  |  30 +
 drivers/crypto/Kconfig            |  12 +
 include/linux/crypto.h            |   5 +
 8 files changed, 1040 insertions(+)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.43.0

