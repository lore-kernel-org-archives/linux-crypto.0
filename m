Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48201344D9F;
	Tue,  4 Aug 2026 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785843471; cv=none; b=VyWm7FbODYLBCrma9oterre2uDXMcY/nhbqmx/tU0wAwRq0gbB5IJVWQ4IEQf5rgJmH2Q+cmidqNP8qKzmmdc2xrsCpGhVU8u6VO7YHEkJZyOFjPQ4KUX4962Pn5jSCdbWmazW/n8j4DN93yuL4NHcbLz8UChMhvLXcyLZQ6XDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785843471; c=relaxed/simple;
	bh=gi2r4nsxmmh0nrowARy+PUEpL5Fo4xMUyFf+f5gokXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8fzwmxFbvj4NtKIBWhDf8FehkCHjWYFQnwMc5E37mDf2GV8k/i5wVfKPIMlFIY+zbHUERZULvcj2M+X8OaTiJ7nuylZD36WyImAnmQBRx0+WN49+u+xC452FYW0JOg8r4ORd8XqFY3ymyEgI3lcpfYOkPnkVHYYNinlGe2x+RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dWb6oHBN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dWb6oHBN"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6748Hfb6296040;
	Tue, 4 Aug 2026 11:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wfCQq8/h/rC0+0774
	t2TT/GK+X+y6Bl3MPXnbQdPgXo=; b=dWb6oHBNc2cCht2yrq7SYNnzbi0wkinGR
	ZhXHUnQoUnLHzsHVNUoeW7fpObNIgteym29j6gdKGu/iHsc5onMGdyKGKbSmGfIa
	6t7iLjg9vwAHePezST96bCYDpm+QWRhiM43U5005u+CsVgVcxmJBOVyNey8AJbyR
	2buBhnR7bIQTkLopFy57A40q8IAijDl0NTOelAOTDnmCwtU9RyAU8CdehVZzJMhJ
	sf9CRok8t+4j28HYcftezZDpXYydsrUVX2CzMlmKycrTBSZsWqJGmNGyXgox7BAr
	29HGlKoEr7SEXllmOP0Lm+WREWHcu2gZYAruAv4IZlJ+l1fpWGNtw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a3wk0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:42 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 674BQLdh009806;
	Tue, 4 Aug 2026 11:37:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmh9nf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:37:41 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 674Bbbw832178510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Aug 2026 11:37:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 525C92004B;
	Tue,  4 Aug 2026 11:37:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1991E2004D;
	Tue,  4 Aug 2026 11:37:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Aug 2026 11:37:37 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 3/3] s390/crypto: Enable CONTEXT_ANALYSIS
Date: Tue,  4 Aug 2026 13:37:36 +0200
Message-ID: <20260804113736.1423667-4-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260804113736.1423667-1-hca@linux.ibm.com>
References: <20260804113736.1423667-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a71cf06 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=76iW4yKgqpReaEcOz0EA:9
X-Proofpoint-ORIG-GUID: CEXh9gejOJs7tCks9YNxT3GgOjrtbUaz
X-Proofpoint-GUID: CEXh9gejOJs7tCks9YNxT3GgOjrtbUaz
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX+st6aWNjfhCY
 c7trQwO1GOILmvDRGqZj8QOREI6tswiUptszMgUhoDrAy27QQhpertkVKarXvum6dHiGWz3WdpS
 idCyVP1v4fdLV+JvI97e/txDmBsbLPs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA5MCBTYWx0ZWRfX5TssDmmbAj6Z
 vuMX45eIHxMeYWR5PDJ3wAP6+GcDy+/XnUHWXKEj9F2GQw7zKGSHALDlRSZQW8cGWnDr8ZongKa
 5JHGotz9vYpnvkY1C2cKcGfDNUwWyz8HB7lEh/mszczER65qNOlNCghBvATwPp55F6+G40AfTo0
 j3/GO8m455ygSUd1TAiQKyMHMKGVH3qKcLn3TtxpkCvbrJgWe1gr28k2gmPYc5NFBmPEWHSF/nO
 HMVrvLCPeEXiw+nfpiAeIj4Vzn3zwc2jEv3L0iIyrXJc/80ZlFvUJtMmvv5ntOgm/jdi+9dJNDA
 FF2bzDefJHehmpG1RFPTSrjFaXvJzTP5ZdKPhXEGRwortNdV4KzO59z81MEQ98NuKphOIMWeP2K
 li+d68TTw19BI1McbrpNRj6tvg0ssFNzJGaBG7RVq17KYvRgoer0IHzZOVJQkod6k/49c7vdW7w
 MuXL/G/l/Q06NKuduvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_02,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040090

Enable CONTEXT_ANALYSIS since s390's crypto code compiles now without
warnings.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
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
2.53.0

