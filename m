Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5BC284696;
	Thu,  4 Sep 2025 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001650; cv=none; b=ecVuAi7upyjT8VOkOTLuIS1HJXffzMlHNc0ow8DKFLUbj+gmHE/nZQHUzfosyKHIadZdeDcAUN3zBVgQ9xVy1UKaPHb6ak+3vA8+BiH4Xh+MB69rnEqG3ga/+NofJplPGA8FFytUKzfojPTFqPgsY9WbzcjXyCNteE92w9IoK3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001650; c=relaxed/simple;
	bh=iCoyGxS5Lc34peJOIihuITaj0Eo55mA6knIvQPcqD1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e13Dwo8zu4GA3fT5pJiE16kWlLFZR8Y4Db8tpu7PKFdoquGnih2m2tzH3v/yBFhKYJeDg1TPQbDOYMiffCyFpdru/8naasEgGWWfCBuYio7XDII/qyplRWGsg+gdomay1ynPZsTd2hDMyLXhPGG0IJyB0AvHpy7UN1fuGM5cYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GWBF0/Er; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GWBF0/Er"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkSP014867;
	Thu, 4 Sep 2025 16:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=oIQMO
	bjlEB3vDAdqIHYSLXArja51AsnYnLhtCtETJro=; b=GWBF0/Er9fJiB1b2/2Uj9
	oHvJkIxhUeUf7z7SPbaPoA2cjmI/i/jRmWUiwY9rYPbBbrlqnnLwXNUq9XhBUo/4
	+nkTUrUV3BbpjAIaKYuSHbiGYO/bZc+H9+uarJsmgFXbEbxbikGCoEfCE6RsE1f3
	EjPXSv45YpuVUOHgOHsgzyXi5dQGrtNqNui185/TfqhKrerwETaUIAHh/VNecWPy
	Zhw+g5pn5IrfftAbooxzpsRvYddSVTwfoiFpvpgsz1jd6f491An6JnJ/ULFtoHNt
	R6v+xQGME40nSUdKoRrHBqaRWGtkKiE2QASXY+dKAcQcKpzompODFqEAXIeSm4s0
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0chp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FQ1b1040081;
	Thu, 4 Sep 2025 16:00:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhts9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7W000707;
	Thu, 4 Sep 2025 16:00:23 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-83;
	Thu, 04 Sep 2025 16:00:23 +0000
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
Subject: [PATCH RFC 082/104] crypto: fips140: convert crypto/asymmetric_keys/pkcs8_parser.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:54 +0200
Message-Id: <20250904155216.460962-83-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX/QncuB5T/6Cs
 sJ+e0brtvGryxyXvAJ9vfYfSUP4ax6LGtJNspCFLalx1Znf28LqIofdLItx7KrzkosNhwGyhQa/
 8LF7YwiPVWmVoXQ0LQDJABNalOte+L7GDfgynhkJKQyU2oJ+dEu9me+9sx4jHTV5uHkT3AgVQvI
 xwHna3J5J9GFzhgqk4cqRX34q0uumz9eu7o2w94Q1POU/HUcvpSR7/Rmi5N9/jYD9L/UUmHCPWt
 MSXBII2TDjPpWAg1+vdxi9DZD4KjFtyyWNYvNeUJXT9X+humk9woPKymhllQDna0ZVEqamuoqsl
 u/3/O2+lPaVOZB6JUks2/uUULBfxc6jzJCKi3L9YQPfxWcNTruDPC+g+tWfTpaaGRpIq6fjQ1oJ
 miwuTzRNuljPC1BerPbqKEMXNRVAWw==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b799 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=m_CJyP1kkm8DVyCdAR4A:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: KR5iAhN_vjK09nsbT6nJrFwc__f1uprk
X-Proofpoint-ORIG-GUID: KR5iAhN_vjK09nsbT6nJrFwc__f1uprk

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_PKCS8_PRIVATE_KEY_PARSER --source crypto/asymmetric_keys/pkcs8_parser.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/pkcs8_parser.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
index 105dcce27f71..f26464639232 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -173,8 +173,8 @@ static void __exit pkcs8_key_exit(void)
 	unregister_asymmetric_key_parser(&pkcs8_key_parser);
 }
 
-module_init(pkcs8_key_init);
-module_exit(pkcs8_key_exit);
+crypto_module_init(pkcs8_key_init);
+crypto_module_exit(pkcs8_key_exit);
 
 MODULE_DESCRIPTION("PKCS#8 certificate parser");
 MODULE_LICENSE("GPL");
-- 
2.39.3

