Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19FE283CAF;
	Thu,  4 Sep 2025 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001480; cv=none; b=TYqnS6cbVRyz2Qc/X7d+W2mD/CUY+UKGc8GGAnABET60Kkj/NIm9VBMjIJwd6Tqe6/x/Q2N2LgvXL33BvDjBOM6w2aBGNKBBu+APgwNItH/ULERtRswFR92VHqzTdp8p8BeBvzRVUH/v6ZDKtAYV2Qk7aieHMVb7TcCfA8pwbrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001480; c=relaxed/simple;
	bh=BZAuBQ6wi3wz/ZbqjGalFRb08HDMmtS29SItX0AgiCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ESp+zfb896WXT63p7b1eHwTYTvk8+2WXoz0Brj8SDIqm2pT9yfUaNZ0stELRICclGhw17uNlli5GVOR1MUFef0diItJpI9/rte8GAtKwfTes9fMmnNtUiOhzorop7RJTlYNR1jX+LohJVHlY3vB7gRQngt/dVRhnNdwSw9LSSaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q3RvFZpQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q3RvFZpQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fueks004077;
	Thu, 4 Sep 2025 15:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=qVNha
	P+W3Wxvz9ZZiHpjxaXH/LYt/Nq7LLnWjuN+7aY=; b=q3RvFZpQ2evkIOmwBryWh
	/61yp+6yoQPHXS8ybgQ64ZIdKHk38pUlb0Bx5OZF/SATFm1glgCQS21JHHNpFfri
	ljtCK1MpJUaZb6Sv4bSQbSijV/IVpiQ9h35dLcZZ0qZC9wxrPF8SkGOfd3d5Y1nu
	NWHJ0ZdJLuDOkgYWDxJtS0tfTrIIVCDsQppF1bsvIl6YRLOctAxE9MlvR9MRps4t
	1yzC7R/CFSprloance0+zWtaMgWG2JYgw2iTDDOeaGc+lL3wfB471thOdf2ptFGR
	XqLI3S6ThFx5D7SWfkCAajHYFkWpm92PfyqQ/j4lPU3yJLtmd8imzTCsH3o8h5cJ
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun001t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F46pX040015;
	Thu, 4 Sep 2025 15:57:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:47 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6K000707;
	Thu, 4 Sep 2025 15:57:46 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-47;
	Thu, 04 Sep 2025 15:57:46 +0000
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
Subject: [PATCH RFC 046/104] crypto: fips140: convert crypto/drbg.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:18 +0200
Message-Id: <20250904155216.460962-47-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: c_OLEIxarcjz1dQWS2v0MIQ0AULKi4hO
X-Proofpoint-GUID: c_OLEIxarcjz1dQWS2v0MIQ0AULKi4hO
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b6fc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=fVoq7xtAiqsU_7J2nsIA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfXzCISpKDZmz0g
 d0Pu4QSUavF6vA1swBWFnLM7HAmFurB9ogrsKaBhQSNUCw0cMyZ6tqQ3USkiiMf3568GZ1lry3H
 kTuD1eMm9+pSked9AutiVbPYAJ4GGk/S7Z/Eyop2OVizMLdpr9oMOzVWRuk0oio5u7Stfz1EHIW
 6fx8MzC1L0aotMjU9lntXdbk6fxb59AoZ5Sz0xstGHEx8OLVtAz6Viri4lG4IaJR6ozd/h11pPg
 GYjh64dabywIFdUCUvCap/Kt8sVvjii34UVIte9qoQZq649eXvoKHO2bCD37y0P2VsE74vpPdTR
 Va1UMuVcdcIorrGAX8ZlaJ+IUeEzQAHve0qD/57AETcxbaJLQ7dsIkXbk8PGraykynOqxetDewG
 oZJlgAz6xxibBfK4NKPah50fMIMyug==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_DRBG --source crypto/drbg.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/drbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index dbe4c8bb5ceb..64280ce5beec 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2132,8 +2132,8 @@ static void __exit drbg_exit(void)
 	crypto_unregister_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
 }
 
-module_init(drbg_init);
-module_exit(drbg_exit);
+crypto_module_init(drbg_init);
+crypto_module_exit(drbg_exit);
 #ifndef CRYPTO_DRBG_HASH_STRING
 #define CRYPTO_DRBG_HASH_STRING ""
 #endif
-- 
2.39.3

