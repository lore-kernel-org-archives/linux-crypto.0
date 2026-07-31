Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314630C371;
	Fri, 31 Jul 2026 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516622; cv=none; b=UxHs9Jrw6E913z5SIU6giTCNcX8W27dUH4fAew1bRpKIch95HtaPR4M2SKJzYi9KUCxUIW0t2B3nU1qQXF0wu2DWJ+vnwvkLChkZx+Zj0+OCtjP5axk+S7Zx4z6EXsuwfwns4Hj9nQTENrKDyfitlSBEBMjwsIBP7AZ064slOiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516622; c=relaxed/simple;
	bh=pQrbf13ZZw6TEaBMQCVXPSLhWi2PYKh0c4e2CT2olnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlGBbSBPaTlSeHkrYW6d4e3PoIFb9q9M0FK+umoSex4/hwPZ/JZLZPFw8AugjxdIQSOc7+IAcEC/sSy8HU/xZlVdnSbxsmjpwlO8NsWqZV8CYaNtkBwF+jk13S2NPbJE3gT8n3dnc2fFFn12a6xwaNSPOZ1na5pQE78OQmc8g9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kAv/rndi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kAv/rndi"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFlY51402318;
	Fri, 31 Jul 2026 16:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+2RVMc2ni8gyNc+aC
	VLiIlr1CE9R4CzWE12uCn+7OLE=; b=kAv/rndi2+e2waUIiwtcxKEp5s/YdTJ51
	2UtXqFtdWPnFnE0lp9SKNcPfSCDcQC0Z3mZH9Y9rfqx+FTuseXg5a89phoeQa5EX
	C6hsHBUGrks2t04MThseKPaRDEAPE++4ng4Ps79/GnuRS0oo00SznCUGfAvEHB57
	ex0WC816CSziGKh7Y5EuoIv7L1WfZIvnlMSq2SJbl59023Ht/4b6PMOt1DD1HHGj
	pCKSyNvTcyeGf100nStSX7r4fQCovL3En3vTMu/ALSofPcvV5xUDOWiPRcFs9z8Y
	chZXHjWT+wF/ySE4QlJaehoNrtg0BodnvmjMHNDATB7DhCkFygeGA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuycx1bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VGfKLY029047;
	Fri, 31 Jul 2026 16:50:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fqrw5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VGo5TB41419242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 16:50:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47CE020040;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EEAC20043;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
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
Subject: [PATCH v4 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Date: Fri, 31 Jul 2026 18:50:01 +0200
Message-ID: <20260731165004.2758105-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731165004.2758105-1-hca@linux.ibm.com>
References: <20260731165004.2758105-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jJSHv5Om7-RWBjcc_jjkUv5Boksr6wBT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX7HPxPsnHjbKv
 GC5dje0NPg+iC2FzkJQm2GkUwntPgsf1NYSQRrrpmn0550YqSfNVYXSF+yr3PREk5TcJf+QBftq
 vnSNSYYI9QNx560ePKIFHv44B1Qk/ZvdFvfJKdcY7X/s3J0Dta2vtROs59VnZZ7sJ7vf9/KHGeU
 57eRFFNh+zNHc+3PbEywStWtKJ7sMlFE/ALIv1sTvweVg6sQgHEah4FOmENzt6B4lWHLTdwHvPs
 PYUcipnL8BKqdZbiZ8yARSqAh+bbT0fcJeQRdOLaRvanY5L2ziAO59yDwLvSOS2eDCVkIWpcuJO
 AYLPzATCRK3CrPWhvUdfowv/fIYH7vn0fGQIXtSPJRW1k7Fbt2FJnabkgsWV9llhczWDLqFhSx/
 mhBz2Ds2pkDnX3/6o35razWB1JyAD8s4iMEEx7vy6OtxDhMSuMcOZYL7vFXgJ57E+3ojYiZboIL
 47DbDjkMaAftxmN0xxg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX9K8oadAix1J+
 4RSfMttErCK7nWL9nNBxzVSuto3cBM2hyGudwiSTw/Uqw9sa9I1ne1kdS+CwJ8RpN7KcGtqV/QV
 G+z2hChgPU49FGTlBXETwHSB15LRX2M=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a6cd242 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=WsHKUha7AAAA:8
 a=JfrnYn6hAAAA:8 a=DKx5s9VkpjxxvdiG65UA:9 a=H4LAKuo8djmI0KOkngUh:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: jJSHv5Om7-RWBjcc_jjkUv5Boksr6wBT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310128

From: Peter Zijlstra <peterz@infradead.org>

With [1] cond_resched() is always compiled away and becomes a no-op.

The comments for all cond_resched() calls in crypto code however indicate
that the current process should be scheduled away to avoid instant
re-invocation of a callback. This is not what cond_resched() would do or
did.

Instead of just removing the cond_resched() calls, replace them with
msleep() calls, as suggested by Holger Dengler. This forces the current
task to be scheduled away (sleeps) like originally intended.

Holger provided information why this intended [2]:
"
Let me give a bit of background here: The protected key can only get
invalid, if the Linux instance (z/VM or KVM guest) is moved to another
hypervisor on a different machine (aka life guest relocation). In such a
case, the crypto accelerator card and the host has to exchange the "real
key", which is wrapped by the host and handed back to the guest as the
re-newed protected key. Unfortunately there is no asynchronous trigger
on completion, you have to re-try (and maybe get another "in progress"
return).

And as if that weren't bad enough, if this key exchange between card and
host is the first one, card and host has to instantiate a secure
communication channel (including a key exchange for the transport layer).
"

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
[2] https://lore.kernel.org/all/39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com/
[3] https://lore.kernel.org/all/20260731084027.GE776954@noisy.programming.kicks-ass.net/

[hca@linux.ibm.com: took Peter's patch [3] and provided commit message]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/crypto/paes_s390.c  | 44 ++++-------------------------------
 arch/s390/crypto/phmac_s390.c | 25 +++-----------------
 arch/s390/include/asm/pkey.h  | 16 +++++++++++++
 3 files changed, 23 insertions(+), 62 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 8cfe6166c193..973436592318 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -548,16 +548,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = ecb_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -814,16 +805,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = cbc_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -1122,16 +1104,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = ctr_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -1565,16 +1538,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = xts_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 03ca33ffe6cc..020a1beb2e22 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -887,16 +887,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 	case OP_FINUP:
 		rc = phmac_kmac_update(req, true);
 		if (rc == -EKEYEXPIRED) {
-			/*
-			 * Protected key expired, conversion is in process.
-			 * Trigger a re-schedule of this request by returning
-			 * -ENOSPC ("hardware queue full") to the crypto engine.
-			 * To avoid immediately re-invocation of this callback,
-			 * tell scheduler to voluntarily give up the CPU here.
-			 */
-			pr_debug("rescheduling request\n");
-			cond_resched();
-			return -ENOSPC;
+			return pkey_handle_expired();
 		} else if (rc) {
 			hwh_advance(hwh, rc);
 			goto out;
@@ -907,18 +898,8 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 		fallthrough;
 	case OP_FINAL:
 		rc = phmac_kmac_final(req, true);
-		if (rc == -EKEYEXPIRED) {
-			/*
-			 * Protected key expired, conversion is in process.
-			 * Trigger a re-schedule of this request by returning
-			 * -ENOSPC ("hardware queue full") to the crypto engine.
-			 * To avoid immediately re-invocation of this callback,
-			 * tell scheduler to voluntarily give up the CPU here.
-			 */
-			pr_debug("rescheduling request\n");
-			cond_resched();
-			return -ENOSPC;
-		}
+		if (rc == -EKEYEXPIRED)
+			return pkey_handle_expired();
 		break;
 	default:
 		/* unknown/unsupported/unimplemented asynch op */
diff --git a/arch/s390/include/asm/pkey.h b/arch/s390/include/asm/pkey.h
index 0af5ac4f646b..82e403322e89 100644
--- a/arch/s390/include/asm/pkey.h
+++ b/arch/s390/include/asm/pkey.h
@@ -13,6 +13,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#include <linux/delay.h>
 #include <uapi/asm/pkey.h>
 
 /*
@@ -44,4 +45,19 @@ int pkey_key2protkey(const u8 *key, u32 keylen,
  */
 #define PKEY_XFLAG_NOCLEARKEY 0x0002
 
+static inline int pkey_handle_expired(void)
+{
+	/*
+	 * Protected key expired due to relocation to another host. The long
+	 * running re-wrap has no asynchronous completion notification, so
+	 * polling is required. Trigger a re-schedule of this request by
+	 * returning -ENOSPC ("hardware queue full") to the crypto engine.
+	 * To avoid immediately re-invocation of this callback,
+	 * tell the scheduler to voluntarily give up the CPU here.
+	 */
+	msleep(1);
+	pr_debug("rescheduling request\n");
+	return -ENOSPC;
+}
+
 #endif /* _KAPI_PKEY_H */
-- 
2.53.0

