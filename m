Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200453;
	b=ny9W+86rFXmuZMolSJP/j0uXoy+ak/QlJc6N649WqTsVDc2GtWSG9BcZzHt1pk6u4zdZ
	 rYnyIQQHk9zgMsMkEe4Q60WLrLfr5p89eX2Sc60Q9ebzfoochubgFsQcuTCQ0m/zBXUv9
	 nmCrdT5e2N4AHICDCVxps6xdCc6IWn8NLZn+MjSGR7o1V3mCPs3kUqx+aT4/UIWpKMeb4
	 metPDZUGtCcRg5bmpCHLfL4Yrr57KWbanXhxJSMlMtUvRX3qzT6HQ8FLzbmikXdEID3/d
	 Reh34VIt6IszkXwT+BI984lBMdVLFiCc17UpoYot96k+hzrdXv1ZE4FEPusMhs3HSPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200453;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ZHO6E2DPbIDlG+X+FjAHiNjh+cdkCt7toF72Fd/sJgE=;
	b=QxHeUT/mwBLw1KxoeZBBV4aatu5FFdRldKluR1SuuK3VDtnNtUJyCmw6SasugkECc9tZ
	 Nn4YHd/ChzRFHECNVhy7qyslyKEymAte7vVBD4QmuMQygM4iHTVvl1Fg2b3RBto5XUeYc
	 rkiQPVoC8boNmkaeaCO2mqAJhOl9i9ydLyvO39dHbD34xic5sY6HzztB/rDoc1mHa2EVD
	 NrKYztMohSgosqDsxmy58B2wdz89wh4siomUfSdSdSKbf5NukPLYgHmjcyb2ySR0jRyyl
	 Y+Jk49nQ/Ur62j16JC5LxiCoBMZGTmgbdrjLPOMA0R4k3OnKy2At6KtCe0No7gw7YFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=PpgYdGcL;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABEB60A2621;
	Fri, 20 Nov 2026 18:47:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ABEB60A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=PpgYdGcL
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKEuJZJ3369764;
	Fri, 20 Nov 2026 18:47:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ZHO6E2DPbIDlG+X+FjAHiNjh+cdkCt7toF72Fd/sJ
	gE=; b=PpgYdGcL9RqFr85zsyFWNxixQVVhRTtE3oqY+0omAIxJXBPzY3qLp003S
	F0lTdUFjsqbWtuu97J/7Pl/RWF/qG2/InST6HSJATcswJncr/TtRcx2lbzuJLvol
	EbTLneCOXTXrsDT+r5PkJFhBAXutrOq29YH7PhJ0ugQnWzGZ0Hy7aNHdUlu9MiqS
	KqBvprilpatGeEZFQSvKNz7jSV+W7qYYvCSGBaQgv77WazAICbbTfeeb9cr/5gUX
	MZiKY7HSzh9BujwKIcewprU9Uay6FCEmGpoKikF5xOu275QR70S26/40F2o0gm96
	zyAnxkizrDymC9juF2fySum+Kvm+Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105xa3uy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 18:47:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKHsA6s1314009;
	Fri, 20 Nov 2026 18:47:01 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j2q5nhgn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 18:47:00 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AKIkxon25494034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 18:46:59 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6961E58055;
	Fri, 20 Nov 2026 18:46:59 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 778855804E;
	Fri, 20 Nov 2026 18:46:58 +0000 (GMT)
Received: from ltcden12-lp4.ltc.tadn.ibm.com (unknown [9.5.7.39])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Nov 2026 18:46:58 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: [PATCH v2] crypto: powerpc/p10-aes-gcm - Fix IPsec stall on bond failover
Date: Fri, 20 Nov 2026 13:16:57 -0500
Message-ID: <20261120181657.6396-1-dtsen@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o_wQzfLkxvVon09-hyCEFmo67pJ7JPCD
X-Proofpoint-GUID: o_wQzfLkxvVon09-hyCEFmo67pJ7JPCD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3MyBTYWx0ZWRfX9qa86B8SXCX3
 nfpdPLAHrSbxBIy2HQFjw1BPTAUCrFpeprVFvjYW2c6szRpZKFmy/fK0vDnc4fNDNHtCPmm22B3
 6FdVilW2YpKG+q5n78bgFxmz9/vyViCsiIUIFte73PruDMdWNIIDgrvpv4PR0XSojP/vYIZLB3N
 45sXE7/rHrEamM0TXfKPe5jATB7VPXYM6cidoWsBqrIVBTHe1gORqEqZcIUtOM/L4t5cvhW1T6k
 1u2nEAAQRqHn5Zpp9IO7vHi0PoLxL240/wbw+JEuplvf6XKOeCijjMya5/8Wa5P/sH4Yu0bufKy
 pTmWn+OWiMerpHADVvfjffQf8feUjHMdSGRUqHWwPI9ta/Q54KoBBjr7CTJZp525RWWnVJ1AZNV
 /RbhgrqTJ/MPv0YZHyKBiPJkF1QgKPOAa2Kt+fH4mmt7oAXg2AybXJyuvsIwEIbYpEg6BIVCYec
 zlgT2Uj9Qu7caRB+BsA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3MyBTYWx0ZWRfXwIOYEdwCZuUN
 LWdb8hbOMinb2Hbf+6wV4kAOstGCVE5AYXfH+9PgVuPl8Xc4GorKuaxctP8w6usjtKHqOgdOr1c
 RqQ7pZS7L8ZRJG+KM/MCZvGzM37QoFQ=
