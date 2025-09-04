Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AD627280A;
	Thu,  4 Sep 2025 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001372; cv=none; b=G/lVYNl0LwUHZ13E6wcT3A+s22lz0vctxMxkvFrLg8+ZXhEyBEfq4DrWek5FbGBS23IgXtRv8xVYXQElaYr7/8YdjAYC/yIndts4YjOVRdrT8Z3gDFp5uHSkES5du+u3L4QKSuS+nukaU6q296Ts4D7LlYsBufsggIKimlCPSXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001372; c=relaxed/simple;
	bh=4pbKnGo8aE0eQrAIKPaq5DeEAkqcHEFtg1ZiayqlOQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DhVLywMmYDyYtODO8xtUnS0hBC3p+PzJDFa5y3tkBgYnTojskgiluMagC2VjGRncIqNCwJHj3Kc5wL+EJnsPLQriX994KtR1b5xswDR/oydxxEHsCwWptyO7Tfgc9yjktxm/0q3gqVaRY7Zhvdx3wR5S35E4aO1zc9WSdKDqQpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hg80+o74; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hg80+o74"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtpoX010552;
	Thu, 4 Sep 2025 15:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=9aQWk
	i5sZdBlGbfeecZuW76fQlN+9FoBA5UmGIoZ/es=; b=Hg80+o746mBiBfL+SOcon
	FY4roddTTQJEdpvzXCWWUeN9e3Z9GBj41XgxUm+PONFzuKuIc0PtzLM8HzGkjCe/
	b4f3aVwrnLjGdXOfND7Exj6JkPlQO5j5dIdaLftdbECSswTG1z3RoZ6OUjl2gWnA
	2BxylfANIkyJxBG3NfG/zAaWGDLwt8QlP57fFStgvurU3a+J28NoMcKavRu1xWWC
	Yvl7vb3oPzpyXZBsD0aMXV9NnoxWxk+H1LzTaGlqDVEyxXqBRFQ7sdKJ307V/F6Q
	8Dv6UgIfk+2y+f+1oZNRQ0UcOoqedx0Z5TVBbZDmx6hlV0yX5gk6CoK7i4/spEOC
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EwZRm040037;
	Thu, 4 Sep 2025 15:55:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtme8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:55 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5G000707;
	Thu, 4 Sep 2025 15:55:55 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-15;
	Thu, 04 Sep 2025 15:55:55 +0000
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
Subject: [PATCH RFC 014/104] crypto/testmgr: add helper to alg_test()
Date: Thu,  4 Sep 2025 17:50:46 +0200
Message-Id: <20250904155216.460962-15-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: di-T8jPJ6w9RXwHAYKUKYyJoA0DHs0Fm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfXwL0E10/yHUN9
 MQs789l6nBMJgCf/wCHPAvMRSDckxeIlgLedhy20IFSXsYTPER/VdhFHHHR1Eye/woe7XUiXTft
 c5+JCtGxMolqWG09rv4elDir992fGz1B5uiYLIgfZA42QJ192OioaLR9CipxnyntvvEBTT6sp2D
 FmMlAA3535qjiQfVq/Lg7FYhLRVjnqVpU3BaLDKf5z2EamS4UZhyInkjceNRPILR0rwOlEiG2MB
 m7jy2goe3Rbo+JxSMkL01ZZ2Qdvwn5ebW0VzNxv746c8uYigx/f236yzrAPCgQrCBs989nmuXet
 nNUPLPNxJK/zC1oxlYSHPewhEdSABBFvAVq3DgInXAS+L5zn+yXNsVok0I+4AB46y6zP3SfWv5f
 npy0vpoQbou2xB87uGJptGiu2vkgBg==
X-Proofpoint-ORIG-GUID: di-T8jPJ6w9RXwHAYKUKYyJoA0DHs0Fm
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b68d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=ci7oWrC8YUWSPfuW81oA:9 cc=ntf
 awl=host:12068

Add a new helper function, alg_test_fips_disabled() containing the
logic to decide if an algorithm is allowed to be tested.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/testmgr.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a216cb8b8caf..ab7c6724d36f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5771,6 +5771,17 @@ static int alg_fips_disabled(const char *driver, const char *alg)
 	return -ECANCELED;
 }
 
+static int alg_test_fips_disabled(const struct alg_test_desc *desc)
+{
+	if (!fips_enabled)
+		return 0;
+
+	/*
+	 * Only allow FIPS-allowed algorithms to be tested.
+	 */
+	return !(desc->fips_allowed & FIPS_ALLOWED);
+}
+
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 {
 	int i;
@@ -5795,7 +5806,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		if (i < 0)
 			goto notest;
 
-		if (fips_enabled && !alg_test_descs[i].fips_allowed)
+		if (alg_test_fips_disabled(&alg_test_descs[i]))
 			goto non_fips_alg;
 
 		rc = alg_test_cipher(alg_test_descs + i, driver, type, mask);
@@ -5808,10 +5819,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		goto notest;
 
 	if (fips_enabled) {
-		if (j >= 0 && !alg_test_descs[j].fips_allowed)
+		if (j >= 0 && alg_test_fips_disabled(&alg_test_descs[j]))
 			return -EINVAL;
-
-		if (i >= 0 && !alg_test_descs[i].fips_allowed)
+		if (i >= 0 && alg_test_fips_disabled(&alg_test_descs[i]))
 			goto non_fips_alg;
 	}
 
@@ -5855,7 +5865,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		if (i < 0)
 			goto notest2;
 
-		if (fips_enabled && !alg_test_descs[i].fips_allowed)
+		if (alg_test_fips_disabled(&alg_test_descs[i]))
 			goto non_fips_alg;
 
 		rc = alg_test_skcipher(alg_test_descs + i, driver, type, mask);
-- 
2.39.3

