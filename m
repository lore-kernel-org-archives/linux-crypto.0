Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93BF2836BD;
	Thu,  4 Sep 2025 15:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001326; cv=none; b=RZi3rTUwuoNva14XK1WCdfw/qpXtpkQsDIGvQGAI2JOb2nQWnXuv0vqPj6lUi1ehgULYSMHgGGYLp64/DKiDRFEJB8EgZ/WXemB6XA7FTWIleddsEGwMQ2Er/2PGZzEACE7R6UZwY9uA4Oifp6JSAIR+M0YQWggV+euYfoSXHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001326; c=relaxed/simple;
	bh=pxw09zIdPdHEOD6sHfYpZ8l8koTl+Sf04Kl1gMzB+aw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hm2B77Lqhw3qtTZfERXsbITXkwKJggTMscZv82MbUPctNBN5yhuS/dovUWZ26SwW3I1AIUl8GU9tW6n8tyTXMTyqDWcUwY3XCa/oU7X9Fx1oMmqaB6moitumQaMQIKLtIGC5Vvvqf/BNdlbfjepHLRwdOvM1pi0oTxst2bqoGg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JQUGhZpJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JQUGhZpJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FjeEC008801;
	Thu, 4 Sep 2025 15:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=h5wJi
	KG8PQhmLB3Yl/OVA3XGBY1ryrZRdzwcLsN4j20=; b=JQUGhZpJl30pmsRn7cBZa
	TlFsxtDH1BhKzAhlQnO7vx/hvSuJjho9jY/Ubs0Kt/gkU+T/dX8X/TA6amrUJVkt
	HLARGTA65gM4gAESCaCXX8/26pKbFS4A9GjhXs1EcHrkY+LmOFrR4z7/3YSdUi3w
	hQnYkVGVGgnPAfqiI+NYx2cBBdSfmPaqq8FG3jJBVsFMWDXiiVFV/S17MjMwfBFs
	BrZpvEYD9UPP1PmF4BUIm6HgLemCWVtkOE16l3d6JD43l+Mv9Lz42EQY1IFxax+5
	ud1wW38uHm/O59jDVAovV+ib6YWmOqBLVKluoooaFRghtZIrf/n9bFW6VlZMzA5R
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd1004r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDeeP040212;
	Thu, 4 Sep 2025 15:55:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtkvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:13 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx4q000707;
	Thu, 4 Sep 2025 15:55:12 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-4;
	Thu, 04 Sep 2025 15:55:12 +0000
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
Subject: [PATCH RFC 003/104] crypto/jitterentropy: remove linux/fips.h include
Date: Thu,  4 Sep 2025 17:50:35 +0200
Message-Id: <20250904155216.460962-4-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfXzM2kl4dwgd/G
 KkZhqsw41RiOK2WG3BcEfA04MkfyMnhIM7swt5kLH0jGKgXDPHKYHHrCzso+6ImwzNA7HbJFhsU
 wg3jsnr7/pcqnqIb59eMhmnvKxuP476Mfe0NBDhqU2AzBRLd/cOTAOs0pIEZIxGQ2v30y/EiP+t
 LzcRBA/+jO/oNR+AlbnR9fcAVsGf/UbgSxw/SiFDEHYbAjuixs9vfrSUBVZkkoQuvriAEjB8Xjl
 N/7hxVSgdM0yV6J35BDX5E2odhU9V1pUAKGsXZVfNpr5dMThMVg4W0VrKGmpR9JvsYt17J6EApF
 UXKhWGZyj0nFMKgOwBXFneYnarwle5MfvQAcO8fk+ANzhXO6VuqPQu/tUrkWXudEyYCzxxpat2N
 j9cpZ0cm8uqXiCjhcZqUsIRwntZDAw==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b661 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=0-84nR_iETsBtlKI5ukA:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: NDxDESRMPgIXplIBMFRLgKoq1_EXPhSe
X-Proofpoint-GUID: NDxDESRMPgIXplIBMFRLgKoq1_EXPhSe

crypto/jitterentropy.c is deliberately compiled with -O0 and is not
supposed to depend on any kernel headers (see commit dfc9fa91938b
"crypto: jitterentropy - avoid compiler warnings").

We'll be changing include/linux/fips.h later in this series to include
other headers which break the build of jitterentropy.c due to gcc not
being able to constant propagate under -O0.

Just forward declare fips_enabled, which is the only thing
jitterentropy.o needs from this header anyway.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/jitterentropy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 3f93cdc9a7af..d939f57667dd 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -146,10 +146,11 @@ struct rand_data {
 #define JENT_ENTROPY_SAFETY_FACTOR	64
 
 #include <linux/array_size.h>
-#include <linux/fips.h>
 #include <linux/minmax.h>
 #include "jitterentropy.h"
 
+extern int fips_enabled;
+
 /***************************************************************************
  * Adaptive Proportion Test
  *
-- 
2.39.3

