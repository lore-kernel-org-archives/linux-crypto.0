Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA7C28134C;
	Thu,  4 Sep 2025 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001534; cv=none; b=qhMBahwbDcldjmYkV0mjMNzuXDttOKVvLBqBkjI0/y0SI9jFmbPq86aYsUxwhPz5XElgvExH8Vg6PARgeWAFZ1EKd18Xzepd+P9FS8lhxkpj9GOUWbD5cxmNkkvwHesOM92FoFBo1yWjFp3rBNQCS+WMlr5p3AZP8oykrL5sSrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001534; c=relaxed/simple;
	bh=wuN0Yr8JcqRs+VyIdHv7eMVLYw9c/lVHCsLVYNzVO3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XVTNMwjL6zLwYzpTQLEXzAseVmqxNp+iFjr7Owy7kuA0y92OwEx77rXfpGCvkD9l2Fymbv09s3BVc7CvQGH2TGgymq6OBrFGXV3oXFWgFpAp584/HW0LvjqPyESfAPGdewRA3a/zOFbqx6juQBO1zgyumRet8PKA839qGfrBrYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZegPYdWd; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZegPYdWd"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuh0L004085;
	Thu, 4 Sep 2025 15:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=7yPaI
	nWnyxJ6sRGwfc/HxmKeOBmaWthImzu5oLZZ0Xw=; b=ZegPYdWdiMCTXKjt+u1sf
	yQLeBVngjEPItvY+iK3Ic3cpR4PLT1H4wtB63VTNsIkCWpEcMiphxqvnHcivUlPV
	qjGDOJ/v3/WVUdhcXzo3puzxOh4p0pUb7xsrhUSjUQ2bxcEtHKoT/hBKQcKNiU4l
	OV88kBCKm2vAW9uXokieciP1OawM5XJum9nneXfHTA2LB81kmpp+rkc5WJreQSj9
	Z7WDBHK0N3853jQsSOUecqpM0JAgqfNYD4JmDNTDvyPPMVTtkYFxYcttsgWX8Kd9
	XsubVrO0q2OmCkObt/+fKHW5gszfMCqstBSomwmY96gcnXcMMNr9vZmxaqPPs2N9
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun003w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FR1JL040152;
	Thu, 4 Sep 2025 15:58:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtpxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:41 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6a000707;
	Thu, 4 Sep 2025 15:58:41 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-55;
	Thu, 04 Sep 2025 15:58:40 +0000
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
Subject: [PATCH RFC 054/104] crypto: fips140: convert crypto/gcm.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:26 +0200
Message-Id: <20250904155216.460962-55-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: kVVPtKH6-xJlpTIRmlT0_XgGnIxGJDJD
X-Proofpoint-GUID: kVVPtKH6-xJlpTIRmlT0_XgGnIxGJDJD
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b732 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=Ec78SZSnjNWTXeOdtAIA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX8SOuWQFIXFiE
 JNAGguFrOEoQ6GtuJof9sCjzDHCXYt5syByqJLzk+/Iskjx/ZyJ8XDWr0+RAfJtzHC5w399s9JC
 4ga9Q5aCpNqnEAeyCkWaZC1/F8GTuaOgX1YfA4wN1Qb2dIASycqQ3FEg9TK53Fvcra5Q1Wq+l2Q
 p2qnnr3AKjpNRVR/YjXAF2z0QXezI7G3nNXBKCvOt9iuz0u+8iaDjGrhkbhl/bqqrypCAmPxUax
 ydDJSztRoFFo+gxs75u/4uMFRqcUS5iPPaxS0XHrPQd5ylW/b6yxMaDdQQeeb5nMOpkV+6Klb1F
 055SMqVzEKqGX7BNbI/4XHQtzbTiJb3PqoyvHKEme0ayuAxFBMPA5JV7B9xqYXwKsyL9tgoMnqc
 CDcww9TzuSVwmDC7NhLozFOflG0Wrw==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_GCM --source crypto/gcm.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/gcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 97716482bed0..54a376e782d1 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1119,8 +1119,8 @@ static void __exit crypto_gcm_module_exit(void)
 				    ARRAY_SIZE(crypto_gcm_tmpls));
 }
 
-module_init(crypto_gcm_module_init);
-module_exit(crypto_gcm_module_exit);
+crypto_module_init(crypto_gcm_module_init);
+crypto_module_exit(crypto_gcm_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Galois/Counter Mode");
-- 
2.39.3

