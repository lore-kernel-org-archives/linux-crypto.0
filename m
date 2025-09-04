Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4585B27A476;
	Thu,  4 Sep 2025 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001365; cv=none; b=J4E0dirby+/aLSs6aVUeSmgP8yyg/nlq/R2QRhQo9rTsCzOBcVF7UruoDZyAQ04cjRF1ZuXkBrSzsT6YCV0+7vX3NdFx4YZcnBdKRJ0qiKE8K3shSO0UePUUPBHu+sm0J+/fQbh4Pv/xqmhj9zFHgXEEoneCIAvYUR7RE1jRCwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001365; c=relaxed/simple;
	bh=Jg4TUmPui4Ik/MkdbxuEnEqu4OL9Xeff7Hk0sdc5kno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O9dOStr/YszIOSvlJ2t0vIJjzMlYqoL6bqdFAvY4qwwWo89xHl8DJ9ZzCfF2c43QABkXPuZKxoAefZIh8Cb+6S5E2wrDK2rkz2p6AhI+2kuO2ubeqXcSjLkhcWLuxfyux3BcUCyZsdVcaJZUkIo3WxfXOJ/3rkRFDAag9qsCW3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hqh0T3Zl; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hqh0T3Zl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkTR010494;
	Thu, 4 Sep 2025 15:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=ucnxU
	Gbd4zw0L4AkueVft7DBpwiyi1dzgHdlYKbLV+o=; b=Hqh0T3ZlhjVyL7GApVa9g
	6DOokoj4P2Q/QUL8/cbCFTLjpKKbyIEF944lQkgbO1bZFh3SGS/WwIDBuDj2wt7X
	EYJruKmZJ6NVHCqkmf6Q0OJskYt08bHlrhfF8Vh5/5tHr47K5jBr+w3NQRy/uwY6
	TQ2pRq2IajCTMui8BDTrYBaPHKU/Hjz6UjhC1/i/AjacOuKTc9G1OQtz01ibZRZu
	Gq70o8YT/nhcW6/K2tkzokVIw8KA7gHypkrobebtv1MYYq6nnJxYJPdfrEPZyJWy
	MozEFKzwaWPtL0rZtu6LkWwQZX8KOEyEmTNkrX3Y1yOyu1iywq1iQXLqakr2oWpV
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2m8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDeei040212;
	Thu, 4 Sep 2025 15:55:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:48 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5C000707;
	Thu, 4 Sep 2025 15:55:48 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-13;
	Thu, 04 Sep 2025 15:55:48 +0000
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
Subject: [PATCH RFC 012/104] crypto/algapi: don't init algapi in fips mode
Date: Thu,  4 Sep 2025 17:50:44 +0200
Message-Id: <20250904155216.460962-13-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: dcfMv8d6Ily-a4LLixqdhier21It_UV3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX6hnZOCJQkNWz
 9i+x0nL6zjBEDgZMizMkNodWpPbWzZMj6Bs9YR8URfDFWOU5t1Ex4eR6mLnS2c1wk/KLxQJEn/R
 brn6TJgyGw5BxXTN4Mpn9AVhO28ehSd0ttdg8X8HCO56rsBvScZGF2Vob8dN7/4NU08REkxgJaX
 Hblg5fpINfIlLMwI4vhITqWcHkgDdjEhYOyMm6w2SBurZsFapCdi3rog0rO26NximxXZypXIgZN
 vdl+ngUW58Nbo6mO1xtlf1cOOW2BSOZLHy3LeeKuNJKjbU2DfY0dUiYqoXD0DH+joNB1CNMRzu4
 4fZaqRZeSoBZZSMpf10D5UcrBrTtN1KbKfgh8lKb+9Bz+C/tIHzKtcZLy1vaZsNrGNausHZKT75
 svPpXRy3owXEFWN9yngthG7YNwBOdA==
X-Proofpoint-ORIG-GUID: dcfMv8d6Ily-a4LLixqdhier21It_UV3
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b686 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=s-B9qG6w68Oqjs_RQC4A:9 cc=ntf
 awl=host:12068

If the kernel build supports a FIPS module loader and FIPS mode is
enabled, we should not start tests or register /proc/crypto as this
will already have been done by the FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algapi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e11b8fdb0865..09faecd47ea7 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1105,6 +1105,14 @@ static void __init crypto_start_tests(void)
 
 static int __init crypto_algapi_init(void)
 {
+#if defined(CONFIG_CRYPTO_FIPS140_EXTMOD) && !defined(FIPS_MODULE)
+	/*
+	 * The FIPS module will have done the initialization already.
+	 */
+	if (fips_enabled)
+		return 0;
+#endif
+
 	crypto_init_proc();
 	crypto_start_tests();
 	return 0;
-- 
2.39.3

