Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FC4284696;
	Thu,  4 Sep 2025 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001652; cv=none; b=gf0LIsMKhyTfsThpD6TXvV9iGGB2sbTeC7xRAk2AFsiVQJslXzUyryTDG14JIcZbyrHuF74ei/m5NsDUkpeEK+T29Suxy7pkjdfMEiGld5kYo/zuiwjcVao3R0wZn3cxih4GbTGxGb58pJPZycksRaIu0DhLRlhkE1oIbfhleOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001652; c=relaxed/simple;
	bh=MXAMrNlkS3PsNHI1nq7ECcL4GukAh0Yk624AUcV9kpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WVK5kOmn9pZ4a229awDXRgO2mfk8aa0NdZGWa4h1p828mBcDDT03BDlUKH8WQlYECbwC58aaHx8tSJg15hhir03ykdd9MqkLqFKvN8RLALcWdEK8tmqYopmUmFF2SsH5INunkdMqUOCjrCRq5CrGC3sD15qZgo94HMYjXL3j4oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qXLDVOXg; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qXLDVOXg"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjPo027677;
	Thu, 4 Sep 2025 16:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=PDmOd
	ZiTUU3H6h5YFvwdpCHQW2rJv84OojCCRUGOHU0=; b=qXLDVOXg/JgqpJqToEvzq
	v6xkdCBJrKUciOKwx3QP6H3+nzviLpUTQOesEQHWR2Fr+xvvlKGRnx7z5GstToV+
	fZK6bthQuQcEuVgFHmFo+7DL565cR4YyCcYs6uvX+Bqi/rqpvGv0c2nYdzBTjowP
	HmcBajTvjg4G3/5gHOlMfGwhP1Esb0ZmYwbwVDmDf+d+MXnJc7s3819Mjp+0vAO0
	aictatSDiko0HxTdxzOb4/9ncAxphCIMzwhIYyl7gLNXehBu8H9eW26azKHJA1oq
	8At5V5kfLtQKjv8ESCVsiHlmPWcpQnvCOPLIGWNlZ9te6uRNYxXJxbbZ5DEY9HAy
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn07bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FcUYl040079;
	Thu, 4 Sep 2025 16:00:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtssm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7c000707;
	Thu, 4 Sep 2025 16:00:35 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-86;
	Thu, 04 Sep 2025 16:00:35 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 085/104] crypto: fips140: convert crypto/asymmetric_keys/signature.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:57 +0200
Message-Id: <20250904155216.460962-86-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040157
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b7a5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=txtBRqNqmEtfbrBktwkA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: gopV0piEsYNk7x7zYXtPAesi1Oi9QNvA
X-Proofpoint-ORIG-GUID: gopV0piEsYNk7x7zYXtPAesi1Oi9QNvA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX1/UiS+o7gsqw
 YKm5iRncSutWnDptknu76wlyLir4NwITrC+EYvvLb9I3jWR5JLFLkhYvhLjh2Eh0Xy7w1aGmRJG
 rMg5OfqDbRHfSLwcJy/78LDNctHdFkPUwemS546E9EH3HoaFRLDkJnkJJml73KNh+etzVJGDSqG
 JP7AxcCvwfcR0xD0UXgffg+JGSHbpHJq9cBmA37X1Oa4cXGejIAP37cfaR/x7jBePtAhxsMgCxu
 Duxc5BiDlmNhskb2gaNufM55Cr2G73tvBxmhcREHG5GPUyDHhWKeDTvZi/IR+t9eyo9bi26P21t
 RfA/TQ82cbQcZuU+Ghsd2iVIrzc0XuZvghVWqBaYOenYhkB3mjW77PmE/DQBInnG2vbAJse8vNX
 T7W1VmMj8ABdcRDTMbvQ+QnVaQADkQ==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_ASYMMETRIC_KEY_TYPE --source crypto/asymmetric_keys/signature.c --header include/crypto/public_key.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/signature.c | 12 ++++++------
 crypto/fips140-api.c               | 13 +++++++++++++
 include/crypto/public_key.h        | 14 +++++++++-----
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 041d04b5c953..06ae0a49222c 100644
--- a/crypto/asymmetric_keys/signature.c
+++ b/crypto/asymmetric_keys/signature.c
@@ -20,7 +20,7 @@
 /*
  * Destroy a public key signature.
  */
