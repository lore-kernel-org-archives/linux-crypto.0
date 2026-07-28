Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C0B46A609;
	Tue, 28 Jul 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251071; cv=none; b=A1C9s2W4zGm07LPb8k1Fct8nKYQwTS62XO+b1x5mXLf5fWt2X/GQpxynEwNWD4ToRpaLevSEQ/4iAxkE3QiXkptNyUW9gl2VEd268OAEaq25LBACq7vclrDe+b1mP6+YnoC87H1VikOEaZKo28A/3EnuCzcJgPUfIHb46PIqSSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251071; c=relaxed/simple;
	bh=IuoUSsJVXEqSPaPBT4iT4cy5UT0u7RqpsWLCXn84F2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5wBJ4r5YSdEkQsNC1Zbxd0wa2FHhVo8A1CuTyDUbswdV7aRAtrx2eKY1sxCpU/TjJNYMsKHQbrKs1joPC80trCsTxVlX0bVFs6INsoa4FNTWal+Gg/DiNrk1PrQhAtcrbSbnkBVA0rqOeSBh0UqMZJAF5jCawydh+MM4uI66lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j/7LC8Lm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j/7LC8Lm"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SElkWf1500888;
	Tue, 28 Jul 2026 15:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zjh1OwSOvEOr2jJC8
	cWs2GZDtSyYCsPz5Am4m3RwWtk=; b=j/7LC8LmntWWsonD0NSsToogtmoEzWh8q
	Hcq3uBPJ7GnOPNeKjLSxOByqTvES3h5ZkTsNWxKA08+H2rKxKg2xMUgBTMqRFAGJ
	iG6d9blh+rgZLhoKsRBGsEwYrfBq32AFV/J3umxe0DSKtobPnyTnKWAhyZNnxrHu
	/07PELwaLbDDrBtl2vaZVJOB5HbQ1KReFUCO4pTvJPh/tmq1JR/q9qSKcOKfwNfe
	tDcOPvQcjUuVzCmhQDxIM4lwhOCUAy35iC2x3pemmUGS/Om+2BTWVuyaiD4gsuSu
	K6K8BLy0y7mTQbt5fx5xzFtSlcDYCUjcAzm3t+lXZqZErGeC0n6mg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwcwamb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SEuEs5011145;
	Tue, 28 Jul 2026 15:04:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y2473-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SF4Dsn35848698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 15:04:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1908E20040;
	Tue, 28 Jul 2026 15:04:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAD2D2004F;
	Tue, 28 Jul 2026 15:04:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 15:04:12 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Date: Tue, 28 Jul 2026 17:04:09 +0200
Message-ID: <20260728150412.3893933-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728150412.3893933-1-hca@linux.ibm.com>
References: <20260728150412.3893933-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jD3wUn-7nj6F1Hg9MPU347BLgMzBgaaH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfX+ZIh/ChZyQfp
 4Y8QqOXlx5DhCPSWRqEiU89YuRB04GPfpFdcDUJVWEha7DKuNKMByMduNPXXcp6DwCswWyg5JzK
 8kN5K4Byun2wv/XOCNXy743oh8VPqLQ=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a68c4f1 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=OZtxAwA-5Z5iMo5a8dwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfX9kDlX9JEOUIv
 EJgkVUkRGzX/HIAwILrgG1KmzY89OJ/0FH1mOkqeuZIc+SoskuA/d7RZ4m4MWedQ0vtmX4TnPXd
 3U0yrjdM/lwGx0RtKK4d4hzaUmnmGYoARgIz6l4v3/2xpNYDy9nv4LsOgoweZU5kmUM2k1QuvnP
 6ap3mej5ZOSjbcmPOq6FdY47LMEVPb+v8g1Rdv+kEDVCt2ZRo7z1NLHdygrypv9oFGuSND/iYre
 qRilqiq0C5dA0W7RKfCcVh2na/xTUMsHIvTx6BPP8o58UY9aOH7BxCtPnsSBeL919h97Jlqh+bc
 yTWEcuRndOaH0coSHBtvdWzBS40KUwBh0zWzgjJvNsOnscznkog4202AepKX3W3+zYFsCp2Q+Ql
 3G5LgePAzS8FYG7AfhmQ68RtEq9TXwAyB1EOiCKMAVrL7tugA6XSxXAIpfX4S0/MsoifjveLPU4
 wT2aKYHyGGRqA3dWRyQ==
X-Proofpoint-GUID: jD3wUn-7nj6F1Hg9MPU347BLgMzBgaaH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280132

With [1] cond_resched() is always compiled away and becomes a no-op.

The comments for all cond_resched() calls in crypto code however indicate
that the current process should be scheduled away to avoid instant
re-invocation of a callback. This is not what cond_resched() would do or
did.

Instead of just removing the cond_resched() calls, replace them with
msleep() calls, as suggested by Holger Dengler. This forces the current
task to be scheduled away (sleeps) like originally intended.

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/crypto/paes_s390.c  | 8 ++++----
 arch/s390/crypto/phmac_s390.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 8cfe6166c193..511cb6105436 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -555,7 +555,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		 * To avoid immediately re-invocation of this callback,
 		 * tell the scheduler to voluntarily give up the CPU here.
 		 */
-		cond_resched();
+		msleep(1);
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
 	} else if (rc) {
@@ -821,7 +821,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		 * To avoid immediately re-invocation of this callback,
 		 * tell the scheduler to voluntarily give up the CPU here.
 		 */
-		cond_resched();
+		msleep(1);
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
 	} else if (rc) {
@@ -1129,7 +1129,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		 * To avoid immediately re-invocation of this callback,
 		 * tell the scheduler to voluntarily give up the CPU here.
 		 */
-		cond_resched();
+		msleep(1);
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
 	} else if (rc) {
@@ -1572,7 +1572,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 		 * To avoid immediately re-invocation of this callback,
 		 * tell the scheduler to voluntarily give up the CPU here.
 		 */
-		cond_resched();
+		msleep(1);
 		pr_debug("rescheduling request\n");
 		return -ENOSPC;
 	} else if (rc) {
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 03ca33ffe6cc..da76c7beb184 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -895,7 +895,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 			 * tell scheduler to voluntarily give up the CPU here.
 			 */
 			pr_debug("rescheduling request\n");
-			cond_resched();
+			msleep(1);
 			return -ENOSPC;
 		} else if (rc) {
 			hwh_advance(hwh, rc);
@@ -916,7 +916,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 			 * tell scheduler to voluntarily give up the CPU here.
 			 */
 			pr_debug("rescheduling request\n");
-			cond_resched();
+			msleep(1);
 			return -ENOSPC;
 		}
 		break;
-- 
2.53.0

