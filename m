Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7929428134C;
	Thu,  4 Sep 2025 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001540; cv=none; b=mz9VqivxxtJaO4Rak2dP0/V++GAdSosBmboBGCo+tkIf1UKFzVDlARbXNwz3Qe7kTnEWjR3i19ay1SQM3qzL/RCXNNf2yR4kvowMH0vVEFo9xtnz/XOYluHnFs7A6F58QRJdcNz8HN70vbFX73EK/E6ncGnOm3nn3F1LCJpU3ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001540; c=relaxed/simple;
	bh=MsQuIqvna3Lk33rVED4jn07Ft55txMPzCQgblcRccZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nYxkjrnB88nne8nsC8osdPPP+gP+HOEDYHUC8A7rBbcc+A4o4vmXhC4Ijms4IZJi0LKjOgqcQ1DO5uYsG0RwBJ3GTSS+KEcDAJ0HUu40oOntGP8m4z/zi3PZlTDBIwsO6QbpYK7bmNO6TM7ZOJFDpcrdZrWaPoCVIUQWh7cyTwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FLP7OG2g; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FLP7OG2g"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtoT7014940;
	Thu, 4 Sep 2025 15:58:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=lqpmy
	FlrH/TTpyK8bdK3ImgmWmN75cbMpuSO6C6hOZs=; b=FLP7OG2gGEM3WPVV5UUza
	mDMcse3i3OtLnEMrxd8e/eD7Dhbp9B9z7nO4P7wvoAGvrVh1pw7ymEyeqtVvcuev
	NrlQ9aMDfnRurwMOaZYqE+hsjXaqKYdbAS761R716Qipn+icLVxtK289ga/sQiM9
	/puChVqn3kZZM8cuvSex19x02TVRQ38iKgg3ruVi157ehqzraR3b5efI7LlQ8acW
	riL0n/LB2hWuQ3VKyxtb63/yIpWuQbdNxlcpjqwCBayAOfRJqShAMjyDkXQvSVx3
	t6DKs2S7qT8AM5+zu3/Bymc+BR2bHcZN1j6pgF3zwYoPOJvANZ1Ir2xY5XQIXNSh
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0ce0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F46ps040015;
	Thu, 4 Sep 2025 15:58:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtq0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:45 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6c000707;
	Thu, 4 Sep 2025 15:58:44 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-56;
	Thu, 04 Sep 2025 15:58:44 +0000
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
Subject: [PATCH RFC 055/104] crypto: fips140: convert crypto/geniv.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:27 +0200
Message-Id: <20250904155216.460962-56-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX8ORYEp+/EAI8
 k8Tf1ALGu2jwKdc5MfMEF2kgurvq7yKwq50/AtzG2IaUKJlMPCsZvmR8xz5ZPt9uCjexiwoL7fd
 PWtkHSVJhAB+bm0gEna9KELbCxXfI4UiAG7JSspR0Vr1UPXffTcZeWZQlGXVEg3kINR8oUNsjvj
 mvzUTyux6tj7yBx5Qrbi2y8/MvO54cDcSYR8NmYgy2K/HvyGtHO5dIhdDqItqOKrP01YRP/DAu8
 PQIf+YoV1gqtUh6iLHL2qqIGqiqdxE0QbAVgOknlyJoQj5metY32N50DtJcoAaN9GtNcZTKSW6a
 H3qQ+0hXmt11F7hGYCIlh0LOSNbtDHE6vXZuqPvBL2pazsKeGm8JpgsnQHIIER82xkRQaa2jrbO
 PpWBEZhcpq0NKIY1EciiglcWsh7brA==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b736 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=zFtWU51pQonVRbV9V7cA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: pvs0hBQWgmNoDdabjpSlo7goBaiyyxg-
X-Proofpoint-ORIG-GUID: pvs0hBQWgmNoDdabjpSlo7goBaiyyxg-

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_GENIV --source crypto/geniv.c --header include/crypto/internal/geniv.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c            | 13 +++++++++++++
 crypto/geniv.c                  | 12 ++++++------
 include/crypto/internal/geniv.h | 14 ++++++++++----
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index fab12d65a312..09f5818cebe2 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -410,3 +410,16 @@ DEFINE_CRYPTO_API_STUB(crypto_ecdh_decode_key);
 
 #endif
 
+/*
+ * crypto/geniv.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_GENIV)
+
+#include <crypto/internal/geniv.h>
+
+DEFINE_CRYPTO_API_STUB(aead_geniv_alloc);
+DEFINE_CRYPTO_API_STUB(aead_init_geniv);
+DEFINE_CRYPTO_API_STUB(aead_exit_geniv);
+
+#endif
+
diff --git a/crypto/geniv.c b/crypto/geniv.c
index 0b18240ac813..61d81aa2d4ff 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -37,7 +37,7 @@ static void aead_geniv_free(struct aead_instance *inst)
 	kfree(inst);
 }
 
-struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
+struct aead_instance *CRYPTO_API(aead_geniv_alloc)(struct crypto_template *tmpl,
 				       struct rtattr **tb)
 {
 	struct crypto_aead_spawn *spawn;
@@ -103,9 +103,9 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	inst = ERR_PTR(err);
 	goto out;
 }
-EXPORT_SYMBOL_GPL(aead_geniv_alloc);
+DEFINE_CRYPTO_API(aead_geniv_alloc);
 
-int aead_init_geniv(struct crypto_aead *aead)
+int CRYPTO_API(aead_init_geniv)(struct crypto_aead *aead)
 {
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(aead);
 	struct aead_instance *inst = aead_alg_instance(aead);
@@ -138,15 +138,15 @@ int aead_init_geniv(struct crypto_aead *aead)
 out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(aead_init_geniv);
+DEFINE_CRYPTO_API(aead_init_geniv);
 
-void aead_exit_geniv(struct crypto_aead *tfm)
+void CRYPTO_API(aead_exit_geniv)(struct crypto_aead *tfm)
 {
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
 }
-EXPORT_SYMBOL_GPL(aead_exit_geniv);
+DEFINE_CRYPTO_API(aead_exit_geniv);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Shared IV generator code");
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 012f5fb22d43..c7aaad2ab534 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_INTERNAL_GENIV_H
 #define _CRYPTO_INTERNAL_GENIV_H
 
+#include <crypto/api.h>
 #include <crypto/internal/aead.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -18,9 +19,14 @@ struct aead_geniv_ctx {
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
-struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-				       struct rtattr **tb);
-int aead_init_geniv(struct crypto_aead *tfm);
-void aead_exit_geniv(struct crypto_aead *tfm);
+DECLARE_CRYPTO_API(aead_geniv_alloc, struct aead_instance *,
+	(struct crypto_template *tmpl, struct rtattr **tb),
+	(tmpl, tb));
+DECLARE_CRYPTO_API(aead_init_geniv, int,
+	(struct crypto_aead *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(aead_exit_geniv, void,
+	(struct crypto_aead *tfm),
+	(tfm));
 
 #endif	/* _CRYPTO_INTERNAL_GENIV_H */
-- 
2.39.3