-void public_key_signature_free(struct public_key_signature *sig)
+void CRYPTO_API(public_key_signature_free)(struct public_key_signature *sig)
 {
 	int i;
 
@@ -32,14 +32,14 @@ void public_key_signature_free(struct public_key_signature *sig)
 		kfree(sig);
 	}
 }
-EXPORT_SYMBOL_GPL(public_key_signature_free);
+DEFINE_CRYPTO_API(public_key_signature_free);
 
 /**
  * query_asymmetric_key - Get information about an asymmetric key.
  * @params: Various parameters.
  * @info: Where to put the information.
  */
-int query_asymmetric_key(const struct kernel_pkey_params *params,
+int CRYPTO_API(query_asymmetric_key)(const struct kernel_pkey_params *params,
 			 struct kernel_pkey_query *info)
 {
 	const struct asymmetric_key_subtype *subtype;
@@ -62,7 +62,7 @@ int query_asymmetric_key(const struct kernel_pkey_params *params,
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(query_asymmetric_key);
+DEFINE_CRYPTO_API(query_asymmetric_key);
 
 /**
  * verify_signature - Initiate the use of an asymmetric key to verify a signature
@@ -71,7 +71,7 @@ EXPORT_SYMBOL_GPL(query_asymmetric_key);
  *
  * Returns 0 if successful or else an error.
  */
-int verify_signature(const struct key *key,
+int CRYPTO_API(verify_signature)(const struct key *key,
 		     const struct public_key_signature *sig)
 {
 	const struct asymmetric_key_subtype *subtype;
@@ -93,4 +93,4 @@ int verify_signature(const struct key *key,
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(verify_signature);
+DEFINE_CRYPTO_API(verify_signature);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 49e89f4bdddb..5c245b1be2ba 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -687,3 +687,16 @@ DEFINE_CRYPTO_API_STUB(public_key_verify_signature);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/signature.c
+ */
+#if !IS_BUILTIN(CONFIG_ASYMMETRIC_KEY_TYPE)
+
+#include <crypto/public_key.h>
+
+DEFINE_CRYPTO_API_STUB(public_key_signature_free);
+DEFINE_CRYPTO_API_STUB(query_asymmetric_key);
+DEFINE_CRYPTO_API_STUB(verify_signature);
+
+#endif
+
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 46e6e14b8559..c8f30adbd655 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -54,7 +54,9 @@ struct public_key_signature {
 	const char *encoding;
 };
 
-extern void public_key_signature_free(struct public_key_signature *sig);
+DECLARE_CRYPTO_API(public_key_signature_free, void,
+	(struct public_key_signature *sig),
+	(sig));
 
 extern struct asymmetric_key_subtype public_key_subtype;
 
@@ -104,11 +106,13 @@ static inline int restrict_link_by_digsig(struct key *dest_keyring,
 }
 #endif
 
-extern int query_asymmetric_key(const struct kernel_pkey_params *,
-				struct kernel_pkey_query *);
+DECLARE_CRYPTO_API(query_asymmetric_key, int,
+	(const struct kernel_pkey_params *arg1, struct kernel_pkey_query *arg2),
+	(arg1, arg2));
 
-extern int verify_signature(const struct key *,
-			    const struct public_key_signature *);
+DECLARE_CRYPTO_API(verify_signature, int,
+	(const struct key *arg1, const struct public_key_signature *arg2),
+	(arg1, arg2));
 
 #if IS_REACHABLE(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE)
 DECLARE_CRYPTO_API(public_key_verify_signature, int,
-- 
2.39.3

