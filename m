Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731EF283FF8;
	Thu,  4 Sep 2025 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001548; cv=none; b=jmTdvzKXPHXBWN4qRa6A1MDG2jFaZBVy7Yo4fbDV63xNpKa1M2fDmN2XkkgiqXxWr6zy+bULkxEiG1JA3xcRqGMJNePrulTdEhUE0t7mp9Pzen897uG4tB7c1y0dICBy/0I8zuHxUHuTpwN0teGuKs5qvj3VmwchQW6UY/uQc9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001548; c=relaxed/simple;
	bh=WwM2HYUDpX031nEiQ7YC1h7/MEm/EFaM1zfIS5JQRiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AaToYlxjLwUZDy2V/23Qb+NNFe6M5aA9p8ua3rZh1gqPWuU1V20OW6mJmBlANxPwxVJAnrb1mep40RLcfXoqW3N+XR1XIGgaqHsBkigbT+DFEhDRZP9lD6CnIb/CWPvMqMt4zZEHXq07wxFnmRVt/Pi3UbW0lgvoV6ymEUm53Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZyTd9+Ja; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZyTd9+Ja"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FuVwq003790;
	Thu, 4 Sep 2025 15:58:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=oODu7
	QT1mN3yQ0jtLB7u8PZw8SSfsivcXJM/fn5fc9E=; b=ZyTd9+JaA94Be7O61nyTl
	JAS7twPvGQk1w7v8gUkPWjcs0eC+irJ9rc9XAC9ljtzcRv6Ifm7Jk1J9lnGz24mN
	dN86260hzif+mM0EndNOi1O15+Iz3GsQqAHUCxrEBx6GQQbaW7lNiBFAeduyfXEr
	CbjgYDOT7LTHYscHAZKaq8AmLMJKm23wTRqdOkz3Bz2pOuhn6D3kGQlNILusfJbn
	YrlWtLgAMdbGMrj9gvskdkpYfMfeiWDKK1ztdU50tjGtAYY5Ne03V5SeR26SXDA/
	HsmxJNiUiZ3cj/n4eSrfG9Z4RKBE0b3dsCmkYNZDDjtAK50s7lsNstyiUOX1AJzi
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun0058-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FM8Hc040108;
	Thu, 4 Sep 2025 15:58:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtq6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:55 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6i000707;
	Thu, 4 Sep 2025 15:58:55 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-59;
	Thu, 04 Sep 2025 15:58:54 +0000
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
Subject: [PATCH RFC 058/104] crypto: fips140: convert crypto/jitterentropy-kcapi.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:30 +0200
Message-Id: <20250904155216.460962-59-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: r5cE_5ef8Ur2YDz0akM_QhYyAxaJGYnO
X-Proofpoint-GUID: r5cE_5ef8Ur2YDz0akM_QhYyAxaJGYnO
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b740 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=YjGd64ftHNhPMr_yi2kA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX+IEe6HyoadXA
 YlhqB2wLqEnMxpmqqlTHzXvns6Gm4eSnXowcJe06KFvl5I2VleWx5YzTQVk25JYtEHEtDNtwNq5
 fF3jHxYetJ/xCXVKQrHyPqJf/uw/mFCqgDJMBr6M6Nb+67L3J7+swmaL/dGBJTca7ffk+7z4ZMm
 8CPBv4K0yxCtdQzgZmlkNMZTTHg8Bq54tAJcmyTI424eokGKS7JxNI3Co6qWOGIBcOOD5gQuGKT
 +l0mJZKZVYIVemxqfCktJyJoUXyQD6hF9lnMMsDkwzIHsTfUZQ/unyj+fCjZvu5xJJQwfOjzzNf
 q8tUFfDhrlVDXoXoy4bXI57SNL+cm31U0KuB/yjxsfHYonSLjNrVyVLmN+hXHBQ5y0fi7Dq+K8E
 QA+g9vkKhWfJrtzwKnjxmhg3n+qLeg==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_JITTERENTROPY --source crypto/jitterentropy-kcapi.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/jitterentropy-kcapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 1266eb790708..4718a40f8bd6 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -368,8 +368,8 @@ static void __exit jent_mod_exit(void)
 	crypto_unregister_rng(&jent_alg);
 }
 
-module_init(jent_mod_init);
-module_exit(jent_mod_exit);
+crypto_module_init(jent_mod_init);
+crypto_module_exit(jent_mod_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-- 
2.39.3

