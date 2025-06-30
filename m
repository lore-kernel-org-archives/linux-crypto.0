Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A049D28C5C3;
	Mon, 30 Jun 2025 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751294336; cv=none; b=sRKJU1f7T8jnPabHuVGJKriDQuFog4ZuHo0KdD7XqwjU7tXOAK8WYDAaXIgNs1O1zN2MYLtb5zaiLy+6ybZC7nEgCDa5KOE7/0+f/CgezHXl9enHw7h2p8wbWSS636d4ziSSJLLgV7kYEU2zm1ohL3e2o+R0df/tqENLdTGHGMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751294336; c=relaxed/simple;
	bh=YkpdTWyHs7BogwjbVOCLLOWPQw2lUFU7xGgB8Vz4XiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNdVhKMRdZFqtxlSemi93xCv71rba1pmFKyFISa2yFhybEl+BvCIREijxC2v97j9jxMg7sgtkNTykZU0abVRFAf5j5kP7Pa6ELlwmpII1Z/bCrO4jJUhBsNBjrWby/aerRU21FHV7OAxgY8mLIVwKQBoIRpt/RUWBDwAaKxa7X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HAyuKSw6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HAyuKSw6"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55U8xoV4015498;
	Mon, 30 Jun 2025 14:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FoXKg6Hji1p/ojTmp
	Vp6/rHsjyhOOpO76o2a912PFZE=; b=HAyuKSw6G1bEEBkwwq418GlX3dUv8m1BQ
	FtvhdX9W5/XPxD+8eAt8onoT17SQuNQCdp5cDonxcQabxSAONdSyV1Bl0aDJ4Qfu
	l6D/b4WvXFNWigI0Uy5vtWDZjsXGm/ypuUV5pT1EnldKKTUMGPJbjt7zSv1U2ooz
	RPCZ0WhLi0tDzc7W9nH1ARj5/AA6WCBHTmAf7tKDVQVcC+UTcuVZjoV3Dya/DJUu
	m7nZzKpYIsq5kRxJJzjTMR67K16BlXdGnGFyc9g82W9f1biDwOFgMuYvqMe9kDW7
	vXIDKSIlhNOpAae+reTLHFpiCCBNOBQDSHS+XLqb+i1AINnF8mwow==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47j7wra05s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 14:38:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55UB733W021371;
	Mon, 30 Jun 2025 14:38:44 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 47jwe35yax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 14:38:44 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55UEchip17105504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Jun 2025 14:38:43 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9503C58059;
	Mon, 30 Jun 2025 14:38:43 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D20B658058;
	Mon, 30 Jun 2025 14:38:42 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Jun 2025 14:38:42 +0000 (GMT)
From: Stefan Berger <stefanb@linux.ibm.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, simo@redhat.com,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [PATCH v2 1/4] crypto: Add squeeze function to shash_alg for support of XOFs
Date: Mon, 30 Jun 2025 10:38:31 -0400
Message-ID: <20250630143834.2748285-2-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250630143834.2748285-1-stefanb@linux.ibm.com>
References: <20250630143834.2748285-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=E/PNpbdl c=1 sm=1 tr=0 ts=6862a175 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=n-XTF91Upou305-BhzYA:9
X-Proofpoint-GUID: j1g4INO6doFYn94WUF0KCeDfofzljWv-
X-Proofpoint-ORIG-GUID: j1g4INO6doFYn94WUF0KCeDfofzljWv-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjMwMDExNyBTYWx0ZWRfX0JMMKHrpI+i8 tVnKZ1ZvwHlioFw74gQz98Y/wwo2WxNGCSzIkovOiE3USUS5svXsdc1VJB2Ds8cP+l5e90JXZFY Fg+Zgbe5O9Ek5bW/TueUub9HONcw05qJzbzxecKNnSs/eX0YyJKdwB5qBwkm0NrbzNAvwivlkJ6
 A6T4bDmYOyhoU5mloEHh65ElpnbctdWrrkI+vpZI0xb/pr/r9OCqhLXsub0yUXig1TRBrmvqf50 GK1PkWsuCUtkXEjmPx9XNKOe32kAacgKBDSAizfNvCl62oCVFkRz1sMpxG1tIYYY9fML46Nlf+2 v5+wETc7nHAit1WNSx1Gk9l0v0V2kVE2/iPUJNGu7Vibe3vZG+2dT75gzhCUcfI/d7Ofd7Dewmd
 6Srwx0PrIskTyiE+T35yoBqXOU/yu1vxaAgIj2DxrEcypPfQ/7TRUSsoBNMc+6xOLn09mBvD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-30_03,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 clxscore=1015 adultscore=0 impostorscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506300117

Add a squeeze function for support of shake128/256 XOFs. This function
accepts a variable-length output buffer for the XOFs to return their data
in. The 'final' parameter clears the state of an XOF and should only be set
to 'true' when the last output is requested.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
---
 crypto/shash.c        |  9 +++++++++
 include/crypto/hash.h | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 4721f5f134f4..12b3882e9a26 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -86,6 +86,15 @@ int crypto_shash_init(struct shash_desc *desc)
 }
 EXPORT_SYMBOL_GPL(crypto_shash_init);
 
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
index 6f6b9de12cd3..36b88d34c0dd 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -209,6 +209,7 @@ struct shash_desc {
  * @final: see struct ahash_alg
  * @finup: see struct ahash_alg
  * @digest: see struct ahash_alg
+ * @squeeze: Get data from an XOF type of hash
  * @export: see struct ahash_alg
  * @import: see struct ahash_alg
  * @export_core: see struct ahash_alg
@@ -241,6 +242,8 @@ struct shash_alg {
 		     unsigned int len, u8 *out);
 	int (*digest)(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out);
+	int (*squeeze)(struct shash_desc *desc, u8 *out, size_t outlen,
+		       bool final);
 	int (*export)(struct shash_desc *desc, void *out);
 	int (*import)(struct shash_desc *desc, const void *in);
 	int (*export_core)(struct shash_desc *desc, void *out);
@@ -1011,6 +1014,22 @@ static inline int crypto_shash_final(struct shash_desc *desc, u8 *out)
 	return crypto_shash_finup(desc, NULL, 0, out);
 }
 
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
 static inline void shash_desc_zero(struct shash_desc *desc)
 {
 	memzero_explicit(desc,
-- 
2.49.0

