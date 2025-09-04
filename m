Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C36A28315D;
	Thu,  4 Sep 2025 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001415; cv=none; b=j2GLw0ekI7BKFnQ2j+n9f4Jx1yC6vjWYptWWgCGCHvbXdNKwB5UbmbmhCU39SYJc2rf22S7NNaxuCpGkq4oOUnI950+gnCgC1nLrdyETJJvj1j4WwVtKCs/SE92P9xKi296WcI+Q9VM1EqOWNthmddcKxScaefuOQnwm5HIUxZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001415; c=relaxed/simple;
	bh=7X+gGBGRMwqv42TV207bmmc87tNTQnP9E3qttZjsQR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n4RMXxLPLaCzvz81NkoMGo47UqzwgQYFqrkHW0eDSE3NkzHNhpZvsgBBLwmippi9XK/AAW1dbsdvTJjnykdbOiQ8pIG29YtAoXv9xLFccANnn5zyJh7ScwOdjmMUuW21sdEaV+59g8mxX9G9ZIgy8yv/Z1S5gh32n8N1tYlD3/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qyash+5r; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qyash+5r"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FthmX026658;
	Thu, 4 Sep 2025 15:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=jrNSS
	cgFIwf4usm9/bjTzUIOGG46vqlxz31ML8gm7kw=; b=Qyash+5rQTyoeScjwYokn
	I3k6knLYYrMRl/P6efTUTlVt/2Mpl2mp0MzuTTolnuzVX+IjYNKaC2EGu01JSJBG
	kUs1/izCAuyqY2w+7BxzR4wXuZVHS7T8ugsmIfixF9hk+1VVnxKcf+cN2XVBK+oM
	diLyw78BP8YVQpIHKAIEfacqujGiZ8fv0BKbkpvQE547k9Jf8WgrRPlRBoRImfds
	X2oTuYxbIXM5+IVwPriF16Zj6uUYqSbXvthxE7IAIMsONBDkVjkTgHZybETLMLQ0
	UKHyLMYNns5jxCFyucc2RJNC5rPOM2Yb4U3ADe06kvMRszsX8m/qyktlshtxpQkH
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd1004w7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FG6wL040116;
	Thu, 4 Sep 2025 15:56:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtn6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5c000707;
	Thu, 4 Sep 2025 15:56:35 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-26;
	Thu, 04 Sep 2025 15:56:34 +0000
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
Subject: [PATCH RFC 025/104] crypto: fips140: convert lib/crypto/memneq.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:50:57 +0200
Message-Id: <20250904155216.460962-26-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfX9TU3QI2c1a43
 SJtiMwCeBq70nUgaI0rbmTn2n/gxXGFBo9RnwbEPhAWvMPryBydwKqQTX9vSKLNuDqk+HZu7Y0U
 eNhkqdbTVq3njV4CPn3bTu6Jn6iTtbAYmxVJaBnr3+JoR9TGNEdgjPdwND7Gaj7NXrRxExcigZa
 gSoU2tsxKgtBzRUmpKML9F01+XgP80KCea5hDplVjXugf/8PtMiAnAUxw4GIENR4Fo8ckP++Ma0
 zVNHHR22M6hYVogqejdzLSWemy88ht5rIfWkx3X6QmXhvJyr/evk0lmQPiGkvEsqcbbEaOhQe1c
 /IZ5HC49FQwXMncB56kwgbpiRWm+7tMTtO8GLlWDB1/9+JBmQoS+ZpgflQWuSH0IhhBe9sdjh/n
 +M/n+YQfPWN6KlXF0uJYmfGnwOIvJA==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b6b4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=hH5gqmks7TWo5nbZDzEA:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: M-lp2wtJlSGS7lEFnOAqdcE9fpIluZLs
X-Proofpoint-GUID: M-lp2wtJlSGS7lEFnOAqdcE9fpIluZLs

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_LIB_UTILS --source lib/crypto/memneq.c --header include/crypto/utils.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c   | 11 +++++++++++
 include/crypto/utils.h |  5 ++++-
 lib/crypto/memneq.c    |  4 ++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 6c29b46631e4..16d0d8afebe7 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -49,3 +49,14 @@ DEFINE_CRYPTO_API_STUB(gf128mul_64k_bbe);
 
 #endif
 
+/*
+ * lib/crypto/memneq.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_LIB_UTILS)
+
+#include <crypto/utils.h>
+
+DEFINE_CRYPTO_API_STUB(__crypto_memneq);
+
+#endif
+
diff --git a/include/crypto/utils.h b/include/crypto/utils.h
index 2594f45777b5..d7c3dae79138 100644
--- a/include/crypto/utils.h
+++ b/include/crypto/utils.h
@@ -7,6 +7,7 @@
 #ifndef _CRYPTO_UTILS_H
 #define _CRYPTO_UTILS_H
 
+#include <crypto/api.h>
 #include <linux/unaligned.h>
 #include <linux/compiler_attributes.h>
 #include <linux/types.h>
@@ -53,7 +54,9 @@ static inline void crypto_xor_cpy(u8 *dst, const u8 *src1, const u8 *src2,
 	}
 }
 
-noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
+DECLARE_CRYPTO_API(__crypto_memneq, unsigned long,
+	(const void *a, const void *b, size_t size),
+	(a, b, size));
 
 /**
  * crypto_memneq - Compare two areas of memory without leaking
diff --git a/lib/crypto/memneq.c b/lib/crypto/memneq.c
index 44daacb8cb51..2ee1d7d71d49 100644
--- a/lib/crypto/memneq.c
+++ b/lib/crypto/memneq.c
@@ -161,7 +161,7 @@ static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
  * not call this function directly, but should instead use
  * crypto_memneq defined in crypto/algapi.h.
  */
-noinline unsigned long __crypto_memneq(const void *a, const void *b,
+unsigned long CRYPTO_API(__crypto_memneq)(const void *a, const void *b,
 				       size_t size)
 {
 	switch (size) {
@@ -171,4 +171,4 @@ noinline unsigned long __crypto_memneq(const void *a, const void *b,
 		return __crypto_memneq_generic(a, b, size);
 	}
 }
-EXPORT_SYMBOL(__crypto_memneq);
+DEFINE_CRYPTO_API(__crypto_memneq);
-- 
2.39.3

