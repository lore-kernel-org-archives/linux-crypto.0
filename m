Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCFC2D23AD;
	Thu,  4 Sep 2025 16:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001622; cv=none; b=udC+iYqtPecSfY8ItKeI6Zmwjj4lK+KhGaa5Sk12BV+jjvEqJ4aXi7nlzBO7l2EVdlTWEshUHVjXnPDb3sjFKa5U6wPOq8iBTHC2DVzBZJ8w68vuBfNFrzxEXxMT0j1U8QfzVe2LhuMaT+QrFcEhZFfNuq18Q5MMjdGV6jz6qrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001622; c=relaxed/simple;
	bh=PjQwHT7gdIRnktyhDfObVwSn9uabZiYevqIAOh+Ie6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MARb4cqbSr8sBXs6T9iExify1nE4Nn8JjFCENO+M+z2GZUd/etIIEn5V5hmcu5/1Y/GV98Kr/1XZaPuZcS2wGYnmbIZm/2uxAldH8WhUN9tDma22deItmxh3YUe08qkZ884qR77B42+BeQDu6JhZAacAfXPDVlyPJbzuC58vji4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JtNc1ip5; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JtNc1ip5"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Furd0004119;
	Thu, 4 Sep 2025 16:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=MUp6v
	AenlTDbqp91WgXche1Ljc3MTmqTdd2VkCwAK1E=; b=JtNc1ip5SVPmrV3Nr4L3W
	Xt7jYQt8oujmzbioG+kCemuTQ9Wrfj/BwPZgBRLC3Ghco4g0rpm10Dxq1sWc1+Hf
	c3nk3RamC+i6VKSQ3A7EMjssS00LStSAKJcxYGu9deHK+3KuiSdorVI9AnPfJKHT
	IdFRBEhTK5onGVzWerDDB3CDNP0V4Y4ltnjr41vf+MeGdKD7ZLcJD6tcvT/fadx0
	wUx7i751Lf5jEOS5uiQwj/qQUU3swEnGpllAGej1jian1ihNdGqp5xhy09U44fFq
	mCTXZurR+EPdft6M1wxYoSWCc1FKPA8+EAbekZjrlP/HPLIDcKv1OwLIjkkMNtgu
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun007t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FLHeg040062;
	Thu, 4 Sep 2025 16:00:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtrhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:08 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7O000707;
	Thu, 4 Sep 2025 16:00:07 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-79;
	Thu, 04 Sep 2025 16:00:06 +0000
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
Subject: [PATCH RFC 078/104] crypto: fips140: convert crypto/asymmetric_keys/pkcs7_key_type.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:50 +0200
Message-Id: <20250904155216.460962-79-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: 0m-fN6XIXMGNv0OAodIjdI-RCEl2b6SZ
X-Proofpoint-GUID: 0m-fN6XIXMGNv0OAodIjdI-RCEl2b6SZ
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b789 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=LlUqIrUXH3xG68jPStYA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfXxeI1cEbPuzTW
 1tgHEZbXGUvKzy15r6DJeoWp5O4o6vUvY91KZAi3emiG3poUXekE8eniNiRpVeZ2Lb3OCKwhDog
 CqWo2fcjZeNfHevPCExk5vAQ3bClwGa4d88Lz4gbmtuZb4p2qTRxYG6Qo4dtsCkmYQfEkowOdm1
 p5qz1I8R9SlRlgs5hr5pJgqVX2b6CKkPJqr8n1sE2PRq2nmoWwZJtvaC4CP0mh9E00o8OpClRqc
 Q4wN4NPL94VXv4APT0o1p7BEPNGVT3yf98TlPDuE6pamQwrcTQm/CZ2awF9nPrG+37vgDer8meR
 +/skLSpptX6qG2neFtJ4P03OThmqXifVs2tHxNJaLBuqSO240wsUuvN6vAbkxubeA9RLelSxye7
 aibJL18lXRLsG0vErYhDZUohb2dSzA==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_PKCS7_TEST_KEY --source crypto/asymmetric_keys/pkcs7_key_type.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/pkcs7_key_type.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index e71be8b5b0f2..6566c74665fd 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -92,5 +92,5 @@ static void __exit pkcs7_key_cleanup(void)
 	unregister_key_type(&key_type_pkcs7);
 }
 
-module_init(pkcs7_key_init);
-module_exit(pkcs7_key_cleanup);
+crypto_module_init(pkcs7_key_init);
+crypto_module_exit(pkcs7_key_cleanup);
-- 
2.39.3

