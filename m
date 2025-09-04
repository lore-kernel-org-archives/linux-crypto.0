Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5998628152D;
	Thu,  4 Sep 2025 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001525; cv=none; b=NeIxZty0rF4E2PwhLqZTh62kblHUBzbLMO/6VhX4L7N6K9O/6Qw+VChIFaYm3hU+iWUWTLHz/RF5quVWl5l4oeLA9QWaHcPLb3tOg2ZQGebVjZGCyPj8voMB3dFKjrYPwx1JskUDEH9C9/bQtDghcRGfhgTNnJojCAJROV+BUBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001525; c=relaxed/simple;
	bh=CqRNoC4IMRX42hpSvCbk1suPg2gYYg+ftbQMoSDkjGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eF7czgDki6wd12ae47IOwzc9b0fJoLNWc3n5NvqMbaNJkEXdecrxX2VLGX9G/YZbCFweEJmp6r8R/8KQXlZgHi7VSGuorrW3g6HDjkm69T4VXaxEvYFNebeNv+dTZjuVpi8UzwaBOzfzV2D6tJeFJ6ncs2wyk9uGJHYFhUjC7Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E3LGENF5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E3LGENF5"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkhY014876;
	Thu, 4 Sep 2025 15:58:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Uh3oH
	F9/rhj/2iEzplCrChReBtqeW01a0uFrH1gjCWo=; b=E3LGENF5oE1I6Gq8NkkcM
	7lLvDA5V1zd3RvbFt0urwPJgDY8AfrJzCk5tWbT1y7roDPgNxDS/vYgInHW6UN4i
	TMPMOoOW8bf0+OhmzfDuY3cSBJTFVc5e2R+WBLlXVauij1x+u4ZwFOG6J4f9x24Q
	rWA9CSWPI3W1esP8GAccWzCEF1VyK5Gzhxohszg8vQX7Ec+/bp7z9h5IVLeJEHnc
	E4Oh75ZftcWUVe+WyKgYqxSnqRdSyn3vbRC4RVjldYKxNouW7mjDwYOtqCGIwqXq
	FLOW9eOh4BVA/BCvDwvk+1JXb83iSQNm/4tfttIoRAmz7vLOQXAMV0wj18pe9ars
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EsIS4040070;
	Thu, 4 Sep 2025 15:58:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtps5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:27 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6S000707;
	Thu, 4 Sep 2025 15:58:26 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-51;
	Thu, 04 Sep 2025 15:58:26 +0000
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
Subject: [PATCH RFC 050/104] crypto: fips140: convert crypto/ecdh_helper.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:22 +0200
Message-Id: <20250904155216.460962-51-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfXyAY3mUq6WCbc
 HYzM3lBXa0MmLLWWiFgxgn2WxgEvOsMuSgfk7UVahPISoRLMhJ/ttpTvV4SVDQpsIBtUsUrxNov
 TLp0a3Agw8OTBRzgpPR2zrabbRsLdL0X2Ap1QJ6ZLnDifg2fMGVgmLNqo1STSUhDx9tMHjnilvA
 L+CAu19lG2LUNVeiO5oD7hWa8l4sfxTt8SwylqsH7RBy5kse8mJG+0zG5PLv5LbeC8mC0COhJx1
 0VlioNIyh//QQ3GeXwY5CHjNEN1jjZ98O1cW0q60Y54P+NGjHJOiZVlHoSEChgRYZ+Z0/mJPGPX
 clJ6hiwM4bYEBGUWHeT/YtJOafWJ1cq6zfnYTZpctJTUb14OLeC4TGDBRGNr6qmeV9vLiIIEvlu
 E0ldCeS2vMTqUhi3fzVhdK9OSs1szQ==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b725 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=SIgnMC2MHgTHJr_2pDQA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: nCETbJpZHEwj_2yMtJUURHMMMMO6SW3Z
