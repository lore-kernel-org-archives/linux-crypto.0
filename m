Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29628466C;
	Thu,  4 Sep 2025 15:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001406; cv=none; b=lzm97qs6Nz124LI1328UHQDTUJNFl4R5vA82ShRFh/mPbF4hFQb5ma7Ycr178M5MraGRy5UgRPQY6AIL0hzDXNIzlEaadZBaGJuOAjtTPRa53qJVYAzB1C2g7ZBbUnKEpKHUNOwgeD9VNRssA4zCycfEYkAJDltyE4hyU36qs2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001406; c=relaxed/simple;
	bh=Yflp3KZTxKPGyDZ7pRhyvIgWdQ70HPZz2jejwFB51Dg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JM2HoQkjglRvycEu5KfRc9RFzEFtVOlZsiEChFkoFWZPxThWSYUKGf4a+g1CHSoRA2GwtlU7qZJ4uYYAg5FkeSogR43MDy2SlWFMSBX3Qec+gQPEJ0zGyHyZngM+STubznjibihwmtsmnl9MIr4gJ57wuR7NTR1ywCxUET4Bmns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j2XXIH/K; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j2XXIH/K"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftrah010582;
	Thu, 4 Sep 2025 15:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=MW0Ip
	dF3gYHir1HxEMHzNA66+A0Hj2XRq1ptlVjMuL0=; b=j2XXIH/K6yJ6hLFK4+QnK
	azfXvy0hIHf3sUmjnVP70OmYFUaD+MGEL8JtNHKw2dgILMIoOVEEm813SLYKXEPG
	VRS9RWqZJPp4steyzW/ue7YzQLw72kW9iuv5XKZzKHCj61vmOcptO0BuOzZHIkbh
	SAKMsLcJcHcM7LjygF4MZJPhIMpReA8X2HT8wAkwLKSjLuaXKXX77v6rEow96pGr
	IDQOBsoY1ZPTxCc5+Zem6C1zolEAaIKFYleGvEuvOhald3EhRFOUglmZs2notM3C
	Gzw88LCuWQRIGWDF9YT0R3Kg/iX7qguM5DppoEn0xE8fD1kQSZNmdPy9G8WMWE7d
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ff3G2040054;
	Thu, 4 Sep 2025 15:56:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtn53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5a000707;
	Thu, 4 Sep 2025 15:56:31 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-25;
	Thu, 04 Sep 2025 15:56:31 +0000
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
Subject: [PATCH RFC 024/104] crypto: fips140: convert lib/crypto/gf128mul.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:50:56 +0200
Message-Id: <20250904155216.460962-25-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: -mQpJsTUwtCNtrwgsBpHvckrFrGDkB7M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX561nD4GUY/Hw
 QXLoYL1+MViqcSYCNWNaRCtH3AMmB54I7owo7T060iHIpzVtos+7quoTaOQ3lCYd44/QJJLMeWM
 g9GYEaZ18+yf3JeI86SHF+XRu3bOuQN6/Cbwworowhspkvsuq+6u47MS+AlcW5WZN0BosB2HfxX
 8yLfb5+7xlKj6TMjIalJW32qnQbRUbmghC1mSVxLnYQq0gsfBmKJCwdm+QzmYN1XodkxPb5f1jv
 f0FR+7e/acDDU7luxyZhiuWPkK5HgTI/iqZQIU6VBX6jKtdYWGuNIqDpAtt0bo+5yom38pW8qFh
 jOAisGads0BeQ7ey42u/CZ0+gZrMU4fegzADiEG27u2OvLP3EztshNe0CyBmEJX/wh+UajrFP1r
 tyIf3U1bAVBVaVPXcMlG9VoVXqLAuA==
X-Proofpoint-ORIG-GUID: -mQpJsTUwtCNtrwgsBpHvckrFrGDkB7M
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6b1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=1-JrGfBR3iohAa1lrrEA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_LIB_GF128MUL --source lib/crypto/gf128mul.c --header include/crypto/gf128mul.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c      | 17 +++++++++++++++++
 include/crypto/gf128mul.h | 29 ++++++++++++++++++++++-------
 lib/crypto/gf128mul.c     | 28 ++++++++++++++--------------
 3 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 4924b11ec592..6c29b46631e4 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -32,3 +32,20 @@ DEFINE_CRYPTO_API_STUB(aesgcm_decrypt);
 
 #endif
 
