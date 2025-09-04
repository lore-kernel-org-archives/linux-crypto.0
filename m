Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1C02D322F;
	Thu,  4 Sep 2025 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001343; cv=none; b=F5L52nZZVykQXlMfZwChex3ZMunr45PgXEtdgOARqXhURg2qhA4ykLwe/3XLOFJB7ugNwd/8Mz+kBMo2Vp5rto8swrcU1rX9hGAGNFnZQ1dU0f3KSjRusTZru55T5F5mIm2CZBjX2wsIv+Bd9LEMKVrhFcSoBPWa+QRr3WwFwQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001343; c=relaxed/simple;
	bh=xRSdlmR/yWazqoD81pKEerk2CR5EYkuWvr9UkB895MU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jmtIUnBzXwm5g8P+N9wtSaDQAg3wINoYzJno2sUe/UjYODBPiuqTMo14/QtnckbG0o0SporjoS3qjRRPNXT7FbEt91Lr46lLwej/ATvdmFDrVqHrcSyUYaILfVzxVCiKI2l0mu3MmhmSm4YX22qcgjRShqizfh77FSaHSYaTXmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JoDZb2cK; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JoDZb2cK"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FjeEF008801;
	Thu, 4 Sep 2025 15:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=q64d7
	udWGMiLjjWA+0moofUx3X8YZ0jDQv1lPJTIk9w=; b=JoDZb2cKgtq1v8th9/yiL
	Bj2d9qlq0LZHYZKRdRIxCCO3b42UIluVXLGsiViEZRcWS0SJsuKJ9xINfuZwhccB
	bcy5gwHH2isXu3ga+ud1fzl9MrNPsIRtGB3mBHguJGDQknOxfeIGL9Tjff+WArRh
	j05gJyY0DtIgfCXav/m5v7ebA7I9wJNwaUvY/x8dUtNi3X3K6qVRDxHSOq2N7Yp0
	ca0vtSpfHPvr6qfj1aeFqNUt3YRu0JvXkV1YkTfF8ve8st4ruW3pcsP8LZc9Tg6g
	DPXwRqS0KduEvKBPPi1hYRBlhOmjbI++UvhOgCstP46DhhT38sDMOP78gCOW1Jk3
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd1004rx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FcVo3040046;
	Thu, 4 Sep 2025 15:55:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtm5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:29 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx50000707;
	Thu, 4 Sep 2025 15:55:28 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-8;
	Thu, 04 Sep 2025 15:55:28 +0000
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
Subject: [PATCH RFC 007/104] testmgr: standardize alg/driver output in logs
Date: Thu,  4 Sep 2025 17:50:39 +0200
Message-Id: <20250904155216.460962-8-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfX7bsvr0VRP1SR
 PK12c6oPgowXBFCPjbHMAVSU5vNrV2lHFcj1kNejr2qbW2abz3PK1RG8U7RctIw1WNnEBSnMc4Q
 yWjtfEKsLHuttNn8NICiupkcftGRutXeDwarihIG0cMLfWu7ASHTce9FPlFGuEqGQC4F5rk1yHl
 dMQHUCOsCavkF7MY2ThQTgSUJInanWaqIrZ/N30q5bVrHZG9Ne+OYXKom4LGvitmIqLu8eAEPBI
 4J/Nis3Igp4MFFalmbbXWLcUXR0wpsBfHHqec4QVjAXTV3ZO/BiPdyJ7viN6Pr6yb0UHWNUv4iv
 MpnOFMxCHRpC3KOn3lNM/Yp0y/KmOEbHgzqyun4U7F5TVbUKp199+8PBQ3E8g4+NiqhlX+x34b5
 g3ZEsocnQUTvRZio0Rhj/W/+4ZBUpA==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b672 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=rYamME7zdi_Fmqbn0fgA:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: 9k7ONWN7VtMQdSxDM8FIldBQb8nKiT4B
X-Proofpoint-GUID: 9k7ONWN7VtMQdSxDM8FIldBQb8nKiT4B

The crypto code prints log messages with algorithm name and driver name
in multiple places, usually as "$alg ($driver)", but sometimes as
"$driver ($alg)", which is confusing.

To remove all ambiguity, standardize on "$alg (driver $driver)".

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/testmgr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ee33ba21ae2b..47764fc879bb 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5753,7 +5753,7 @@ static int alg_find_test(const char *alg)
 
 static int alg_fips_disabled(const char *driver, const char *alg)
 {
-	pr_info("alg: %s (%s) is disabled due to FIPS\n", alg, driver);
+	pr_info("alg: %s (driver %s) is disabled due to FIPS\n", alg, driver);
 
 	return -ECANCELED;
 }
@@ -5814,18 +5814,18 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if (rc) {
 		if (fips_enabled) {
 			fips_fail_notify();
-			panic("alg: self-tests for %s (%s) failed in fips mode!\n",
-			      driver, alg);
+			panic("alg: self-tests for %s (driver %s) failed in fips mode!\n",
+			      alg, driver);
 		}
-		pr_warn("alg: self-tests for %s using %s failed (rc=%d)",
+		pr_warn("alg: self-tests for %s (driver %s) failed (rc=%d)",
 			alg, driver, rc);
 		WARN(rc != -ENOENT,
-		     "alg: self-tests for %s using %s failed (rc=%d)",
+		     "alg: self-tests for %s (driver %s) failed (rc=%d)",
 		     alg, driver, rc);
 	} else {
 		if (fips_enabled)
-			pr_info("alg: self-tests for %s (%s) passed\n",
-				driver, alg);
+			pr_info("alg: self-tests for %s (driver %s) passed\n",
+				alg, driver);
 	}
 
 	return rc;
@@ -5850,7 +5850,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	}
 
 notest2:
-	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
+	printk(KERN_INFO "alg: No test for %s (driver %s)\n", alg, driver);
 
 	if (type & CRYPTO_ALG_FIPS_INTERNAL)
 		return alg_fips_disabled(driver, alg);
-- 
2.39.3