X-Proofpoint-ORIG-GUID: nCETbJpZHEwj_2yMtJUURHMMMMO6SW3Z

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ECDH --source crypto/ecdh_helper.c --header include/crypto/ecdh.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ecdh_helper.c  | 12 ++++++------
 crypto/fips140-api.c  | 13 +++++++++++++
 include/crypto/ecdh.h | 12 +++++++++---
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/crypto/ecdh_helper.c b/crypto/ecdh_helper.c
index f18f9028f912..42530c3f70dd 100644
--- a/crypto/ecdh_helper.c
+++ b/crypto/ecdh_helper.c
@@ -24,13 +24,13 @@ static inline const u8 *ecdh_unpack_data(void *dst, const void *src, size_t sz)
 	return src + sz;
 }
 
-unsigned int crypto_ecdh_key_len(const struct ecdh *params)
+unsigned int CRYPTO_API(crypto_ecdh_key_len)(const struct ecdh *params)
 {
 	return ECDH_KPP_SECRET_MIN_SIZE + params->key_size;
 }
-EXPORT_SYMBOL_GPL(crypto_ecdh_key_len);
+DEFINE_CRYPTO_API(crypto_ecdh_key_len);
 
-int crypto_ecdh_encode_key(char *buf, unsigned int len,
+int CRYPTO_API(crypto_ecdh_encode_key)(char *buf, unsigned int len,
 			   const struct ecdh *params)
 {
 	u8 *ptr = buf;
@@ -51,9 +51,9 @@ int crypto_ecdh_encode_key(char *buf, unsigned int len,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_ecdh_encode_key);
+DEFINE_CRYPTO_API(crypto_ecdh_encode_key);
 
-int crypto_ecdh_decode_key(const char *buf, unsigned int len,
+int CRYPTO_API(crypto_ecdh_decode_key)(const char *buf, unsigned int len,
 			   struct ecdh *params)
 {
 	const u8 *ptr = buf;
@@ -80,4 +80,4 @@ int crypto_ecdh_decode_key(const char *buf, unsigned int len,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_ecdh_decode_key);
+DEFINE_CRYPTO_API(crypto_ecdh_decode_key);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index f236b302c2a7..fab12d65a312 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -397,3 +397,16 @@ DEFINE_CRYPTO_API_STUB(ecc_point_mult_shamir);
 
 #endif
 
+/*
+ * crypto/ecdh_helper.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_ECDH)
+
+#include <crypto/ecdh.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_ecdh_key_len);
+DEFINE_CRYPTO_API_STUB(crypto_ecdh_encode_key);
+DEFINE_CRYPTO_API_STUB(crypto_ecdh_decode_key);
+
+#endif
+
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index aa09f880c0d3..35d20c9b23d2 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -51,7 +51,9 @@ struct ecdh {
  *
  * Return: size of the key in bytes
  */
-unsigned int crypto_ecdh_key_len(const struct ecdh *params);
+DECLARE_CRYPTO_API(crypto_ecdh_key_len, unsigned int,
+	(const struct ecdh *params),
+	(params));
 
 /**
  * crypto_ecdh_encode_key() - encode the private key
@@ -66,7 +68,9 @@ unsigned int crypto_ecdh_key_len(const struct ecdh *params);
  *
  * Return:	-EINVAL if buffer has insufficient size, 0 on success
  */
-int crypto_ecdh_encode_key(char *buf, unsigned int len, const struct ecdh *p);
+DECLARE_CRYPTO_API(crypto_ecdh_encode_key, int,
+	(char *buf, unsigned int len, const struct ecdh *p),
+	(buf, len, p));
 
 /**
  * crypto_ecdh_decode_key() - decode a private key
@@ -80,6 +84,8 @@ int crypto_ecdh_encode_key(char *buf, unsigned int len, const struct ecdh *p);
  *
  * Return:	-EINVAL if buffer has insufficient size, 0 on success
  */
-int crypto_ecdh_decode_key(const char *buf, unsigned int len, struct ecdh *p);
+DECLARE_CRYPTO_API(crypto_ecdh_decode_key, int,
+	(const char *buf, unsigned int len, struct ecdh *p),
+	(buf, len, p));
 
 #endif
-- 
2.39.3

