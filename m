Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DF7252912;
	Mon, 23 Jun 2025 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684730; cv=none; b=JIV/XAbzOoKjSnoKHRvxyH1x5lPMca5K6j39hTvOj6LoasnjcCkMGCoiB/L6BmrvZmXAmp5EHb+mix09tx3bXkh4vnJZ8I8vCw+SGmG2QDpVzQ6aWqwx/ZoWTBIxeEJTF1ZdJtVZ1H7imSG6MW5knpSuzBkhUrqS2lNexF5ewYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684730; c=relaxed/simple;
	bh=ZEvVKr1fw4SqRYALlAyjNhD0pRFYu2CAbdCbtackT7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bI+qGujx+fgTXBDXYTzfPKz6zPRHrNMYh4Wd7qy8AhSNNF2iby6xb9adBTJWEvjfw+VefxfrsqUHU3lPYns8GpUhaVm27kpgYH7VLxwpucybwgZhszhXTbHigKLHJBnFqyRT7DC4UVa7SIrN4wVUFMREiV8VjkaYpYhYf7JvEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SxBIbubf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SxBIbubf"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NBAhvR009021;
	Mon, 23 Jun 2025 13:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=y09d/LFHtaUMHvnG+
	FYVHOuZNJKQNfX/KMoPl7iXM4A=; b=SxBIbubfNJB8s3COlJv6FIboQzN9VGH9G
	j8lOzKRx/WtRkwqIqlJ39uXoCMohujfIr0dn+JVVbP18EMj8tVFXBnOtkliCo2PC
	YWTqVMX663reAdmxmKd9uocEC7dJT465PSKHEYtEKKZyEugedgyn0/0pLFAHNRvg
	ft0512LBs6ubkoWpcGcsgzV4s2Z3/WNxXmpsCFfu9HFo1dh/g7fKb1XfKBWd6SdX
	QsP/6eMGIqzLC4+h83cf7pi2EOayNPOkHQAeFHUs+07aWz3+kGsV5IZm2FuAhd0r
	2Sjgu2QiVayDuT2NNueoGGAkor8Uqe8HHBlKauHmRIsRPZME5Mbcg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dj5tj92r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55NB21Sf015025;
	Mon, 23 Jun 2025 13:18:42 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47e72tf01t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:42 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55NDIaPl25625154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 13:18:36 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F64A5805E;
	Mon, 23 Jun 2025 13:18:41 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1E5C58043;
	Mon, 23 Jun 2025 13:18:40 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Jun 2025 13:18:40 +0000 (GMT)
From: Stefan Berger <stefanb@linux.ibm.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, simo@redhat.com,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [RFC PATCH 1/4] crypto: Add squeeze function to shash_alg for support of XOFs
Date: Mon, 23 Jun 2025 09:18:27 -0400
Message-ID: <20250623131830.2194643-2-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623131830.2194643-1-stefanb@linux.ibm.com>
References: <20250623131830.2194643-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yqRk7zyWxL5J7MAHA5SAXCg-Bd6d8qgg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDA4MCBTYWx0ZWRfX2znzapI1azT7 wVpRLSjyPoqRAcaREcwIz5PiM71mEyUYIBZ9IJzdQJjmS2C/f/PQeMTVuX1Z0cs0LSvKVDqk5b/ W2RPTDREND9fSQZEyxdJqJvkGpK9ucOQd0g9essNm5KW8R6Lf0FQ1OIJ3qCYMwgxLCoA/Fo64L/
 FPnn4k+SvgXGQlYjznrKBnPzb7Zh0KuoZCbkXZpNVOd7Yb5UpYS3fVSNx2JdKT/hWaQsf05CqNf 0x/g74h+2SxG3TbwX6dXwm+c9FVJbH3SRDKmkFiUSQglibS8qo++VfQQ5Jr3MSyI/fUgTmHQaNY 92u6rDTvm6npdTENcq7AAR4ZEZH5gnZpp1c/YVRmoxLhGJvX+2fk4kkWhEnfaoTe5tlUi3kdTQL
 jUht5Va5HuDd5Iw2cMR2cMeVWjAgnzZPqzZdbiBaHvHMYspc/S3mHyCr8RLdAv44VrEtJGv+
X-Authority-Analysis: v=2.4 cv=MshS63ae c=1 sm=1 tr=0 ts=68595433 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=n-XTF91Upou305-BhzYA:9
X-Proofpoint-GUID: yqRk7zyWxL5J7MAHA5SAXCg-Bd6d8qgg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-23_03,2025-06-23_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506230080

Add a squeeze function for support of shake128/256 XOFs. This function
accepts a variable-length output buffer for the XOFs to return their data
in. The final parameter clears the state of an XOF and should only be set
to 'true' when the last output is requested.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
---
 crypto/shash.c        |  9 +++++++++
 include/crypto/hash.h | 20 ++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 301ab42bf849..258494f49fce 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -59,6 +59,15 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out)
 }
 EXPORT_SYMBOL_GPL(crypto_shash_final);
 
+int crypto_shash_squeeze(struct shash_desc *desc, u8 *out, size_t outlen,
+			 bool final)
+{
+	if (!crypto_shash_alg(desc->tfm)->squeeze)
+		return -EINVAL;
+	return crypto_shash_alg(desc->tfm)->squeeze(desc, out, outlen, final);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_squeeze);
+
 static int shash_default_finup(struct shash_desc *desc, const u8 *data,
 			       unsigned int len, u8 *out)
 {
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index a67988316d06..9072652e8e60 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -183,6 +183,7 @@ struct shash_desc {
  * @final: see struct ahash_alg
  * @finup: see struct ahash_alg
  * @digest: see struct ahash_alg
+ * @squeeze: Get data from an XOF type of hash
  * @export: see struct ahash_alg
  * @import: see struct ahash_alg
  * @setkey: see struct ahash_alg
@@ -213,6 +214,8 @@ struct shash_alg {
 		     unsigned int len, u8 *out);
 	int (*digest)(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out);
+	int (*squeeze)(struct shash_desc *desc, u8 *out, size_t outlen,
+		       bool final);
 	int (*export)(struct shash_desc *desc, void *out);
 	int (*import)(struct shash_desc *desc, const void *in);
 	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
@@ -980,6 +983,23 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out);
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out);
 
+/**
+ * crypto_shash_squeeze() - get xof message digest data
+ * @desc: operational state handle that is already filled with data
+ * @out: output buffer filled with the XOF message digest
+ * @outlen: number of bytes to get from the XOF
+ * @final: whether this is the final squeeze call
+ *
+ * Get message digest data from an extend output function (XOF)
+ *
+ * Context: Any context.
+ * Return: 0 if the data could be created successfully; < 0 if an error
+ *         occurred
+ */
+int crypto_shash_squeeze(struct shash_desc *desc, u8 *out, size_t outlen,
+			 bool final);
+
+
 static inline void shash_desc_zero(struct shash_desc *desc)
 {
 	memzero_explicit(desc,
-- 
2.49.0

