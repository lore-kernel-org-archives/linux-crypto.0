Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FDD288C14;
	Thu,  4 Sep 2025 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001587; cv=none; b=BfUyRdxdhBNJ+JWDkwt2uVLIcgAiR2Vey376nDWNqdYEnfGiF9ugJjIbuhCTOFwDwNl4vVAFl+xKQQ8po894SEYKB+qRSa1SDuQiw/gAu4Ujr3pYW+yDk5kg0hmbyTf/Iwd8cQ09hrNpCTaVK7cV17nsJNDSBphU8QNbJ7cxN2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001587; c=relaxed/simple;
	bh=0+5OKrfawWL8bX1UAuVrSym3/0oEEFBpl43hBOGjsGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PvmEC9HvBlVaEsGGfSOkKuDWsKYlJcnHZ5qeZkgB2h7grxcmqe/g+KRPE2dSqfZJHpqFdUt7Ch2ySSo0ebc+Kd2anb0IqFvbo/oKLAfq+hSog7byg86vKtpm5DJ6RjXhXHcgfkAsBoIDTLHxdLJXV6PQAXSBMR3EM8s1p2l8XUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oQsXkMBD; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oQsXkMBD"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtonY009162;
	Thu, 4 Sep 2025 15:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=GuWcS
	60KkF8UOTMH77HTb07tfeqSHVDciEpn7cogBd0=; b=oQsXkMBDlchR1nUK57Vo8
	5T6yM+gITRVFjFHjkV2rb/8gJChLlr12ZY4TVBXYr4+TgO8kpEFVhheFQld9VASY
	il7JZUhu/Ptr218LazcEBEL2p9LoozhBpW6h26DTvbzgqfH+vG5BxSkXJBi07434
	o1MKVhWXTZBTa37KY4Tcqg9vsacFzg0lDTmEtPjK4EIKoGx54sXKclypKbivp6Xv
	+hHuAl50nr3NHc7pHJ4dS1tBFdHAmRE/qrHS+7/40x2Kuv22XKPsZN5H77KNjdLQ
	x+2MIoMPx4VZK+odS0MIv5OerwWjd5l4yOzynd6tdwDq2mgh+gGtx+4dMe8a02r3
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FQ1aP040081;
	Thu, 4 Sep 2025 15:59:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx76000707;
	Thu, 4 Sep 2025 15:59:33 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-70;
	Thu, 04 Sep 2025 15:59:33 +0000
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
Subject: [PATCH RFC 069/104] crypto: fips140: convert crypto/sha512.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:41 +0200
Message-Id: <20250904155216.460962-70-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: BzSTT2y3ql7S8MtmpbuLIhOh4yaha1LZ
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b766 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=D_I-C2MOsqScy25tWyEA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX8xCMLPB4Mi24
 0tVaDVCFd9gjz4Wwk94Pxig96ZAgDrWuTHOme1hlbeBYe6g/GeQg71vji11BLiHkU5P1l0O/SzQ
 TdFT7gBaN0EH3H52AHYmlACKiQNVk2GJnIIKsgdKh+plGxsZKcSLNpNSYqo5VXloihq0Q2Rmw13
 nARnH86FXJn4NoOfqojKEHhg1E2Q+HlBPHE3iRs2j/EpXH8mQ+xNaiBepm7WJ5WfyIsKUFQNDbO
 t5PkmRqxD84MWyQrHmIqjzWVqLIQXQq+mq2W7QEkV5ehzn+wyNWZJfrj5jpDxTc6uCJOXLWS/J9
 waAWSIkYBIGDXcyBpgEG32m35XcBB9fZkEf3qLDy7NU3EKUOxy9GIvrli7+Pcz/8UH+PyAhITwo
 JtbX+xqCFQ5DZFctW15vtwSLNq4ncA==
X-Proofpoint-GUID: BzSTT2y3ql7S8MtmpbuLIhOh4yaha1LZ

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SHA512 --source crypto/sha512.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/sha512.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/sha512.c b/crypto/sha512.c
index fb1c520978ef..ee4639b0e74e 100644
--- a/crypto/sha512.c
+++ b/crypto/sha512.c
@@ -333,13 +333,13 @@ static int __init crypto_sha512_mod_init(void)
 {
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
-module_init(crypto_sha512_mod_init);
+crypto_module_init(crypto_sha512_mod_init);
 
 static void __exit crypto_sha512_mod_exit(void)
 {
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
-module_exit(crypto_sha512_mod_exit);
+crypto_module_exit(crypto_sha512_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto API support for SHA-384, SHA-512, HMAC-SHA384, and HMAC-SHA512");
-- 
2.39.3

