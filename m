Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89C73C10B5;
	Mon, 31 Aug 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165538; cv=none; b=sWtdnV1iCHZDcvYaUiZGe+gWFurQ/KCfdm4xdi8sJ1GyfB6j1ILh4riDo3djzHx3Mq0cJnW21CZ7JGXZ8oZnluCTomM0lMMXkfrtR1bZlz3DLCoK6knqYhVtJ39L087/wa7zbpm4y6Dl3Wj0Wq/1yHGiocs2kIHkqEYO7w5jXVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165538; c=relaxed/simple;
	bh=ejzB1iKMIn4u9bg7Cq13/HRXh+7B+Fi6D9F5qX/CXpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCuq1whY7fZ79nkGAr1tpF4TYpQsjqIIYhB6+zXRbMc2tOV3+n7YMKvFk2Js6TygPyhhQk8rt7nGWEmlGcygGWHWBY9hYbFOX3zDYZBoYZgskTcSBaRFyT8WwIs8Ecdcn3d0B1EW09ipIaszV+p85lr1LzUi2TMFJUkHpzgntWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e109AmRO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e109AmRO"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82PHk1640269;
	Mon, 31 Aug 2026 08:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Tj0u80JoJJMYZZcGH
	iCpophjZNtpmxztHG40MT/itcE=; b=e109AmROKBCTRXmZRKt+2dF94x7XhfcQy
	Wj1GscilsoFvMtepEy8mBJ78fWdhHtoxGi3VG8gPYh1GsMGPpcPXCm9XjD77OyqT
	AL4oE7FQwSu+ZxbGkhqmpgG6NXiayhjISOSsX6e2bUuPfbFUcDWN/t3Fgu8KF9C1
	0Gyca7D0l3vZ9YFHX0+ExOFT2UlmxGl4AuSkncbEmCYq/IiOajMU71DH2PtgXRoZ
	cZO25YS63q3C//AuvRlW7FY3K09XxEsKe7Gn1RkDi1MqebFkYwH+IUw71vG7rHNJ
	61Ewc9zr695B2ueOXB/ccedqrLEkrF+q5PgFRnPLe+mYBs/KzbgXA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq54g3qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QTb4004749;
	Mon, 31 Aug 2026 08:38:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gccexvn64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8ceIA45220096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0539420040;
	Mon, 31 Aug 2026 08:38:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA9BC2004E;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:38:39 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 9/9] s390/crypto: Enable CONTEXT_ANALYSIS
Date: Mon, 31 Aug 2026 10:38:38 +0200
Message-ID: <20260831083838.3703-10-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831083838.3703-1-freude@linux.ibm.com>
References: <20260831083838.3703-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX7xLitmiz2/zg
 KsjGMJH13LJrmYQZyDh9rQThmruJJW/EkyEJ+OzKY48PqZoCOCl9Trpkb/uNvW7vCOwNlxJWvnJ
 RrXOoLgAz9PD0IIEhFZ9cCr6BGpWFyo9naRkPXPgoFBGytDTm8tKwbqE1P17bo/1li3A0LUgXc1
 OW21OKGFt2bGsOVk0KxZPeO9QMv0uJFOnO4ljOGrLFD0ojVRmZfNKmUVKhapl6dUavABRx2Xlqp
 rLAPi5Pks+8EcTVaOv8HCc0FCRW4LOw51J/Di1RRoIyXjRESGoZyUGjQ+pSrOSClRpK/BIzOCQh
 onw2KjFVNaGsI/22M3rB2yyZKLmf0Vp2oYQJ4w2b+95CY4IAr5nNPBHghwHRPt+5Fv6YeYkVM4G
 jACuw+M2Em4sOKJBWom2y2zMFXVShSe5HjJz+HbIj301Gge/68Rh++a2RQo1kXnhc76e9nPwo6X
 QeaiRjoNtZYf7y2TCuQ==
X-Proofpoint-ORIG-GUID: puLKfp-tFau4yTqLVWWaIR_gmEwxSyZf
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a953d94 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=76iW4yKgqpReaEcOz0EA:9
X-Proofpoint-GUID: puLKfp-tFau4yTqLVWWaIR_gmEwxSyZf
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfXzuv6dEzg+QRp
 MD7fggG3rvb79qvn+iHd7Imx2jHSrluCR3bHbe8h6lRWVEFoy6laV2TokTr4z0kiD0Zv6Zn8dno
 vPq0P61hYLZR68jJLhp9CC/qMnJuNlI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310072

From: Heiko Carstens <hca@linux.ibm.com>

Enable CONTEXT_ANALYSIS since s390's crypto code compiles now without
warnings.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/crypto/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/crypto/Makefile b/arch/s390/crypto/Makefile
index 48aeb0c0ffbd..1d6420813935 100644
--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -3,6 +3,8 @@
 # Cryptographic API
 #
 
+CONTEXT_ANALYSIS := y
+
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_CRYPTO_PAES_S390) += paes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
-- 
2.43.0

