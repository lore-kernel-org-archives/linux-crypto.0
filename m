Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C482DF3CA;
	Tue, 17 Jun 2025 13:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167891; cv=none; b=Fx4rCg+KhSKgI9Z2aJnaJknqL9jWUXaLYkMnaEH/7oFIMSJEXIBa3N6XY0twU2WoEwIlW9WETuz4VEKZt4pWGeTsTDHHr/Ux1J5vEWxnBoudityMjVZ+dLDauaG+FKDut79Kknym/PYxfK1kKOF+c+2dZNi+xHUeGCfzt5TXhSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167891; c=relaxed/simple;
	bh=1tTefitN9xfheFcOvtA5l7WyUhU/3NCTNfuS4ufSJvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EQnYHCowCzBDePtFTCpL9DPo67NWJ6X9tbSVj3+eBZn9edzJEHGs6nk/UVJH00Qp32z3A95kSPmNteKnxZpuxDsIT/VBSwFc7oLOsVzn5/+0uKskxUiu+qeBvvNhw7D8JQUVgS2VXTj7pApo3bVkbVSQTtffzRZ0UyB1DGLoAXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OgoFEtyi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OgoFEtyi"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HAn6uH013475;
	Tue, 17 Jun 2025 13:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=oPb/c30xF1/1rRkA8y/mfGecLt7IhDuqOQi4cHiTu
	c0=; b=OgoFEtyiAELGjqI4qWQK5+ZCF+K56OzEH1l6h5aRek03N3QwV4p1OgKLU
	AGDrbxL93V1C63OWV8cr1Z+QGhW67jJiiTmY7z9fU8iMzAGQX6+sxkOMK3qx+975
	KZXeeONm4BBkCWOEa99982lR5r5CS/tAHIB71vIu3nvaO3gFRlTUQ5YzC1o7gqxD
	mVt3JL0aKa6rh+gTAdJvBdStpZdjXDWri3RMc+eWuv57Z4gnLszgGrV1E8FXv+NN
	dRhL98va816k/fpaO/i8ykd0eRMJ5JudiRJgMiedt5IKpnAQLnASXO8KB1uGIDse
	nHYR2lONGhEtT9puYoJihK+GnKLpA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r206un-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55HC9DgE000724;
	Tue, 17 Jun 2025 13:44:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 479mdp3r44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55HDifl452035898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 13:44:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6512820043;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11E452004B;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.71.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v12 0/6] New s390 specific protected key hmac
Date: Tue, 17 Jun 2025 15:44:34 +0200
Message-ID: <20250617134440.48000-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7muto1cVZRNQTULUD81mGjktjCFnDQkv
X-Proofpoint-ORIG-GUID: 7muto1cVZRNQTULUD81mGjktjCFnDQkv
X-Authority-Analysis: v=2.4 cv=AqTu3P9P c=1 sm=1 tr=0 ts=6851714e cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=6IFa9wvqVegA:10 a=-xSpq2wtoGP2116iE9YA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDEwNSBTYWx0ZWRfX6fm/BPIeAWwx ppJaKN1Y+e+9iukS5EYwSNepgTS8BseLK+3y/aecekqpGrHqt5K1SWuBq3GuLStXuzC6q2NRBRg i6WhfKbjKV4Tx9trlw9Q/iKAjhFY+RbeGI/t1SYvXTqcm0kWpeQ5T9t5CtHaiBoizyOZY7rjRyW
 aQ/beWmbWBcFmHtpZQYIWPcR9/KYLgCkliFrqmFYFHP7V1Wup6TWcNQZf/MHzMrzwCyGV64wC2F iuWxGOH4wyKHZ4i9pQh14V6OhhiJdrXo/h34SEAQkDfRLpcErnoAdvV7MMMiCK3djvM9ixW+gHY zvAIHyfmb3whNYa/YJ0/ffa8Vj6Z4+LRKHDizdm+CkKL7auUwU+UTDteynkG7QMK7HTGscnYvEu
 VpXb3h5Cm++ADjz2sqJXZ0yKqCrd54R+Qw2g25NB/cMu30vrl8Li9qwwK7rNzbRx8k1s3FGW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506170105

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
v11: Utterly rework with the insights collected with the paes rework
     and the basic work done with the pkey rework over the last 5 month.
     Note that patch #1 effectively reverts commit 7fa481734016
     ("crypto: ahash - make hash walk functions private to ahash.c")
     from Eric Biggers.
v12: Fixed some typos, adaptions to 128 bit total counter,
     misc_register() invocation was missing in the patches series,
     added Herbert's proposal for a new function crypto_ahash_tested().

Harald Freudenberger (5):
  crypto: ahash - make hash walk functions from ahash.c  public
  s390/crypto: New s390 specific protected key hash phmac
  crypto: api - Add crypto_ahash_tested() helper function
  s390/crypto: Add selftest support for phmac
  crypto: testmgr - Enable phmac selftest

Holger Dengler (1):
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |    1 +
 arch/s390/configs/defconfig       |    1 +
 arch/s390/crypto/Makefile         |    1 +
 arch/s390/crypto/phmac_s390.c     | 1048 +++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |    4 +
 crypto/ahash.c                    |   26 +-
 crypto/testmgr.c                  |   30 +
 drivers/crypto/Kconfig            |   13 +
 include/crypto/internal/hash.h    |   30 +
 9 files changed, 1133 insertions(+), 21 deletions(-)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: 1029436218e50168812dbc44b16bca6d35721b0b
--
2.43.0

