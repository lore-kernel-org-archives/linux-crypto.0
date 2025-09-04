Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A278E286427;
	Thu,  4 Sep 2025 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001396; cv=none; b=Pc+DRALYZFO78wh4cS4B2oeGJMxjlhfxv1ES5h4/CN5Nbi5uU6bXAdxr8kA0fkOTxmaK0zVet8lGIJ816kaldZ/a5cKTFaVViR7sVdFrWjazl4PSWwwBryWOrTpuCcbfYDZKxwt22rHnVbsvLPjfBUJbxVoDqAfi9WGhUO3HxVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001396; c=relaxed/simple;
	bh=cyNFWsmdUo4TJ2/tN5ziOKqdHWZBUIC7nAT84SJ5+TE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KWlc9A7vFMr+fjK8PbAfRHh433kH0nGcjHy3/2jcah/YOVivn+XuXoR5mxA5WS3hafnQarZSEFZ+vtmGiIRy9LcwynnlSaUFb5ChxTf8DftB2kH9W/k1aI6HsvPpCylcHwsRFAaHagac0wM3n6mSfGyivQfxi2Co+LC/U6YchPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PK7tm5zz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PK7tm5zz"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftp7p010553;
	Thu, 4 Sep 2025 15:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=uJ/XO
	wAElMUJrPClxAhrnCl0Ulx64YaIRTlvRa5KgzE=; b=PK7tm5zzMVqLIP8il8CtJ
	VajneRrR+hg6moMnQ3GI7lle2OLCT1c75TZfzUljweyPle3sSON7I+ZEP73XE5T0
	x1mgVJxGfaQA2u0HnVwXNi3eOoVBTysN5VMj1QeOI+UIvbyEpWqGoyZH1ikHdsET
	NgYUQJCkatSFdR8Ul+/WEajKQ8kBgty8jBhYsU8wes8ueabtKYySbov46nN48mfd
	CxhcRTAHl/XryssVpXQvB7rx5Wsne1+LbKlrh5UksnxdhmcZzBSsY8ksa07UgHD5
	/E3s/ngqk6GOmYk/RhRiXG+YiwU/YvQ5Buo73ZITaqURToj0iXoNUy8gC2Zl6tjA
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EuWCm040230;
	Thu, 4 Sep 2025 15:56:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:21 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5U000707;
	Thu, 4 Sep 2025 15:56:20 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-22;
	Thu, 04 Sep 2025 15:56:20 +0000
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
Subject: [PATCH RFC 021/104] crypto: fips140: include crypto/api.h in a few places
Date: Thu,  4 Sep 2025 17:50:53 +0200
Message-Id: <20250904155216.460962-22-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: 46z7tf8xlF-J9nthnwSNea5ftDxqnUAY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX0wkjVvJkCERi
 lUZimhISZbNnzl3ZBo5vfcfwCinvCZoy5yeoPD+tN+pgqGMzjKv1LUH1XQNPIKEY5YOUj4SLctC
 i9N5jy3jybCPbLmBipWUrjfYEFsZ5vh13kixi5o54UZoXcK4F4vWJLJLw4tWil/OAfl7qnw2CTm
 IE8zyWOo9J3VKpzpWF01YvULErL55/Y9iTqiF8gEbBGTOctvHw+NgSQc49bLFMBFJkXZ9y/8gNy
 Kn0obvnvExwtp+Pj92AV1OJASaZA8c+Qr4vw2prpfP4M5UzFbPWpQBEq56fu+8rSsBwQwnt9FE7
 kPA8XAmg3dv3cFA8tgP4RpEKMCYrdTfSDfqOGuwwwBJFHGQbENvaIsfLwkxSNXRuZQrG0honN4R
 oGzxCd2WfGP2mlhRN7xVAD+2Srqo+A==
X-Proofpoint-ORIG-GUID: 46z7tf8xlF-J9nthnwSNea5ftDxqnUAY
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6a6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=yiOFjC3WA3SV1473uhQA:9 cc=ntf
 awl=host:12068

This is preparatory for the subsequent patches which mostly manage to
add in the necessary includes automatically but will miss these files.
I could have chosen to squash this into those commits, but it's nicer
not to mix manual changes with scripted changes.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/pkcs7_key_type.c | 1 +
 include/crypto/dh.h                     | 2 ++
 include/crypto/ecdh.h                   | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index b930d3bbf1af..e71be8b5b0f2 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -6,6 +6,7 @@
  */
 
 #define pr_fmt(fmt) "PKCS7key: "fmt
+#include <crypto/api.h>
 #include <linux/key.h>
 #include <linux/err.h>
 #include <linux/module.h>
diff --git a/include/crypto/dh.h b/include/crypto/dh.h
index 7b863e911cb4..b5891c21cfe0 100644
--- a/include/crypto/dh.h
+++ b/include/crypto/dh.h
@@ -8,6 +8,8 @@
 #ifndef _CRYPTO_DH_
 #define _CRYPTO_DH_
 
+#include <crypto/api.h>
+
 /**
  * DOC: DH Helper Functions
  *
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 9784ecdd2fb4..aa09f880c0d3 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -8,6 +8,8 @@
 #ifndef _CRYPTO_ECDH_
 #define _CRYPTO_ECDH_
 
+#include <crypto/api.h>
+
 /**
  * DOC: ECDH Helper Functions
  *
-- 
2.39.3