+/*
+ * lib/crypto/gf128mul.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_LIB_GF128MUL)
+
+#include <crypto/gf128mul.h>
+
+DEFINE_CRYPTO_API_STUB(gf128mul_lle);
+DEFINE_CRYPTO_API_STUB(gf128mul_init_4k_lle);
+DEFINE_CRYPTO_API_STUB(gf128mul_4k_lle);
+DEFINE_CRYPTO_API_STUB(gf128mul_x8_ble);
+DEFINE_CRYPTO_API_STUB(gf128mul_init_64k_bbe);
+DEFINE_CRYPTO_API_STUB(gf128mul_free_64k);
+DEFINE_CRYPTO_API_STUB(gf128mul_64k_bbe);
+
+#endif
+
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index b0853f7cada0..9367a2234fc4 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -49,6 +49,7 @@
 #ifndef _CRYPTO_GF128MUL_H
 #define _CRYPTO_GF128MUL_H
 
+#include <crypto/api.h>
 #include <asm/byteorder.h>
 #include <crypto/b128ops.h>
 #include <linux/slab.h>
@@ -160,7 +161,9 @@
 
 /*	A slow generic version of gf_mul, implemented for lle
  * 	It multiplies a and b and puts the result in a */
-void gf128mul_lle(be128 *a, const be128 *b);
+DECLARE_CRYPTO_API(gf128mul_lle, void,
+	(be128 *a, const be128 *b),
+	(a, b));
 
 /*
  * The following functions multiply a field element by x in
@@ -221,9 +224,15 @@ struct gf128mul_4k {
 	be128 t[256];
 };
 
-struct gf128mul_4k *gf128mul_init_4k_lle(const be128 *g);
-void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t);
-void gf128mul_x8_ble(le128 *r, const le128 *x);
+DECLARE_CRYPTO_API(gf128mul_init_4k_lle, struct gf128mul_4k *,
+	(const be128 *g),
+	(g));
+DECLARE_CRYPTO_API(gf128mul_4k_lle, void,
+	(be128 *a, const struct gf128mul_4k *t),
+	(a, t));
+DECLARE_CRYPTO_API(gf128mul_x8_ble, void,
+	(le128 *r, const le128 *x),
+	(r, x));
 static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 {
 	kfree_sensitive(t);
@@ -241,8 +250,14 @@ struct gf128mul_64k {
  * factor in the first argument, and the table in the second.
  * Afterwards, the result is stored in *a.
  */
-struct gf128mul_64k *gf128mul_init_64k_bbe(const be128 *g);
-void gf128mul_free_64k(struct gf128mul_64k *t);
-void gf128mul_64k_bbe(be128 *a, const struct gf128mul_64k *t);
+DECLARE_CRYPTO_API(gf128mul_init_64k_bbe, struct gf128mul_64k *,
+	(const be128 *g),
+	(g));
+DECLARE_CRYPTO_API(gf128mul_free_64k, void,
+	(struct gf128mul_64k *t),
+	(t));
+DECLARE_CRYPTO_API(gf128mul_64k_bbe, void,
+	(be128 *a, const struct gf128mul_64k *t),
+	(a, t));
 
 #endif /* _CRYPTO_GF128MUL_H */
diff --git a/lib/crypto/gf128mul.c b/lib/crypto/gf128mul.c
index 2a34590fe3f1..15698c82f0d8 100644
--- a/lib/crypto/gf128mul.c
+++ b/lib/crypto/gf128mul.c
@@ -168,7 +168,7 @@ static void gf128mul_x8_bbe(be128 *x)
 	x->b = cpu_to_be64((b << 8) ^ _tt);
 }
 
-void gf128mul_x8_ble(le128 *r, const le128 *x)
+void CRYPTO_API(gf128mul_x8_ble)(le128 *r, const le128 *x)
 {
 	u64 a = le64_to_cpu(x->a);
 	u64 b = le64_to_cpu(x->b);
@@ -177,9 +177,9 @@ void gf128mul_x8_ble(le128 *r, const le128 *x)
 	r->a = cpu_to_le64((a << 8) | (b >> 56));
 	r->b = cpu_to_le64((b << 8) ^ _tt);
 }
