Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFB22F3C21;
	Thu,  4 Sep 2025 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001660; cv=none; b=g5Rvcp1tsm4rsEb8xWe76HeGuxKyKrbldEd1T8TYLsLByXJv9Hj7/lzvaS7S1+KKY3PwTqLuam+1mHppRIeqW2bTuf5/TBYFapZ1yHThSLOexYp6OLhKoF7RE9xk69n0AhWzS+TdgUI6utNgsdFVAaagGxEQ5//eGe8CdFSLk8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001660; c=relaxed/simple;
	bh=9TPIzMzB5jaE1EtJ+R30ZOltUM6YKx4lC36pNRirqTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D4w73N/5UKCLv38culFUPDCTr0pHYm7y36AJlDQrl0DGDyxuRFOvaPeSMVFJlroV5bMJw7c1CuYU6ivwO9ZL/P7DDkm/XbnetYztIHYHUD0EFdz76D3pxnis0MLh/WkzKfWZDlKntW82EesqOxi/Wd1Q9ODrtsqOyXVxAmLIHow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SSlgyfAL; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SSlgyfAL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtppK010552;
	Thu, 4 Sep 2025 16:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=KyTlK
	dOlWb+d7YvycBFYFRYqHwMqbv06iolppBpHRXc=; b=SSlgyfAL+BSt9/xJIChfE
	DsXSZ1Ia+mFamiAIocGyhrKDs5A/MtaEGcPc4oS6kDJBaom7jArYFAGQBHoLNyZ2
	2NLJGNPnZqxhNo4kNCuMSYN9FzMjb5/WwvWkQT/Qb3d8jfryjdZVY8JJOUNUCsu8
	aBfYwXoHnbsnbn+OLfnB7XrbCbQ2eG8//6jsOaoBl3GxTCgbXklha2YA9QT5Aiid
	rTmOaQ9H4Ihs/SBJMV2J+V67EQhNDJDi7vl76MBN9Og4jZnYdN9zUKJXP7p1uZhU
	Yij15ioIKPznI61cpkJ6oZzna7zsIOkTYiyNLegPb3VwHplkND0WVzZqjDiFCGxW
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr31j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FgNXM040151;
	Thu, 4 Sep 2025 16:00:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtt0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:43 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7g000707;
	Thu, 4 Sep 2025 16:00:42 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-88;
	Thu, 04 Sep 2025 16:00:42 +0000
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
Subject: [PATCH RFC 087/104] crypto: fips140: convert crypto/asymmetric_keys/x509_loader.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:59 +0200
Message-Id: <20250904155216.460962-88-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: UfYPGMkj51-vXFWvZkCW8ZgBHrDOxAZa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX4hwNt1UVxkN9
 2evvq6bezOQ9wbT6POIATyE9bCQYW8gHznCWLeKoW5anuYuEKLlCC5bPWCaoshPoS8Sy90oKIPr
 BjvrQOE5MUaOnfMs7UpTUgfleKuabTKaD8/3wvu7HpvzGiIqYFr2ODpHWI+LPX1ksWg2WiXbeeG
 on6pQ7gqWJaaZc2LELLLyEBd+dvMjczq2o6Jt/tvaT85UiIwvlWmS8it0YOsQUINncokuC0DVX4
 +Kp1IFkrOMO8BB+ksdt0zSlVXeb3S37TWUQ9FzicySyPt3sejwqkPVbdocLWH7aBdCV2FUorOcM
 Qx43PjQK6qt+j0fF35zDl56taDmDNjyaTdlLi0eVAIii/TWVipJFcOmRVEynOfHraLxSwFwqcK5
 Xl8qk9JEZwfGXfT+FZEV8AaJoD9DWw==
X-Proofpoint-ORIG-GUID: UfYPGMkj51-vXFWvZkCW8ZgBHrDOxAZa
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b7ad b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=eiX3Vj3_IqpN7uzC1f8A:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_X509_CERTIFICATE_PARSER --source crypto/asymmetric_keys/x509_loader.c --header include/keys/asymmetric-type.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/x509_loader.c |  4 ++--
 crypto/fips140-api.c                 | 11 +++++++++++
 include/keys/asymmetric-type.h       |  5 +++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_keys/x509_loader.c
index a41741326998..a480763b1649 100644
--- a/crypto/asymmetric_keys/x509_loader.c
+++ b/crypto/asymmetric_keys/x509_loader.c
@@ -4,7 +4,7 @@
 #include <linux/key.h>
 #include <keys/asymmetric-type.h>
 
-int x509_load_certificate_list(const u8 cert_list[],
+int CRYPTO_API(x509_load_certificate_list)(const u8 cert_list[],
 			       const unsigned long list_size,
 			       const struct key *keyring)
 {
@@ -55,4 +55,4 @@ int x509_load_certificate_list(const u8 cert_list[],
 	pr_err("Problem parsing in-kernel X.509 certificate list\n");
 	return 0;
 }
-EXPORT_SYMBOL_GPL(x509_load_certificate_list);
+DEFINE_CRYPTO_API(x509_load_certificate_list);
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index db5b142e21df..91812ed74f8a 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -713,3 +713,14 @@ DEFINE_CRYPTO_API_STUB(x509_decode_time);
 
 #endif
 
+/*
+ * crypto/asymmetric_keys/x509_loader.c
+ */
+#if !IS_BUILTIN(CONFIG_X509_CERTIFICATE_PARSER)
+
+#include <keys/asymmetric-type.h>
+
+DEFINE_CRYPTO_API_STUB(x509_load_certificate_list);
+
+#endif
+
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index fb7f82527978..ee1bf9b28bfd 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -84,8 +84,9 @@ DECLARE_CRYPTO_API(find_asymmetric_key, struct key *,
 	(struct key *keyring, const struct asymmetric_key_id *id_0, const struct asymmetric_key_id *id_1, const struct asymmetric_key_id *id_2, bool partial),
 	(keyring, id_0, id_1, id_2, partial));
 
-int x509_load_certificate_list(const u8 cert_list[], const unsigned long list_size,
-			       const struct key *keyring);
+DECLARE_CRYPTO_API(x509_load_certificate_list, int,
+	(const u8 cert_list[], const unsigned long list_size, const struct key *keyring),
+	(cert_list, list_size, keyring));
 
 /*
  * The payload is at the discretion of the subtype.
-- 
2.39.3

