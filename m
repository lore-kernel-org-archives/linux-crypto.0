Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC4846C844;
	Fri, 14 Aug 2026 12:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786711054; cv=none; b=duUt4yKs94imsaPKreaKkQZWe7g3svgzKI2tKJ2bhR2pGHWwRgjrRQZKkNASYVKOilAc9ugA3mPgiC+32H1CkeVzubZQNX7OSk7pNh9VTI78uHRI5ZkbJg3sDMSVv41ufnwS9JL+uivkEWG7n3g0ZiehTgk9gGzbUUmpzwyQzjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786711054; c=relaxed/simple;
	bh=0cTf+JsB3P1MVoP5vqs5TrCvU92MfpGe82qzxAz32WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joFFaKh3RVP88MGkNfmFBkMZvDScUYQ/Dguw+3OUoLvaM50zaUST2q7C5ed9JUBCx6tyJZ5j880EA+NSHOYVehDoXqqwbSn0Ar3ivOBUeeT5FQHmhYZcS7uuAISc1QmV1/+4jA2+cgXi9y5ySpmyg4NNIzQEeWxP7bu1hiXfmZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aUp1D8MD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aUp1D8MD"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EB1iRk860477;
	Fri, 14 Aug 2026 12:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CDS/Oe60ukATIRtM7
	HOjCWX0aBFQj/7hF0gGEz1cLsw=; b=aUp1D8MD/QXI1+YELAgmFvDIkFot9ofSw
	ewBo0JclX5IswPvbxVZbgGlkg0YnFdWJTD3lN4EDKMl2+arzWcNoLo4ZatrM+f6m
	tJGA9sOz6SDglEevSHQZ0PXF4N0DKf+aqcV4aij7aCAFnLzFHFIo1no5xQHOYZUr
	bBf/qpH4xEWTBuFkca3zP3J51DTvsMtneUB6ccWZRbWU9Q4dAqp5xgB5gkSQzCSZ
	kS4I3bI+E2m+2DoQs3XJhthKJLpRnmlIHcMdl/lufZ8rwmdMS6qxraStFYs2tmJj
	6qTrEANcB1zauwGvzx0GU3hlEovkBrtU4+tx96VHJLYGK/panzXBA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvp3bkwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67ECQIj7027047;
	Fri, 14 Aug 2026 12:37:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqfeck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67ECbCr444499380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 12:37:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B022A20049;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5992320040;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.129.52])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v4 3/3] s390/crypto: Fix use of mutex in atomic context
Date: Fri, 14 Aug 2026 14:37:11 +0200
Message-ID: <20260814123711.61145-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814123711.61145-1-freude@linux.ibm.com>
References: <20260814123711.61145-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AMtp2X5w c=1 sm=1 tr=0 ts=6a7f0bfd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=tsDQq-nlSdI8Wb5FvoAA:9
X-Proofpoint-GUID: KxM3sq6AkQWXiIbvnHxFqgQe4kgv-nX8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfX68AcuG364hHD
 LX8DHGfR3dCu+rgrd+izb+cSteGYz239FFi/ReEgh+wqbuPm4tbyyKUtk1h81/OIel5lLT2tIcG
 XrdRVGH+SPr5MGMB4nZcgoG6c2IBZNPcexq0kG9Ng2dSYlP8WKHBmtHzk2+xwVZRox4+mseR/CN
 dVkZ8KD/cYmt0Y9DOH1vu65BYVvI+T+A4JM46gAPDTBePgxuRhD2bQ/Kz5lfqN0nMXtK52+kLus
 UIhL6C0hX+nHEv2Hbdyx0RgKGiv++XK3Aw0oHsBASLSsagt2xZpZYQGVrJo42O3vy++Wj4GcFzC
 LdeFgcHbbRUVC0k3BgrWBDvCRvKO3iPuwO/p1yzkwP4ehBoKRvSxicXBjf4YJxDqNsZFfIOArcM
 m0KmsbgeitDXOAeefRLAubgMQi+/xeSwo526EEN4cdTxJMsxskagB8zu5DGqhztenKs+tk2tlok
 FkZRltUuBfSkwEyjrSA==
X-Proofpoint-ORIG-GUID: KxM3sq6AkQWXiIbvnHxFqgQe4kgv-nX8
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfX8hBm/yPqfT03
 BZGVxdD0K+Kom0x9kPRJA/4OWT1hYAvSpg0IECum5KdjbOHKbeEzvCcMbI3glo3Za8lhT4Kgyqk
 n/O2or84yb+80vaC+nP8mAE30/s0uXw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140095

The AES CTR implementation used a mutex to lock one page of exclusive
memory for fast CTR processing. Unfortunately a mutex is not save to
use in atomic or interrupt context. So use a binary semaphore instead
which is save to use in such environments.

Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.5+
---
 arch/s390/crypto/aes_s390.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 10561aa687c7..bd9815988c81 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -26,14 +26,14 @@
 #include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <linux/init.h>
-#include <linux/mutex.h>
 #include <linux/fips.h>
+#include <linux/semaphore.h>
 #include <linux/string.h>
 #include <crypto/xts.h>
 #include <asm/cpacf.h>
 
 static u8 *ctrblk;
-static DEFINE_MUTEX(ctrblk_lock);
+static DEFINE_SEMAPHORE(ctrblk_sem, 1);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions,
 		    kma_functions;
@@ -569,12 +569,13 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 	u8 buf[AES_BLOCK_SIZE], *ctrptr;
 	struct skcipher_walk walk;
 	unsigned int n, nbytes;
-	int ret, locked;
+	bool locked;
+	int ret;
 
 	if (unlikely(!sctx->fc))
 		return fallback_skcipher_crypt(sctx, req, 0);
 
-	locked = mutex_trylock(&ctrblk_lock);
+	locked = down_trylock(&ctrblk_sem) == 0;
 
 	ret = skcipher_walk_virt(&walk, req, false);
 	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
@@ -592,7 +593,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
 	if (locked)
-		mutex_unlock(&ctrblk_lock);
+		up(&ctrblk_sem);
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-- 
2.43.0

