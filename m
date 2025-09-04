Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448BD32F764;
	Thu,  4 Sep 2025 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001674; cv=none; b=fZJWIG0oJ69lhOGSMWDqFsOYBtmEtDR559IZxDY/QVeYSmI1Km68DEctVbt8Y+yLvGXq3lbC0AE1qF1oawbMXpPjQ5EvmRnXEdq3GR7ne7meyPcETeDlN+Mx8CVHxxCsowrWg414VwRg1VVIUHOrRifhO1Gdv6QYVZSuzW22jzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001674; c=relaxed/simple;
	bh=AP2FFQrUg4OSfDpam5zCmzl6IDHvYgld6nv2AZeSpkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gm7w34cjY22MrknDbMZt+rqLFNnh0obkaD6Ti1Dx8jIcNv2pHFzvFkVzcziqhA9umha4tXSaziGcnweCywiFp9Jd6FGjQq1P5/yqihsl6XARtg1bdyZ6Nm4PeU9Tw0HwCJi263vbOSTytXzTw7EeG2hyWLNLK8E3owUySUXZ4Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qh7sNeUk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qh7sNeUk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftj28010474;
	Thu, 4 Sep 2025 16:00:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=J3FJE
	g7zK/vFpfISuvQH8S0xyOGjSfrH398cHQvEgkQ=; b=Qh7sNeUkBxQaDJTJZSGTF
	Og0rKrmZXq2h76to/10DpNjLKQ+cu4HwLfp5EL6ZLGcaZLv7VNYBYFMBBnwyzWka
	Kf474cGGjt+XRRemqlL507l7M1LlKFvgAVHOKl/nOSf9MJ/Yz75+JbLGL40OmKJM
	4q8cCzPO+rT7XKm+f10Ph+Hz82hK2AiQUbGr0i+JcTibo5bJTZ56XnbbWf3taqEO
	b+FYcKUAQSB3fMoU4g8ydbQvuxx/UGYHgk2zqvs58W5wMZOf7jEzcfxzQo+PHKzc
	b+eiodeJq0jxU381WbcnhcBaStYENQvmbLTdTmhI8o8OK39rItfNJfMKxuXWyU9s
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr32c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FIfm0040023;
	Thu, 4 Sep 2025 16:00:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtt6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:55 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7m000707;
	Thu, 4 Sep 2025 16:00:54 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-91;
	Thu, 04 Sep 2025 16:00:54 +0000
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
Subject: [PATCH RFC 090/104] crypto: fips140: manual fixups for include/crypto/sha2.h
Date: Thu,  4 Sep 2025 17:52:02 +0200
Message-Id: <20250904155216.460962-91-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: 2pTXXym0CudGWjqmEoqz8tQmkJB0pgpe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfXxf882mt+64pw
 ocfYloUpzwfjWZktECv30zAe4JfyJnRFTO1BOhi1WslFSfvTZLZk8REQW77T2vZerqV47kcQ7Z5
 By+IWaj08v5Qa+FU4XHphugo0jWJGkUmnP2VAkpQvuwCbzHAvv3J9bmqpIN62q5Qa90vXYAgIpn
 ibtsDxfhlXWcDM1jKxQfHvC7u3QOMC2ctKRdtlrZ3cS0Y5REYWq+bhMCp8L4ARbQX7exAK/lx3k
 zuxvexnhhNPLIGAnk3PU6wmjNdqcSVlq3Iq4uqAcf116721HHB1HqYhBMQahYaILTXfBg2ns8Xm
 Avuaq18FMnaUVWERl8lVbuYgchvbpiyZiyFX6TN0akAYLquly9/amlGoNuBIWbNSad0NlDEhbZJ
 rp7d6aRXTgPV3Z/opeVeFLfajJhCxg==
X-Proofpoint-ORIG-GUID: 2pTXXym0CudGWjqmEoqz8tQmkJB0pgpe
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b7b9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=bDtzrUVmyApwIZ_QROUA:9 cc=ntf
 awl=host:12068

Define fips_/nonfips_ variants of sha*_zero_message_hash when the
kernel is configured to use a standalone FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/crypto/sha2.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index ce908568009a..5af928f61d9e 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -59,6 +59,20 @@
 #define SHA512_H6	0x1f83d9abfb41bd6bULL
 #define SHA512_H7	0x5be0cd19137e2179ULL
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define sha224_zero_message_hash fips_sha224_zero_message_hash
+#define sha256_zero_message_hash fips_sha256_zero_message_hash
+#define sha384_zero_message_hash fips_sha384_zero_message_hash
+#define sha512_zero_message_hash fips_sha512_zero_message_hash
+#else
+#define sha224_zero_message_hash nonfips_sha224_zero_message_hash
+#define sha256_zero_message_hash nonfips_sha256_zero_message_hash
+#define sha384_zero_message_hash nonfips_sha384_zero_message_hash
+#define sha512_zero_message_hash nonfips_sha512_zero_message_hash
+#endif
+#endif
+
 extern const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE];
 
 extern const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE];
-- 
2.39.3

