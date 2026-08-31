Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72303D4118;
	Mon, 31 Aug 2026 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788165532; cv=none; b=dbU6KxtF/9D43gfgWgZ5aS9pXVepbGomoUcxo/Ws1WGBdC5duKw7EOR1oQ4s5Yymw5GFhddF5R0yM0bq6g0GPFX9fq6rBl0WT3+3c4Bo95i0krYG8gN/B8QkjQxyYRPnieT1z5EXag3jxD/VrFSidnMw2OkeYur4PAe1cmqw0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788165532; c=relaxed/simple;
	bh=Ll07k/2tMa7OkGJrIsiDpxwhXvf6cB3fzR2D4ZVlsIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=druMVj1POuPr6aFKoKdbrzdcYdPRNOr839sjrP1r4akmRWlR9nYfheG4Tvck4YiibytPw555uvRi/u6uyuVjLIq6382psFz7AGc5dCQqfcK4QrqJ1zpjB7K97Iva0eXtP+/nokVh2B9NUlrsM3cHW8juUpjowOgUWXjz1Exq2Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qIyI7BHY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qIyI7BHY"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V82JiP1530938;
	Mon, 31 Aug 2026 08:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cbKYUM4w+4jDo7MBq
	kkiDg216YJ+nMsj3pg6dVR3PK0=; b=qIyI7BHYuzisSS+gFL5VjexeY//7DHBJD
	5za4WOjQvhQ4VwDRcJDl9cCrN2ieT40vUB19NPptVpBdGKeLSDjV3ibk2CNpkfBW
	Afva38E/uzWx/4pY3anKyC1UKuBJq/Nok3F9Pt0rQjUbaqd68oC7KXYI5qAT/Uy8
	lbAxJFpXTqELJ9nOfFB84OXsU0Jzhiisvhp9HD+/QnOkoAlyNMFhB31Ziuvr7K9o
	JcF6MahMDUL6saZbAl9/J/ckpY/z/BnjRvGXwiRYVN6KtTIzjG1R0pQo0DY7cn1d
	lIL94TZZaWNCm/uSLir0oPqvwRN3lxLt+CFP/t7By/1+5tsHiLxKw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbmuhga3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67V8QTCT004745;
	Mon, 31 Aug 2026 08:38:42 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gccexvn60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 08:38:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67V8cdE141877926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 08:38:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC3A520040;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C62CE20043;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.165.38])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 08:38:38 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        herbert@gondor.apana.org.au
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v7 3/9] s390/crypto: Fix use of mutex in atomic context in PAES
Date: Mon, 31 Aug 2026 10:38:32 +0200
Message-ID: <20260831083838.3703-4-freude@linux.ibm.com>
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
X-Proofpoint-GUID: jcXeZBTgGbYwsFB4QepUGzWbMmEnjjse
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX9JO9kDtTJPeF
 UM+Wx8Dr+VVhmATjk/dOMOKc6d9wvU/naIEqbG0FbOHhcdhphbSKNB22xYA7J8ZylKqdaViQISV
 qA+hWG7ne6Zg50NO4MXVUt6TNJtfXxT1/7DMYpxqQWvI+rsJwWN4Vy9uWYu31kBelHyU80mWr3g
 LaHwBNv+bor+552V9/H+dF6GDRhHyYaiGZ/fQ7ly47AFMFu3PB+T7XuLgmOEfW5qAMky+HQG6aM
 tkzrdkUrmxt4e89XYboCQWuPUMV3zEsZ3Inb6FPV9zNGnyEdqI7EWkcuEyPzkErWWZdBAVYzN19
 wpUjsLGs2mpulQXXJFvS1/C5ekLfVJ8uIwbcf9Kmj/eV4DjD5RQ6J6qTbIkVa4glEPVMK8lxLDL
 2dMm2M2iy+K/u+ZroNGul5rYnRE2OzXaWNzs2GM8y9mQUBRIatpBlzhxFegDE8QfgIK3cKt3I35
 Q/at7WuEqT4fnZgKTTg==
X-Authority-Analysis: v=2.4 cv=Osl/DS/t c=1 sm=1 tr=0 ts=6a953d93 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=lwDCFwzbP7am-i5S8aEA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA3MiBTYWx0ZWRfX4Gbch3GtEESc
 KI2HN2yfwilqpdji1tSntEsiLBOA1mKz8Hu81al5b2re3f3zalCcuiWQRPZuMaVvGNYP3DX/doV
 pnOVetxoraYCcaQGUeE9S0QktnUNSp8=
X-Proofpoint-ORIG-GUID: jcXeZBTgGbYwsFB4QepUGzWbMmEnjjse
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_03,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310072

The PAES CTR implementation used a mutex to lock one page of exclusive
memory for fast CTR processing. Unfortunately a mutex is not save to
use in atomic or interrupt context. So use a binary semaphore instead
which is save to use in such environments.