X-Authority-Analysis: v=2.4 cv=K+m3jCWI c=1 sm=1 tr=0 ts=6b0095a5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=GNyWvEEFRfobykiQUNcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200073

The Power10 AES-GCM driver registers its gcm(aes) and
rfc4106(gcm(aes)) algorithms through the crypto SIMD helper. When
crypto_simd_usable() is false, for example in softirq context, the
helper defers requests to cryptd and completes them asynchronously
with -EINPROGRESS.

This breaks IPsec traffic during a bond failover. With the crypto
offload device active, traffic is switched to a passive device that
has only software encryption, and the ESP requests then go through
aes_gcm_p10_crypto. Under heavy load, some or all of the TCP streams
drop to zero throughput and do not recover. The stack is seen to drop
the ACKs as invalid, which points to the cryptd queueing delaying or
reordering the packets.

Fix this by registering the algorithms directly as aead_alg with
CRYPTO_ALG_NEED_FALLBACK, and allocating a "gcm(aes)" or
"rfc4106(gcm(aes))" fallback tfm in ->init(). When VSX cannot be used
(!crypto_simd_usable()), the key was not set up for SIMD, or
cryptlen < 64, the request is handed to the fallback and completed
synchronously in the caller's context. The driver no longer defers
work to cryptd.

Remove Kconfig option CRYPTO_SIMD and add CRYPTO_AES and CRYPTO_GCM.

Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
---
Tested with tcrypt.ko (including the self-tests) and with IPsec traffic
across a bond failover. TCP throughput no longer drops to zero.

 arch/powerpc/crypto/Kconfig            |   3 +-
 arch/powerpc/crypto/aes-gcm-p10-glue.c | 155 +++++++++++++++++++------
 2 files changed, 119 insertions(+), 39 deletions(-)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index b247f7ed973e..3a20bd98f0e7 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -31,7 +31,8 @@ config CRYPTO_AES_GCM_P10
 	select CRYPTO_ALGAPI
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
-	select CRYPTO_SIMD
+	select CRYPTO_AES
+	select CRYPTO_GCM
 	help
 	  AEAD cipher: AES cipher algorithms (FIPS-197)
 	  GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index f3417436d3f7..ca39ff991ae9 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -2,7 +2,7 @@
 /*
  * Glue code for accelerated AES-GCM stitched implementation for ppc64le.
  *
- * Copyright 2022- IBM Inc. All rights reserved
+ * Copyright IBM Corp. 2022, 2023, 2024, 2025, 2026
  */
 
 #include <linux/unaligned.h>
@@ -63,8 +63,10 @@ struct Hash_ctx {
 };
 
 struct p10_aes_gcm_ctx {
+	struct crypto_aead *fallback_tfm;
 	struct p10_aes_key enc_key;
-	u8 nonce[RFC4106_NONCE_SIZE];
+	u8 nonce[RFC4106_NONCE_SIZE] __aligned(16);
+	unsigned int simd_set_key;
 };
 
 static void vsx_begin(void)
@@ -173,8 +175,48 @@ static void finish_tag(struct gcm_ctx *gctx, struct Hash_ctx *hash, int len)
 		hash->Htable[i] ^= gctx->ivtag[i];
 }
 
