Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2039D6F2;
	Thu, 30 Jul 2026 05:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389363; cv=none; b=FIwmphb+BMtOl/i87tqKR0vYx4dP72LG+IYKsbYXmyM85BjfkCtZpnegEjx3tcLtHBZCh/uJe5bSSDsdINuhePWDpFF5t9/zQROlnZvHM7wRHhs8W72LvwuhWiKGG7Uoq3Ukhk9lIn320VuCpCUsL88489mY9lJ19nOhwTdTx9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389363; c=relaxed/simple;
	bh=IuoUSsJVXEqSPaPBT4iT4cy5UT0u7RqpsWLCXn84F2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLYWqe/2+LJMGZRNsIrBDH92zAM6HL43RtVlM2td0tn0OYN8lfz1nH9It0tN6FjHOJatEbZfesXmyQ3zSHUyH37YzcIo9avdFr80cWaiMqi4WXlhuUtkPGjVWofyMJxPwBtBvvTjYoohztwSr87O9RqO+qC4aPqhH/7j5JdLzu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=slITOhSj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="slITOhSj"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U3mOmA1902762;
	Thu, 30 Jul 2026 05:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zjh1OwSOvEOr2jJC8
	cWs2GZDtSyYCsPz5Am4m3RwWtk=; b=slITOhSjVwXHjLutJhruQKN9obGt15RLu
	gr/v3UTn0NELcgIfksAjr7+w6aAeh7pFfK2Kd74VwD8b03AK/1WOrBIvgVVdDU/+
	IsoOm+95yNYVpBeG+Pe/oDD4+LkU9m1oQVIYAnjeq1wZAXfXYd9SEsn8x+E8X0qa
	31wtGqCrjXBvlxpIMsDuj8pLjM/1nWt3k5oj2ir0YytF1u7k6IUKHuAF5X3zuEqA
	2SbiCRCeKmiwkHLd8V0mpBewWQegnacevBC/RxIEdXX1SDN9RbTET3pkP4m8BiK3
	q3AdSbofS2ESmvOjlhjhK226Gla4VUXxnnS/N8VXQ638zmDIDbx5w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7p56d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U5QFGb010505;
	Thu, 30 Jul 2026 05:29:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fqj32t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U5T8Fp26280206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 05:29:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BDF420040;
	Thu, 30 Jul 2026 05:29:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF9BD2004B;
	Thu, 30 Jul 2026 05:29:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 05:29:07 +0000 (GMT)
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
Subject: [PATCH v3 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Date: Thu, 30 Jul 2026 07:29:04 +0200
Message-ID: <20260730052907.2607026-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730052907.2607026-1-hca@linux.ibm.com>
References: <20260730052907.2607026-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TWbh65qGMuKVorflwqDKgA2LhMfqKmBO
X-Proofpoint-ORIG-GUID: TWbh65qGMuKVorflwqDKgA2LhMfqKmBO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfXxXwI+IvimFVb
 ELpn2nnodGmeHwxT9mcxFIrwU0yziZV6m0j/g2Bn60b12yo/7GHMPOwSgnqstsbmL8FbxjyFSoa
 As/HPEFlx/4Jj3npymoTAZiSL/JOi7qdP3g+M3qDlJe1fqc6JEOfWgkdXo52RpYktdwvKus6qjM
 hgR9+ZKp0wkLaglQeNlar2wftzTcm8ZOkCAilaO0rXjf9MvMjyjQSxtXYh51KjuHnpvZXb9Ils+
 l1YrBMhPs0R0NE7mXmYyyER9jVdp+2+aZPiJEYNbe+exOlTPDiyjBNEjdFdcnrvXn430Dt0UGdm
 3qxXxjnXlH5Q9tW5OPPkwDh9exDdL3unVOYrnOR9QSm4mCWDPHniY+oQGHq4LOhYpx8Z2hERALL
 1vlvUa77CeptmeK7GXOaadIhCqniuh/9ICqSWoql1v6+0cHpcRpkwoH6ptzDNJoSAd2mIRR/aH1
 4jGcI11/bWae1Jb2IPw==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a6ae128 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=OZtxAwA-5Z5iMo5a8dwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfX1tQd4JvHluCA
 ecN8GJLVoWsE7YOA++oZ0Xl1PuGnuiOIyg87gRxXZdsz9RYzs6r7RkaUDz1ksUrm8T0sqsyNsKC
 vS5j+iO6nWqUXt/1Da6gsn2vAJY2ACU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300033

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

