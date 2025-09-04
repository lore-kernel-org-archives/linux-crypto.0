Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B228850F;
	Thu,  4 Sep 2025 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001634; cv=none; b=dWejf04ID4KAgViR1kuTYIfdk7C1avLnIgcecyeV1gSvIwhQmjoNYQKxgc7ImXmv+Pt28KA2ezhrGsJp8zmN3K02sKsYYqC7AmQmX/15yv5DoNG2rA/IMDZIx0awml9GrYm6Z7iKIwxuKtMLk0BdQ6ThqP5mWzwzCCEV/dVo3Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001634; c=relaxed/simple;
	bh=SFUtbEwDlzNTadl/JhzQYYbETk15xST365Bvs6zfnK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kEDyCfgZhvqKaSx9JHM3YdvV0h742DKH+CgwKr3XkStv2eWyWIQC5v84iTuwG2TX4j0YADEGDh1p3Af0xy5Ia6cMlIpCr8pnbNgQ5V1seAkYgt/XHxmMAU/jqpCh2nsJl+zZ8yDsqBgjk1vwpIvtFlH0c6UGysn+yqQZxA9VDas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AjDJTMjC; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AjDJTMjC"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftnj1023987;
	Thu, 4 Sep 2025 16:00:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Peh1i
	eNrDATIXCp81zoKbCBdvtyyXDvPKQgU7d+ddfA=; b=AjDJTMjCWrrPQ07efNbaW
	YrYdtTDMPbWgtc1dM2aQHmmtyenbFG4VxqrmB/adMzvMFcoFveZZPZWhP0HnZjMz
	08AXfxCIbZdPV5wXt3vhn8cnRzJKBwI/HtdJyZLq/8zRlnvIR8atJGcJHlk0q6qk
	Dp/eDkrUS157QKsB861SazLiy9QU+leWej8lQMgd0GcZmcU4QG+mWjd9LRdQRw0e
	6YJChDFRZgpQ7RBiJ5YqcIJuoRhNxgZC3udPF6orTcSs640ef1CQB650VYO2VRjM
	p4h0GfzD/QEofvMhTGnW75mGOvyS1KouuwiOnamszjrsFcJynm41ulGyIw/EZvLw
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd02c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FG60J040116;
	Thu, 4 Sep 2025 16:00:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhts3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7U000707;
	Thu, 4 Sep 2025 16:00:19 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-82;
	Thu, 04 Sep 2025 16:00:19 +0000
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
Subject: [PATCH RFC 081/104] crypto: fips140: convert crypto/asymmetric_keys/pkcs7_verify.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:53 +0200
Message-Id: <20250904155216.460962-82-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX9/chRgKumiv6
 R1hblA2VONyRLCCOOlmClRzk8+NC+2KReqxWTb45TCwll3lcEzq8otfuz73vA8dmssGjhGyAOcs
 JnnQosimXA4hWOYS0XWi0bBx64acQSIsQ8GIVXKIZbNPiqqS1vfrCAOv3Sd44H9ZX00KqIDc2Nv
 ox4nM9j6eRbOmd4EFJfSpp/fQ/mwOwgkezYAIOXYNAOEgjTjiolbwj0DkNyLVYRry6BPzLL7BFH
 7yZXCsUhVys88cAh+DknfFggB+G8okvjX1CPAdGxib3e4ZtBkorpXPZI9hxa3oeWUitUHF8Tium
 eUKV1JEQQzsHBZPJ6yI/Ci2rFJWF7N8notZ/xU0GkOu4Px4MVYdn3BKbqB+vrSJWy3JE2N0aqif
 zuDR7wbz/fRms1T/A/nKzjIDN+LDLg==
X-Proofpoint-GUID: Vsy_vcJw04AD9layO2rEL2RLKO-knX4A
X-Proofpoint-ORIG-GUID: Vsy_vcJw04AD9layO2rEL2RLKO-knX4A
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b795 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=uCkkgEfSgqTv6BX6tFYA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_PKCS7_MESSAGE_PARSER --source crypto/asymmetric_keys/pkcs7_verify.c --header include/crypto/pkcs7.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c |  8 ++++----
 crypto/fips140-api.c                  | 12 ++++++++++++
 include/crypto/pkcs7.h                | 10 ++++++----
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index f0d4ff3c20a8..ebb86a8ace9c 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -391,7 +391,7 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
  *  (*) -ENOPKG if none of the signature chains are verifiable because suitable
  *	crypto modules couldn't be found.
  */
-int pkcs7_verify(struct pkcs7_message *pkcs7,
+int CRYPTO_API(pkcs7_verify)(struct pkcs7_message *pkcs7,
 		 enum key_being_used_for usage)
 {
 	struct pkcs7_signed_info *sinfo;
@@ -459,7 +459,7 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 	kleave(" = %d", actual_ret);
 	return actual_ret;
 }
-EXPORT_SYMBOL_GPL(pkcs7_verify);
+DEFINE_CRYPTO_API(pkcs7_verify);
 
 /**
  * pkcs7_supply_detached_data - Supply the data needed to verify a PKCS#7 message
@@ -474,7 +474,7 @@ EXPORT_SYMBOL_GPL(pkcs7_verify);
  *
  * Returns -EINVAL if data is already supplied in the message, 0 otherwise.
  */
-int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
+int CRYPTO_API(pkcs7_supply_detached_data)(struct pkcs7_message *pkcs7,
 			       const void *data, size_t datalen)
 {
 	if (pkcs7->data) {
@@ -485,4 +485,4 @@ int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
 	pkcs7->data_len = datalen;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(pkcs7_supply_detached_data);
+DEFINE_CRYPTO_API(pkcs7_supply_detached_data);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index f65b2a950ccf..fb3dc947022a 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -663,3 +663,15 @@ DEFINE_CRYPTO_API_STUB(pkcs7_validate_trust);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/pkcs7_verify.c
+ */
+#if !IS_BUILTIN(CONFIG_PKCS7_MESSAGE_PARSER)
+
+#include <crypto/pkcs7.h>
+
+DEFINE_CRYPTO_API_STUB(pkcs7_verify);
+DEFINE_CRYPTO_API_STUB(pkcs7_supply_detached_data);
+
+#endif
+
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index bec3884eb242..f5e288073934 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -40,11 +40,13 @@ DECLARE_CRYPTO_API(pkcs7_validate_trust, int,
 /*
  * pkcs7_verify.c
  */
-extern int pkcs7_verify(struct pkcs7_message *pkcs7,
-			enum key_being_used_for usage);
+DECLARE_CRYPTO_API(pkcs7_verify, int,
+	(struct pkcs7_message *pkcs7, enum key_being_used_for usage),
+	(pkcs7, usage));
 
-extern int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
-				      const void *data, size_t datalen);
+DECLARE_CRYPTO_API(pkcs7_supply_detached_data, int,
+	(struct pkcs7_message *pkcs7, const void *data, size_t datalen),
+	(pkcs7, data, datalen));
 
 extern int pkcs7_get_digest(struct pkcs7_message *pkcs7, const u8 **buf,
 			    u32 *len, enum hash_algo *hash_algo);
-- 
2.39.3

