Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E3234846A;
	Thu, 15 Jan 2026 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768478438; cv=none; b=gUTFAm2Fb652Lyl0PZ24SUVToZVHM/KF2vrCjTk4oviIIM6azPYhOKbGLPq6qfr7JpNwlneHlma39zo36iRaMgHh3fQ1Hel8OeLxE0WEPHXe8RFsSmYNoyz4yZCnJtbx2lgW6aUDV0cHjs2kS3O8OCLZ/GE++MPOwoF1c4yZCK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768478438; c=relaxed/simple;
	bh=rpelUFlUA35mpGDZTbY/+wWQgLEdroLSXRrnB8aefoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpwsjzvK5f23tl+2DaR//RRoW7SCk8trYZI5pargoObH0QtNR0AESl/hMI+VgjUFTVkMxH2Iks8hPGMeMwn+p57gmZS/m4S5SN3mXMuBpawuVSSqmcXyuXayGV6pc38V9PK3fbcyTfPKNgFP10Zvh4LqLt/AwJsfX0COVqo8ouI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DWmUI02U; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DWmUI02U"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60EM25dV007270;
	Thu, 15 Jan 2026 12:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xiUtufTEZmxc2y2Ig
	ZIZLx1EaRrcmGHtdidN5i6+3Z4=; b=DWmUI02Un0hIOrAvJeg7pt2E1+ONI7BQD
	OwD2B8AsyDzlyiW43BbpBUxWN0LEAsBJ1k/rZlJ+igMfFI/Wl0QQW7Zk24ylsKOU
	d8zncwio1spVx4Da5hTddvoF23ddivLKOXvZBl755i3oVNkPJnDjY2nH0asunUhf
	4gAsbAgqmG8RQsz+CBIzPSzn9zIYS2vcp1eIAcxAtEjCboBg8yvBOghQkhE78zST
	0nO0W8JKrLeVx+UKlskHDlsoS+BfDG7wu692nxt75YERouIJ2ERoVS4WegLR2ypZ
	q6mny0HanZXbo2MGgzdngfCxOqjy+I6MhvUu1n59GVBsNeIq9whmw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6edxug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBYQX6025809;
	Thu, 15 Jan 2026 12:00:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm2kkqs7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FC0RN831850904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:00:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4E2120040;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7513C2004D;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from funtu2.aag-de.ibm.com (unknown [9.52.218.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v2 4/4] crypto: s390/paes - Refuse clear key material by default
Date: Thu, 15 Jan 2026 13:00:26 +0100
Message-ID: <20260115120026.4286-5-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260115120026.4286-1-freude@linux.ibm.com>
References: <20260115120026.4286-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JwUGgJuZhCHDZfpNsJ6n1RXuIVn1y_hL
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=6968d6e0 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=d0OAICLbZFG8d2Fc00oA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA4NiBTYWx0ZWRfX0GkqBU+XZb2z
 2XovdnQsnPdzYE0VvK3Wvpjbpt1YDgeilkp9TTXFicp2w9DZHqjrlZduHiE4vGKd7UjwPaNf6m1
 9jYKTZqr3zW4O7OEIDBaY/F00kxnLyLAxHKpi8J58Bx3CFHMtTK16INmX/taCKNSOg3XOZiqifG
 mTWXkk+hl7JGMPMoGekhHqFdgwPLfUGBlHzvkhSoYmt9QH+uEVQubT7JpwqyHjO6ldnBXWvOjvY
 ru4YtSWyh3XH8jTAoFyCera9k0P3jLZUFSl1PqPkpVEfdyutgL9iTU6oNDIYaGiDrfcSJkeJWh5
 E4C2mJTQ9PqHJfrve++L4Qbhwm4YwKQzq5DIz+XntkSDHT2fpYKtKQ0xBO3y9ONREocK6QDfn60
 RYt6mGlGLN+blLFwyWjcu0ps+Dpuudd1/8/GaxMNtaTSNUP0czZvBwK3KmXS65AjNHOCIxzIQrf
 F8e+/EJ1STa6jJyp9HA==
X-Proofpoint-ORIG-GUID: JwUGgJuZhCHDZfpNsJ6n1RXuIVn1y_hL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150086

This patch exploits the new xflag PKEY_XFLAG_NOCLEARKEY from the pkey
layer. So now by default all the paes algorithms refuse the use of
clear key material ("clear key tokens") in the setkey function with
-EINVAL.

With a new kernel module parameter "clrkey" this behavior can be
controlled. By default clrkey is 'N' but for testing purpose on module
load a true value (1, 'Y') may be given to accept clear key tokens.

Note that during selftest clear keys are always used and thus the
xflag PKEY_XFLAG_NOCLEARKEY is NOT set as long as the algorithm is in
a larval state indicated by crypto_skcipher_tested() returning false.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
---
 arch/s390/crypto/paes_s390.c | 93 ++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 36 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 64aef7eb2030..8cfe6166c193 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -40,6 +40,10 @@
 #define PAES_256_PROTKEY_SIZE	(32 + 32)	/* key + verification pattern */
 #define PXTS_256_PROTKEY_SIZE	(32 + 32 + 32)	/* k1 + k2 + verification pattern */
 
+static bool pkey_clrkey_allowed;
+module_param_named(clrkey, pkey_clrkey_allowed, bool, 0444);
+MODULE_PARM_DESC(clrkey, "Allow clear key material (default N)");
+
 static u8 *ctrblk;
 static DEFINE_MUTEX(ctrblk_lock);
 
@@ -192,10 +196,14 @@ static inline int pxts_ctx_setkey(struct s390_pxts_ctx *ctx,
  * This function may sleep - don't call in non-sleeping context.
  */
 static inline int convert_key(const u8 *key, unsigned int keylen,
-			      struct paes_protkey *pk)
+			      struct paes_protkey *pk, bool tested)
 {
+	u32 xflags = PKEY_XFLAG_NOMEMALLOC;
 	int rc, i;
 
+	if (tested && !pkey_clrkey_allowed)
+		xflags |= PKEY_XFLAG_NOCLEARKEY;
+
 	pk->len = sizeof(pk->protkey);
 
 	/*
@@ -209,7 +217,7 @@ static inline int convert_key(const u8 *key, unsigned int keylen,
 		}
 		rc = pkey_key2protkey(key, keylen,
 				      pk->protkey, &pk->len, &pk->type,
-				      PKEY_XFLAG_NOMEMALLOC);
+				      xflags);
 	}
 
 out:
@@ -231,7 +239,7 @@ static inline int convert_key(const u8 *key, unsigned int keylen,
  * unnecessary additional conversion but never to invalid data on en-
  * or decrypt operations.
  */
-static int paes_convert_key(struct s390_paes_ctx *ctx)
+static int paes_convert_key(struct s390_paes_ctx *ctx, bool tested)
 {
 	struct paes_protkey pk;
 	int rc;
@@ -240,7 +248,7 @@ static int paes_convert_key(struct s390_paes_ctx *ctx)
 	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
 	spin_unlock_bh(&ctx->pk_lock);
 
-	rc = convert_key(ctx->keybuf, ctx->keylen, &pk);
+	rc = convert_key(ctx->keybuf, ctx->keylen, &pk, tested);
 
 	/* update context */
 	spin_lock_bh(&ctx->pk_lock);
@@ -263,7 +271,7 @@ static int paes_convert_key(struct s390_paes_ctx *ctx)
  * pk_type, pk_len and the protected key in the tfm context.
  * See also comments on function paes_convert_key.
  */
-static int pxts_convert_key(struct s390_pxts_ctx *ctx)
+static int pxts_convert_key(struct s390_pxts_ctx *ctx, bool tested)
 {
 	struct paes_protkey pk0, pk1;
 	size_t split_keylen;
@@ -273,7 +281,7 @@ static int pxts_convert_key(struct s390_pxts_ctx *ctx)
 	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
 	spin_unlock_bh(&ctx->pk_lock);
 
-	rc = convert_key(ctx->keybuf, ctx->keylen, &pk0);
+	rc = convert_key(ctx->keybuf, ctx->keylen, &pk0, tested);
 	if (rc)
 		goto out;
 
@@ -287,7 +295,7 @@ static int pxts_convert_key(struct s390_pxts_ctx *ctx)
 		}
 		split_keylen = ctx->keylen / 2;
 		rc = convert_key(ctx->keybuf + split_keylen,
-				 split_keylen, &pk1);
+				 split_keylen, &pk1, tested);
 		if (rc)
 			goto out;
 		if (pk0.type != pk1.type) {
@@ -343,6 +351,7 @@ static int ecb_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	bool tested = crypto_skcipher_tested(tfm);
 	long fc;
 	int rc;
 
@@ -352,7 +361,7 @@ static int ecb_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		goto out;
 
 	/* convert key into protected key */
-	rc = paes_convert_key(ctx);
+	rc = paes_convert_key(ctx, tested);
 	if (rc)
 		goto out;
 
@@ -382,7 +391,7 @@ static int ecb_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 
 static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
 			     struct s390_pecb_req_ctx *req_ctx,
-			     bool maysleep)
+			     bool tested, bool maysleep)
 {
 	struct ecb_param *param = &req_ctx->param;
 	struct skcipher_walk *walk = &req_ctx->walk;
@@ -430,7 +439,7 @@ static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
-			rc = paes_convert_key(ctx);
+			rc = paes_convert_key(ctx, tested);
 			if (rc)
 				goto out;
 			spin_lock_bh(&ctx->pk_lock);
@@ -450,6 +459,7 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/*
@@ -468,7 +478,7 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 
 	/* Try synchronous operation if no active engine usage */
 	if (!atomic_read(&ctx->via_engine_ctr)) {
-		rc = ecb_paes_do_crypt(ctx, req_ctx, false);
+		rc = ecb_paes_do_crypt(ctx, req_ctx, tested, false);
 		if (rc == 0)
 			goto out;
 	}
@@ -531,11 +541,12 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/* walk has already been prepared */
 
-	rc = ecb_paes_do_crypt(ctx, req_ctx, true);
+	rc = ecb_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		/*
 		 * Protected key expired, conversion is in process.
@@ -602,6 +613,7 @@ static int cbc_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	bool tested = crypto_skcipher_tested(tfm);
 	long fc;
 	int rc;
 
@@ -611,7 +623,7 @@ static int cbc_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		goto out;
 
 	/* convert raw key into protected key */
-	rc = paes_convert_key(ctx);
+	rc = paes_convert_key(ctx, tested);
 	if (rc)
 		goto out;
 
@@ -641,7 +653,7 @@ static int cbc_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 
 static int cbc_paes_do_crypt(struct s390_paes_ctx *ctx,
 			     struct s390_pcbc_req_ctx *req_ctx,
-			     bool maysleep)
+			     bool tested, bool maysleep)
 {
 	struct cbc_param *param = &req_ctx->param;
 	struct skcipher_walk *walk = &req_ctx->walk;
@@ -693,7 +705,7 @@ static int cbc_paes_do_crypt(struct s390_paes_ctx *ctx,
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
-			rc = paes_convert_key(ctx);
+			rc = paes_convert_key(ctx, tested);
 			if (rc)
 				goto out;
 			spin_lock_bh(&ctx->pk_lock);
@@ -713,6 +725,7 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/*
@@ -731,7 +744,7 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 
 	/* Try synchronous operation if no active engine usage */
 	if (!atomic_read(&ctx->via_engine_ctr)) {
-		rc = cbc_paes_do_crypt(ctx, req_ctx, false);
+		rc = cbc_paes_do_crypt(ctx, req_ctx, tested, false);
 		if (rc == 0)
 			goto out;
 	}
@@ -794,11 +807,12 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/* walk has already been prepared */
 
-	rc = cbc_paes_do_crypt(ctx, req_ctx, true);
+	rc = cbc_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		/*
 		 * Protected key expired, conversion is in process.
@@ -865,6 +879,7 @@ static int ctr_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	bool tested = crypto_skcipher_tested(tfm);
 	long fc;
 	int rc;
 
@@ -874,7 +889,7 @@ static int ctr_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		goto out;
 
 	/* convert raw key into protected key */
-	rc = paes_convert_key(ctx);
+	rc = paes_convert_key(ctx, tested);
 	if (rc)
 		goto out;
 
@@ -919,7 +934,7 @@ static inline unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes
 
 static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 			     struct s390_pctr_req_ctx *req_ctx,
-			     bool maysleep)
+			     bool tested, bool maysleep)
 {
 	struct ctr_param *param = &req_ctx->param;
 	struct skcipher_walk *walk = &req_ctx->walk;
@@ -979,7 +994,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
-			rc = paes_convert_key(ctx);
+			rc = paes_convert_key(ctx, tested);
 			if (rc) {
 				if (locked)
 					mutex_unlock(&ctrblk_lock);
@@ -1006,7 +1021,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
-			rc = paes_convert_key(ctx);
+			rc = paes_convert_key(ctx, tested);
 			if (rc)
 				goto out;
 			spin_lock_bh(&ctx->pk_lock);
@@ -1029,6 +1044,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/*
@@ -1046,7 +1062,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 
 	/* Try synchronous operation if no active engine usage */
 	if (!atomic_read(&ctx->via_engine_ctr)) {
-		rc = ctr_paes_do_crypt(ctx, req_ctx, false);
+		rc = ctr_paes_do_crypt(ctx, req_ctx, tested, false);
 		if (rc == 0)
 			goto out;
 	}
@@ -1099,11 +1115,12 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/* walk has already been prepared */
 
-	rc = ctr_paes_do_crypt(ctx, req_ctx, true);
+	rc = ctr_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		/*
 		 * Protected key expired, conversion is in process.
@@ -1190,6 +1207,7 @@ static int xts_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			   unsigned int in_keylen)
 {
 	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	bool tested = crypto_skcipher_tested(tfm);
 	u8 ckey[2 * AES_MAX_KEY_SIZE];
 	unsigned int ckey_len;
 	long fc;
@@ -1205,7 +1223,7 @@ static int xts_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		goto out;
 
 	/* convert raw key(s) into protected key(s) */
-	rc = pxts_convert_key(ctx);
+	rc = pxts_convert_key(ctx, tested);
 	if (rc)
 		goto out;
 
@@ -1255,7 +1273,7 @@ static int xts_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 
 static int xts_paes_do_crypt_fullkey(struct s390_pxts_ctx *ctx,
 				     struct s390_pxts_req_ctx *req_ctx,
-				     bool maysleep)
+				     bool tested, bool maysleep)
 {
 	struct xts_full_km_param *param = &req_ctx->param.full_km_param;
 	struct skcipher_walk *walk = &req_ctx->walk;
@@ -1299,7 +1317,7 @@ static int xts_paes_do_crypt_fullkey(struct s390_pxts_ctx *ctx,
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
-			rc = pxts_convert_key(ctx);
+			rc = pxts_convert_key(ctx, tested);
 			if (rc)
 				goto out;
 			spin_lock_bh(&ctx->pk_lock);
@@ -1318,7 +1336,8 @@ static inline int __xts_2keys_prep_param(struct s390_pxts_ctx *ctx,
 					 struct xts_km_param *param,
 					 struct skcipher_walk *walk,
 					 unsigned int keylen,
-					 unsigned int offset, bool maysleep)
+					 unsigned int offset,
+					 bool tested, bool maysleep)
 {
 	struct xts_pcc_param pcc_param;
 	unsigned long cc = 1;
@@ -1337,7 +1356,7 @@ static inline int __xts_2keys_prep_param(struct s390_pxts_ctx *ctx,
 				rc = -EKEYEXPIRED;
 				break;
 			}
-			rc = pxts_convert_key(ctx);
+			rc = pxts_convert_key(ctx, tested);
 			if (rc)
 				break;
 			continue;
@@ -1351,7 +1370,7 @@ static inline int __xts_2keys_prep_param(struct s390_pxts_ctx *ctx,
 
 static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
 				   struct s390_pxts_req_ctx *req_ctx,
-				   bool maysleep)
+				   bool tested, bool maysleep)
 {
 	struct xts_km_param *param = &req_ctx->param.km_param;
 	struct skcipher_walk *walk = &req_ctx->walk;
@@ -1369,7 +1388,7 @@ static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
 
 	if (!req_ctx->param_init_done) {
 		rc = __xts_2keys_prep_param(ctx, param, walk,
-					    keylen, offset, maysleep);
+					    keylen, offset, tested, maysleep);
 		if (rc)
 			goto out;
 		req_ctx->param_init_done = true;
@@ -1392,7 +1411,7 @@ static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
-			rc = pxts_convert_key(ctx);
+			rc = pxts_convert_key(ctx, tested);
 			if (rc)
 				goto out;
 			spin_lock_bh(&ctx->pk_lock);
@@ -1408,7 +1427,7 @@ static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
 
 static int xts_paes_do_crypt(struct s390_pxts_ctx *ctx,
 			     struct s390_pxts_req_ctx *req_ctx,
-			     bool maysleep)
+			     bool tested, bool maysleep)
 {
 	int pk_state, rc = 0;
 
@@ -1436,11 +1455,11 @@ static int xts_paes_do_crypt(struct s390_pxts_ctx *ctx,
 	switch (ctx->fc) {
 	case CPACF_KM_PXTS_128:
 	case CPACF_KM_PXTS_256:
-		rc = xts_paes_do_crypt_2keys(ctx, req_ctx, maysleep);
+		rc = xts_paes_do_crypt_2keys(ctx, req_ctx, tested, maysleep);
 		break;
 	case CPACF_KM_PXTS_128_FULL:
 	case CPACF_KM_PXTS_256_FULL:
-		rc = xts_paes_do_crypt_fullkey(ctx, req_ctx, maysleep);
+		rc = xts_paes_do_crypt_fullkey(ctx, req_ctx, tested, maysleep);
 		break;
 	default:
 		rc = -EINVAL;
@@ -1457,6 +1476,7 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/*
@@ -1475,7 +1495,7 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 
 	/* Try synchronous operation if no active engine usage */
 	if (!atomic_read(&ctx->via_engine_ctr)) {
-		rc = xts_paes_do_crypt(ctx, req_ctx, false);
+		rc = xts_paes_do_crypt(ctx, req_ctx, tested, false);
 		if (rc == 0)
 			goto out;
 	}
@@ -1538,11 +1558,12 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk *walk = &req_ctx->walk;
+	bool tested = crypto_skcipher_tested(tfm);
 	int rc;
 
 	/* walk has already been prepared */
 
-	rc = xts_paes_do_crypt(ctx, req_ctx, true);
+	rc = xts_paes_do_crypt(ctx, req_ctx, tested, true);
 	if (rc == -EKEYEXPIRED) {
 		/*
 		 * Protected key expired, conversion is in process.
-- 
2.43.0

