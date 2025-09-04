Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C072857F9;
	Thu,  4 Sep 2025 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001579; cv=none; b=VUn/nPsfaRRm8D7aqvR/aQx0g1gl4iQpCViXogCyldbcOJDIb3pStvonySJuRSJvr/LZe2VSYswDM99R93JnWszL9WRMJR+mEE4k+9YwVkhbTz+ABtoMyBsSiaGN/gb+8ivTCdrueV9dbwy5Ra89Zjy513q9F6fNv3SQyfWq8f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001579; c=relaxed/simple;
	bh=OVrAXS2/9Q8JpXT6DRuxYUxGwW5EJ35Itya2o5xQg/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iZ0nnf9avzTPZR5QdtGWWASXU9E06eiAYOQXTyrrociscZw5TtP6nXsLlLFe8MU73bamBliNilmGhSwFyMU4L0frPyqFK5yKbiMeHIKCnOkSjYSPmibRFGWP0e1T1UiMTUCpDHIZKk54KGByytgomyiy2r7tFHXr/yrS8MTSw0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=frcC+OWW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="frcC+OWW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjXS009095;
	Thu, 4 Sep 2025 15:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=ycIGi
	fDuWf+CeQOswvNp1kxnJg61WPFB2sZ54xOujfc=; b=frcC+OWW4pkR4rkpVj8UP
	fA8xb5sxLVoajOi/qGZTC0aETo+m2yd+LsFTj+yA1wFPbPG/QLujWXGs0rjMT/U6
	FKgtStJqif5RqOOMfWpsqyBI2BadR0mZtazxNuzcQ5E5w3EXlwYI95qUmlGfS/xs
	2aXhAKR0vYqU0qmLVYOQq+DfZX+89kbyiU3D81P07GTCSfReIhiB/jLForZgHLAS
	g/WB6nE/Dt/SnDx3Qxz1eTLv3KsaCRsyER7HCVCpfh1oACHUFvU0mL/KCFf5byrG
	fAguLLjA13PKyvf+7cBu/BsK7z9MGPlqqitjA/nD4zXWjQI5uaKSDzYpHyaTqlQ7
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00cv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EsISh040070;
	Thu, 4 Sep 2025 15:59:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:26 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx72000707;
	Thu, 4 Sep 2025 15:59:26 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-68;
	Thu, 04 Sep 2025 15:59:26 +0000
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
Subject: [PATCH RFC 067/104] crypto: fips140: convert crypto/sha256.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:39 +0200
Message-Id: <20250904155216.460962-68-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: v6qh7MGmoxvUP95dPn37p1nFhaJODi9N
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b75f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=3F5NGw1PvRVMck1SXtoA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX//AAwp3+ENhr
 ngZCsHYKv9GlRLdpSha7hxBQlDO8/lOX8XA7cwCSATWjWpCBdTfyBSWpJToraC/j8DL91qCpoDW
 p2az7poMTJxfZT8Pup3OX8Zu9MMx1TFUBdAqlzDz98NPn6kMDyDDzNuxvPEOYqBoGWWT7VZpOqR
 +nvdr7AVTGr9BJWawsj6y7hs+cDtESLVTtmK6TTNM1njdnyAyFbKa5Czkzsp1ywb4iDba6IX6JH
 rTJlAcyrvd+j2VIH7YDCy6xBzxP4ODfLjRUNsnLzSjdqoLi6Odv0S/hzCZDwX2IJAUoMt6Y6gl+
 Mopq4g/ywWdvMI7lT23R0+r8+SwoM1LO4VoAXs1HhsLmWlAkXAqyZPyJrIJQVxTgZO/y4FfU/3+
 DmWaN8pVLpXOZvR3kroK3puSR+fi8A==
X-Proofpoint-GUID: v6qh7MGmoxvUP95dPn37p1nFhaJODi9N

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SHA256 --source crypto/sha256.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/sha256.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/sha256.c b/crypto/sha256.c
index 052806559f06..808448aa01c7 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -327,13 +327,13 @@ static int __init crypto_sha256_mod_init(void)
 {
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
-module_init(crypto_sha256_mod_init);
+crypto_module_init(crypto_sha256_mod_init);
 
 static void __exit crypto_sha256_mod_exit(void)
 {
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
-module_exit(crypto_sha256_mod_exit);
+crypto_module_exit(crypto_sha256_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto API support for SHA-224, SHA-256, HMAC-SHA224, and HMAC-SHA256");
-- 
2.39.3

