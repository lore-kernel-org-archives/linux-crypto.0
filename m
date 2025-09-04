Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A50C28850F;
	Thu,  4 Sep 2025 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001631; cv=none; b=amgP7qLgIgcMwZmf8ogp4vtPJbNBOcGTVIHq386fCyOhc5pmkUAqlppUnSsFrBFevwLz99wWt9goAh3ArLqyiBEQCJWuqX3FRQmWJSrEY5utk2TpU9eqLT66M2G32hgcm+FS9xlf0UWzbY0wHKClNfbSXoW2UM401EnSQGO5dxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001631; c=relaxed/simple;
	bh=bDLaYRSDOaR9nSAQ/NVZmhN/6RVuHZjPAPALuC7k//4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GepwR2/rgnAlWb3RymIFWXgfH1etR/rRafwskcauf3/+rD7y8BKEMcIlgH7GhEmJcCQvo4Dh1FGiu33X8VyVAByvxBk6faR49+F+WWpK4JkjsViDAFmiRpq+dJp2n84++VzTUt1nX1npnKMoRKbe4Kt+FGRtobFXvgebK7F9n4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OJPbyOJm; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OJPbyOJm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuela004077;
	Thu, 4 Sep 2025 16:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=K2RBG
	ChugR1aDWYehn/rKYr/EzQdrq0YrDDLh9j6hDI=; b=OJPbyOJm3T30DflM4MFIv
	1mJxY1jwroagQoyNbYkXZ+b8EUe8tLwaaHmc6tN05LU7FE4C34E/6uRsudh0NNc9
	lsloG0btIgws1xxGzkVb5jQtrAth25Q4baJ2GhSPcW8BFlLcVKsC1zKv7L/Gg3z3
	3+Wy0olZ4fjuTAL2UKooJDUjw0XVr2vGrPK/eGQDqw6a9bNr9o7VhsReQcnQ4ri8
	ai3xc9Q5HQUX4PKTPgr1771uKXEND75hIkZEKWgB8reNja046Ue/Vc+/+58Q59Ok
	//lxM1xToXbc2FFBFQPFdFLnCdAUoaorZfIW0Df2H6kREr+cZ2MRrZ214nxsW22P
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun0084-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F7Qq2040109;
	Thu, 4 Sep 2025 16:00:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtrwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:16 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7S000707;
	Thu, 4 Sep 2025 16:00:15 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-81;
	Thu, 04 Sep 2025 16:00:15 +0000
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
Subject: [PATCH RFC 080/104] crypto: fips140: convert crypto/asymmetric_keys/pkcs7_trust.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:52 +0200
Message-Id: <20250904155216.460962-81-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: oPodm8Gd3DlNMFVe4umafaVr2kZGXuKI
X-Proofpoint-GUID: oPodm8Gd3DlNMFVe4umafaVr2kZGXuKI
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b791 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=nGXLWeCPwzFqg8WHzYQA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX6/v/UzIBihyk
 rNZmUlbp3OCbOVcE5iXIXHHCchrFvUpeIbDJBknd1BxVi2Mxcr7Kw01SYOSLonbLCHBaaNWfk/R
 cTTVu86jJWrellvN9nDTLmxxB7EvfFWaSPwDIxgdGlow82q/tvF8hLdl2t6PV4e+ScQLdwBlUZG
 nKCE4uWt4DM8qEmb8TPufXy/xXHBqYbD8chOCMQqG5Y/m9iCmtAViuh7MaJEVF5bP8Q7V4rP08l
 2aht0EUGF1MJUUxo2MhCIE2aeFB+Fr5K56dHBP+ekiy6h0vu7ibyxfdu5IfmpUPCx+BBuFipYNh
 dkl+vuE9+QF5zv5LFbPbPEZZp4g2vQCaFDjVMm0NOti26M6ZrFCu1+ex4/AEKSdW0iVIE3sXgHm
 JhiEVORMEUDdp5xLlovU3Ngco+HCxw==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_PKCS7_MESSAGE_PARSER --source crypto/asymmetric_keys/pkcs7_trust.c --header include/crypto/pkcs7.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/pkcs7_trust.c |  4 ++--
 crypto/fips140-api.c                 | 11 +++++++++++
 include/crypto/pkcs7.h               |  5 +++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 9a87c34ed173..0c04ba146ab6 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -155,7 +155,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
  *
  * May also return -ENOMEM.
  */
-int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
+int CRYPTO_API(pkcs7_validate_trust)(struct pkcs7_message *pkcs7,
 			 struct key *trust_keyring)
 {
 	struct pkcs7_signed_info *sinfo;
@@ -185,4 +185,4 @@ int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 
 	return cached_ret;
 }
-EXPORT_SYMBOL_GPL(pkcs7_validate_trust);
+DEFINE_CRYPTO_API(pkcs7_validate_trust);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 36d7cd3595a9..f65b2a950ccf 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -652,3 +652,14 @@ DEFINE_CRYPTO_API_STUB(pkcs7_get_content_data);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/pkcs7_trust.c
+ */
+#if !IS_BUILTIN(CONFIG_PKCS7_MESSAGE_PARSER)
+
+#include <crypto/pkcs7.h>
+
+DEFINE_CRYPTO_API_STUB(pkcs7_validate_trust);
+
+#endif
+
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index fcb744d3f436..bec3884eb242 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -33,8 +33,9 @@ DECLARE_CRYPTO_API(pkcs7_get_content_data, int,
 /*
  * pkcs7_trust.c
  */
-extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
-				struct key *trust_keyring);
+DECLARE_CRYPTO_API(pkcs7_validate_trust, int,
+	(struct pkcs7_message *pkcs7, struct key *trust_keyring),
+	(pkcs7, trust_keyring));
 
 /*
  * pkcs7_verify.c
-- 
2.39.3

