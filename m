Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8AD2D46AF;
	Thu,  4 Sep 2025 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001659; cv=none; b=g1v6u4kaNphM2weuBJ/yDdQ9CuMGwPn3dTxTAatBMbcAv349t2gIo/+UMWSw3Orbq4SHHUlFTQOnglLuuwGGDFAc0NVbgrJmbcwfvtuOGCuY5dBPSjOm6bMO6yW/eR7xItxn0o62sX/he2o4BqMbVatG9+0T0Miomwrh65WWgqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001659; c=relaxed/simple;
	bh=gae44ImsHHdJm2PX8fT8bfTAry+3/kbRT+wTVUnomkk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f74xApSnpx7iUqMRFVSxtAX29sqkES7GBNeY7qvIPqCySEuAgc33vFuR7bhF5bXDg+bx7Sc96LRX3cX1lMw8JpmIwoniJzRSryk+hd5DWl7O5E5UuoyKs9qKon2VmPCBok+pfvbCLV66lwmnO1ThNcmp+2xkmoSiQ/KPnEQk9Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WZHgZlIr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WZHgZlIr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftpch027797;
	Thu, 4 Sep 2025 16:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=ZQ17/
	HHrrxd+0R11hS0JrykquN+cME89wtawmXqzAIU=; b=WZHgZlIr/cha4Ic5uIxKd
	aNSzuBcHrLBl2a/PNMpu6ZbiV3A5WzOvCau7HpwpdRrxF38NFEbGYQL8XMbViAxc
	Se1R20WGB8Xv33+1Jz6xsmKjrSIlsaxPjjbVBborddDt6iVcQJeENuxwgPVtTYh8
	BhJX1wfw696+AX7rFe+GzBfO1uZHr0S/rCi9SWsHByBKwRgkvVMyNpyFRwx9EAuG
	9GJiKMcFBt95oS2+cvzfFR/6xsuzeOAiFk9ktVrmM2aJWtmHx8CXYj5k+iInUXPR
	eG6wFvcPRxXGV/iReaLeh/TLS5x2GNhGZuNAe3yqUqguCV3X1+4z+1oumbgAyFnW
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn07bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EsITi040070;
	Thu, 4 Sep 2025 16:00:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtsx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7e000707;
	Thu, 4 Sep 2025 16:00:39 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-87;
	Thu, 04 Sep 2025 16:00:39 +0000
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
Subject: [PATCH RFC 086/104] crypto: fips140: convert crypto/asymmetric_keys/x509_cert_parser.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:58 +0200
Message-Id: <20250904155216.460962-87-vegard.nossum@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b7a9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=k3iTR8l_nZvy9YQv4v4A:9
 cc=ntf awl=host:12068
X-Proofpoint-GUID: Cs4b5ySe3DBSlTKqEdBpqxmsrL3iiLKO
X-Proofpoint-ORIG-GUID: Cs4b5ySe3DBSlTKqEdBpqxmsrL3iiLKO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfX7KbtoFo/1sXq
 kQ0HBwKI9iD+J2GXTu4c6ySOtPRGvPaIOiPX2eL3Mzw1G/7nVEuEF/ciI3tepUOy0g1gBV8bHGI
 Jqd1vg0qYcNKMmRcUoRIHDRA2zHEClZeGWEp6SLKC6BRgwZBFhM80pd/PwrADVsyV03DXFDlJUO
 pJjaP67ybLpy98pnu/dxEo3wctOhJgkgegeQM1EPB+fh41+cvAPyzLAWPwegEm/AG54N2iGIVmP
 6JhCvBfqg+QOe8JQS7GpYX6zZeBdlupjFL/J8FSNOvZ3w8yTiDDREabohCqZZcwIYQ7ZEqqsO3D
 Zna+MHUhbm0D9G1Bw8E+UdQpGvdXXr9qX3Yv7uM7tLaCli0JLxXWCzBCu6YQoShZ4MCv8kJVt0i
 aCYM6+j+2l6zh6WRAVPSxzsMfSo99A==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_X509_CERTIFICATE_PARSER --source crypto/asymmetric_keys/x509_cert_parser.c --header crypto/asymmetric_keys/x509_parser.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 12 ++++++------
 crypto/asymmetric_keys/x509_parser.h      | 15 ++++++++++-----
 crypto/fips140-api.c                      | 13 +++++++++++++
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 2ffe4ae90bea..aae629557e8d 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -41,7 +41,7 @@ struct x509_parse_context {
 /*
  * Free an X.509 certificate
  */
-void x509_free_certificate(struct x509_certificate *cert)
+void CRYPTO_API(x509_free_certificate)(struct x509_certificate *cert)
 {
 	if (cert) {
 		public_key_free(cert->pub);
@@ -53,12 +53,12 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert);
 	}
 }
