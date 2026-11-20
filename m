Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795189160;
	b=oOB1IG7/H43/Ezm4a3tAoPstsfdVLcgJgTU2h9zpif7YbwQ+br/k2vWtx6sEvMzKs/Dd
	 PfpkDiOLp8WmP8YDGpEkeJeMpNxSFk9N7MVLH51nwavHJknIe1R/BU8lwigtCqZavtcI+
	 z3sPJwS9Gat6k1UleNaTG8fAt8UmzR2QM4i1VClJ39j+1+H65Xp9RB1RVVD8p8hTYbDVk
	 5fKJPi2nmd11ljD2Z9RDIj4EF1DAdpRR5qX0xfDxyZB+zNa3qxBnnNKiYDLgUr3R/f3g8
	 RVcg62yrYR8BphF9mvcCV7PJPpms3ofhTe86zPrCrkh7SwlwecxftPdHAw77JW4XXag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795189160;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=w76addurpn2wtfLB+4uKHNexN3ZTDY39p20Lfkff1Lg=;
	b=WoCvJnSg3olrQmnRzz2tThxoQh9MWP+LqBnaHPxHGl9TWvGW7g3grGUt9eoJgBhO5xoO
	 1LnbIaI6r/G03viRwdkm3UkMBDIm0V3fVAM2BUnnFRtPVA0k0YSbGGnll10TrCvOouRoC
	 xMxuqXi7gPokCsuLob/ZZal1v6LAK89PSWsM7xGN1uHM0JUeEx5kSxw02I8gGLaktmPAt
	 WdNYXvq75ibwI//Q5ZORaFh4bIClNcmJopgVEepgQ7BfjDvo1g3pIuy3E8yIg4O2OR1P4
	 VR+tkI+/M1lFkP6wM2Bq9eCMO4vguPXvbJ8kXfgGIYAXXFFrgSE/AOKBC/Ez5hzwMJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=nY6nxmWD;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7F606A320;
	Fri, 20 Nov 2026 15:39:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37C7F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=nY6nxmWD
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKEuFP43386308;
	Fri, 20 Nov 2026 15:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=w76addurpn2wtfLB+4uKHNexN3ZTDY39p20Lfkff1
	Lg=; b=nY6nxmWDmcCiGy5X9ZT1yEj7CgUWY46rXgbwWqWP9vB8+0WeyWRVQANjZ
	0sXSfkyFVINlgmnBHHTcwKOMyh2mE11OiH0iB4V/CMkZUo22mwrE99RSf3OJiVkL
	q6hEm+l0R6yFmglPIuvwbksFjiYmKx42knuaHuaNmX/cmYeeerDQ9+pS1Sn1n43H
	fqPlEhxVrxUAw2PaotsG+1glbfjSw7zd1I0RYbV6cVusBVr+KkhwkO5OjWXueARY
	h4x1258DBMIkmqoER/4aSCenPvHojn9Z9OH7xhsjY1r0LmRBms8n+nMaxUSGQco/
	QEEZvek90KP7B46NApd4fDteRrmFw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105thdxv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 15:38:59 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKEo2jA1389309;
	Fri, 20 Nov 2026 15:38:59 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j1bb5mws7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 15:38:59 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AKFc6UM26673850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 15:38:06 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AA1158056;
	Fri, 20 Nov 2026 15:38:57 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EDE058052;
	Fri, 20 Nov 2026 15:38:56 +0000 (GMT)
Received: from ltcden12-lp4.ltc.tadn.ibm.com (unknown [9.5.7.39])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Nov 2026 15:38:56 +0000 (GMT)
From: Danny Tsen <dtsen@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au, leitao@debian.org,
        nayna@linux.ibm.com, appro@cryptogams.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: [PATCH] crypto: powerpc/p10-aes-gcm - Fix IPsec stall on bond failover
