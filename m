Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B643F5BC0;
	Mon, 17 Aug 2026 10:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963330; cv=none; b=KJbqNDdOwByS/WXcCGmrPvvTnL4qH9wy4VZyqYUuC66/O4Sc/8YeM0KjFxZ87pQGpXy8mpIXynR1LBJaCJWJlFR9Zc44DBxjL92JM+25hKUkRCReTOB7OxwFHZEFk3BgleYjRAxmFzvLQ2d0ECMUjy1cHJzoDj+IwGleimbXGwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963330; c=relaxed/simple;
	bh=IvMxtNvRQiWiHB5awk0/6pSrhzdv5xbKiML/o42hBC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3AAw9J/boRDNvbGnuKHbdH6uM6dnsL6OEp7/nOYmKwBS8mUARl4xrAdBE/ShlCmZwqCmrbChW8AGQ/EiSbc/b1n2C6LgKsWRSEbOhiPJm66Di3JfjOsYORCSdmY7RMafhcrOPXYTWz+P+A7qrx3P/RAcnwNzr9tEu4H2vkK+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GbrNaz21; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GbrNaz21"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLW4Lx3685545;
	Mon, 17 Aug 2026 10:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ddgg+3yCFszUcRfJ8
	Bi6XqkBSFMXIaZYhbilrgZelAU=; b=GbrNaz21cGcWoHSArBZR7aSz1JAiXU4lm
	lFkHBueCXOAiOciIA1Tjucd81PAvHqv2qkz2hDDHyLWor0sAJaGONwyfJRZ7QbiS
	eE+xxCwnHRmgaOezAwQZluX3KVAYh51LvuYp6kCFtW9xW3yiOqzi4r/oc4t0aNRC
	pSRQ9QPVqO0lFZFOi59FvFmQ+VM2gZGTvznlWDyrhmK0kV6KveyaHAY75VPUo3WF
	ElX8o3f7DdW+zZqIyEUloGl+uzcKTAVvS8aD8gjrZs5BRuOwfn2sv8V+4ubAGwkq
	g1MsKweSAwxoiIBOdmzNthP1NieFEWox/I/GZrODaxO53GTEn9Mjg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fm3ht37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:08 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HAfR2U013497;
	Mon, 17 Aug 2026 10:42:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354y5d77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 10:42:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HAg4qT31392206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 10:42:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04CF020040;
	Mon, 17 Aug 2026 10:42:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D26A22004E;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 10:42:03 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 3/6] s390/crypto: Fix use of mutex in atomic context in PAES
Date: Mon, 17 Aug 2026 12:42:00 +0200
Message-ID: <20260817104203.74033-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817104203.74033-1-freude@linux.ibm.com>
References: <20260817104203.74033-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OGo2X00WLqZjvfjjee5PaauSR0tqepS9
X-Proofpoint-ORIG-GUID: OGo2X00WLqZjvfjjee5PaauSR0tqepS9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX5QsqQSSj6Ql7
 q+49d9K/PsrIjMv1uekf4Ja2yTptQ0RMZDTRq7njMqdg3eQbP0ahB2uhWrxVrq2//g5pxKqLNuy
 NY24je1br4QlCPIrdtf/WvS1V1BKDb0=
X-Authority-Analysis: v=2.4 cv=WtQb99fv c=1 sm=1 tr=0 ts=6a82e580 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=FX_TaYed26Q6Wz4qpTAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA3OCBTYWx0ZWRfX9wUw9rlKbME7
 BPuikxRMLflcYudqmD7yTlCQspuuRaHTSxsoUSTtzIrwRs7f7RTTeVuUCCT5fJ8wU+kcGe1pPkD
 T48Nel5a16ZsgCFSMoj4V+J/fNJ0GnGs8dmVyeCYFLQe0MMAbzgqjiYNBzR4KkNHZTbreqHKGNz
 /jg4RVpLIKmCixWFopes+zwXPeWPTYjkPO9zCqGdBB1EYjy1asFTqvsVg5LhR/6EM/KmendWdSU
 +0uqnO1jDqMGyF7qouDVAX5L2mr/iA7Kn/7BymyA0d7l6xIAzYZF07C1wldhNIktgjBGExAyfyg
 wHBvju+Jmm2c703JOnx/kvbJHwYnou1E3h0F79cqmWmZGFW2D1XADyPoJf8tM00DA0WxQD7m/gH
 EPxBqXlZ7wG6Qp0SmNtiOsOjwVSjWyPHh+POF52MMGG+tFBYiYDtkOFcOhNhetg+NrvwD69WqlZ
 cnwtSCVtz4f4r3I5+RQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170078

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

