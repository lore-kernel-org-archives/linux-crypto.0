Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA5432F764;
	Thu,  4 Sep 2025 16:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001664; cv=none; b=ZwGLBbDKg9khrLNsIzpUHVfucJn14CBspDPlNjqjbQBxhelLMAVMoROtNClmqtp0Lz/yNOd3Umoi7YcFrWzHbESTbM1Z2XfDdC8OLUlyOpu2EO0o6ji3+F5xUAPjKrZagpRBgMr4bOlQrllugBn67uXKgcW+hr/siZ/wQg0Kbpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001664; c=relaxed/simple;
	bh=RWLxEu3okD/86K9IzH6hCwooSrGUDF64kKZOgFxsNbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dxbOk9dVKAZD1+mHS+v8n3wI70vmt5GhCrYjxLO32M+Y8xPZVOhzPTFVUZvqv8fqbGV9FMg8hbvmjc1bWcV07tdDV74wcr5P/YerBmz/l2jidHMKAPA+aFZxQ+Hrw65V3NtNOcNPiEsO+2rtEnpu78WeV0FP9In5AFdHrSJwmdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ePCiWMJJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ePCiWMJJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjKW014848;
	Thu, 4 Sep 2025 16:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=oa/de
	I0rhZ13wFSfVxs7qnpnOm7Bf6BzpoIGyAvk5Ks=; b=ePCiWMJJDwKqBnzynfBDK
	GO5NHvFk8sRnObWmGreIFjybjP3qLWvsyIyfyEzY+NPm2UKEy5D24Bfun/N+EgX0
	7OgZWNWZRYkaTyWja99Ofq3kwpasxFiaHJbVkqgLSxsjsvG2Wr/M4OSQtWt1/gEW
	gPyt+07l/FTm4DQ5LKD/EhYhrcO5bBERDNwjRz9G8QesuZmKn0WkycdiM7DL3h6x
	XW+/Ii+mhBDq6T9haS90acBt7l95Il4NnMgtjtUhonNCvdmM2/fkBYgTKJFTDC7K
	3yG+T7adUsMsiVSQRNWrTtiMFVPNGvqA23SvnLF7Y7RUrmQClMxPNAXjE1f1hV9v
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FTLSY040133;
	Thu, 4 Sep 2025 16:00:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtt33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:48 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7i000707;
	Thu, 4 Sep 2025 16:00:47 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-89;
	Thu, 04 Sep 2025 16:00:47 +0000
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
Subject: [PATCH RFC 088/104] crypto: fips140: convert crypto/asymmetric_keys/x509_public_key.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:52:00 +0200
Message-Id: <20250904155216.460962-89-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfXylHnpFtJQzML
 0kLEpAD+PO43adOJxDzgLr9Vtjjty4TYhkHPYJ9MAqHUbTBOVlpVPfR7VMBB/HgjXc4zXzkP+B1
 fZuJzJvjyjwPO8/QLP2a2rvNk0fAH+dUdHnGU9SQ7ENjF0/Iuaav8L7gGB4AGh1tiOpUD5rl5O+
 zVdi8OP4ivdesIA2rUvsvEE7aXcSV5IYInwqjKm/SQk4tAZN+2F/P3CJB8n4N8QL8fUDCoW5xFC
 +kE/wgrMIMNWE8Cn/3oS84HP26kqGx8ei3FZ8entlvAJzH8G8W86lCtaNdgVJFc1Fyz/4m0fnnk
 gNy0IWnnxMGr/XbhtKJ2YXXMizxhsrTXIcFCWN/QtC8mODek1CDNEj72cS+1hFSnzvEeFjlrGN8
 NXzhxC3UwhqIByMwurHelgssP1v7Yw==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7b2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=9LomtPCryUeiOyqmeTwA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: IWHIkxLSBLC_4Eifmybc3qE3olxmp8m2
X-Proofpoint-ORIG-GUID: IWHIkxLSBLC_4Eifmybc3qE3olxmp8m2

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_X509_CERTIFICATE_PARSER --source crypto/asymmetric_keys/x509_public_key.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 8409d7d36cb4..2f76b7b855de 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -246,8 +246,8 @@ static void __exit x509_key_exit(void)
 	unregister_asymmetric_key_parser(&x509_key_parser);
 }
 
-module_init(x509_key_init);
-module_exit(x509_key_exit);
+crypto_module_init(x509_key_init);
+crypto_module_exit(x509_key_exit);
 
 MODULE_DESCRIPTION("X.509 certificate parser");
 MODULE_AUTHOR("Red Hat, Inc.");
-- 
2.39.3