+static int p10_aead_init(struct crypto_aead *tfm)
+{
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->fallback_tfm = crypto_alloc_aead("gcm(aes)", 0,
+					      CRYPTO_ALG_NEED_FALLBACK |
+					      CRYPTO_ALG_ASYNC);
+	if (IS_ERR(ctx->fallback_tfm))
+		return PTR_ERR(ctx->fallback_tfm);
+
+	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
+				crypto_aead_reqsize(ctx->fallback_tfm));
+	return 0;
+}
+
+static int rfc4106_init(struct crypto_aead *tfm)
+{
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->fallback_tfm = crypto_alloc_aead("rfc4106(gcm(aes))", 0,
+					      CRYPTO_ALG_NEED_FALLBACK |
+					      CRYPTO_ALG_ASYNC);
+	if (IS_ERR(ctx->fallback_tfm))
+		return PTR_ERR(ctx->fallback_tfm);
+
+	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
+				crypto_aead_reqsize(ctx->fallback_tfm));
+	return 0;
+}
+
+static void p10_aead_exit(struct crypto_aead *tfm)
+{
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (ctx->fallback_tfm)
+		crypto_free_aead(ctx->fallback_tfm);
+}
+
 static int set_authsize(struct crypto_aead *tfm, unsigned int authsize)
 {
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+
 	switch (authsize) {
 	case 4:
 	case 8:
@@ -188,19 +230,35 @@ static int set_authsize(struct crypto_aead *tfm, unsigned int authsize)
 		return -EINVAL;
 	}
 
-	return 0;
+	return crypto_aead_setauthsize(ctx->fallback_tfm, authsize);
 }
 
 static int p10_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			      unsigned int keylen)
 {
-	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
-	struct p10_aes_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(aead);
+	int ret = 0;
+
+	ctx->simd_set_key = 0;
+	if (crypto_simd_usable()) {
+		vsx_begin();
+		ret = aes_p10_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
+		vsx_end();
+		ctx->simd_set_key = !ret;
+	}
+
+	return ret ? -EINVAL : 0;
+}
+
+static int gcm_setkey(struct crypto_aead *aead, const u8 *key,
+		      unsigned int keylen)
+{
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	int ret;
 
-	vsx_begin();
-	ret = aes_p10_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
-	vsx_end();
+	ret = p10_aes_gcm_setkey(aead, key, keylen);
+
+	ret |= crypto_aead_setkey(ctx->fallback_tfm, key, keylen);
 
 	return ret ? -EINVAL : 0;
 }
@@ -208,8 +266,8 @@ static int p10_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 			     int assoclen, int enc)
 {
-	struct crypto_tfm *tfm = req->base.tfm;
-	struct p10_aes_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 	u8 databuf[sizeof(struct gcm_ctx) + PPC_ALIGN];
 	struct gcm_ctx *gctx = PTR_ALIGN((void *)databuf, PPC_ALIGN);
 	u8 hashbuf[sizeof(struct Hash_ctx) + PPC_ALIGN];
@@ -220,12 +278,26 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 	unsigned int cryptlen = req->cryptlen;
 	unsigned char ivbuf[AES_BLOCK_SIZE+PPC_ALIGN];
 	unsigned char *iv = PTR_ALIGN((void *)ivbuf, PPC_ALIGN);
-	int ret;
-	unsigned long auth_tag_len = crypto_aead_authsize(__crypto_aead_cast(tfm));
+	int ret = 0;
+	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
 	u8 otag[16];
 	int total_processed = 0;
 	int nbytes;
 
+	if (!crypto_simd_usable() || !ctx->simd_set_key || req->cryptlen < 64) {
+		struct aead_request *subreq = aead_request_ctx(req);
+
+		aead_request_set_tfm(subreq, ctx->fallback_tfm);
+		aead_request_set_callback(subreq, req->base.flags,
+					  req->base.complete, req->base.data);
+		aead_request_set_crypt(subreq, req->src, req->dst,
+					req->cryptlen, req->iv);
+		aead_request_set_ad(subreq, req->assoclen);
+
+		return enc ? crypto_aead_encrypt(subreq) :
+			     crypto_aead_decrypt(subreq);
+	}
+
 	memset(databuf, 0, sizeof(databuf));
 	memset(hashbuf, 0, sizeof(hashbuf));
 	memset(ivbuf, 0, sizeof(ivbuf));
@@ -260,6 +332,7 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 	if (ret)
 		return ret;
 
+	vsx_begin();
 	while ((nbytes = walk.nbytes) > 0 && ret == 0) {
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
@@ -268,7 +341,6 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(buf, src, nbytes);
 
-		vsx_begin();
 		if (enc)
 			aes_p10_gcm_encrypt(src, dst, nbytes,
 					    &ctx->enc_key, gctx->iv, hash->Htable);
@@ -283,13 +355,13 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 
 		total_processed += walk.nbytes;
 		ret = skcipher_walk_done(&walk, 0);
-	}
+		if (ret)
+			return ret;
 
-	if (ret)
-		return ret;
+		vsx_begin();
+	}
 
 	/* Finalize hash */
