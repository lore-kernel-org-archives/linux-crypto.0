Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374E52877C8;
	Thu,  4 Sep 2025 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001569; cv=none; b=CtNcg1tCVdxa82MnRuQTMQ867hxuHB+8ojNh7NPKfgEjWhEPxbkvt6ubC/BWiDcYU5FQ/dNGFY22bUhmwpJQcAlP2unykADSeJ9s/sZn674SMfn14NL2a9ZKlBWGt3rkbvCA0T2ypFKrTh7S5DbdEl7Wt0H7OKd4idhVttqjvoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001569; c=relaxed/simple;
	bh=jQhrx6UwIyR5mr/wy4Uz19KgttERZiwG//J5+SZl1Xg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oWRdMhtcns4dISbho31e7iWLJOg/SysYJLHvq3wL+d+Tbugyg9zhgoEsX2y7IRfVJ7B5rhbBQvKkBO7ny1UxnCXuzoQJkqOpXAqORl5Cg+sT/y8hOPMgdfaKl14hfkSGLSTxiaPup29C0wIS84yqnsEvOW9chN/LK/GRHQ6GakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G9u4yDEj; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G9u4yDEj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FuVww003790;
	Thu, 4 Sep 2025 15:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=f1Ay5
	qI5yL8yPe8iZhFkXiIMiWmkrMr9sGtK7Wtx6vk=; b=G9u4yDEj3hDkgo+jSAmxY
	eavWLSDs2R78jXMh4sgc9ILg/2xi1fZCQaCBfgtiFuq0MKZvAcgH1G0ldKbQ3uIA
	t74mXBZKt3p8u3KgGZJ0yAp0mLkUqfnqGWby2THcz9rkIW+Ss0l7jR/cYD/Fvq8b
	uvN3x25G61gIOphJBAjWm8P9kHhiu+KjsAyqt3TgW4VZhWxKWbU+N7y8s4wW5A6q
	3agi5tH0zGNRM/Iiutd5EWdX2EpW5XcM0ZDSkSl6oZmW7eTAIaBHhBPZTT8mzBt7
	9nMSi9TZ2wx13v+4LTHVnQFPkbdPuO+IFzjp989RJADhMGUOfRaD8vqJzsK2E+82
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun006j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FM8Hp040108;
	Thu, 4 Sep 2025 15:59:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:16 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6u000707;
	Thu, 4 Sep 2025 15:59:16 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-65;
	Thu, 04 Sep 2025 15:59:16 +0000
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
Subject: [PATCH RFC 064/104] crypto: fips140: convert crypto/rsa_helper.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:36 +0200
Message-Id: <20250904155216.460962-65-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: c5EM9lTAyXwNtM04CSOw059tYivkEztj
X-Proofpoint-GUID: c5EM9lTAyXwNtM04CSOw059tYivkEztj
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b755 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=p-M5X6iOyKJetTEfr6IA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX/3s7Tryl+o1h
 uOX7GtxUdGTLXV8kmOyZJngwd4+s9hz9YmSUesRWLREWrCv9W8dtc7NQtrwYZkWKkPR8pTVARNj
 ZrFphcwdCwCV/a7dQIMNP2tISfdyfOcnPYFpXfmHvlZNeHcwVyD0EuhF2ZsxMBwD82X6hts4jdZ
 QFpfOIBkR7dNr+RKkMSFIVI+MjcJAtOfV9ZjBlB6M4NjAqIkqg/hVgbJO2FoIOm8C8ZrVA6WJmx
 cgBfYRzuicNdXF1b0l1BYkRLhkjkXsxPR05QcY9oQCR5yujKNsqXL3zm7kYwgLwoq0+RM4YdfBV
 W483brBAWvYgIiAzFpzj9BfoPBFxsHMicVmhkqMtGxHD/MlsUsK2taRY3U8jBoVVQ0Faiw2XV5C
 khtgMQEKkkR2uqF8acOC9WCw+rf1RA==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_RSA --source crypto/rsa_helper.c --header include/crypto/internal/rsa.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c          | 12 ++++++++++++
 crypto/rsa_helper.c           |  8 ++++----
 include/crypto/internal/rsa.h | 12 ++++++++----
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 8810af32dd43..47977f5b8554 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -488,3 +488,15 @@ DEFINE_CRYPTO_API_STUB(crypto_del_default_rng);
 
 #endif
 
+/*
+ * crypto/rsa_helper.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_RSA)
+
+#include <crypto/internal/rsa.h>
+
+DEFINE_CRYPTO_API_STUB(rsa_parse_pub_key);
+DEFINE_CRYPTO_API_STUB(rsa_parse_priv_key);
+
+#endif
+
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 94266f29049c..ba1278fcf393 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -159,12 +159,12 @@ int rsa_get_qinv(void *context, size_t hdrlen, unsigned char tag,
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
+int CRYPTO_API(rsa_parse_pub_key)(struct rsa_key *rsa_key, const void *key,
 		      unsigned int key_len)
 {
 	return asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
 }
-EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
+DEFINE_CRYPTO_API(rsa_parse_pub_key);
 
 /**
  * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in the
@@ -178,9 +178,9 @@ EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
+int CRYPTO_API(rsa_parse_priv_key)(struct rsa_key *rsa_key, const void *key,
 		       unsigned int key_len)
 {
 	return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
 }
-EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
+DEFINE_CRYPTO_API(rsa_parse_priv_key);
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index 071a1951b992..1265aa81f6fe 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -7,6 +7,8 @@
  */
 #ifndef _RSA_HELPER_
 #define _RSA_HELPER_
+
+#include <crypto/api.h>
 #include <linux/types.h>
 #include <crypto/akcipher.h>
 
@@ -48,11 +50,13 @@ struct rsa_key {
 	size_t qinv_sz;
 };
 
-int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
-		      unsigned int key_len);
+DECLARE_CRYPTO_API(rsa_parse_pub_key, int,
+	(struct rsa_key *rsa_key, const void *key, unsigned int key_len),
+	(rsa_key, key, key_len));
 
-int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
-		       unsigned int key_len);
+DECLARE_CRYPTO_API(rsa_parse_priv_key, int,
+	(struct rsa_key *rsa_key, const void *key, unsigned int key_len),
+	(rsa_key, key, key_len));
 
 #define RSA_PUB (true)
 #define RSA_PRIV (false)
-- 
2.39.3

