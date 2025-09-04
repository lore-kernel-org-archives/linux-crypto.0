Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7E028688C;
	Thu,  4 Sep 2025 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001576; cv=none; b=pS2yKy/ehGcI/KYe5N2BCvUdUReyXSnk5ao85QqpAInEXZ3CVVLDNYxJuraUqHu/bUAwhDoAqv4ALvtfZCrRkj7RanAboBKtYD2hdNlpJezUCeR+o8Y5GZpAiKO8AnYVPiYxnZ3WArDgvUJS10jzGuxBbG7bko44NKzVaUefRXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001576; c=relaxed/simple;
	bh=Vagp8y0n8HpnPzNfucUkCp58u4SSpDrWM+siN0W9uu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gNVk+qiT7YZ4waC3zUZwoHTnrnUbuZufsSafhS5tTxKtse0STWZR7ZSEu60ozGtHv97eFjDIDQeLqz42UlmlGO05ws0BKW9qHyQEvrVB1jTLskucJ39sHbJeE+oNVh6Hf9gKRZwPm0YqVILRbmv9o5D/Dqr1HV0ndWsSKSto7GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eOUp/RP0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eOUp/RP0"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiN2023797;
	Thu, 4 Sep 2025 15:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=aT8V9
	gw0DOkED1LeJAw5L4yr/hjf2cW/ao4lL0bmhEI=; b=eOUp/RP0LdIzuUDUO7L0c
	+azFt2p5cQjWBYgOPlJff/bBOOcWvkj/pcKJ20Eqw3JRCZ5V5Re8F+QVjBQWrEdG
	GhksAVhGoBRPv93uvLAR/xy1tn7IHCvcX/9I6994AAI2fZTB/kUTcO40GEVnwUmd
	/jkZQ87XaHPrvupddQExLDmS0Vt6h5rxIYHmcvVy1ttPH83nJkJVpKAvxgdV0M7K
	QzIDiEnLjYGVt0TQoBMzUffB1jaKbdM3NMr+LAj1triGUmFQPq2foYnfpyF5zqEQ
	qfsZKiLvQnFTpHx4V49qq/RgRoeahPLx9jjnZ2Gd/tMhMtHFWb4UhYR7ZM4A5HvM
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd02ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FPlWa040063;
	Thu, 4 Sep 2025 15:59:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqpx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:23 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx70000707;
	Thu, 4 Sep 2025 15:59:22 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-67;
	Thu, 04 Sep 2025 15:59:22 +0000
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
Subject: [PATCH RFC 066/104] crypto: fips140: convert crypto/sha1.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:38 +0200
Message-Id: <20250904155216.460962-67-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX8BMzGpI5Ml+k
 7PkriUeUqyn6wvrIBnCpm4vxnu4og0OQbi3+QF4Ouuq3RN62qhzcLKNYFUdQ+wb7KK9HMCSf+Hd
 MIYq72l02P+6JRNvnZyOuQM90Ls0xOcf9289TV4qwo1EJZcJxUElyT0VcYFhWH2JU3cmm645Xz/
 0SZhgERqcLyODLSRaytjPX1lCCr4G0SZLSjz8H2zAtLc7TZFexPFz/03SOOuE99tLWSzf7JS75L
 0aftdni160NRFoJonNECWmUqbtd+7ZhkEnRzWQ7fMjtbgQvAyP6rf0mspTlboDi4W8g3lUHrfQ2
 dDYfSZcDp/JyjiKKByIfdHMBHo0NMPLJj/2H39xfxJdL8OM/cwSQiPI/ebxcG5UvLZtKdEZCenM
 QfJ7VzGIaltOQBSxyeAxqu5zZsZVpQ==
X-Proofpoint-GUID: OYL4h59MJpAFC37Fgot8juC0e0fKf615
X-Proofpoint-ORIG-GUID: OYL4h59MJpAFC37Fgot8juC0e0fKf615
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b75c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=xR-44P041G3JoPkPz7wA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SHA1 --source crypto/sha1.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/sha1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/sha1.c b/crypto/sha1.c
index ecef4bf2d9c0..17f635542943 100644
--- a/crypto/sha1.c
+++ b/crypto/sha1.c
@@ -184,13 +184,13 @@ static int __init crypto_sha1_mod_init(void)
 {
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
-module_init(crypto_sha1_mod_init);
+crypto_module_init(crypto_sha1_mod_init);
 
 static void __exit crypto_sha1_mod_exit(void)
 {
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
-module_exit(crypto_sha1_mod_exit);
+crypto_module_exit(crypto_sha1_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto API support for SHA-1 and HMAC-SHA1");
-- 
2.39.3

