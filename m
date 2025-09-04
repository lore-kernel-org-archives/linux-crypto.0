Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001281F4C87;
	Thu,  4 Sep 2025 16:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001625; cv=none; b=Bjf6ATIcqlPQCRrgfMRefpWI664HmHePeb5jIME+/IO5108OfhVgurCBgywRAw+RVzQp1HB+XPJuEQmPZU+q7ZuK4szEfU9iG9nmO0qo1X/8UfVPlA5p43K6SJ2k9VhwDNfp+MPWUQIW8SirqvFP7TVXA315YS8SjQdarZCPOlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001625; c=relaxed/simple;
	bh=dUwo6glnJa8fIKT5P0beNexqxDtNy7m0W25MD3wIEpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBp/l4Rl7SIYq/ds1JLtuT//+mbXlW/PbVXAdCHfwfE6SwhGtexDsF/Sydgih6/vUA2Wetwq+DOcrUHN/1OiouT/mRebm8VfDVZZPpsuMfr3yt48/lfSqP/TVwRou6dX/9KUk6tjriFWdaQbjVQZ8ff0blSfsXqm3fJIXoaa+a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HnMvT/Gh; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HnMvT/Gh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuh0b004085;
	Thu, 4 Sep 2025 16:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Pzuv2
	uJWfWyR88QUkBOirwd8U319b9K8fNyvexnfKC4=; b=HnMvT/Gh0klpcDKjYYyZd
	nhzOSO/x7zKBQE4ZCm7pdt+l256CZ2IXmIKgk6jvjrA1YEqhXyW1AMQsigCA6H2/
	LiZ5admZCeCR/l8yUpjhXtGznp7P04Vu6bejqszpMPR+dLQgT2jRP8yFH+MsKf+A
	006Dz3avFy35P9tCKlrvPwpfR0keHZvSZOfWCr156uSqufmKMlEZw/yDe4eML801
	0X2jkLol0bLCuc545PsVIL4iCaPH3nuZR1K82+TABJiOVylkASs6NCzU/KFWvNai
	BtdKc+6gQHbXxfYmigMEj/CK2wsyUKrFDOJN2/xIXwFht33aV/R/lJKE/fO/ylPu
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun0080-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedpr040082;
	Thu, 4 Sep 2025 16:00:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtrqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:12 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7Q000707;
	Thu, 4 Sep 2025 16:00:11 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-80;
	Thu, 04 Sep 2025 16:00:11 +0000
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
Subject: [PATCH RFC 079/104] crypto: fips140: convert crypto/asymmetric_keys/pkcs7_parser.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:51 +0200
Message-Id: <20250904155216.460962-80-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: yQT6KVZUtloKS-rpibmLAzAG7Wzf1ROn
X-Proofpoint-GUID: yQT6KVZUtloKS-rpibmLAzAG7Wzf1ROn
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b78d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=dHIHOIEmS-RQ8QRPIjcA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX5/MC3HxK3yCk
 VfWTnVJYbsUNg8//cKG0LhRAOXNz25iNuZV/p/w7XB6OhjdQYpzbWaYiMTvtwHto30secz46yXg
 vmgIFSiBMDh6DaPoeWMyRPJSxdaIyOpCA0ZCQttGIivDjrtZ6N4TkV7dqPKaKq+QH9mF365qNkj
 tViwpjJLiBqTRaGSvUPPWyXgfNz/wCgeBacOnqrvPR8yhwq3yXR4mpyUvUiqAQJ31we2M482rI5
 csI+qnBWoNWHW1rSbxPDWrGjeUXg9U0VT2sXzpXYrk48y596tPDe89eEYBatRaeXSPVuvjirq7g
 z3hUGjOTrUJZKc3gR+xUWaQhMgNAzqIf3N4ulolc4UZFD3W3K/EIphDgQOBhvHBOIRWgUZz8dgl
 53Gs4yK+l8CJNIVFL86r65eYuI1XwQ==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_PKCS7_MESSAGE_PARSER --source crypto/asymmetric_keys/pkcs7_parser.c --header include/crypto/pkcs7.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 12 ++++++------
 crypto/fips140-api.c                  | 13 +++++++++++++
 include/crypto/pkcs7.h                | 18 +++++++++++-------
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 423d13c47545..68e70ec19d4d 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -54,7 +54,7 @@ static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
  * pkcs7_free_message - Free a PKCS#7 message
  * @pkcs7: The PKCS#7 message to free
  */