-EXPORT_SYMBOL(gf128mul_x8_ble);
+DEFINE_CRYPTO_API(gf128mul_x8_ble);
 
-void gf128mul_lle(be128 *r, const be128 *b)
+void CRYPTO_API(gf128mul_lle)(be128 *r, const be128 *b)
 {
 	/*
 	 * The p array should be aligned to twice the size of its element type,
@@ -224,7 +224,7 @@ void gf128mul_lle(be128 *r, const be128 *b)
 		gf128mul_x8_lle_ti(r); /* use the time invariant version */
 	}
 }
-EXPORT_SYMBOL(gf128mul_lle);
+DEFINE_CRYPTO_API(gf128mul_lle);
 
 /*      This version uses 64k bytes of table space.
     A 16 byte buffer has to be multiplied by a 16 byte key
@@ -240,7 +240,7 @@ EXPORT_SYMBOL(gf128mul_lle);
  * t[1][BYTE] contains g*x^8*BYTE
  *  ..
  * t[15][BYTE] contains g*x^120*BYTE */
-struct gf128mul_64k *gf128mul_init_64k_bbe(const be128 *g)
+struct gf128mul_64k *CRYPTO_API(gf128mul_init_64k_bbe)(const be128 *g)
 {
 	struct gf128mul_64k *t;
 	int i, j, k;
@@ -280,9 +280,9 @@ struct gf128mul_64k *gf128mul_init_64k_bbe(const be128 *g)
 out:
 	return t;
 }
-EXPORT_SYMBOL(gf128mul_init_64k_bbe);
+DEFINE_CRYPTO_API(gf128mul_init_64k_bbe);
 
-void gf128mul_free_64k(struct gf128mul_64k *t)
+void CRYPTO_API(gf128mul_free_64k)(struct gf128mul_64k *t)
 {
 	int i;
 
@@ -290,9 +290,9 @@ void gf128mul_free_64k(struct gf128mul_64k *t)
 		kfree_sensitive(t->t[i]);
 	kfree_sensitive(t);
 }
-EXPORT_SYMBOL(gf128mul_free_64k);
+DEFINE_CRYPTO_API(gf128mul_free_64k);
 
-void gf128mul_64k_bbe(be128 *a, const struct gf128mul_64k *t)
+void CRYPTO_API(gf128mul_64k_bbe)(be128 *a, const struct gf128mul_64k *t)
 {
 	u8 *ap = (u8 *)a;
 	be128 r[1];
@@ -303,7 +303,7 @@ void gf128mul_64k_bbe(be128 *a, const struct gf128mul_64k *t)
 		be128_xor(r, r, &t->t[i]->t[ap[15 - i]]);
 	*a = *r;
 }
-EXPORT_SYMBOL(gf128mul_64k_bbe);
+DEFINE_CRYPTO_API(gf128mul_64k_bbe);
 
 /*      This version uses 4k bytes of table space.
     A 16 byte buffer has to be multiplied by a 16 byte key
@@ -321,7 +321,7 @@ EXPORT_SYMBOL(gf128mul_64k_bbe);
     lower byte in the buffer, stopping when we reach the
     lowest byte. This requires a 4096 byte table.
 */
-struct gf128mul_4k *gf128mul_init_4k_lle(const be128 *g)
+struct gf128mul_4k *CRYPTO_API(gf128mul_init_4k_lle)(const be128 *g)
 {
 	struct gf128mul_4k *t;
 	int j, k;
@@ -341,9 +341,9 @@ struct gf128mul_4k *gf128mul_init_4k_lle(const be128 *g)
 out:
 	return t;
 }
-EXPORT_SYMBOL(gf128mul_init_4k_lle);
+DEFINE_CRYPTO_API(gf128mul_init_4k_lle);
 
-void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t)
+void CRYPTO_API(gf128mul_4k_lle)(be128 *a, const struct gf128mul_4k *t)
 {
 	u8 *ap = (u8 *)a;
 	be128 r[1];
@@ -356,7 +356,7 @@ void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t)
 	}
 	*a = *r;
 }
-EXPORT_SYMBOL(gf128mul_4k_lle);
+DEFINE_CRYPTO_API(gf128mul_4k_lle);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Functions for multiplying elements of GF(2^128)");
-- 
2.39.3

