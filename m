Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8950C323F7A;
	Thu, 25 Sep 2025 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758839834; cv=none; b=PvCfjCW+YemHLyah/POt4HQLLwLBinHbFbxjR8Nhr+h6IohyMiIxHSjonFNzh7xVx4eiLnO+nOcSFaak+XDPas2P7Mw3KH7zpfMIy1pLzrJhkiD5GoGDmiM+Zk1ZBXXj/Eydh2/vAsFUtjlXvF7OhiTVa6Mxre99oJaAvUM3NHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758839834; c=relaxed/simple;
	bh=HxwYsUkXekwK8672F34j4o5hHpRLRgvnBqtRsFvVCNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c4ehId0rFnkdVrzS+lFTWssEmbEqdSH258mw1Ri/N22E4KoCkfSopqy1dtJk+WftX9J3JmiF8nZEWy+COCaQnN8hTpMf2qIJCPOzvNeKsSfzJSSGAjUjSqAYJ9VCkjyfABihwvnlzyNu4nIMnIPTEe9hX7ISahNT9wp3eZ/7HNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JsCiFT/5; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JsCiFT/5"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PMPSnN027686;
	Thu, 25 Sep 2025 22:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=QcuASX6IaoM2io3PjC9a4EWZCXLWp
	mZqlVKNev2x7nA=; b=JsCiFT/57THM4V+8T8wMlPkYjwiUPGtrXzqqiFdOI4VBy
	wiC7fNPjWVYGB3YoDyvK3JD2BlZv0vTUiDg0sg0CqMCMih5fCRCfQdH+3q9y/SZG
	Rb4SvBtOl6H2ySbBwyCofcbu1f0ZsVA/XZgW4/fy2iE7EnxMcqZl7irN5XmreXyX
	2Ur0jXWixui3pgGgww2btGXEgiADaUyoJfZWaRIsEB3kW1ieWZiza5EuyjKKfB7l
	krO/bC/Nwi6k23XdTzOCfEnbubyM+zsdogeRuOGCnEjEF8wjuW8CGup4nedGDZjI
	KU4Tz6PVXZBEk+AY9P7coryTh5jR/yi0bynuO290A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49degjg04v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 22:32:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58PL1dcF025730;
	Thu, 25 Sep 2025 22:32:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49dd9tjhjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 22:32:00 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58PMVxHO023089;
	Thu, 25 Sep 2025 22:31:59 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 49dd9tjhj2-1;
	Thu, 25 Sep 2025 22:31:59 +0000
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: saeed.mirzamohammadi@oracle.com, smueller@chronox.de,
        vegard.nossum@oracle.com
Subject: [PATCH] crypto: pcrypt - Fix recursive instantiation by using proper instance naming
Date: Thu, 25 Sep 2025 15:31:24 -0700
Message-ID: <20250925223125.515570-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_02,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2509250207
X-Proofpoint-GUID: gF4CcgfOpOM-Wg3JxZ3ws4s6Ux0SdxAv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDIwNyBTYWx0ZWRfXzWYnXj9nmvas
 k8gbkQ7jjaJ9OFZPhojNBnUfCyj3JmrKLaSHjvjSJoncr+hIgg0P04FLwPWyaNjPHW1oAU7S/ej
 w4HLLwh5F/lO9FDxMm6CxV6IvViHrCj/h6mGZz4eO5Z/1rloz0DhCCLdU83GTSes89Wu7wx8yoH
 4orTTObivvHlLfGJWtexO+6cXmOh2GXL1PG64HtezYzpmkLOd8AIqRCIVzC8plY65irIVgEiTjr
 K5HFAHvWhUVWLUxFJt8Imck6SvUEYtED5HFfbJVIvsjlW4ALb6cOjCqbb3MX4WcNloSbHZ0PrkA
 py3jjWRUhGk3mTcdPE5eC7I3d/FFXM5WIn5SURiUrwZD+2BSvrMxi/l1Kg7ZfP94R9t1qzO9Sym
 fSgtTGLDrxuPcADHkXfGEW21oqXx1PPGTAcc53zog1U+STJFCbo=
X-Proofpoint-ORIG-GUID: gF4CcgfOpOM-Wg3JxZ3ws4s6Ux0SdxAv
X-Authority-Analysis: v=2.4 cv=H4jWAuYi c=1 sm=1 tr=0 ts=68d5c2e0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=kZmX_PnipvbHtk_YSgsA:9
 cc=ntf awl=host:13622

The pcrypt template recursively instantiates itself because it copies
the child algorithm's cra_name directly, causing naming collisions with
the larval instance. When aead_register_instance() fails with -EEXIST,
the larval wait mechanism re-runs the lookup and finds the pcrypt instance
instead of the real child algorithm, leading to pcrypt(pcrypt(...))
recursion.

Fix by using crypto_inst_setname() instead of memcpy, ensuring pcrypt
instances are named "pcrypt(<child>)" rather than reusing the child's name.
This eliminates the naming collision that triggers the re-lookup mechanism.

Also apply the same fix to cryptd for consistency, even though it doesn't
exhibit the same recursion issue.

To reproduce:
python -c "import socket; socket.socket(socket.AF_ALG,
socket.SOCK_SEQPACKET, 0).bind(('aead', 'pcrypt(ccm(aes))'))"
...
OSError: [Errno 36] File name too long

Before the patch (/proc/crypto):
name  : ccm(aes)
driver: pcrypt(pcrypt(...(pcrypt(ccm_base(ctr-aes-aesni,cbcmac(aes-aesni))))...))
[and 9 other ccm(aes) instances.]

After the patch (/proc/crypto):
name  : pcrypt(ccm(aes))
driver: pcrypt(ccm_base(ctr-aes-aesni,cbcmac(aes-aesni)))

Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
Fixes: 4e0958d19bd8 ("crypto: cryptd - Add support for skcipher")
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Closes: https://lore.kernel.org/linux-crypto/4c0e7a68-254e-4f71-a903-952415c609d9@oracle.com
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 crypto/cryptd.c | 9 ++++-----
 crypto/pcrypt.c | 8 ++++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 31d022d47f7a0..b3342cb840d15 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -210,12 +210,11 @@ static void cryptd_type_and_mask(struct crypto_attr_type *algt,
 static int cryptd_init_instance(struct crypto_instance *inst,
 				struct crypto_alg *alg)
 {
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "cryptd(%s)",
-		     alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
+	int err;
 
-	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+	err = crypto_inst_setname(inst, "cryptd", alg);
+	if (err)
+		return err;
 
 	inst->alg.cra_priority = alg->cra_priority + 50;
 	inst->alg.cra_blocksize = alg->cra_blocksize;
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 7fc79e7dce44a..78f6cdc5fb551 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -224,11 +224,11 @@ static void pcrypt_free(struct aead_instance *inst)
 static int pcrypt_init_instance(struct crypto_instance *inst,
 				struct crypto_alg *alg)
 {
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "pcrypt(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
+	int err;
 
-	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+	err = crypto_inst_setname(inst, "pcrypt", alg);
+	if (err)
+		return err;
 
 	inst->alg.cra_priority = alg->cra_priority + 100;
 	inst->alg.cra_blocksize = alg->cra_blocksize;
-- 
2.50.1

