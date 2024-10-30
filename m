Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA86433D5
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305366; cv=none; b=iU3+7rQoSi1J4I0X0yzFd1JBWljeh/mVIulFEaTqQ3HmsS/8/oI/HAMD8b/Ekux8CxIoTArn2QdqV6OYGbW+8cfrlTkaEXGE15gYR71C6zvMWNtHlp5GgNX0hoCQBeXYmwkVZcFkP2M6jeAA63P/gu+r8frMmzs8q3GdrBVGcAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305366; c=relaxed/simple;
	bh=Rz2u+giaMcc6t+VFi1N+mCWc9dZoL+swNFNm9j/rOPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NwpHkUnab/gxovumo0gVYTxhQlE19AD/cMZnwB5vLlbVH7Mhn6OVy1Zn7Jk9rzfdyQBPsFpr6akCmztobu4oPUtDj4xK0ibhzX/FDWVFoGgl9178RyNkT4WlEajbaOzrJKa8ZwytJLoAGyqn0JH+vgCjQb5OlteJJPE5FbeXltE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HmrARMnf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HmrARMnf"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UFeakd020725;
	Wed, 30 Oct 2024 16:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=4vD9YnzGmIrFa639YpE3bkqFqu1kzuu+2SjwY1YmY
	c4=; b=HmrARMnfAbKF24mhp1PH2FGUyO4XDqY4dHvkNESvFEAs4TNERFXEesw9P
	OfYs0yxT1KUFB2bUOUMtY2FgpaQNNy3+gpsQGjSyQ64QDlf1tvMsWC4V3grMW50A
	YgFpLbw+RR5QBNrTuAJZScbBtP5bT6deadJbWDjJXGAMaucPFloC1vxgaApmlXg0
	NB0XwgtDOfXMuO0l7RrlKbEN8BnOJOP0lQoEwfQ4XGTHxzwK1ao/kjVlzSy94eWC
	tGnD2zR755N4CTCvsFvfkGafnzmpCWW+RkEJI648QIDDYOB5kBgX42IhMRniXOT8
	jBQ1d6SeKTJxyHH6l8grhPCnOySFA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42kqnar6af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:22:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UFZUZL028181;
	Wed, 30 Oct 2024 16:22:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hb4y0x6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:22:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UGMaIW15270300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 16:22:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E15620040;
	Wed, 30 Oct 2024 16:22:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E04B820043;
	Wed, 30 Oct 2024 16:22:35 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.18.237])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Oct 2024 16:22:35 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux390-list@tuxmaker.boeblingen.de.ibm.com, linux-crypto@vger.kernel.org
Subject: [PATCH v1 0/3] New s390 specific protected key hmac
Date: Wed, 30 Oct 2024 17:22:32 +0100
Message-ID: <20241030162235.363533-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cf-_lgfTa27p1l1SLHltcfWnY6Bd1XS9
X-Proofpoint-ORIG-GUID: cf-_lgfTa27p1l1SLHltcfWnY6Bd1XS9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=484
 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300127

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

Please note that v1 does not apply to the current crypto-2.6
or linux-next kernel trees: For crypto-2.6 there is a hmac
patch in the pipe and for linux-next there is a collision with
the s390/configs/*defconfig. However, the hmac code itself
is ready for a review cycle.

Holger Dengler (3):
  crypto: api - Adjust HASH_MAX_DESCSIZE for phmac context on s390
  s390/crypto: Add protected key hmac subfunctions for KMAC
  s390/crypto: New s390 specific shash phmac

 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 484 ++++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |  20 +-
 drivers/crypto/Kconfig            |  12 +
 include/crypto/hash.h             |   7 +
 7 files changed, 518 insertions(+), 8 deletions(-)
 create mode 100644 arch/s390/crypto/phmac_s390.c

--
2.43.0

