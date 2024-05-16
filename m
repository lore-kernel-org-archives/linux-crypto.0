Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE714D44F;
	Thu, 16 May 2024 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715872823; cv=none; b=YRdyZ9J4kA9UWJT4fZZ6hidc+XA3M588t72t73krg5ndMhD1Dio13fXkoOt3UL722bheGlLJAOkU+uz4s8yQR38Peq30h7hiWCUfM465ADeDqWAZz1AnVDqLngIp8eOqBFpxib2MB2OZg0ZsOp8JwnyeIfbvlS7cnoW7LpIMIV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715872823; c=relaxed/simple;
	bh=4m1KVQIU2GD3e2+fUgsK8uxs5V4ePORcZ55mdW/W1NA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TCaCh8fMJiJ9viofrWV+aeulELt1fYzZOWv0kXUZLxYKORWCkRooHMrs7BuwCjo7+gc8JfdNMnEvf6j2M/ClzOaEZBeBzuRbkQ62NK92CiagfUkRe0dwyUd4VCTkfZbKNQxzyoumZDT31SPlfJLTCF1Kk/RZHvwt5poQlBvNKgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SglBm+Fs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SglBm+Fs"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44GFCp4W008123;
	Thu, 16 May 2024 15:20:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=o2TFFO81KQaYy3GGMBx/MYUX0l65rhr9cCLVcbK1Q6k=;
 b=SglBm+Fsa7VhZUWmQRys/kDhlmjPrrlK2xK7D1dW41LSs6v3TMj2Bb+WrjGwAvnriMEy
 221czXRSTWkZ2EpL1cMD9Aa/xDkr74S46fMlG+X30emJYRKzTZZuV2wXlgu39kRvkojx
 zpFxlbr9vI++Eirp5QC1sGe4/7prJU7wCHYqDKthVfElNMH52UQGxnnb0iIHJRoeRUZ6
 5eL65Py/ZryzS2zmdMWld/MHH2B5nCKQ3nD+t7BU2pHjsmw110wK3qRwHbyZvHZ4uca4
 Jnavko+tfCD1IE1a5K/voNSlNK7xjXDXE1kGDkOsoxwuCv4JTdBCO64wY+LraF6tRUR9 FQ== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y5mjyg0ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 15:20:04 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44GEBDs8002252;
	Thu, 16 May 2024 15:20:03 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y2m0pjmma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 15:20:03 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44GFJxdC27918916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 May 2024 15:20:02 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D66B258066;
	Thu, 16 May 2024 15:19:59 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9171958061;
	Thu, 16 May 2024 15:19:59 +0000 (GMT)
Received: from ltcden12-lp3.aus.stglabs.ibm.com (unknown [9.40.195.53])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 May 2024 15:19:59 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        appro@cryptogams.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com,
        Danny Tsen <dtsen@linux.ibm.com>
Subject: [PATCH v2 0/3] crypto: X25519 supports for ppc64le
Date: Thu, 16 May 2024 11:19:54 -0400
Message-Id: <20240516151957.2215-1-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tGFtNT6gXTXPJyF15RFvet5MNLCPAK9r
X-Proofpoint-GUID: tGFtNT6gXTXPJyF15RFvet5MNLCPAK9r
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=796
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405160108

This patch series provide X25519 support for ppc64le with a new module
curve25519-ppc64le.

The implementation is based on CRYPTOGAMs perl output from x25519-ppc64.pl.
(see https://github.com/dot-asm/cryptogams/)
Modified and added 4 supporting functions.

This patch has passed the selftest by running modprobe
curve25519-ppc64le.

Danny Tsen (3):
  X25519 low-level primitives for ppc64le.
  X25519 core functions for ppc64le
  Update Kconfig and Makefile for ppc64le x25519.

 arch/powerpc/crypto/Kconfig                   |  11 +
 arch/powerpc/crypto/Makefile                  |   2 +
 arch/powerpc/crypto/curve25519-ppc64le-core.c | 299 ++++++++
 arch/powerpc/crypto/curve25519-ppc64le_asm.S  | 671 ++++++++++++++++++
 4 files changed, 983 insertions(+)
 create mode 100644 arch/powerpc/crypto/curve25519-ppc64le-core.c
 create mode 100644 arch/powerpc/crypto/curve25519-ppc64le_asm.S

-- 
2.31.1