-EXPORT_SYMBOL_GPL(x509_free_certificate);
+DEFINE_CRYPTO_API(x509_free_certificate);
 
 /*
  * Parse an X.509 certificate
  */
-struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
+struct x509_certificate *CRYPTO_API(x509_cert_parse)(const void *data, size_t datalen)
 {
 	struct x509_certificate *cert __free(x509_free_certificate);
 	struct x509_parse_context *ctx __free(kfree) = NULL;
@@ -132,7 +132,7 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 
 	return_ptr(cert);
 }
-EXPORT_SYMBOL_GPL(x509_cert_parse);
+DEFINE_CRYPTO_API(x509_cert_parse);
 
 /*
  * Note an OID when we find one for later processing when we know how
@@ -649,7 +649,7 @@ int x509_process_extension(void *context, size_t hdrlen,
  *	applications MUST be able to process validity dates that are encoded in
  *	either UTCTime or GeneralizedTime.
  */
-int x509_decode_time(time64_t *_t,  size_t hdrlen,
+int CRYPTO_API(x509_decode_time)(time64_t *_t,  size_t hdrlen,
 		     unsigned char tag,
 		     const unsigned char *value, size_t vlen)
 {
@@ -724,7 +724,7 @@ int x509_decode_time(time64_t *_t,  size_t hdrlen,
 		 tag, (int)vlen, value);
 	return -EBADMSG;
 }
-EXPORT_SYMBOL_GPL(x509_decode_time);
+DEFINE_CRYPTO_API(x509_decode_time);
 
 int x509_note_not_before(void *context, size_t hdrlen,
 			 unsigned char tag,
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 0688c222806b..79342e8e8bd9 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -5,6 +5,7 @@
  * Written by David Howells (dhowells@redhat.com)
  */
 
+#include <crypto/api.h>
 #include <linux/cleanup.h>
 #include <linux/time.h>
 #include <crypto/public_key.h>
@@ -44,13 +45,17 @@ struct x509_certificate {
 /*
  * x509_cert_parser.c
  */
-extern void x509_free_certificate(struct x509_certificate *cert);
+DECLARE_CRYPTO_API(x509_free_certificate, void,
+	(struct x509_certificate *cert),
+	(cert));
 DEFINE_FREE(x509_free_certificate, struct x509_certificate *,
 	    if (!IS_ERR(_T)) x509_free_certificate(_T))
-extern struct x509_certificate *x509_cert_parse(const void *data, size_t datalen);
-extern int x509_decode_time(time64_t *_t,  size_t hdrlen,
-			    unsigned char tag,
-			    const unsigned char *value, size_t vlen);
+DECLARE_CRYPTO_API(x509_cert_parse, struct x509_certificate *,
+	(const void *data, size_t datalen),
+	(data, datalen));
+DECLARE_CRYPTO_API(x509_decode_time, int,
+	(time64_t *_t, size_t hdrlen, unsigned char tag, const unsigned char *value, size_t vlen),
+	(_t, hdrlen, tag, value, vlen));
 
 /*
  * x509_public_key.c
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 5c245b1be2ba..db5b142e21df 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -700,3 +700,16 @@ DEFINE_CRYPTO_API_STUB(verify_signature);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/x509_cert_parser.c
+ */
+#if !IS_BUILTIN(CONFIG_X509_CERTIFICATE_PARSER)
+
+#include <crypto/asymmetric_keys/x509_parser.h>
+
+DEFINE_CRYPTO_API_STUB(x509_free_certificate);
+DEFINE_CRYPTO_API_STUB(x509_cert_parse);
+DEFINE_CRYPTO_API_STUB(x509_decode_time);
+
+#endif
+
-- 
2.39.3

