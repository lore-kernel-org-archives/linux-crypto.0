Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DB35A0F9;
	Tue, 14 May 2024 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715708345; cv=none; b=Z+p70FYuk0gLdeBr0IESkNwCfv9L7IatjPrdQye4EOqrX5C07VsWSuIgzrlnjPkiBSKUhIu1WkEx6B4sGSkTJdxgokXue0gD00imK4C28OZp6+M3Lt4htq+NQPh5SFdEjE4weC85REfosD4D/GE/ZDg14OFW1fUvsaH2sMWQ3WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715708345; c=relaxed/simple;
	bh=/9A7UTd7MM9F162NMDRSPFTTgx/ChKayAwWTGhRscw8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m3XEKIwyPk/R48cRes6+MUeQVNOGqjn0vq/meN1+BuVmWOpNdScQKcNfOlsGzXkenyhow1TrdzJWRoqHbni1EGktgu0HQoc6XCbv2cJf3s+KdglShJIgx9L6C0usS8anDEJjKfSuXoRLztpzHArNlEDD7BknUgaw98UP3Ko1IFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k11JKdhY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k11JKdhY"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44EFfnZ9022109;
	Tue, 14 May 2024 17:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=s380DvIVUvrqNkCPvWQHywF6rq8I55TzcUuDNMTmk7A=;
 b=k11JKdhYJkXi0FlErdzjhCBQ1bHqwdHmRof8d50Q8Tl1v4TuaQWENszEj/alcX+X6562
 btV3Rxoplz78bJv17ISs6fG5d5DUBVm3GbqhQny1lbCsV2rNxPQYt0v9xKoV0keS+rjc
 jM7pIcGU2tZXKKJxgAFSx/tCAyQM0kveCvkktdxzbmp0jFcr9AdR9q0d8m6hDRuK0EVq
 DnK27RHAkKqeEMS3V4E7GfCbk3I2pLu+zsOqm/DJ/89xFKcak1XJbmSVFcS+J7SAi3HQ
 LiBO1oIG5IBaeQ+GtCJMhFKtiqjmc4LbgTKWA7fXx4l+T9xDIDrqtAqImiszOe0N+LEi LQ== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y4a9brbdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 17:38:44 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44EFOu8S002288;
	Tue, 14 May 2024 17:38:43 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y2m0p6r78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 17:38:43 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44EHcePx25362850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 17:38:42 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47E9758052;
	Tue, 14 May 2024 17:38:40 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7F0D5805D;
	Tue, 14 May 2024 17:38:39 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 May 2024 17:38:39 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH 0/3] crypto: X25519 supports for ppc64le
Date: Tue, 14 May 2024 13:38:32 -0400
Message-Id: <20240514173835.4814-1-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O4MzfgNaX7KpN4B9YAgFpEOV1qf4shVt
X-Proofpoint-GUID: O4MzfgNaX7KpN4B9YAgFpEOV1qf4shVt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_10,2024-05-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 mlxlogscore=663 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140124

This patch series provide X25519 support for ppc64le with a new module
curve25519-ppc64le.

The implementation is based on CRYPTOGAMs perl output from x25519-ppc64.pl.
Modified and added 3 supporting functions.

This patch has passed the selftest by running modprobe
curve25519-ppc64le.

Danny Tsen (3):
  X25519 low-level primitives for ppc64le.
  X25519 core functions to handle scalar multiplication for ppc64le.
  Update Kconfig and Makefile.

 arch/powerpc/crypto/Kconfig                   |  11 +
 arch/powerpc/crypto/Makefile                  |   2 +
 arch/powerpc/crypto/curve25519-ppc64le-core.c | 299 ++++++++
 arch/powerpc/crypto/curve25519-ppc64le_asm.S  | 648 ++++++++++++++++++
 4 files changed, 960 insertions(+)
 create mode 100644 arch/powerpc/crypto/curve25519-ppc64le-core.c
 create mode 100644 arch/powerpc/crypto/curve25519-ppc64le_asm.S

-- 
2.31.1

