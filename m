Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD85228315A;
	Thu,  4 Sep 2025 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001529; cv=none; b=pk3Xz4Y0N13RakFWF6DYGcr45jRJcxZupU7ayg3yLXwDAgbklor+UFGeI/Cij5F68bf18IUumJEq9PswFcXiysVBwRQbzRzq2fhu//FjjfXiB2Ru/NqgamfjLyNp0+GwLwPljsfxHiwt+KQwK1elAXanu1B9s7ovhrGRKJkD99Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001529; c=relaxed/simple;
	bh=brOkKyHEUySCQTzZKC4+5KsIdg8scDDs6kmSavOKXg8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YpsfvoxbgLL0kJY68dB0cF6BuMEcwd0FLfvr213i13GdOJGlYJ6mH/5gI28kYyEi1sbpVGQqLXnXkdhOdR3k50XOVZwqs+NuPkmJIrqZCaLhWEuWN1SpRSfBTdMMZWnplHQ+PxBBPr6F1MEdvKLKFGivxCPhwlW1gPfGvXp4WqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SDYz8VG+; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SDYz8VG+"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftpp3010552;
	Thu, 4 Sep 2025 15:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=VY12K
	sYzjMoDtuUXBww0Mh+86J+sIjxrZ4IQ42A2+SU=; b=SDYz8VG+WfYA1aYp4r+tC
	7RksZrv6Eus3VM/XltC7zTFUQYoANtXP0PpwhC2vPgpDE41bdDZCfnlgoFHyU/cc
	MCOptCweRZcBfceRC2efvQRpuFxSAGCunJxZDLjpuMuanmbVaKcQhNO5Yh3DerEb
	WFvhvnsrLXziUw4DE8/HO4F9XLkzRdgzXpOk8r4YhhUgqXV53yhyhir+5QquuxFL
	qk0lctWruLWgirtWfFurxl9s+nHS3DwaRECx19NzHpNC9IaHQqvBHXs3OuJ2vulC
	xGBLeqefUihbEIyEwogljzJoFNxTzZD6YC3KimAd1ekZ+2iF2lvrd+Dy6z2wFvqu
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FQ1Zo040081;
	Thu, 4 Sep 2025 15:58:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtpus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6W000707;
	Thu, 4 Sep 2025 15:58:33 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-53;
	Thu, 04 Sep 2025 15:58:33 +0000
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
Subject: [PATCH RFC 052/104] crypto: fips140: convert crypto/echainiv.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:24 +0200
Message-Id: <20250904155216.460962-53-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: Rgjksq2FEbxf9W_4u1iJ-sCUPURr7x6h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfXyiqqScrBnQy/
 OPIxs10Rnwh345VIIEanftuCks9byar418y/xJvJYt1N4PlBgvU0bFJNZ49yEUjVCe6ueTky1SP
 yECTRATiOmVFSO6/yvmynkYzTFTdGp2H285QyGby14SSkbsG/2XcBsw9+5LNt5TsMAMG1H/zumY
 PIKJDXaYKuOe2FK8d49hbNhzoljAzhvvvDjgRFPpiw2mBIRx+zjE4mD2D/yr0xkGHuXkKqBXLgc
 kHgEec6BubSZDQZovCL9ttNR2yB08cbvu5WcswuBe1eil4OZRuIWaNurqzOYcQT2PbLC57QOO6t
 Q5Hi+V2AD58RyKSOWqSa5QuiycK1J3NYgiYWEORUTf9fzvNqt8TB6DAKzWHYE9CoV9dmZYcR3vF
 DNz00kYaoWUncqRNgadW1jmLUrNAQw==
X-Proofpoint-ORIG-GUID: Rgjksq2FEbxf9W_4u1iJ-sCUPURr7x6h
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b72b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=xFEBqvoGrMZ6ZLoA3HkA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ECHAINIV --source crypto/echainiv.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/echainiv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index e0a2d3209938..d409b4169e83 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -145,8 +145,8 @@ static void __exit echainiv_module_exit(void)
 	crypto_unregister_template(&echainiv_tmpl);
 }
 
-module_init(echainiv_module_init);
-module_exit(echainiv_module_exit);
+crypto_module_init(echainiv_module_init);
+crypto_module_exit(echainiv_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Encrypted Chain IV Generator");
-- 
2.39.3

