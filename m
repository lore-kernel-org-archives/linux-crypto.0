Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827591586C8;
	Fri, 29 Nov 2024 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732878971; cv=none; b=UmcAImmtsAAo0fmXA+xCPDYC+FF3Cg8up2ITd0AXr+IWGxwDxonORnnkLdB6tUIL/0EZG3TSgydLUeXAmgFAc69jhBfdzUTjq6KJDyOK9gjZvh9GGEOh+bkLNS3RHeRiuLN3exlPROfzqHZwZ6tbi8/tlsTZ9wtkU2IJG/ZaJDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732878971; c=relaxed/simple;
	bh=6ouqENTqLw886zWpLJC0n681BepRUowgvS3Y3wxo1GA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gUuFw6+2HUUe06XFySn0zp6bA7NRxkF/du7I1Wp8J5U2+p1oA8/RppKHXJLiRk39/GXLknJwiQ1/YxXQf358Hz4wrHaZvdFLwZ48O3suTIPiqvDfjrbktcVRN1/1Pcv9E5ZtFaHxzqz64/zex01nmHWsagymciKuYro0i32K7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bSVeQHeD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bSVeQHeD"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AT80tv1002220;
	Fri, 29 Nov 2024 11:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=gzcZkhh/Uh4y9Ds1ndVI+z0KwrwafdJ92qdDoS8bl
	A8=; b=bSVeQHeDEufGMwkyWnFtu8Ga//Bp2OsJK7KbwkMPP/1F48VH9OXp/Z0T1
	cnGcOByLkK3llGxkgUKRNokD7VWncYf8K1TanXON/f+yFjNYL2iZRH2m6pjVco2n
	4VcKZks4K6Q8nL0GDO6PxAJOxTJd0bIK0KoM4NY2onVseIdOZ3iJKDn2PR/jlQbV
	DnMeEmvfvOyqJE8T5StwNN4pwH2kQcI4xEysLdV2wwFIc3bK+gDoWny8WS7rfmmh
	JVpGRPWOnygIa0B290U+M3JLa8ELQnqDsETYO9t5tBcrqeV6qyZfR8roLDSWWSfc
	drsG0yOSNmlSytSRPlaliYSQsQrSg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4366yxssqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 Nov 2024 11:11:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ATB1Hgp011990;
	Fri, 29 Nov 2024 11:11:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43672gv9hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 Nov 2024 11:11:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ATBAx6329753954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Nov 2024 11:10:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE52D2004B;
	Fri, 29 Nov 2024 11:10:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A24820040;
	Fri, 29 Nov 2024 11:10:59 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.44.200])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 29 Nov 2024 11:10:59 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v6 0/2] New s390 specific protected key hmac
Date: Fri, 29 Nov 2024 12:10:56 +0100
Message-ID: <20241129111059.303905-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PogoSDJfgxXMDn2pFgqjsklv9_jlPuw0
X-Proofpoint-GUID: PogoSDJfgxXMDn2pFgqjsklv9_jlPuw0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 mlxlogscore=777 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2411290090

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

Harald Freudenberger (1):
  s390/crypto: New s390 specific protected key hash phmac

Holger Dengler (1):
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 474 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |   4 +
 drivers/crypto/Kconfig            |  12 +
 6 files changed, 493 insertions(+)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: 3f020399e4f1c690ce87b4c472f75b1fc89e07d5
--
2.43.0

