Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3167F28314E;
	Thu,  4 Sep 2025 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001449; cv=none; b=KKMSf2tA8R1e8+7IRZ4rOY8nOvju2R8nK81306EwZ8/A64WRACtL6YmI4qHS+8e5NXSzGp2DqPH7zYJuYBqQVwW32YMlfNF33Y5V8J8Nb0qf7hwvk+BTG07UuYCianLptc7EfXmcUAHehQXAKt/0M9dxhMixqWVsz0/Z5tC9Rew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001449; c=relaxed/simple;
	bh=2kB6eplUb9ap0Gv+2lQET/8Z3sX9wCVh7r51zrOvnwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lb9/KVTdesLMhqw0UcuDmsdkO0wFvQtHiskdR33YhMGEYJFACWKmNduene4C7i60OLJ/u/f3Dt5wIBJKzV0Xy/FUwGr3ZhUKEHg+T2AJkcX9BujnJbw4DmFWsV4bF4RUaICSYmf7Ln7lqdpnYVADZtlxpDyonUk5tBr+ipH6Dsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KHAE0nTz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KHAE0nTz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtpQ3027809;
	Thu, 4 Sep 2025 15:57:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=R0K3m
	S/+QHoX6lWJ8RJqVFI7CZUjVv5QY553VOp5hko=; b=KHAE0nTz74OptrwNV5EfD
	+sAp37P9PhKKMF/g1xbFGkIRQLiY88e/yC3uOLuYjK13wElgoHNS02vpqUiul4QR
	P8ZYLbMUqKIXByHLN2qFJumf2p1ke6qTj4GwdKfaBb0o+brwjf0QcaoIJEQV5xQY
	C3gXbc1bc32YHkTr68E98nQtJf0iDOnX70gvHhFEfqdG+Zt+zVstmLSKbpwLWsQ+
	SDD/5gahtNwABZN4iDqxN+zVrKwtA4Etim1ROQkZCoDI+4KTYebzCMmCnqgNe9Gx
	SMkVvJgjEwj+NmVvkw5YyC3Tmg1G4muemKow8eGfAqpAhHrfst8ejhi0di4uFbeY
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn071y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedoe040082;
	Thu, 4 Sep 2025 15:57:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:14 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx60000707;
	Thu, 4 Sep 2025 15:57:13 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-37;
	Thu, 04 Sep 2025 15:57:13 +0000
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
Subject: [PATCH RFC 036/104] crypto: fips140: convert crypto/authenc.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:08 +0200
Message-Id: <20250904155216.460962-37-vegard.nossum@oracle.com>
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
 definitions=main-2509040156
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b6db b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=2qxeGsSNoiSZSQ8gfzQA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: PnMFhbM3vVkDJGqjHACe7HKVYgZMRd4A
X-Proofpoint-ORIG-GUID: PnMFhbM3vVkDJGqjHACe7HKVYgZMRd4A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfXwBN5U9jyBSmv
 cwgQ20VHR3/4NO7zk2aW0i2on7UBlfj0+nGaB6q0Dlls8iXohliPXKXc2NSNAo1sOSEgDcipzBs
 9Mt0He3ZCZbCjMTpdjuSeJ29o2p7oaP3wx3R4C0Q7ZwJyZ3mVZCh7fLxjWDm6mFebOqk6mjmcXX
 XAwzVAqmsEaHHXr7Z7DcMxUARns6iwlYcJFWSW8IPcuF3KtnsJw2MhSXNnOmpCNID67yRkvZhIW
 Y+qDIF1mtw2mDhTYLclR7DaKjkXdwvPUq+3ChWHflUJ22eT/9pleZT1wMFjbym90yM1YGIFUjYk
 nv09/PZ9lrOOmROK/xPp0IrXjtx77WA/VdCqpAAH7eycJTZmBxpW/0czSTR6J0j8Jck+pH93aT+
 wuoud2nDD2yIWwh8NfN5OEuuhNNO6w==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_AUTHENC --source crypto/authenc.c --header include/crypto/authenc.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/authenc.c         |  8 ++++----
 crypto/fips140-api.c     | 11 +++++++++++
 include/crypto/authenc.h |  6 ++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index a723769c8777..4fcb42a66e80 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -41,7 +41,7 @@ static void authenc_request_complete(struct aead_request *req, int err)
 		aead_request_complete(req, err);
 }
 
-int crypto_authenc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
+int CRYPTO_API(crypto_authenc_extractkeys)(struct crypto_authenc_keys *keys, const u8 *key,
 			       unsigned int keylen)
 {
 	struct rtattr *rta = (struct rtattr *)key;
@@ -77,7 +77,7 @@ int crypto_authenc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_authenc_extractkeys);
+DEFINE_CRYPTO_API(crypto_authenc_extractkeys);
 
 static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 				 unsigned int keylen)
@@ -421,8 +421,8 @@ static void __exit crypto_authenc_module_exit(void)
 	crypto_unregister_template(&crypto_authenc_tmpl);
 }
 
-module_init(crypto_authenc_module_init);
-module_exit(crypto_authenc_module_exit);
+crypto_module_init(crypto_authenc_module_init);
+crypto_module_exit(crypto_authenc_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Simple AEAD wrapper for IPsec");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index f5cf473f1f25..df1dfcd5cf22 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -302,3 +302,14 @@ DEFINE_CRYPTO_API_STUB(crypto_destroy_alg);
 
 #endif
 
+/*
+ * crypto/authenc.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_AUTHENC)
+
+#include <crypto/authenc.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_authenc_extractkeys);
+
+#endif
+
diff --git a/include/crypto/authenc.h b/include/crypto/authenc.h
index 15a9caa2354a..2f01a570e899 100644
--- a/include/crypto/authenc.h
+++ b/include/crypto/authenc.h
@@ -7,6 +7,7 @@
 #ifndef _CRYPTO_AUTHENC_H
 #define _CRYPTO_AUTHENC_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 
 enum {
@@ -26,8 +27,9 @@ struct crypto_authenc_keys {
 	unsigned int enckeylen;
 };
 
-int crypto_authenc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
-			       unsigned int keylen);
+DECLARE_CRYPTO_API(crypto_authenc_extractkeys, int,
+	(struct crypto_authenc_keys *keys, const u8 *key, unsigned int keylen),
+	(keys, key, keylen));
 int crypto_krb5enc_extractkeys(struct crypto_authenc_keys *keys, const u8 *key,
 			       unsigned int keylen);
 
-- 
2.39.3