-	vsx_begin();
 	gcm_update(gctx->iv, hash->Htable);
 	finish_tag(gctx, hash, total_processed);
 	vsx_end();
@@ -305,11 +377,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 
 		if (crypto_memneq(otag, hash->Htable, auth_tag_len)) {
 			memzero_explicit(hash->Htable, 16);
-			return -EBADMSG;
+			ret = -EBADMSG;
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int rfc4106_setkey(struct crypto_aead *tfm, const u8 *inkey,
@@ -318,6 +390,10 @@ static int rfc4106_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 	int err;
 
+	err = crypto_aead_setkey(ctx->fallback_tfm, inkey, keylen);
+	if (err)
+		return err;
+
 	keylen -= RFC4106_NONCE_SIZE;
 	err = p10_aes_gcm_setkey(tfm, inkey, keylen);
 	if (err)
@@ -329,7 +405,14 @@ static int rfc4106_setkey(struct crypto_aead *tfm, const u8 *inkey,
 
 static int rfc4106_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
-	return crypto_rfc4106_check_authsize(authsize);
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+	int err;
+
+	err = crypto_rfc4106_check_authsize(authsize);
+	if (err)
+		return err;
+
+	return crypto_aead_setauthsize(ctx->fallback_tfm, authsize);
 }
 
 static int rfc4106_encrypt(struct aead_request *req)
@@ -373,18 +456,20 @@ static struct aead_alg gcm_aes_algs[] = {{
 	.maxauthsize		= 16,
 
 	.setauthsize		= set_authsize,
-	.setkey			= p10_aes_gcm_setkey,
+	.setkey			= gcm_setkey,
 	.encrypt		= p10_aes_gcm_encrypt,
 	.decrypt		= p10_aes_gcm_decrypt,
+	.init			= p10_aead_init,
+	.exit			= p10_aead_exit,
 
-	.base.cra_name		= "__gcm(aes)",
-	.base.cra_driver_name	= "__aes_gcm_p10",
+	.base.cra_name		= "gcm(aes)",
+	.base.cra_driver_name	= "aes_gcm_p10",
 	.base.cra_priority	= 2100,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct p10_aes_gcm_ctx)+
 				  4 * sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK,
 }, {
 	.ivsize			= GCM_RFC4106_IV_SIZE,
 	.maxauthsize		= 16,
@@ -392,19 +477,19 @@ static struct aead_alg gcm_aes_algs[] = {{
 	.setauthsize		= rfc4106_setauthsize,
 	.encrypt		= rfc4106_encrypt,
 	.decrypt		= rfc4106_decrypt,
+	.init			= rfc4106_init,
+	.exit			= p10_aead_exit,
 
-	.base.cra_name		= "__rfc4106(gcm(aes))",
-	.base.cra_driver_name	= "__rfc4106_aes_gcm_p10",
+	.base.cra_name		= "rfc4106(gcm(aes))",
+	.base.cra_driver_name	= "rfc4106_aes_gcm_p10",
 	.base.cra_priority	= 2100,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct p10_aes_gcm_ctx) +
 				  4 * sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
-	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK,
 }};
 
-static struct simd_aead_alg *p10_simd_aeads[ARRAY_SIZE(gcm_aes_algs)];
-
 static int __init p10_init(void)
 {
 	int ret;
@@ -412,21 +497,15 @@ static int __init p10_init(void)
 	if (!cpu_has_feature(CPU_FTR_ARCH_31))
 		return 0;
 
-	ret = simd_register_aeads_compat(gcm_aes_algs,
-					 ARRAY_SIZE(gcm_aes_algs),
-					 p10_simd_aeads);
-	if (ret) {
-		simd_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs),
-				      p10_simd_aeads);
+	ret = crypto_register_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
+	if (ret)
 		return ret;
-	}
 	return 0;
 }
 
 static void __exit p10_exit(void)
 {
-	simd_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs),
-			      p10_simd_aeads);
+	crypto_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
 }
 
 module_init(p10_init);
-- 
2.47.1

