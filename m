Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8E7288501;
	Thu, 22 May 2025 08:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904288; cv=none; b=MBLamP8dCvHfK6Ns9zSju1vSTR10xVJKfGZFDpo7YgzBOAJ3rHNlq2u2bRYm9TdNJ0dqkfmPtZeOCFExFsm21BWJWuiE52nGG2md1mw7D1siN4P1ZU3xn8ShwN/DYjYff/FllIeyUwO4haTHcsU5+5EjLjo24Vg6CGxfTuULmFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904288; c=relaxed/simple;
	bh=+Ic6rkU2Ep97Xl38JvfDDszjFzNam79Q/PY4DfhDXlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIns3TYC2Vp2708zKrlR4Ty8Zg9TB+jmB0heUjQT7kC42Zon57wjpP1pkJCizJSuAZDkM75uqR2KK2ZzYG1BgroEsQvhCOXNXTVq7nPsnmb3XcjMTRPHNnfdUqMOnmUXon08mNi/rnwWSoPsjFJ4FrwuGu8W8uo4GKCK+5AnHKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oEjemQVl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oEjemQVl"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M7w76l004675;
	Thu, 22 May 2025 08:58:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=y+4IJ7F5m2RvOWvFP
	bcMb3dABRS0x6eIBa2nMiu5kW0=; b=oEjemQVlFcaiJlCwsYyHs/A42TsAD6l4B
	Fj55qsNaU/FUveYBS/nFUstRvYyTU5PL3zUm7Va0sblwCtl9tOgvDfFF+IyiVYVA
	+sPGLVL6M4Ul926phxJwGdHXrizdc3DvjYZAmXH+7kJmTjnBMjQEGzbOMUJviEFj
	JZgbSyNugerUbnxe/cDWogcmT5f19IB03/yfupB49xbs44MwVpMrQjCg1p2tKgPK
	gs9KFb0ZzfBhCofBh7xcyTP1Jywr/478NVoVDve1QW/147roUs2uZeIuKrXGJZWf
	Fodloc8OvBILL6AbcQNmXLcRsInnNswzcRH2BxZ4FVdb2wOJ0jh1g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh7340d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5atsJ032070;
	Thu, 22 May 2025 08:58:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmgn8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:57:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M8vujJ16974292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:57:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67D2220040;
	Thu, 22 May 2025 08:57:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CCE32004E;
	Thu, 22 May 2025 08:57:56 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 08:57:56 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com
Subject: [PATCH v11 2/6] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Thu, 22 May 2025 10:57:51 +0200
Message-ID: <20250522085755.40732-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250522085755.40732-1-freude@linux.ibm.com>
References: <20250522085755.40732-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfXz77bzTmmfVkW zpn9GNTiiCPTMmTyi7xa/T6wDcteQZvpbXjMcETHHWaV1gPo+y9NqdG7QHwuLbVLpxkbUrL9j0T 95EwbHMstzXd2eKRDF8ZKN8SVouBywVNNGoLfGLGl/RbaTx4qdZtRFvrZXXVspZxNK9gaNeyoHm
 9VQ8mDWVIQPhfyH6MfRbR8/rCKW345gcgIrkXnwA1NWTJ1FQT65OvWVaIIo5uU26E8w+V4mDc2q d1cEkmGKQi5jSKNNkCFEXZooJL4/1NtnXcWTKQNF5SwmqWbAQKcKGnbe/abrMONGB/CUsomYTd3 VQ34V6qm3CD4ifBwPm3LPTcSrtN+gVkiTKi/7qYyCIeGXfez0mK2JjkSsEaZM3/adrR/d9i7af4
 +yzqpGb6As2MiELA91sIi9Jm5LTAAvbEVaR0RoLe4FvnTQdXzj52nhi9WK+EhHME/xE2IwXL
X-Proofpoint-GUID: wUlft5meDvizbdnPxUPtJzewUk5nfUAI
X-Proofpoint-ORIG-GUID: wUlft5meDvizbdnPxUPtJzewUk5nfUAI
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682ee718 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ZStr9B_HsUFEIA23VokA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=601
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220086

From: Holger Dengler <dengler@linux.ibm.com>

The CPACF KMAC instruction supports new subfunctions for
protected key hmac. Add defines for these 4 new subfuctions.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/include/asm/cpacf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 54cb97603ec0..4bc5317fbb12 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -129,6 +129,10 @@
 #define CPACF_KMAC_HMAC_SHA_256	0x71
 #define CPACF_KMAC_HMAC_SHA_384	0x72
 #define CPACF_KMAC_HMAC_SHA_512	0x73
+#define CPACF_KMAC_PHMAC_SHA_224	0x78
+#define CPACF_KMAC_PHMAC_SHA_256	0x79
+#define CPACF_KMAC_PHMAC_SHA_384	0x7a
+#define CPACF_KMAC_PHMAC_SHA_512	0x7b
 
 /*
  * Function codes for the PCKMO (PERFORM CRYPTOGRAPHIC KEY MANAGEMENT)
-- 
2.43.0

