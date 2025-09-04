Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC29304BBC;
	Thu,  4 Sep 2025 16:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001607; cv=none; b=tyt/QE6EHWhAoz/7so1GH168YRF7m2Umyz6IK26NI/AtXkZevVQDT5gCchAjm0t46E6GgWXK+d2KH4u6FUecZm6qG7batx1si09ZjP+dd2Zx1WsgHD3EljXDtDoE0qB+MCbcu355hEkRG3A2Tmic4ufYXjgVoBUN626fiQT/fsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001607; c=relaxed/simple;
	bh=IBdszxGpxki3Stw+RoOnuhVEG56V/Q1Hru4UI3Zp9Rk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l9XTrmABW0NGRhaLGaTWYPfBlsCh4qkIF55Hx/n5Yk5QqL/HlXhG+rx8vLeTnESiTCda8eIrzdYQc+Uazn9YSHuYAvaDocISijgp58hJMX000dmLrux2y80AhyDO/B2FHRmXAJV+m4xJcF5PgTXcYR6lRYk62nZn8jhgSUxr7Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gJN09aXm; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gJN09aXm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuk7t004100;
	Thu, 4 Sep 2025 15:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Khn5T
	I8jNyVBPDxOqyf8C2shyeznrXYOkDUUzyZTA9s=; b=gJN09aXm1HRscOhVFDI2s
	++8SWCkdrOGWt4s4kXRL8B1imZ7JIqHWzveHCckrqu/y3zc8iMnThA7dOLPotRH4
	lYZzUMGNbADVInlIMXeSdnPYxsrOeG+pzjStsvZYFzdXcuF/V21N7QWssjeybgGd
	WqherRrXovSplzB+mEsKZi+ywfPxfedpjUMgM/7YegoHS1jzDY1quWio27nx7Cil
	LIu3hRn23Sl93WhYpaKsgRVc/RH155ZwHOBhUuXs7i4tX42VXDzhqpXyp/aZlMNX
	JXBvCDNA4xWWcaYe/reuhNqRnvU2UK5HWDGFszxQISJnGwpa/MJd8k4sOZ71KynX
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun0078-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Evw3v040310;
	Thu, 4 Sep 2025 15:59:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtr3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:51 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7G000707;
	Thu, 4 Sep 2025 15:59:51 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-75;
	Thu, 04 Sep 2025 15:59:51 +0000
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
Subject: [PATCH RFC 074/104] crypto: fips140: convert crypto/tcrypt.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:46 +0200
Message-Id: <20250904155216.460962-75-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: EMPxPcurv5Yopcn1AsbYvh1iBFtleTSf
X-Proofpoint-GUID: EMPxPcurv5Yopcn1AsbYvh1iBFtleTSf
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b778 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=9NBxSOz5KizJvwrhGbsA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX+GwV5HWg8y28
 Zd8QYKgUi/57uXggaodi0qACV7XMeovFCm3YfYQKIHRlVBXe3F+wbTOLN74tj66tH2H/51OG4PW
 6xhINezePnLGMQZ0m6GDgU8THa6bSotWpy3WeBx8afYrnf3+BJLtFBTgv7+A2uQG5auv3zzAZwV
 0/q71UoRjZvSLOezK42Q9C7mLuLTEV9H/qzzyFIDJtqiTPGwiXW2CDF3BEIHiF2rJzwLpanz1de
 vwLzTXano9g77bBd66Nq6B9oJ0RljnNCDxb1ZLyRoNaicX7aEAqb01mP3nADOiCntaU/G9kD5aP
 c8TM2/0S2s0ZkPF+HKvBYNc/21Bb2W6dxCAQ0u7YzCjdAQ4I11BkY07wbGhScCk1R0A0fD0n4/Z
 ionwarfiP+ekBtsS1iXE2b0OFL9K/w==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_BENCHMARK --source crypto/tcrypt.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/tcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index b69560f2fdef..233ab3073b79 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2864,8 +2864,8 @@ static int __init tcrypt_mod_init(void)
  */
 static void __exit tcrypt_mod_fini(void) { }
 
-late_initcall(tcrypt_mod_init);
-module_exit(tcrypt_mod_fini);
+crypto_late_initcall(tcrypt_mod_init);
+crypto_module_exit(tcrypt_mod_fini);
 
 module_param(alg, charp, 0);
 module_param(type, uint, 0);
-- 
2.39.3

