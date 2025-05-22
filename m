Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED712264610;
	Thu, 22 May 2025 08:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904285; cv=none; b=oo4t34ilWzu5BSKP9Kpx2rYDPe5f5Enf76nlMaYrqEgfyeit/PYlwgFhTSxSfUIWtyYDhMWC1N42R6IIUBaywozZ+WP9Lt8/ypRO30fPd7Ye6VHtfD+28P2eDqNBQiJGS+UoF/+II4vWP2h0B/kftNJ3Ogtla8H/Mqq5Rw4MTws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904285; c=relaxed/simple;
	bh=5MZ0nEv447ugQAoYhKr8xAaA4YfX1lGE5CiGs4ClXbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VegTevit6P0SorddfOFjrK/wJarn2BJaDDVQ1uUp5ghjRgRogC7ryAukWc0xxFDpDitJW5WAaETaxbkSJ2lj1I1Q2sd8jiT3aAPVWWbs/zMhLDA4NkAcJHuHFNbc/IayX5FvbkW6VzjmRBpEeEL26gKwC3dIpJFsUHBpSDH+kGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PGp4QIiT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PGp4QIiT"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6jkZ1002081;
	Thu, 22 May 2025 08:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=G2yIVL1cONtV4lLFp
	e3sh1+DGOYdykgCCcAOVpQGFKU=; b=PGp4QIiTsFzAklcuiOFOfc3qsbPCFFg3S
	dz4Gp/nOZRr9X2ie4+EryLCO7O7iynAOMOh8LNNeQg4so7lmRRtTXuv0nZn5JAth
	QkJZlSE7egrLWHJQ2HMqeFJ6eAAUomQtYlMq15QpxKsLREjmcoLSLPqVcmzBpW1w
	YQDJPPHx7xthnGsZVobfTvzOkPR4k3ccCtKp2A77YX5+x/ZgVLhuw+HuDACGBxzl
	0r0Qtle9occLYf7kIfHqwKmmXSn+hGADVFJNfZWPIJq2OMTFNwTbKJsoVUERpWHY
	vC0LPvUtGyGJoXTagDXrDfmcDoL++fYeghKj8/losKvqtsAeq0Eew==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh7340e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M51lsg032024;
	Thu, 22 May 2025 08:58:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwmq8nyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:57:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M8vuMZ31851154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:57:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2085120043;
	Thu, 22 May 2025 08:57:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC4D32004D;
	Thu, 22 May 2025 08:57:55 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 08:57:55 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com
Subject: [PATCH v11 1/6] crypto: ahash - make hash walk functions from ahash.c public
Date: Thu, 22 May 2025 10:57:50 +0200
Message-ID: <20250522085755.40732-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250522085755.40732-1-freude@linux.ibm.com>
References: <20250522085755.40732-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfX9o/vC8icQRd/ o7WOyaC0YCziD/wYi7DEi0ToUMkSM9oBkosBb+5ogBBG7QUPKX3tsaC14e7dIkypi+QByvwhHOD LasTlJkQGzyZRfeM5OaoG5mO/IWZ2UhIYZ61xaGQ4brpbrbMqPM7eD0IZWWCUZAP5iE2XPeb95x
 Mivx6a2M6M4GlyAYj0eqwvTb1CZHu9S7lWU+JbJM60nJ91iw9X3k35z7EPN3BczPt8M8AolBubd OnhxNBuqnhaW31zOtG4fWGL8A/HYFum0A6601AaAB/WXgI8/PwxQpQkqKwuWySJ2H/8APKDF/Cy IyrqYeE49t5ve70nPPwbygAQdqp5vbMRg/aR4wB5jaKIw/zaoejMTXHWuOxKWAwUEyBbWSO0+aV
 qxjKwpOA8itErm72uq11BfelpGKrE9+nfFCQQBxDye3Y+qQ4ly8pQmE0I0stowLb4OAHl0QF
X-Proofpoint-GUID: 5l9x6LWi61kq4KiraqhYdXYqYqqHn5tf
X-Proofpoint-ORIG-GUID: 5l9x6LWi61kq4KiraqhYdXYqYqqHn5tf
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682ee718 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=JHhC2R5EPSX9PecNMUYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=973
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220086

Make the hash walk functions
  crypto_hash_walk_done()
  crypto_hash_walk_first()
  crypto_hash_walk_last()
public again.
These functions had been removed from the header file
include/crypto/internal/hash.h with commit 7fa481734016
("crypto: ahash - make hash walk functions private to ahash.c")
as there was no crypto algorithm code using them.

With the upcoming crypto implementation for s390 phash
these functions will be exploited and thus need to be
public within the kernel again.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 crypto/ahash.c                 | 26 +++++---------------------
 include/crypto/internal/hash.h | 23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9f57b925b116..3344c4fee526 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -29,19 +29,6 @@
 
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
-struct crypto_hash_walk {
-	const char *data;
-
-	unsigned int offset;
-	unsigned int flags;
-
-	struct page *pg;
-	unsigned int entrylen;
-
-	unsigned int total;
-	struct scatterlist *sg;
-};
-
 struct ahash_save_req_state {
 	struct list_head head;
 	struct ahash_request *req0;
@@ -92,8 +79,8 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 	return hash_walk_next(walk);
 }
 
-static int crypto_hash_walk_first(struct ahash_request *req,
-				  struct crypto_hash_walk *walk)
+int crypto_hash_walk_first(struct ahash_request *req,
+			   struct crypto_hash_walk *walk)
 {
 	walk->total = req->nbytes;
 	walk->entrylen = 0;
@@ -113,8 +100,9 @@ static int crypto_hash_walk_first(struct ahash_request *req,
 
 	return hash_walk_new_entry(walk);
 }
+EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
-static int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
+int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 {
 	if ((walk->flags & CRYPTO_AHASH_REQ_VIRT))
 		return err;
@@ -140,11 +128,7 @@ static int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 
 	return hash_walk_new_entry(walk);
 }
-
-static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
-{
-	return !(walk->entrylen | walk->total);
-}
+EXPORT_SYMBOL_GPL(crypto_hash_walk_done);
 
 /*
  * For an ahash tfm that is using an shash algorithm (instead of an ahash
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 485e22cf517e..195d6aeeede3 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -12,6 +12,20 @@
 #include <crypto/hash.h>
 
 struct ahash_request;
+struct scatterlist;
+
+struct crypto_hash_walk {
+	const char *data;
+
+	unsigned int offset;
+	unsigned int flags;
+
+	struct page *pg;
+	unsigned int entrylen;
+
+	unsigned int total;
+	struct scatterlist *sg;
+};
 
 struct ahash_instance {
 	void (*free)(struct ahash_instance *inst);
@@ -43,6 +57,15 @@ struct crypto_shash_spawn {
 	struct crypto_spawn base;
 };
 
+int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
+int crypto_hash_walk_first(struct ahash_request *req,
+			   struct crypto_hash_walk *walk);
+
+static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
+{
+	return !(walk->entrylen | walk->total);
+}
+
 int crypto_register_ahash(struct ahash_alg *alg);
 void crypto_unregister_ahash(struct ahash_alg *alg);
 int crypto_register_ahashes(struct ahash_alg *algs, int count);
-- 
2.43.0