Date: Fri, 20 Nov 2026 10:08:56 -0500
Message-ID: <20261120150856.7039-1-dtsen@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=IouL47/g c=1 sm=1 tr=0 ts=6b006993 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=vHEsa_ci47n734hVdoYA:9
X-Proofpoint-ORIG-GUID: Sep--9Vz2DZV9Y1AemP9mTMl0g57JzDC
X-Proofpoint-GUID: Sep--9Vz2DZV9Y1AemP9mTMl0g57JzDC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA2MSBTYWx0ZWRfX6kHqno09eSCA
 NhhvdSYYAZ7nY3TpfgBJp4iEWpSQsA8BiYISwlEpKQATpSoAsA2KrJuLeCiNxf0EaKPynMs0zlY
 /KnyWu5GZ78tTM7oxzoCMJTz9ZyHMntaXuCNRuxY4NaCvseJVkKpXNWkauGEUWYlNJ2E7e7841T
 GBlIE2UJfClmpys6uIVQKakJTyGICvCkn/bE1z6J5L+pO+EyY3ezg3viuj1v54XqcncO0aTuHyH
 tyFupTHIAkPuqzGwRO+tHeilhDT/WZbTY5ErZaHXkJ3VHMEToERZ7QaQ1MvRoMdHtyLpFyvOZjG
 gvy7XbdpCVqReI/FI57cdG3+gX1QLq3o5L7ddSXpFFwgFbGRt6/8PxSsmdWfuA7S75KzsnCN2qi
 GvBmtpTV0TEgg+e3BrhjH1CDUPCC766vhkZLco8hCLrdY8X/UKMUSmw2d01IaI5qEGO6rBD7b6C
 TqQxY/PJHqScGnbwB4g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA2MSBTYWx0ZWRfX//zq61Xz1gIy
 HBl1mv87UjlqsLP/Lq9lCN3aSTcWQbNXNFutdGnRCXH2t5fI+sO3oLDhEV7rffrZsxEINCCqjff
 dG+68dyNXKj7QnOiQH6qXvzYD7Uap80=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 phishscore=0 clxscore=1011 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200061

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

Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
---
Tested with tcrypt.ko (including the self-tests) and with IPsec traffic
across a bond failover. TCP throughput no longer drops to zero.

 arch/powerpc/crypto/aes-gcm-p10-glue.c | 143 ++++++++++++++++++-------
 1 file changed, 107 insertions(+), 36 deletions(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index f3417436d3f7..13352b838432 100644
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
@@ -63,8 +63,12 @@ struct Hash_ctx {
 };
 
 struct p10_aes_gcm_ctx {
+	struct crypto_aead *fallback_tfm;
 	struct p10_aes_key enc_key;
-	u8 nonce[RFC4106_NONCE_SIZE];
+	u8 nonce[RFC4106_NONCE_SIZE] __aligned(16);
+	unsigned int keylen;
+	u8 key[AES_MAX_KEYLENGTH] __aligned(16);
+	unsigned int simd_set_key;
 };
 
 static void vsx_begin(void)
@@ -173,6 +177,40 @@ static void finish_tag(struct gcm_ctx *gctx, struct Hash_ctx *hash, int len)
 		hash->Htable[i] ^= gctx->ivtag[i];
 }
 
+static int p10_aead_init(struct crypto_aead *tfm)
+{
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->fallback_tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_NEED_FALLBACK);
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
+	ctx->fallback_tfm = crypto_alloc_aead("rfc4106(gcm(aes))", 0, CRYPTO_ALG_NEED_FALLBACK);
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
 	switch (authsize) {
@@ -194,13 +232,34 @@ static int set_authsize(struct crypto_aead *tfm, unsigned int authsize)
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
+		ctx->simd_set_key = 1;
+		if (ret)
+			ctx->simd_set_key = 0;
+	}
+
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
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
@@ -208,8 +267,8 @@ static int p10_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
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
@@ -220,12 +279,24 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
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
@@ -260,6 +331,7 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 	if (ret)
 		return ret;
 
+	vsx_begin();
 	while ((nbytes = walk.nbytes) > 0 && ret == 0) {
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
@@ -268,7 +340,6 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(buf, src, nbytes);
 
-		vsx_begin();
 		if (enc)
 			aes_p10_gcm_encrypt(src, dst, nbytes,
 					    &ctx->enc_key, gctx->iv, hash->Htable);
@@ -283,13 +354,13 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 
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
@@ -305,11 +376,11 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 
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
@@ -318,6 +389,10 @@ static int rfc4106_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 	int err;
 
+	err = crypto_aead_setkey(ctx->fallback_tfm, inkey, keylen);
+	if (err)
+		return err;
+
 	keylen -= RFC4106_NONCE_SIZE;
 	err = p10_aes_gcm_setkey(tfm, inkey, keylen);
 	if (err)
@@ -373,18 +448,20 @@ static struct aead_alg gcm_aes_algs[] = {{
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
@@ -392,19 +469,19 @@ static struct aead_alg gcm_aes_algs[] = {{
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
@@ -412,21 +489,15 @@ static int __init p10_init(void)
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