-void pkcs7_free_message(struct pkcs7_message *pkcs7)
+void CRYPTO_API(pkcs7_free_message)(struct pkcs7_message *pkcs7)
 {
 	struct x509_certificate *cert;
 	struct pkcs7_signed_info *sinfo;
@@ -78,7 +78,7 @@ void pkcs7_free_message(struct pkcs7_message *pkcs7)
 		kfree(pkcs7);
 	}
 }
-EXPORT_SYMBOL_GPL(pkcs7_free_message);
+DEFINE_CRYPTO_API(pkcs7_free_message);
 
 /*
  * Check authenticatedAttributes are provided or not provided consistently.
@@ -112,7 +112,7 @@ static int pkcs7_check_authattrs(struct pkcs7_message *msg)
  * @data: The raw binary ASN.1 encoded message to be parsed
  * @datalen: The size of the encoded message
  */
-struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
+struct pkcs7_message *CRYPTO_API(pkcs7_parse_message)(const void *data, size_t datalen)
 {
 	struct pkcs7_parse_context *ctx;
 	struct pkcs7_message *msg = ERR_PTR(-ENOMEM);
@@ -167,7 +167,7 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
 out_no_ctx:
 	return msg;
 }
-EXPORT_SYMBOL_GPL(pkcs7_parse_message);
+DEFINE_CRYPTO_API(pkcs7_parse_message);
 
 /**
  * pkcs7_get_content_data - Get access to the PKCS#7 content
@@ -182,7 +182,7 @@ EXPORT_SYMBOL_GPL(pkcs7_parse_message);
  *
  * Returns -ENODATA if the data object was missing from the message.
  */
-int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
+int CRYPTO_API(pkcs7_get_content_data)(const struct pkcs7_message *pkcs7,
 			   const void **_data, size_t *_data_len,
 			   size_t *_headerlen)
 {
@@ -195,7 +195,7 @@ int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 		*_headerlen = pkcs7->data_hdrlen;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(pkcs7_get_content_data);
+DEFINE_CRYPTO_API(pkcs7_get_content_data);
 
 /*
  * Note an OID when we find one for later processing when we know how
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 81d920836e1b..36d7cd3595a9 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -639,3 +639,16 @@ DEFINE_CRYPTO_API_STUB(find_asymmetric_key);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/pkcs7_parser.c
+ */
+#if !IS_BUILTIN(CONFIG_PKCS7_MESSAGE_PARSER)
+
+#include <crypto/pkcs7.h>
+
+DEFINE_CRYPTO_API_STUB(pkcs7_parse_message);
+DEFINE_CRYPTO_API_STUB(pkcs7_free_message);
+DEFINE_CRYPTO_API_STUB(pkcs7_get_content_data);
+
+#endif
+
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 38ec7f5f9041..fcb744d3f436 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_PKCS7_H
 #define _CRYPTO_PKCS7_H
 
+#include <crypto/api.h>
 #include <linux/verification.h>
 #include <linux/hash_info.h>
 #include <crypto/public_key.h>
@@ -18,13 +19,16 @@ struct pkcs7_message;
 /*
  * pkcs7_parser.c
  */
-extern struct pkcs7_message *pkcs7_parse_message(const void *data,
-						 size_t datalen);
-extern void pkcs7_free_message(struct pkcs7_message *pkcs7);
-
-extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
-				  const void **_data, size_t *_datalen,
-				  size_t *_headerlen);
+DECLARE_CRYPTO_API(pkcs7_parse_message, struct pkcs7_message *,
+	(const void *data, size_t datalen),
+	(data, datalen));
+DECLARE_CRYPTO_API(pkcs7_free_message, void,
+	(struct pkcs7_message *pkcs7),
+	(pkcs7));
+
+DECLARE_CRYPTO_API(pkcs7_get_content_data, int,
+	(const struct pkcs7_message *pkcs7, const void **_data, size_t *_datalen, size_t *_headerlen),
+	(pkcs7, _data, _datalen, _headerlen));
 
 /*
  * pkcs7_trust.c
-- 
2.39.3

