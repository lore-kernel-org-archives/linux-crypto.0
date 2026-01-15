Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5369911CBA;
	Thu, 15 Jan 2026 12:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768478436; cv=none; b=rhRDTfJe77EMdYjTiGKUEoMfEdYgNFSkP5Sf5+TD48QMZeKl6Wc411UfDP4SvJe00vP1yOnZAXaFCOSD3ZrOpmqaAkxe7OYWWOwuNe1CqNGleY2yMtqO0lpCDvZuvP3F9g/xdnpzy7HjgzzE9xQD7fge53RSp8291oCRtL6JGFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768478436; c=relaxed/simple;
	bh=6EFNx9IVDC46XyowzTIu26t18IF0L707eDcnRLIFXXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtL8lgB92FID1HadqJEkpxbdLjMJpBIoliirM+c7tfcNtLtrVI1VPvyOSLV3ZKtDdyA0Bt5Fp1nND8s4RAFnwKwOyJDiLRtDqTCdEWF0m8+MGjvUeKbFAfrC+RJF1Zr85d396DHV2s7RVQzQy/Zro7DSe3LcugpYFqPtDEYz5lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=roYXZAWk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="roYXZAWk"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60F7oRRf032700;
	Thu, 15 Jan 2026 12:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1Dvh7JLEbbDIsKcS7
	IDkjfYj9TshxU5+K0re1jHkskg=; b=roYXZAWkjIeTFxMaSxgVE6aKGoCfhvKAF
	esUF4RlVHRAM/x9FUSJpD9oHjBubtCI4EmmeQvNx4kBIvzQIp7ACU43n9/6LPXsh
	cubk7LCtxF1OuMo5e3llT9gU9Hnvubj/BirxdIZuahN6YPm6u2Eu2bnfDM4YDz8z
	CcRttiTXd6PPFRavZrDlbBPQbxaCPHp1ME/QP9KuPpqdTPKQaLyA5wAUSREaDdDb
	w4sWOVMcKFiZkD7grvueOvLEeEPNUk/cHvn+dhr3aUq90W0ZfkCYIwYIeDbtueYs
	+JkDmAz8sLGxTBO6Bv9ZO9JQ2huG/18hS2v9TtSzZZ+Z0R+bXnE9w==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6edxuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60F8pfAt025549;
	Thu, 15 Jan 2026 12:00:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm23nfr03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FC0RTq11075924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:00:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 701CB2004B;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5464320043;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from funtu2.aag-de.ibm.com (unknown [9.52.218.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v2 3/4] crypto: s390/phmac - Refuse clear key material by default
Date: Thu, 15 Jan 2026 13:00:25 +0100
Message-ID: <20260115120026.4286-4-freude@linux.ibm.com>
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
X-Proofpoint-GUID: 2zUIq952xZRRVUab5uSEDsK7locHqEgS
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=6968d6e0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=kV1x1iOdP4fPeWTJk_UA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA4NiBTYWx0ZWRfX4U1htm1uyeK7
 tCsuwnvmH3n0kh2jFoXSP2gVO7239dftQk7yXQ8RLJyvhcunRysqY2jXNrwSs7idnSkx+2LoGAh
 JaTsHG8+k+LXGHS+GzJVCLhUoVE3HJAsWm8ec5IOEnJcKvvMV7817ERNkr/eg8UxdI6WTv6FIIF
 Ilwb/IVecxyXd7Gs1v+t8bRPHjX6ravQr/dT4IqeY1RCfz6Z+3XIZZz0CPKzeGXi9q/oyYFbWUo
 zgmchOL80ltA48Cr6cVFweSLK9DlhYY8nNWNlVzIgbO9AACJRYiOXZSaTtHpKj6FbBcgQnmzkLS
 tI0d3mqPzriQRh13YPVTaLYxuJYam9QCn2metLe7FFuB2LCQXxDdYNF1vXnOicggce5GP5x2dCg
 U1iu0tTVJkBhUPX8ROlADyUwT5nmX/vlgfxju8p+CogMlOL6Svai+HWxoiUS+pVFyhETn5gnlko
 c06+oaE+pAJpmCiRqIg==
X-Proofpoint-ORIG-GUID: 2zUIq952xZRRVUab5uSEDsK7locHqEgS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150086

This patch exploits the new xflag PKEY_XFLAG_NOCLEARKEY from the pkey
layer. So now by default the phmac refuses the use of clear key
material ("clear key tokens") in the setkey function with
-EINVAL.

With a new kernel module parameter "clrkey" this behavior can be
controlled. By default clrkey is 'N' but for testing purpose on module
load a true value (1, 'Y') may be given to accept clear key tokens.

Note that during selftest clear keys are always used and thus the
xflag PKEY_XFLAG_NOCLEARKEY is NOT set as long as the algorithm is in
a larval state indicated by crypto_ahash_tested() returning false.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
---
 arch/s390/crypto/phmac_s390.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 88342bd4c37a..03ca33ffe6cc 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -23,6 +23,10 @@
 static struct crypto_engine *phmac_crypto_engine;
 #define MAX_QLEN 10
 
+static bool pkey_clrkey_allowed;
+module_param_named(clrkey, pkey_clrkey_allowed, bool, 0444);
+MODULE_PARM_DESC(clrkey, "Allow clear key material (default N)");
+
 /*
  * A simple hash walk helper
  */
@@ -311,10 +315,14 @@ static inline int phmac_tfm_ctx_setkey(struct phmac_tfm_ctx *tfm_ctx,
  * This function may sleep - don't call in non-sleeping context.
  */
 static inline int convert_key(const u8 *key, unsigned int keylen,
-			      struct phmac_protkey *pk)
+			      struct phmac_protkey *pk, bool tested)
 {
+	u32 xflags = PKEY_XFLAG_NOMEMALLOC;
 	int rc, i;
 
+	if (tested && !pkey_clrkey_allowed)
+		xflags |= PKEY_XFLAG_NOCLEARKEY;
+
 	pk->len = sizeof(pk->protkey);
 
 	/*
@@ -328,7 +336,7 @@ static inline int convert_key(const u8 *key, unsigned int keylen,
 		}
 		rc = pkey_key2protkey(key, keylen,
 				      pk->protkey, &pk->len, &pk->type,
-				      PKEY_XFLAG_NOMEMALLOC);
+				      xflags);
 	}
 
 out:
@@ -350,7 +358,7 @@ static inline int convert_key(const u8 *key, unsigned int keylen,
  * unnecessary additional conversion but never to invalid data on the
  * hash operation.
  */
-static int phmac_convert_key(struct phmac_tfm_ctx *tfm_ctx)
+static int phmac_convert_key(struct phmac_tfm_ctx *tfm_ctx, bool tested)
 {
 	struct phmac_protkey pk;
 	int rc;
@@ -359,7 +367,7 @@ static int phmac_convert_key(struct phmac_tfm_ctx *tfm_ctx)
 	tfm_ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
 	spin_unlock_bh(&tfm_ctx->pk_lock);
 
-	rc = convert_key(tfm_ctx->keybuf, tfm_ctx->keylen, &pk);
+	rc = convert_key(tfm_ctx->keybuf, tfm_ctx->keylen, &pk, tested);
 
 	/* update context */
 	spin_lock_bh(&tfm_ctx->pk_lock);
@@ -404,6 +412,7 @@ static int phmac_kmac_update(struct ahash_request *req, bool maysleep)
 	struct kmac_sha2_ctx *ctx = &req_ctx->kmac_ctx;
 	struct hash_walk_helper *hwh = &req_ctx->hwh;
 	unsigned int bs = crypto_ahash_blocksize(tfm);
+	bool tested = crypto_ahash_tested(tfm);
 	unsigned int offset, k, n;
 	int rc = 0;
 
@@ -444,7 +453,7 @@ static int phmac_kmac_update(struct ahash_request *req, bool maysleep)
 					rc = -EKEYEXPIRED;
 					goto out;
 				}
-				rc = phmac_convert_key(tfm_ctx);
+				rc = phmac_convert_key(tfm_ctx, tested);
 				if (rc)
 					goto out;
 				spin_lock_bh(&tfm_ctx->pk_lock);
@@ -480,7 +489,7 @@ static int phmac_kmac_update(struct ahash_request *req, bool maysleep)
 					rc = -EKEYEXPIRED;
 					goto out;
 				}
-				rc = phmac_convert_key(tfm_ctx);
+				rc = phmac_convert_key(tfm_ctx, tested);
 				if (rc)
 					goto out;
 				spin_lock_bh(&tfm_ctx->pk_lock);
@@ -517,6 +526,7 @@ static int phmac_kmac_final(struct ahash_request *req, bool maysleep)
 	struct kmac_sha2_ctx *ctx = &req_ctx->kmac_ctx;
 	unsigned int ds = crypto_ahash_digestsize(tfm);
 	unsigned int bs = crypto_ahash_blocksize(tfm);
+	bool tested = crypto_ahash_tested(tfm);
 	unsigned int k, n;
 	int rc = 0;
 
@@ -537,7 +547,7 @@ static int phmac_kmac_final(struct ahash_request *req, bool maysleep)
 			rc = -EKEYEXPIRED;
 			goto out;
 		}
-		rc = phmac_convert_key(tfm_ctx);
+		rc = phmac_convert_key(tfm_ctx, tested);
 		if (rc)
 			goto out;
 		spin_lock_bh(&tfm_ctx->pk_lock);
@@ -741,11 +751,12 @@ static int phmac_setkey(struct crypto_ahash *tfm,
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
 	unsigned int bs = crypto_ahash_blocksize(tfm);
+	bool tested = crypto_ahash_tested(tfm);
 	unsigned int tmpkeylen;
 	u8 *tmpkey = NULL;
 	int rc = 0;
 
-	if (!crypto_ahash_tested(tfm)) {
+	if (!tested) {
 		/*
 		 * selftest running: key is a raw hmac clear key and needs
 		 * to get embedded into a 'clear key token' in order to have
@@ -770,7 +781,7 @@ static int phmac_setkey(struct crypto_ahash *tfm,
 		goto out;
 
 	/* convert raw key into protected key */
-	rc = phmac_convert_key(tfm_ctx);
+	rc = phmac_convert_key(tfm_ctx, tested);
 	if (rc)
 		goto out;
 
-- 
2.43.0

