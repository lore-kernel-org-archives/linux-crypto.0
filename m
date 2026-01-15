Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DAA32AAD3;
	Thu, 15 Jan 2026 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768478437; cv=none; b=f//3CyJfn0i0mLFuyBBzsVpXoPwiI+mUFY3lZkeF4cGEboWkUWZXI0qBLcwQvGwissBKI3o4gy+5OfznYPKNDzVHYGFMeVO4n2PzGhiFLlvZ9EFfjwK0/byZ14AbPgxbCTfD6kST2/DGNp24GHY501IlsdM4Jip1JbMJMRgwZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768478437; c=relaxed/simple;
	bh=IrDcVIEFoX5arzxEWsamWR6rcJsb8P339Zq6FJdyFW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkeywkH146+inYEQnNWjE1jr19NUZ8NCS0UQeSIXOfxv6Wmd5ptUJK27qLfN2WyTji4wn7dsim4SVYOOiEtUAsQtW/mkWUBJDtdOAMJe+sxEFM/gBpydF56IRPGEaiFSe4FUvhdCJ+8mBq5+nVkYq7ie5/HVn1pDT9WkcKGrIqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aC/MgrB6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aC/MgrB6"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60F37R9H014377;
	Thu, 15 Jan 2026 12:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UdmdKUKa6Y3NCBCy5
	+dA4vWR2iEVZE87rmhWS8SLsW0=; b=aC/MgrB6oqa9NxM0B0a1gKlb8QOYJospK
	3TiK5jm+qm2f5Ta22aMVmxBkH0jLdxaX3lbK7fYjJmnU14NeMjaGaotQOZPy3BiU
	aTgR4dkugamtw3FHrEOJb+BP6uMAK7eDFEn+sfFmiBpjIOMCxbptGJzvHj57hqT7
	U82P1aJNv8NcS6X29oj3LNLBOwiIgC718cUR47fwtzc5INvw5zeYKYo1wQxdM26w
	0hYuiIalKdCiOqadSPVGRinzKbNjB0DafWvg2GypMU3TF2bvr8hrE1V6CfLkzFpG
	cAOXq2aPH3ep2AqxzqJSxWyOOPjm5tlhFgjBtd+KCnQw+zqL1uL5g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6edxud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBKTsK014274;
	Thu, 15 Jan 2026 12:00:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm1fyfuux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:00:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FC0RXT11075922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:00:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 515962004F;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 340622004E;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