Furthermore rework the code to get rid of conditional locking. So
restructure the PAES CRT code by extracting the main loop into a
separate function and just give in information about the (locked) page
can be used or not (is not locked).

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 107 +++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 50 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index d075b0241f1f..10d1c56a049d 100644
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
 
@@ -937,41 +937,14 @@ static inline unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes
 	return n;
 }
 
-static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
-			     struct s390_pctr_req_ctx *req_ctx,
-			     bool tested, bool maysleep)
+static int __ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
+			       struct ctr_param *param,
+			       struct skcipher_walk *walk,
+			       bool tested, bool maysleep, bool locked)
 {
-	struct ctr_param *param = &req_ctx->param;
-	struct skcipher_walk *walk = &req_ctx->walk;
-	u8 buf[AES_BLOCK_SIZE], *ctrptr;
 	unsigned int nbytes, n, k;
-	int pk_state, locked, rc = 0;
-
-	if (!req_ctx->param_init_done) {
-		/* fetch and check protected key state */
-		spin_lock_bh(&ctx->pk_lock);
-		pk_state = ctx->pk_state;
-		switch (pk_state) {
-		case PK_STATE_NO_KEY:
-			rc = -ENOKEY;
-			break;
-		case PK_STATE_CONVERT_IN_PROGRESS:
-			rc = -EKEYEXPIRED;
-			break;
-		case PK_STATE_VALID:
-			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
-			req_ctx->param_init_done = true;
-			break;
-		default:
-			rc = pk_state < 0 ? pk_state : -EIO;
-			break;
-		}
-		spin_unlock_bh(&ctx->pk_lock);
-	}
-	if (rc)
-		goto out;
-
-	locked = mutex_trylock(&ctrblk_lock);
+	u8 *ctrptr;
+	int rc = 0;
 
 	/*
 	 * Note that in case of partial processing or failure the walk
@@ -991,37 +964,71 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 				       AES_BLOCK_SIZE);
 			crypto_inc(walk->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
-			if (rc) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
+			if (rc)
 				goto out;
-			}
 		}
 		if (k < n) {
 			if (!maysleep) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
 			rc = paes_convert_key(ctx, tested);
-			if (rc) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
+			if (rc)
 				goto out;
-			}
 			spin_lock_bh(&ctx->pk_lock);
 			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
 			spin_unlock_bh(&ctx->pk_lock);
 		}
 	}
-	if (locked)
-		mutex_unlock(&ctrblk_lock);
+
+out:
+	return rc;
+}
+
+static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
+			     struct s390_pctr_req_ctx *req_ctx,
+			     bool tested, bool maysleep)
+{
+	struct ctr_param *param = &req_ctx->param;
+	struct skcipher_walk *walk = &req_ctx->walk;
+	u8 buf[AES_BLOCK_SIZE];
+	int pk_state, rc = 0;
+
+	if (!req_ctx->param_init_done) {
+		/* fetch and check protected key state */
+		spin_lock_bh(&ctx->pk_lock);
+		pk_state = ctx->pk_state;
+		switch (pk_state) {
+		case PK_STATE_NO_KEY:
+			rc = -ENOKEY;
+			break;
+		case PK_STATE_CONVERT_IN_PROGRESS:
+			rc = -EKEYEXPIRED;
+			break;
+		case PK_STATE_VALID:
+			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
+			req_ctx->param_init_done = true;
+			break;
+		default:
+			rc = pk_state < 0 ? pk_state : -EIO;
+			break;
+		}
+		spin_unlock_bh(&ctx->pk_lock);
+	}
+	if (rc)
+		goto out;
+
+	if (down_trylock(&ctrblk_sem) == 0) {
+		rc = __ctr_paes_do_crypt(ctx, param, walk, tested, maysleep, true);
+		up(&ctrblk_sem);
+	} else {
+		rc = __ctr_paes_do_crypt(ctx, param, walk, tested, maysleep, false);
+	}
 
 	/* final block may be < AES_BLOCK_SIZE, copy only nbytes */
-	if (nbytes) {
+	if (!rc && walk->nbytes > 0) {
 		memset(buf, 0, AES_BLOCK_SIZE);
-		memcpy(buf, walk->src.virt.addr, nbytes);
+		memcpy(buf, walk->src.virt.addr, walk->nbytes);
 		while (1) {
 			if (cpacf_kmctr(ctx->fc, param, buf,
 					buf, AES_BLOCK_SIZE,
@@ -1038,7 +1045,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
 			spin_unlock_bh(&ctx->pk_lock);
 		}
-		memcpy(walk->dst.virt.addr, buf, nbytes);
+		memcpy(walk->dst.virt.addr, buf, walk->nbytes);
 		crypto_inc(walk->iv, AES_BLOCK_SIZE);
 		rc = skcipher_walk_done(walk, 0);
 	}
-- 
2.43.0

