Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBC8284696;
	Thu,  4 Sep 2025 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001648; cv=none; b=lRSkof880wkWoHzUVyHtDVmd1G5tAmOSCu8e9FwUyOrogegeFDTMBs6E02mEH+OAdvAB2DjMcnyrfKLHp0tcno8JasPRy+Q3wCdg7RK5KoQXFQuWHLe4sbGyVMtHCibgdgYZ/MZoXZTLAp9Otpjn+bEayoJelrvfC9f6S1HCJ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001648; c=relaxed/simple;
	bh=bVCWpXCtv0axkR0L152GzFqbmVnkVteYE6BrB5tc+hY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kiIVv7wHhbmdLStUcWCzXVaerZUlPiWzLTjU18MIjxxuRyQ8rlCYOYCLwVv2OiQV3dneUI9TF+xjvG5DJWfzTNyIiMsEMakCg9gxZdqkEV0P0mhPIl0MLKuyBfLdq5G/dzHNNa4TaPO0P+yclB4S5QcLjykyISJ63k0bIUEKTjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U3x4biYJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U3x4biYJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkjV014863;
	Thu, 4 Sep 2025 16:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Ejz/S
	IWlvowL/vsupYHdZbN03LwStuPdrPknGJ8l20o=; b=U3x4biYJREWzFqqt5bdOa
	kwMWSzR7MNqYJeyHIegx2T/mbslewACveo1bajWKMY39f3IQg+UhOZ8/dzTwCsAL
	Mya973oKheejV66Ek8H/Pfcznfio0PkZ7m0swUy5HpknF8yjx5/5W5urnNg8/3Vg
	oLnQWFtxFwqxM4mW+hwRHTKbgLOCZ0GUViUp3GrUkrnzP5SeYHswZ5rgYL5eExiO
	R+0ojGBqp6ZZNr5merLKuM/aDmjvQCIo9KZ/9IOuBvKkivFvlzJU4tPm1tRXgVPA
	2oVT0zmGsckW2LGM76yF3aSEjMXjI0/mfBEX2c0qGuKHQxxt4kErnfOK/wg7Le6f
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FedqR040082;
	Thu, 4 Sep 2025 16:00:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtsmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:00:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7a000707;
	Thu, 4 Sep 2025 16:00:31 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-85;
	Thu, 04 Sep 2025 16:00:31 +0000
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
Subject: [PATCH RFC 084/104] crypto: fips140: convert crypto/asymmetric_keys/selftest.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:56 +0200
Message-Id: <20250904155216.460962-85-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX3hbmuanzhlPD
 ZlqrsbBP3ikMqM++3IYXlJVqO7U66eJFzsGGum+Ua85d0fyUp4GlD9H1mCW9IYk+siYcw6dmSmS
 Er1yynEEy09566HLAjMBsZVluqoaHoBFFAqP9T8ol+cAB+Cf0kFBkyVqLEJ2ywBRV0wxD8pluFy
 fXCpj4A7Inertr4oHCPHci//USD/2BQccyPAT37O64xobXyDsW2r9VsceGDgcOxoBuYZkZeYg65
 IpSaY+FhTCMANAo8e51J7gD8OoHN3C6enL7nzo9Vwd0zPM2vAXqUcUOrt9MtWyE+0jbyaBXQ09k
 IRRcmxbDupAe45f+2vn998ILHj2sOBrPhlU+uVzcdvvSCcj1Z9dgbOwb3ViG64AmJxd5A9cxEXw
 7opuM3EfjT0VWejqHCDHQRdtYdqt7Q==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7a1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=qwTo_7JyjarFZj0Z3joA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: Yf1kGpNEiUOheQnJmEx4hV8Qv966M9Mo
X-Proofpoint-ORIG-GUID: Yf1kGpNEiUOheQnJmEx4hV8Qv966M9Mo

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_FIPS_SIGNATURE_SELFTEST --source crypto/asymmetric_keys/selftest.c

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/asymmetric_keys/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
index 98dc5cdfdebe..4f3b6ef85d1b 100644
--- a/crypto/asymmetric_keys/selftest.c
+++ b/crypto/asymmetric_keys/selftest.c
@@ -65,7 +65,7 @@ static int __init fips_signature_selftest_init(void)
 	return 0;
 }
 
-late_initcall(fips_signature_selftest_init);
+crypto_late_initcall(fips_signature_selftest_init);
 
 MODULE_DESCRIPTION("X.509 self tests");
 MODULE_AUTHOR("Red Hat, Inc.");
-- 
2.39.3

