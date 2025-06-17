Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D502E06D9;
	Tue, 17 Jun 2025 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167891; cv=none; b=shmNYBUbcRxdbpY+DpxlrOl5rKck+eiTi0I8rLgrZyMjrHPqWhy2r2GB93VVEF0r5YNn78HDulYnsxx35QB3seRw21uCwZfGezSk+TpanFfbuxKGiHwK9tlq4TmNRNRK0a5RiCAJmIgGHMs+X/cbWtY7uskuy7pi/7lVjC/3iJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167891; c=relaxed/simple;
	bh=8cIgIum0jmv/ShMgBhHPZC5lT1rtO0t8hbJd6fgvTnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1Xcn6bEfTU88SjklrJKMH2eMovSWCSzvS1gdXS5rxUSAMK3kHW9NX61ItltnmkR2fRTvQ7kuTbteu3QwRWqLivXVlJk01TsoL1O2PZAKq1hekUqe8e2KiD3C3YFnJ5B3yZA/F/F2ByW6RF6L4qEVpEG0olv9ZB3Mvou6tkwxI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PJyBq7Ej; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PJyBq7Ej"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H82YF0019190;
	Tue, 17 Jun 2025 13:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=T8NzjHz2qWHkHASQ9
	Qu31S7FpavpHX6unso/xWiyLSw=; b=PJyBq7EjmZr/uj38UesAZrT1J8weIH7w7
	+NtLUMyUwOKgc9gROWYiEfrv2mnffSBH4UZpvEjf+JzyUebY0Pd+WwY3xSJDnuHs
	EiULybqMv2tLqv00makeu5JKyI4fOarclS8Zqg9loZZP1KpbNijI95v7u6qZ8I6a
	rzsunDzHTMEe4CRcB3h8p9dS3YtXpJCA1SIa7m4LBJJv3WA8bjufvLHmBgM0XEGr
	PT+bwq3nkQ/nrZOUFqYljbgQ9kMHmCfmG5zUhmDOqsHp21MapSF4p6cTwQ9x7yKV
	XXm1yurrJ1ylIiT0qdWwc6N+m/an95XtRSAa+9EX0tLgj0TcIly4Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790te0rae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55HD0K9I005481;
	Tue, 17 Jun 2025 13:44:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 479mwm3n49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55HDif9M52035902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 13:44:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C582D2004B;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 738C02004D;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.71.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Jun 2025 13:44:41 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v12 1/6] crypto: ahash - make hash walk functions from ahash.c public
Date: Tue, 17 Jun 2025 15:44:35 +0200
Message-ID: <20250617134440.48000-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617134440.48000-1-freude@linux.ibm.com>
References: <20250617134440.48000-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MpX9xi3NJo9CZLYB_V6txk9QmpmvamYa
X-Proofpoint-GUID: MpX9xi3NJo9CZLYB_V6txk9QmpmvamYa
X-Authority-Analysis: v=2.4 cv=c92rQQ9l c=1 sm=1 tr=0 ts=6851714e cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=0o2RBGdjaH6X1lB8s1gA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDEwNSBTYWx0ZWRfX2XAaVdYkQ2iu 3ftqFATgsSWQ3gdR3uvnN7ThBzuqp/GGTk6lzFI3aT6tnhohenPFaM2oVD0HBgKxllKl0bE9O8d 4tMBZEWaefqp5LxxG+u8q9VS1inGg3DnPA7TdGMxNGgY2l/d6/d5jecnjc+toPCoQfkzTvs9R8n
 x+VMoL2zFdvBw9Km8852ZQErmP3qp/vKUZ8D0Jp7qd3LjYEELeDAt+vUrnpCsr4gIx+OlDP0LWO u4oLT2NTW8jar+6EYCZbzkvdVWiV5ova7aba9eSUnJEj2wcgZGGjhBXZTSZfrAdxOpuKfleRyfM EckggvkZejbxGzaUCZWqmIU/PmfcmRMGZWyKh3w0nYmra+hDIE4lLfXoq4vEnysFzIUnXy1LfCe
 sSuPaNfttS5RTBRnyxCgRZBaJHpNaN6O1DlCjcVp6y/1zBozdpyuCrcW85NG7yXfX+iybogp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506170105

Make the hash walk functions
  crypto_hash_walk_done()
  crypto_hash_walk_first()
  crypto_hash_walk_last()
public again.
These functions had been removed from the header file
include/crypto/internal/hash.h with commit 7fa481734016
("crypto: ahash - make hash walk functions private to ahash.c")
as there was no crypto algorithm code using them.

With the upcoming crypto implementation for s390 phmac
these functions will be exploited and thus need to be
public within the kernel again.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Holger Dengler <dengler@linux.ibm.com>
---
 crypto/ahash.c                 | 26 +++++---------------------
 include/crypto/internal/hash.h | 23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index bd9e49950201..0809ef102ef8 100644
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
 static int ahash_def_finup(struct ahash_request *req);
 
 static inline bool crypto_ahash_block_only(struct crypto_ahash *tfm)
@@ -112,8 +99,8 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 	return hash_walk_next(walk);
 }
 
-static int crypto_hash_walk_first(struct ahash_request *req,
-				  struct crypto_hash_walk *walk)
+int crypto_hash_walk_first(struct ahash_request *req,
+			   struct crypto_hash_walk *walk)
 {
 	walk->total = req->nbytes;
 	walk->entrylen = 0;
@@ -133,8 +120,9 @@ static int crypto_hash_walk_first(struct ahash_request *req,
 
 	return hash_walk_new_entry(walk);
 }
+EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
-static int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
+int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 {
 	if ((walk->flags & CRYPTO_AHASH_REQ_VIRT))
 		return err;
@@ -160,11 +148,7 @@ static int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 
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
index 0f85c543f80b..ef573545c85d 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -30,6 +30,20 @@
                 __##name##_req, (req))
 
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
@@ -61,6 +75,15 @@ struct crypto_shash_spawn {
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

