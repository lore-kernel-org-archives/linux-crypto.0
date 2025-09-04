Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C142A28750B;
	Thu,  4 Sep 2025 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001473; cv=none; b=ohDDrkvPg/GMubOa/vfNRr/p9HhKY/6LoK1Txh3zJRmRZigGQg9EfSfmcd6CyAIJsT1i27reWEV28yJLOe8SLo3nVTdfHc50L1dlbNWcEyq6bDK/83yppVc2oze0PMCI4m2P+jQJ7MzKD0x1K7V8G7n2ixKCCG2ecdwLjOKfauA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001473; c=relaxed/simple;
	bh=1EDns1lpkGFWvGKMxQ8rTUFRZDjutemO5cFx5A4C5zg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G0WXKbRlxeww6IpPaG30bFL8ddQ5KD6PwWFmWI+BiHotr4d/EfCZoOmEYgRTwOpqMZbsnjT4Cf+tb6agMEn3P+DC2ZzDSuAi6TYgI6sNnFgqd8xQrMgz8ZHm1t8O4jSsk144rqPU+CbsPYEJo89d59DjI5cogxiJHBvyNCiUnFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j+vTHKqc; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j+vTHKqc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftrat010582;
	Thu, 4 Sep 2025 15:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=+A8hZ
	nv9rYxTe5l4U+tymWHN/ax7CG35G8+4sG4Sggc=; b=j+vTHKqcQVm/PXKOwtPSA
	Tg+yojJWodxMJumxMGDj6u/BtvDWbJBMFXpuIDtoNRal3zkN9H/4+32WlZ4k+BQy
	buj5We1/tTo2WxpCNVPIr2bqZgi18qRGvsX0HbhlOgLdMjWRKZsmx5ShV5rf7P31
	M8qUSYysnWxen18EARwtw5XebeOJbwlp17QNfx2Qq1AviZGCbI2sdmTHGghEWliV
	VNlFN+qhCDkwxBDj93jBS7I0AwgYw0WWJ7jdyaJkhzfI4oi9lvGfjl75CKi+RqOF
	2zOWoXT77U3mz/0SoejjgAz3fL6eRw2tJ9pmNwk4+unRMwNEYhVCuW30T6Fa8AX7
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EPF18040051;
	Thu, 4 Sep 2025 15:57:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6E000707;
	Thu, 4 Sep 2025 15:57:36 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-44;
	Thu, 04 Sep 2025 15:57:36 +0000
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
Subject: [PATCH RFC 043/104] crypto: fips140: convert crypto/ctr.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:15 +0200
Message-Id: <20250904155216.460962-44-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: 5hwnjxZR3SM-aUaGM8ujSHfdhapfRsPo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX3bE5fEFXNAJB
 pP/tqCLd+vCWg/gseTEuLHZXKLmbs9TtboX8zAYeS11ejKQaygtS/WHy0B75zAYQJ95Da6kx8JY
 cqBMjKY+7uwQMy2hcVPkVEhOCKYS+biYfGFqGc5tbPQVnBPfF0Kn1R+z1BF2ce8RZKbXQ2kAYbH
 Tmv8XcXY3bmN8PWSW4VM2APReqGuqvDXpvZAHU7Yn9iT7o7M8bP2/A6l4jWfc5ogzBUAWpONwml
 k4FRI8swKaB31CMskBOt8cm2GrtFc63IJkFTpYmbolH9dbgWRqHTtsdz8cHEC5ukxglDJbo+IZB
 oC5jUTNOVR0YelFA9FqwhhTzUwnQzeGPjGPk3/d6kP1/rQLKrPKlNstpo+mTBOpx6JBHhqX9eXx
 XxCVGmi1wJYKuKueGYAF9GwLj2pgfw==
X-Proofpoint-ORIG-GUID: 5hwnjxZR3SM-aUaGM8ujSHfdhapfRsPo
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6f2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=YXgPDwGsYnIv5q04WbsA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_CTR --source crypto/ctr.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ctr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index a388f0ceb3a0..fa67cf6de4b1 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -350,8 +350,8 @@ static void __exit crypto_ctr_module_exit(void)
 				    ARRAY_SIZE(crypto_ctr_tmpls));
 }
 
-module_init(crypto_ctr_module_init);
-module_exit(crypto_ctr_module_exit);
+crypto_module_init(crypto_ctr_module_init);
+crypto_module_exit(crypto_ctr_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CTR block cipher mode of operation");
-- 
2.39.3

