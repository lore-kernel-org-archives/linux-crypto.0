Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58EB280335;
	Thu,  4 Sep 2025 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001427; cv=none; b=EH9XIUa/PIp2jcvBnoZt0MEbiitusRFNhRqS0IBLOCOC3u5BQPAzGH8kB2bX9ppWdl/31LIE2bdoUspfFWx+DnEyGPccyRHjSh0fnDO1CtOHDy38l49zfiGu5FoiCM+BHziuHmdQwXVHy6XCufYApFtZZLJ8Mt0pkt2q0MTO9Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001427; c=relaxed/simple;
	bh=snXi87SfZJ2MPifiJh3If9Npphrj6H5I6xwYiT43UJU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FCyUtQlpOI8RukcssOKH2L0RlmFwiKs9yJcI/mZ/ib4TqH8k7FkQJWvYEQ0npWl8N3lwjBsrmsrValMNorScVTV1FFR0/16yoY2ayQfKWPf/lhLCn53+0G7qhfidWbhgaqWs6VjWDksmMJdWekFmZBGFGYYYSdfhee6bPc34Luo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H9W3EDst; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H9W3EDst"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FurcZ004119;
	Thu, 4 Sep 2025 15:56:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=eiNCZ
	vae8r6ANeRL6JeyTV4arNCqlMuiAaxNO6+7WKI=; b=H9W3EDsts8MmN1M8+0hsI
	YJANAK9RgKOBX0mLbhL89PHR4+rHIlZg5GJClZ1g6FksmbXcn66ZPDszZNUXnOkq
	LoepfDXl8sZ9mVHGns22LWBGKLTncl3J5ENocy94NMDYvC41Zr0CienhzpxpMNMR
	NcWePBmcYl4UrpqCRtx++5h1WTRb5opUpTyG8mD8Syx8vHUpde824LD1oKdu4T7c
	kYa9daeGKg2TQfobXdOw0mCqzaP2WQJ8i1/uxVtdXrtpB68+ENm0X9LaWZJ/+arP
	wlIWCVkVAXDGGfw/1nfzLEmK09kiM85SDmrXfm7iKDc/J/gHXPXiDXxu0+/2ZbFS
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun000h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FedoQ040082;
	Thu, 4 Sep 2025 15:56:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtndp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:52 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5m000707;
	Thu, 4 Sep 2025 15:56:52 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-31;
	Thu, 04 Sep 2025 15:56:51 +0000
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
Subject: [PATCH RFC 030/104] crypto: fips140: convert crypto/aes_generic.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:02 +0200
Message-Id: <20250904155216.460962-31-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: nya5SEr9KLMJ9E-SXL-FVSP7rmd5ZRv6
X-Proofpoint-GUID: nya5SEr9KLMJ9E-SXL-FVSP7rmd5ZRv6
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b6c5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=LfKwApsnRnMPoHVqJ-UA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX5Jvzk4++jjY6
 UpVUxaxkRAxI6+NZU/hP2cv4mN0OmSM2h5kZgVj5UpNiLpV9SH/0/32A6MbevRwpC0hTAqBiFWQ
 1CzrcWEw6yXpoCsnguT9mXEk7pCrlKEYi6ixhiLM9KEGAwFJKV7A6fLo57sVLSWLUHNQAk77od2
 x2v8Kh6hHHTqEh6Res13iacVmJrYQ7dADGmU7teKehMzMBLZfB4hJe2mhznOFqP9WSkqcC6ihSf
 DFZ9JXQGv2zrRUl0bBgtOS9g17h9AlHW93ccSZVVY+GNDmA9uiLFB5TpCyylV6Ko+eTP1wGrs1k
 D2Zk5k5JiKZz3s2bdqdfv4IV/x0QQ1tjZ/0maJJaiCk7bp2/cLrO5obKLaLdzGDJj93MK2zCeIc
 dqkavByuYULwpQXfwtMOfiiLP+qOVA==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_AES --source crypto/aes_generic.c --header include/crypto/aes.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/aes_generic.c |  8 ++++----
 crypto/fips140-api.c | 11 +++++++++++
 include/crypto/aes.h |  5 +++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 85d2e78c8ef2..b3bf792f82f2 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1133,14 +1133,14 @@ EXPORT_SYMBOL_GPL(crypto_it_tab);
  *
  * Return: 0 on success; -EINVAL on failure (only happens for bad key lengths)
  */
-int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+int CRYPTO_API(crypto_aes_set_key)(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	return aes_expandkey(ctx, in_key, key_len);
 }
-EXPORT_SYMBOL_GPL(crypto_aes_set_key);
+DEFINE_CRYPTO_API(crypto_aes_set_key);
 
 /* encrypt a block of text */
 
@@ -1311,8 +1311,8 @@ static void __exit aes_fini(void)
 	crypto_unregister_alg(&aes_alg);
 }
 
-module_init(aes_init);
-module_exit(aes_fini);
+crypto_module_init(aes_init);
+crypto_module_exit(aes_fini);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 896b42fb4330..88858a1f9915 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -152,3 +152,14 @@ DEFINE_CRYPTO_API_STUB(aead_register_instance);
 
 #endif
 
+/*
+ * crypto/aes_generic.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_AES)
+
+#include <crypto/aes.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_aes_set_key);
+
+#endif
+
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index a72621f552d8..6a732ea5ee1b 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -49,8 +49,9 @@ static inline int aes_check_keylen(unsigned int keylen)
 	return 0;
 }
 
-int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		unsigned int key_len);
+DECLARE_CRYPTO_API(crypto_aes_set_key, int,
+	(struct crypto_tfm *tfm, const u8 *in_key, unsigned int key_len),
+	(tfm, in_key, key_len));
 
 /**
  * aes_expandkey - Expands the AES key as described in FIPS-197
-- 
2.39.3

