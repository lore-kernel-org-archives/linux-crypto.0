Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B34D2F5484;
	Thu,  4 Sep 2025 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001473; cv=none; b=vDDscp4BXu7XC0L+jud2ydBjhkBOJMmJ/TUWHi8tAcZrJn6gwcf9DVOaBcjSD9bdUok31cgKPy5+R8KDioU1T4iomyczk+/7VwGMI2+nBBZ8s6CJ/DNfvHNljm9Xm0DLJGZcSIxnmDIKMpZuwfjQeKZhC+QnQq7dzfCTOh5q7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001473; c=relaxed/simple;
	bh=CfgApNBc4mt7eBZmsI/i458sWYBYuAgOkpk3UukDjc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bGOKnMYLXICz2w6WYjCklOxh5kuGHGk1Ni/fs5AyMEJy/3OBIpLBU7VbLbVGDAniNicr4B9cWz3C2ex320NwrW+R0aYLhODCA512prata94iEzNblNh9UDdLkuSJ9Esg8VP/v1cMZN7DtMcMzuKTCHcfHCWrf4dORLy+VEu9tbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kh1AwWfj; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kh1AwWfj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiqB026703;
	Thu, 4 Sep 2025 15:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=YQpao
	bTdYC45ES5PsIC5sMERKonUKNNs68vmlpRQrNY=; b=Kh1AwWfj7ViITbj6XOV5A
	XBkVNOzIu9LqXwsw0+rpfYS7PF/4ton9mBAs6q3wN/XWcCMfhhEGF9WlfPZxbQyy
	vPqa8RjzYpveKohfHXBjYcVSLaAfjh617378JfJ63BdfyyRfThT8qLtGAOn99EaR
	e/neUbgF8CuixV6HpT5nE4/XORf0V+Sjl2nEcM2MIv28pRqKch2RWtzbYLo/o0xc
	SjA/fZn56OSDcscHBgRb7wMRAEiOs021DokjHlWrXR6hRCQuE9usmxTd6YeEk3oa
	3rnQa0jFM9RQKgBzUB/LGjHeBCt8mF3y8CMsg6+euC0FGEHGKJhDCMJJcRRmvV0b
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd1004yu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FpsXO040016;
	Thu, 4 Sep 2025 15:57:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6G000707;
	Thu, 4 Sep 2025 15:57:39 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-45;
	Thu, 04 Sep 2025 15:57:39 +0000
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
Subject: [PATCH RFC 044/104] crypto: fips140: convert crypto/dh.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:16 +0200
Message-Id: <20250904155216.460962-45-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfXynOO52Y8qaRn
 WEo+yccvTee1rMT+PlArwKLJPz8KCIVxscaiQhjy8Z8GObr8omzf9dQTTX7LpN8eIqBvz4ZUmf8
 bVhoLeyRGAAhZUC9L0N6styR8MMmd54yr4D5Y8CRCUzjQQMEayJ9Kgezex9xJBo0MfxeV1Zj/YC
 38Xg2YW+ElD6q0NVjdGcD1X79f8KL95OiBlHJYpbtBBOSbJO1SifJhyOLMgCdTiwKLnY+N4UvYv
 2f/XLkYg1lRf2+ibtUt6v5H2AeuwVufBIDsXNebcr8PTGEH4t360yk8LBB4B/4dZ2FuAULZ/kRd
 Xbd0pyh+7+zWcHkRusbypybFinvfUwAhBGo9O8V6wDrlu9Tj9KTaSbROLYo3XJrQZwMMMndhcXY
 ESwHjh06JFMtarbQTJITyfV2kbu45g==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b6f5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=hFZ9gsKEKL6gBu70e0AA:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: m4lJV_hvUj-lQH2CdRO5NjLgjHtE67-4
X-Proofpoint-GUID: m4lJV_hvUj-lQH2CdRO5NjLgjHtE67-4

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_DH --source crypto/dh.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/dh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 1d80213574b3..4102038161bc 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -920,8 +920,8 @@ static void __exit dh_exit(void)
 	crypto_unregister_kpp(&dh);
 }
 
-module_init(dh_init);
-module_exit(dh_exit);
+crypto_module_init(dh_init);
+crypto_module_exit(dh_exit);
 MODULE_ALIAS_CRYPTO("dh");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("DH generic algorithm");
-- 
2.39.3

