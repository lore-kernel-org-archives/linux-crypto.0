Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF77E44237B;
	Mon, 17 Aug 2026 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976222; cv=none; b=q4IBguL7AwR1Wben4QPUZTMEYiy9NGVcUtq1GRnj9CzH6FvmBcwHnNt8ebS+C/iE8ZndtLgs2jZP6R7EdKy7kmqmuSY25nw+zwM+yyAuJHUhfynt4tSS6Rh8GIJuvZectd2m6AK3RDLKSLt5eLqB+ua9wS0Qvno2SJBYmWdsgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976222; c=relaxed/simple;
	bh=IvMxtNvRQiWiHB5awk0/6pSrhzdv5xbKiML/o42hBC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alFJPJPOgs4o8FUfDwLKl0zFGaB7WIvsEnQ4g4Rfqq/nZBnLLgOyWZI7yo/djwtZ+fjJLxfPe0SQhYpjgyo55e/e7kPYn0K32soMO3HnQ1YJmQEhZ91WjoFIuef2CEuO5vxqC3l+p/2bnzazJGrquBO+GZ3IUk11jhSw3SYAEKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BytNLnOq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BytNLnOq"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCWADQ1442520;
	Mon, 17 Aug 2026 14:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ddgg+3yCFszUcRfJ8
	Bi6XqkBSFMXIaZYhbilrgZelAU=; b=BytNLnOqsKP7Gp3Kx2aQgBqPxnvW2KoXx
	kHWAuhHkx7o8fxQQnkVkje3c3lazE2I/m8576VeDHoAVLlz4hXgt03gXh9od7ZuA
	Uffe2rtIRyvMhCpIyqba97MQ8Ei/c0jESEZ7dv+SbyQe5m1maLwcCNc12XuPeH14
	wgD94opLYOkdQW9RUzNooFnTEEVMA7sI3CpZOh93wFPUlxAZr+/BuRtQKb4ezUVB
	PZ3L0h2bNhLNCQDdKs57ObBag42UI1dk8lECg3yQ4JNcf4IZMYUoic0i4y1KC29K
	kUeZf99fLef/45xPMx3GvZEHSYqs5+ejMfygHoglSohigHJD05xhQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2frt29g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:59 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEBPZw032241;
	Mon, 17 Aug 2026 14:16:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354y6367-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HEGtq851184046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 14:16:55 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 191732004B;
	Mon, 17 Aug 2026 14:16:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB61E20040;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 14:16:54 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 3/6] s390/crypto: Fix use of mutex in atomic context in PAES
Date: Mon, 17 Aug 2026 16:16:51 +0200
Message-ID: <20260817141654.77940-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817141654.77940-1-freude@linux.ibm.com>
References: <20260817141654.77940-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OfaoyBTY c=1 sm=1 tr=0 ts=6a8317db cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=FX_TaYed26Q6Wz4qpTAA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfX2Y1ukoaKYrbH
 U5tC+MqsfvcEbUe9K3SLUpyvQ/qt8CHL1d107iTYclH/LJT6wxrMaJwsW13XxkGjG6BImgNsUcY
 18IZuumxkvLEBp9HREBxMm9vVIZ7WlU=
X-Proofpoint-GUID: gxBSmJDf9O3mOIu2oXC4km-bqszT_LFj
X-Proofpoint-ORIG-GUID: gxBSmJDf9O3mOIu2oXC4km-bqszT_LFj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfXzGCLZW1vH0vT
 V/+Z+Kzk56We8Dt/byIBxY9MEXeuEVmP6vP8IG+DIIoL6KkdHv+U70dYcCLC0y+8tyUdaivT6Wf
 kZuutGTKDAVZR0IVc/NFNhpsR/9PRGO8i88Jx9XBjaUE0VEi6xSv9nuRFiqPBHUt4lUfeT1/iUC
 z5K0PjwJlv1Y+KsO0loD/+wcKIUfr/F2lAU1b6uFdI5AnA6qtOPZlhqmjVjcjvHkiVu/scOpMu4
 E3V1Tld5ziUu3qf5uW1xJi+8TBaNm8DxTITFBhf4NPD2yR9lyImUA6YxbfT2nXro+mmv3TPj9L3
 slWOtCUJ1dgF6jrRhGkAZTI6/1vb9VGdljiEezhI/2cP4aVPZBvBV1vfd6Gf4Vlf+3cS0vQtUoH
 JMhU5tunQstgHtypgzqQgz8CT61p7Q0/wAQ0nbD35csVPiExSy0RTgrWSkXaIqN7LtkLd92t1PM
 tiVujWJoZk0pSRrB4uA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170107

The PAES CTR implementation used a mutex to lock one page of exclusive
memory for fast CTR processing. Unfortunately a mutex is not save to
use in atomic or interrupt context. So use a binary semaphore instead
which is save to use in such environments.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index d075b0241f1f..e8bbfc376ebb 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -19,7 +19,7 @@
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
+#include <linux/semaphore.h>
 #include <linux/spinlock.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
@@ -45,7 +45,7 @@ module_param_named(clrkey, pkey_clrkey_allowed, bool, 0444);
 MODULE_PARM_DESC(clrkey, "Allow clear key material (default N)");
 
 static u8 *ctrblk;
-static DEFINE_MUTEX(ctrblk_lock);
+static DEFINE_SEMAPHORE(ctrblk_sem, 1);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions;
 
@@ -945,7 +945,8 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 	struct skcipher_walk *walk = &req_ctx->walk;
 	u8 buf[AES_BLOCK_SIZE], *ctrptr;
 	unsigned int nbytes, n, k;
-	int pk_state, locked, rc = 0;
+	int pk_state, rc = 0;
+	bool locked;
 
 	if (!req_ctx->param_init_done) {
 		/* fetch and check protected key state */
@@ -971,7 +972,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 	if (rc)
 		goto out;
 
-	locked = mutex_trylock(&ctrblk_lock);
+	locked = down_trylock(&ctrblk_sem) == 0;
 
 	/*
 	 * Note that in case of partial processing or failure the walk
@@ -993,21 +994,21 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 			rc = skcipher_walk_done(walk, nbytes - k);
 			if (rc) {
 				if (locked)
-					mutex_unlock(&ctrblk_lock);
+					up(&ctrblk_sem);
 				goto out;
 			}
 		}
 		if (k < n) {
 			if (!maysleep) {
 				if (locked)
-					mutex_unlock(&ctrblk_lock);
+					up(&ctrblk_sem);
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
 			rc = paes_convert_key(ctx, tested);
 			if (rc) {
 				if (locked)
-					mutex_unlock(&ctrblk_lock);
+					up(&ctrblk_sem);
 				goto out;
 			}
 			spin_lock_bh(&ctx->pk_lock);
@@ -1016,7 +1017,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 		}
 	}
 	if (locked)
-		mutex_unlock(&ctrblk_lock);
+		up(&ctrblk_sem);
 
 	/* final block may be < AES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {
-- 
2.43.0