Received: from funtu2.aag-de.ibm.com (unknown [9.52.218.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 12:00:27 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v2 2/4] s390/pkey: Support new xflag PKEY_XFLAG_NOCLEARKEY
Date: Thu, 15 Jan 2026 13:00:24 +0100
Message-ID: <20260115120026.4286-3-freude@linux.ibm.com>
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
X-Proofpoint-GUID: wtmvzbxc9gQmj-6utVITZJcdluYLKVJm
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=6968d6e0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=Vg_ZLoUHXRvlLGpNDP8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA4NiBTYWx0ZWRfXyTl6QINf+aL5
 UvZyHs98jZMVBwJgmYuTxlDZvGydqdm8/vlZCHeZwPJnSLs/6sjcnUin/KOvvEYaVjDoi3QY3S0
 BfZRmbanEk6FksljBDHLMNUTJHE+gEb4KXQ7C+mAiJ6KY3GCR4V9fUPMZGBIFuHNeeyzrw9INir
 UGtGQKXLZQiXOfmEicIB973m9Y+7HHzsYdqinWhJwFCNz0fMf/QuoXtvQhMG6vK13XkrUYD7+zS
 fH4f+SSccHuOV+WLKBuwoM8uWKhofmlKY2FTioeXoj7CpbyO8XWPTD/Sl4Y3GuL11Sz8BZTjZ2H
 Sb4shkRKjHLeFHFrrV76OQH4ZQa+m1RXX5QcC6gMoCQE6FnusXkY7s3f0jZ6Mz4bN/zVXWdbSPm
 cBJa5PUxpnIudgqFk6HggoMAEAh3Fog90Bk0+XdV0noOrsNPOKmdkITUY2sJDgY6XfylPalHfCv
 RPtPKmy5B+xfLChvnow==
X-Proofpoint-ORIG-GUID: wtmvzbxc9gQmj-6utVITZJcdluYLKVJm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150086

Introduce a new xflag PKEY_XFLAG_NOCLEARKEY which when given refuses
the conversion of "clear key tokens" to protected key material.

Some algorithms (PAES, PHMAC) have the need to construct "clear key
tokens" to be used during selftest. But in general these algorithms
should only support clear key material for testing purpose. So now the
algorithm implementation can signal via xflag PKEY_XFLAG_NOCLEARKEY
that a conversion of clear key material to protected key is not
acceptable and thus the pkey layer (usually one of the handler
modules) refuses clear key material with -EINVAL.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
---
 arch/s390/include/asm/pkey.h     |  8 +++++++-
 drivers/s390/crypto/pkey_cca.c   |  5 +++++
 drivers/s390/crypto/pkey_ep11.c  |  5 +++++
 drivers/s390/crypto/pkey_pckmo.c | 12 +++++++++---
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pkey.h b/arch/s390/include/asm/pkey.h
index b7b59faf16f4..0af5ac4f646b 100644
--- a/arch/s390/include/asm/pkey.h
+++ b/arch/s390/include/asm/pkey.h
@@ -21,7 +21,8 @@
  * @param keylen size of the key blob in bytes
  * @param protkey pointer to buffer receiving the protected key
  * @param xflags additional execution flags (see PKEY_XFLAG_* definitions below)
- *	  As of now the only supported flag is PKEY_XFLAG_NOMEMALLOC.
+ *	  As of now the only supported flags are PKEY_XFLAG_NOMEMALLOC
+ *	  and PKEY_XFLAG_NOCLEARKEY.
  * @return 0 on success, negative errno value on failure
  */
 int pkey_key2protkey(const u8 *key, u32 keylen,
@@ -38,4 +39,9 @@ int pkey_key2protkey(const u8 *key, u32 keylen,
  */
 #define PKEY_XFLAG_NOMEMALLOC 0x0001
 
+/*
+ * Do not accept a clear key token as source for a protected key.
+ */
+#define PKEY_XFLAG_NOCLEARKEY 0x0002
+
 #endif /* _KAPI_PKEY_H */
diff --git a/drivers/s390/crypto/pkey_cca.c b/drivers/s390/crypto/pkey_cca.c
index d4550d8d8eea..9bfb518db893 100644
--- a/drivers/s390/crypto/pkey_cca.c
+++ b/drivers/s390/crypto/pkey_cca.c
@@ -390,6 +390,11 @@ static int cca_clr2key(const struct pkey_apqn *apqns, size_t nr_apqns,
 	int i, len, rc;
 	u32 xflags;
 
+	if (pflags & PKEY_XFLAG_NOCLEARKEY) {
+		PKEY_DBF_ERR("%s clear key but xflag NOCLEARKEY\n", __func__);
+		return -EINVAL;
+	}
+
 	xflags = pflags & PKEY_XFLAG_NOMEMALLOC ? ZCRYPT_XFLAG_NOMEMALLOC : 0;
 
 	/* check keytype, subtype, clrkeylen, keybitsize */
diff --git a/drivers/s390/crypto/pkey_ep11.c b/drivers/s390/crypto/pkey_ep11.c
index 654eed20d0d9..f99c19323f3d 100644
--- a/drivers/s390/crypto/pkey_ep11.c
+++ b/drivers/s390/crypto/pkey_ep11.c
@@ -358,6 +358,11 @@ static int ep11_clr2key(const struct pkey_apqn *apqns, size_t nr_apqns,
 	int i, len, rc;
 	u32 xflags;
 
+	if (pflags & PKEY_XFLAG_NOCLEARKEY) {
+		PKEY_DBF_ERR("%s clear key but xflag NOCLEARKEY\n", __func__);
+		return -EINVAL;
+	}
+
 	xflags = pflags & PKEY_XFLAG_NOMEMALLOC ? ZCRYPT_XFLAG_NOMEMALLOC : 0;
 
 	/* check keytype, subtype, clrkeylen, keybitsize */
diff --git a/drivers/s390/crypto/pkey_pckmo.c b/drivers/s390/crypto/pkey_pckmo.c
index 793326c4c59a..ea774ab89180 100644
--- a/drivers/s390/crypto/pkey_pckmo.c
+++ b/drivers/s390/crypto/pkey_pckmo.c
@@ -215,7 +215,8 @@ static int pckmo_verify_protkey(const u8 *protkey, u32 protkeylen,
 }
 
 static int pckmo_key2protkey(const u8 *key, u32 keylen,
-			     u8 *protkey, u32 *protkeylen, u32 *protkeytype)
+			     u8 *protkey, u32 *protkeylen, u32 *protkeytype,
+			     u32 xflags)
 {
 	struct keytoken_header *hdr = (struct keytoken_header *)key;
 	int rc = -EINVAL;
@@ -266,6 +267,11 @@ static int pckmo_key2protkey(const u8 *key, u32 keylen,
 		struct clearkeytoken *t = (struct clearkeytoken *)key;
 		u32 keysize;
 
+		if (xflags & PKEY_XFLAG_NOCLEARKEY) {
+			PKEY_DBF_ERR("%s clear key token but xflag NOCLEARKEY\n",
+				     __func__);
+			goto out;
+		}
 		if (keylen < sizeof(*t) ||
 		    keylen < sizeof(*t) + t->len)
 			goto out;
@@ -406,10 +412,10 @@ static int pkey_pckmo_key2protkey(const struct pkey_apqn *_apqns,
 				  size_t _nr_apqns,
 				  const u8 *key, u32 keylen,
 				  u8 *protkey, u32 *protkeylen, u32 *keyinfo,
-				  u32 _xflags __always_unused)
+				  u32 xflags)
 {
 	return pckmo_key2protkey(key, keylen,
-				 protkey, protkeylen, keyinfo);
+				 protkey, protkeylen, keyinfo, xflags);
 }
 
 static int pkey_pckmo_gen_key(const struct pkey_apqn *_apqns, size_t _nr_apqns,
-- 
2.43.0

