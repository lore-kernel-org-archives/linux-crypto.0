Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5921F4262;
	Thu,  4 Sep 2025 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001612; cv=none; b=pGBMo6PDATs5bK8oBA12vFa4mVhRVft74hkXFz9R/Ajc/lKMsEHkRVz6U/DyXkkRs6fIvyZrd8WWr8kKWQv0vhMU8b82G1eyrYpSXt1S+uc0QoHidg6Xb9FX8MJaDpPiLffMZvs2nSZfYTlda6ToIRb7921ntM+MNT5IYA3o8fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001612; c=relaxed/simple;
	bh=eMONE7VLA8vQb8qdFCm+/Y5K7ID2uUgrjxlan2CH6HE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UD73KLYUFhnhtjcEW56zIb7+4rL27PLQzMLrEqEDQUk0Gemv4p7w2wwzmcgUgrVBKNKWwEiTJMHCzIJGuLx+azX8VxPaMR3QxJdsckmkoaVUIFn7NtiNxngzLtANwAn7ZYYbvdR47YSZPB5NWr44I1ZtYQmcacxmBzPut/U6Elk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cYdIDDCv; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cYdIDDCv"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtnQP009150;
	Thu, 4 Sep 2025 16:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=vmXNx
	DXxwa8x1unrbNGDK8lrrmw8OOkdnfEH51g8J0s=; b=cYdIDDCvb3h+aLy40bo64
	vPLTzZVTcIfOq1i52SBZdvYGbP+tL4dmyB+w3ompA/B4pJf9+00c/LjlaVIj8JnN
	DZloPO2G1qGCihvLmgq+q8PtusL89kFSLl0MZqnv1luwaG4GKfZtwDIK4Mf1kISE
	WPHuQKLmghPYgIho53l/3rpGzRCxts7ePQi13pPy5Hvt9i3skqk88ZDD8dsOhMsq
	G2Hny911Nuy9ce0NhICrIZyYl+kHtw4iPigjjKy0HNVq9n2PhSjYEYfaqWtchSki
	1NbI39lfGw+Zb8nadeS9UMvNZ3adgLpDzOCe6QJEAt54vB6vbV2ictTuBoJdhlzo
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fedpg040082;
	Thu, 4 Sep 2025 15:59:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtr7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7K000707;
	Thu, 4 Sep 2025 15:59:59 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-77;
	Thu, 04 Sep 2025 15:59:58 +0000
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
Subject: [PATCH RFC 076/104] crypto: fips140: convert crypto/xts.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:48 +0200
Message-Id: <20250904155216.460962-77-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: BImWm17MA5dhsB8hYC30XqlAd79aBoJL
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b780 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=_y4oYdxVqIphRF2WvzQA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX0eX5Wds9IvyR
 nB+vINa3g3Tb+CCBYoF0pLPl7VFMVtAkAW/zVDqSY77Lo8H1OQrdMyoe0iSeYfQib61EUR2zOuw
 /ow16MS3iw1oGfSPgZ0RcsQo7vNTaPTjEOfnrGEpDC/GQ80YsKaCiNpRtUOTuHSaGyxoOCU1Bpi
 oWl9pduUZI1UlxB8ImgHFaFo9rmAYFgxJ3OWdjlVi1ZcuT6e7oXFHAUXmV9Jr8Tr3ygZ9IOgBlg
 cGqTwujaWee1FnQgpdzBO1WH85wgZND3uV6Zba0DGfMoHmWfanrUcTWXjXKsEmt96D2zGWS/ulM
 ObmhhzhAoFkhOCDtBDU2CGgzMd09em3B1HdS30X/NniirTBJr8osfSNcx1XvNrxp3oW6m28aNhV
 mEprnG46rQ81d5yKVs1pCypKCgATdQ==
X-Proofpoint-GUID: BImWm17MA5dhsB8hYC30XqlAd79aBoJL

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_XTS --source crypto/xts.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/xts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 3da8f5e053d6..97e499893292 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -466,8 +466,8 @@ static void __exit xts_module_exit(void)
 	crypto_unregister_template(&xts_tmpl);
 }
 
-module_init(xts_module_init);
-module_exit(xts_module_exit);
+crypto_module_init(xts_module_init);
+crypto_module_exit(xts_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XTS block cipher mode");
-- 
2.39.3

