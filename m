Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B58284696;
	Thu,  4 Sep 2025 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001645; cv=none; b=DoBt884YVhas4kz+ZMdb/o3Kqtpu31+Em9DQI7h14XsaiS1R2sUx8vBIVdT4DWIVbJkMb8XGYfTZVvHUhEoNYCxEYDJUmeodFGdD0SSlqZDlucEtqK9XHxZCZ/cK0Zj+Ox77qlD+F3od5knif9kRQd9gmm3OCe13TNRSzcIaPss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001645; c=relaxed/simple;
	bh=LtTtGJiDrXKJbhzz7/cA4yqNtQrHu7UVPaM8z8ykfW8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Su0RhPAoq7SFWkIWvTL685hdoZNCCpbSMQW3jGbg4wMEKf+D0RFRGzssC2l7XdMM3iJBOBEvLmfV+rSN7pOUFpk6CQ5O5L403fi8d0WLT49fwSI6mW/uZlI93eRETHUyxeUO3PpT2fgdc8BfKLjYHXrnt4wOTaCbqyIp7MJ7Pbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RULB0z97; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RULB0z97"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjKM010465;
	Thu, 4 Sep 2025 16:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=e/Adc
	0BUGfgWz1WDIG/S0G+drreanl9QgMnEnDTttSg=; b=RULB0z97Vid5j6ulUneYt
	2KShwoKpA+//CxJwqQqu7fdoAcF2GT9Hr0R8QkpjH1+JfPS/B0Mr/0O5g5sdJwE5
	0Qa4irze2HDoUB5cJ2nuoQmjRtQ4BIsiWvCmNLb81lGo9cX+cHoidV9YTYxVVyJe
	yqlgn7bnJvwh3di4APpg1nEGxs7vBqMjg9lcqX3rSN8rYYkz+X0HbPzQDenuhztm
	Ru36pWut6QSK6NXsmBTsV2jJHyImttA9AmHYwmcZr3VDTXCZOwpC5hE5dXxurS8m
	9SYnLm6yF9QeADLBtjzplsfvm3zSQP+drp+7CSYFKNaQF/bojbH1u2V29wlb78++
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr30u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FedqK040082;
	Thu, 4 Sep 2025 16:00:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtsee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:27 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7Y000707;
	Thu, 4 Sep 2025 16:00:27 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-84;
	Thu, 04 Sep 2025 16:00:26 +0000
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
Subject: [PATCH RFC 083/104] crypto: fips140: convert crypto/asymmetric_keys/public_key.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:55 +0200
Message-Id: <20250904155216.460962-84-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: 7xrLE1Diy2GJgwl5DuwhveGejONHQAvF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX8gFF/kFVGGgS
 3vrcVghGX/A7IcJSeB8ht43Su133ON/pOFCF2FAih5ldIlJMHjatDLeGnKGSTMaZbeUrt8P94Tz
 lNS7ILcgO7L/dHXNrKTtBjpE/j8d1jwnTcbDykfgNFSmFzqKoRgmJu1UtkuRJ8s7kyUEcEZgBZg
 2B0JSoTBsv1vxrLF9/aHuxyr/GnjxQEdbkUR9tt8Tw0XcKplylF3iwx4IA2SQY6rSmNs5ne3k6o
 XDMIPy9y2GMh02mQQ288Ian+SXSRVWhTfnn8Xa2q0VF9Bws1Xuqp5AAreEzpSkOQqlVV/AcBDlK
 EQw1rNrVWJ/OSCDHfmG1vB+lbexxujpv5PizlDq+0emEOWblRp+0i+z2GBlgNtq+e97jYfemjPm
 YkkX8qG5bF+3sbiucxt50yp1wYyZNA==
X-Proofpoint-ORIG-GUID: 7xrLE1Diy2GJgwl5DuwhveGejONHQAvF
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b79d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=MzB02fGxu2AFUrhEgl8A:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE --source crypto/asymmetric_keys/public_key.c --header include/crypto/public_key.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/public_key.c |  8 ++++----
 crypto/fips140-api.c                | 12 ++++++++++++
 include/crypto/public_key.h         | 10 +++++++---
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index e5b177c8e842..a35689994302 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -39,7 +39,7 @@ static void public_key_describe(const struct key *asymmetric_key,
 /*
  * Destroy a public key algorithm key.
  */
-void public_key_free(struct public_key *key)
+void CRYPTO_API(public_key_free)(struct public_key *key)
 {
 	if (key) {
 		kfree_sensitive(key->key);
@@ -47,7 +47,7 @@ void public_key_free(struct public_key *key)
 		kfree(key);
 	}
 }
-EXPORT_SYMBOL_GPL(public_key_free);
+DEFINE_CRYPTO_API(public_key_free);
 
 /*
  * Destroy a public key algorithm key.
@@ -365,7 +365,7 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
 /*
  * Verify a signature using a public key.
  */
-int public_key_verify_signature(const struct public_key *pkey,
+int CRYPTO_API(public_key_verify_signature)(const struct public_key *pkey,
 				const struct public_key_signature *sig)
 {
 	char alg_name[CRYPTO_MAX_ALG_NAME];
@@ -437,7 +437,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 		ret = -EINVAL;
 	return ret;
 }
-EXPORT_SYMBOL_GPL(public_key_verify_signature);
+DEFINE_CRYPTO_API(public_key_verify_signature);
 
 static int public_key_verify_signature_2(const struct key *key,
 					 const struct public_key_signature *sig)
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index fb3dc947022a..49e89f4bdddb 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -675,3 +675,15 @@ DEFINE_CRYPTO_API_STUB(pkcs7_supply_detached_data);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/public_key.c
+ */
+#if !IS_BUILTIN(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE)
+
+#include <crypto/public_key.h>
+
+DEFINE_CRYPTO_API_STUB(public_key_free);
+DEFINE_CRYPTO_API_STUB(public_key_verify_signature);
+
+#endif
+
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 81098e00c08f..46e6e14b8559 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -10,6 +10,7 @@
 #ifndef _LINUX_PUBLIC_KEY_H
 #define _LINUX_PUBLIC_KEY_H
 
+#include <crypto/api.h>
 #include <linux/errno.h>
 #include <linux/keyctl.h>
 #include <linux/oid_registry.h>
@@ -35,7 +36,9 @@ struct public_key {
 #define KEY_EFLAG_KEYCERTSIGN	2	/* set if the keyCertSign usage is set */
 };
 
-extern void public_key_free(struct public_key *key);
+DECLARE_CRYPTO_API(public_key_free, void,
+	(struct public_key *key),
+	(key));
 
 /*
  * Public key cryptography signature data
@@ -108,8 +111,9 @@ extern int verify_signature(const struct key *,
 			    const struct public_key_signature *);
 
 #if IS_REACHABLE(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE)
-int public_key_verify_signature(const struct public_key *pkey,
-				const struct public_key_signature *sig);
+DECLARE_CRYPTO_API(public_key_verify_signature, int,
+	(const struct public_key *pkey, const struct public_key_signature *sig),
+	(pkey, sig));
 #else
 static inline
 int public_key_verify_signature(const struct public_key *pkey,
-- 
2.39.3

