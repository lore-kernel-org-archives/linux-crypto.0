Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E3A21ABB1;
	Thu,  4 Sep 2025 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001695; cv=none; b=sXvS/GjniX7sVsgBfMT0d6b3TX6aZvaHCytTHPb7GLjfhETTlAA0Rib+uf8tmPWcBtG5E/xeVuSct05nMvu1nRRRPIUZJ5XbXoBDOXZqeT9dtXkKF3UDGsRCiFQWkcTGzgK6n20+NHnGzYyOxXzTQPpZSig1H3RkJEJka83tvZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001695; c=relaxed/simple;
	bh=EMl6hRy5JkPl2xZksyhw99at4yQiGQx/2/rpqigpr8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rdnbjlakhQI4TGEPi3osI42Ummyi8RKtFru8ArxbOqt71u5FqQq2Rn9koY6KyaDo20r1tkZlY7jwhlB+fdSai3J/+rfhJ3pO/nBzN4E2xej92z5m+kZfffwUt0ad74qrt+CTRBfwlcDTETJ6lbCtt61hsSmZbpAK4O4Gat2Wn2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OqM3K4nn; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OqM3K4nn"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkUI010494;
	Thu, 4 Sep 2025 16:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=soDKf
	3/c8gpB9D5hV6f8kpGHOnRHkiTcFXfDQ12Ld/Y=; b=OqM3K4nniBfnpEukCyXT5
	cQBvEtlUuZH9TEQrVS5F95b6jxHTmPvnL8NO5szMgF/186HXnsXOi1V/MNvDQ1fW
	K3QUD8Df/v/GfkR+Z4pfSDkHC6lk4IZscKaYtvLcKiWXX3ONd7dZGinL5YBWUwsM
	S09KilOvwEERvFP3xZxpzy482J5row0B7Rwe1dSFsH0h5sSGcQO2Lpx5PC5RtRwD
	Y1phwcgTds/MznTsB9jaksu1yCUCrsefireeRLplMSfr5YC2939CReyZUj7taP0Q
	EpN9ti25GRFChmEBhuRobmfl+Nfoy6WJ8kICIrnHEwLHoOPIXZ3O4wJJgwyQ2x28
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr339-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F7Qqp040109;
	Thu, 4 Sep 2025 16:01:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhttfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:13 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7w000707;
	Thu, 4 Sep 2025 16:01:12 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-96;
	Thu, 04 Sep 2025 16:01:12 +0000
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
Subject: [PATCH RFC 095/104] crypto: fips140: manual fixups for include/crypto/internal/rsa.h
Date: Thu,  4 Sep 2025 17:52:07 +0200
Message-Id: <20250904155216.460962-96-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: DTKYfOdZq7MF0HFF9Nop_gxUBR-LqjWf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX/XtWTSJ/Gk/K
 uS+rtrjBLZUOIsmnhw2x+Z7O03HRvX1DblQRK87vMpXEluf9Wc/YpupTqJSXsUDghMtSDEJciQi
 pNRjkD32GSSZGCAwbvOyvQZmCY4zNrafHuEqhz3mV4K1DmJqFzz9A+pkH+iKgEYpl7IGNqQosj2
 ws1IsWneYB6+GpwsGkD4BrEp3K7VnqdED/u8sF9KBrGGfshyegEhDI39xCS/tfQPUNK4S0+KxHl
 5DVJOGY8JWOJZw+uc5G5lz67B9gB+ORBiwMK7rBEcHG5XW+oB6Y6Rv33teyZl4StVLHCojxvRAt
 kuUoPlphVrZC/UukHJ39AQfzy9ym65O86mVwOJfdQFYRfE+FpYQToEmtGDneVZZlg0e0/igSNtY
 nFcjUHMAWzyi3GABtUzRQqBpu9SHSw==
X-Proofpoint-ORIG-GUID: DTKYfOdZq7MF0HFF9Nop_gxUBR-LqjWf
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b7cb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=MEBtLbXv8hCP0I2nMe4A:9 cc=ntf
 awl=host:12068

Define fips_/nonfips_ variants of rsa_pkcs1pad_tmpl and
rsassa_pkcs1_tmpl when the kernel is configured to use a standalone
FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/crypto/internal/rsa.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index 1265aa81f6fe..9028a184d06e 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -12,6 +12,16 @@
 #include <linux/types.h>
 #include <crypto/akcipher.h>
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define rsa_pkcs1pad_tmpl fips_rsa_pkcs1pad_tmpl
+#define rsassa_pkcs1_tmpl fips_rsassa_pkcs1_tmpl
+#else
+#define rsa_pkcs1pad_tmpl nonfips_rsa_pkcs1pad_tmpl
+#define rsassa_pkcs1_tmpl nonfips_rsassa_pkcs1_tmpl
+#endif
+#endif
+
 /**
  * rsa_key - RSA key structure
  * @n           : RSA modulus raw byte stream
-- 
2.39.3

