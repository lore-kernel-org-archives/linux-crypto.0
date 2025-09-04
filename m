Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A32328134C;
	Thu,  4 Sep 2025 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001556; cv=none; b=Si4O9lfhuNQ4zMEs8vAQEzmHWUaZYrUDnYONV5sGExThilHA5HoBEcleiJcEHB4ujklF7yEEKcRiJ0hF8Vn9T6VOWLV8LizT69AjWweLi+STeeRNfZcn+XLxLUOThOZN2k5eENzpSH7xHDfIig4b0NwbgmHIB/E78bsL9R/cwMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001556; c=relaxed/simple;
	bh=YiEcRnkUeUAWM8nen1nQcY5DY6RxDHLW1Fxhev3v460=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=av3nS9nh8RyMWfa9qKphj1Xv/GAeTc82DgXM2DVNW1TWKzdu7TOa6nulzpGJkVm5a6SaXNXDwNT5XRea9mFzkwMpBGz5+ScYFZXmq2BQ58sLwSdevOwSfoBcpiYdl0JlIwtbD7lLIZbpRc+WUfe4csYIAW1J1ZYOnheb9hbZ0Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YqucW3d6; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YqucW3d6"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftr8p026810;
	Thu, 4 Sep 2025 15:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Nr+kA
	cTD7cgWpQYXWoFjE8mNY89ORmeLKLB67OMQYbQ=; b=YqucW3d6GrclC+8qVfMfS
	bNstj00FZPICrlpSNv2uXofiYQioIg+5UFguVWakRgkt5rtMMtDWdPC7h9V+T+wM
	R+3tCw6jdbQRUZRAl2K3ZwQzBNI40KCR2/9LTkTj39ssDTlRrqTirjUukLxkBaNN
	haIyYQ4YVLxP9Ya56eVTD1LYEFoG545wWnGG+MdHoqQ8WPCCRdvomW+/wE7u/fIg
	1NuapulJLl0Ch4C+4Xx3LUyhDzDq2oqaMuIBh9MD13SG5IllKUJESYVC/U+PZt23
	TDujAxFqFo9vuHWtFoEmJF6FFLAo00r7uHpt+5g4a7kTzJhl1FYDeoVbK+Pkyg4Y
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd10053b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FedpH040082;
	Thu, 4 Sep 2025 15:58:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtq84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:58 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6k000707;
	Thu, 4 Sep 2025 15:58:58 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-60;
	Thu, 04 Sep 2025 15:58:58 +0000
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
Subject: [PATCH RFC 059/104] crypto: fips140: convert crypto/kpp.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:31 +0200
Message-Id: <20250904155216.460962-60-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfXz420hk//NbPW
 HstddocjeyLlpOvYshJoRiaDyENqNQIKKOxxMtyHMfRrlfI4M8R2Fblh9SWzBKHvaSfcfjV+lW2
 4dLMRatFX5P5PspPdY0Iyki1dPaqzVu1K3gmlYEi05TOv9qO98BKUEc6dXHofZmksI3rRVIVSDC
 9ZFAAdlPw4CCwhX2jX81BQJTQ96rzoRTU7heVdwn8j4/yrUw6ZhltoCPhiHVIAckm/4EwmHz6+L
 VNwICek5VsZt1FNAZS8w6N1f8c1SG5TNYIQ+O0kqJvEfxhz9fP24L8WYlPutybnXgIKsp3N8FjS
 ysgmn/eSWDlFOqtNJyI88t1qtPCvP7+VSL1MnxURRM28tboVnUZEXRTdYZSM+RaFCGXiKDQXOUa
 YmJYJSlUyA/QRmZuHDnK9hGyKjIYLw==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b743 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=fYMsgpmmTYcdmzBG9VcA:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: AWtSoCXrwXlzEffjho48iHIDzrD779T6
X-Proofpoint-GUID: AWtSoCXrwXlzEffjho48iHIDzrD779T6

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_KPP2 --source crypto/kpp.c --header include/crypto/kpp.h include/crypto/internal/kpp.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c          | 19 +++++++++++++++++++
 crypto/kpp.c                  | 24 ++++++++++++------------
 include/crypto/internal/kpp.h | 21 ++++++++++++++-------
 include/crypto/kpp.h          |  9 +++++++--
 4 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 09f5818cebe2..9c9f9d57f99d 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -423,3 +423,22 @@ DEFINE_CRYPTO_API_STUB(aead_exit_geniv);
 
 #endif
 
+/*
+ * crypto/kpp.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_KPP2)
+
+#include <crypto/kpp.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_kpp);
+DEFINE_CRYPTO_API_STUB(crypto_has_kpp);
+
+#include <crypto/internal/kpp.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_register_kpp);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_kpp);
+DEFINE_CRYPTO_API_STUB(kpp_register_instance);
+DEFINE_CRYPTO_API_STUB(crypto_grab_kpp);
+
+#endif
+
diff --git a/crypto/kpp.c b/crypto/kpp.c
index 2e0cefe7a25f..7769cfe8bfde 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -83,26 +83,26 @@ static const struct crypto_type crypto_kpp_type = {
 	.algsize = offsetof(struct kpp_alg, base),
 };
 
-struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask)
+struct crypto_kpp *CRYPTO_API(crypto_alloc_kpp)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_kpp_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_kpp);
+DEFINE_CRYPTO_API(crypto_alloc_kpp);
 
-int crypto_grab_kpp(struct crypto_kpp_spawn *spawn,
+int CRYPTO_API(crypto_grab_kpp)(struct crypto_kpp_spawn *spawn,
 		    struct crypto_instance *inst,
 		    const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_kpp_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_kpp);
+DEFINE_CRYPTO_API(crypto_grab_kpp);
 
-int crypto_has_kpp(const char *alg_name, u32 type, u32 mask)
+int CRYPTO_API(crypto_has_kpp)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_kpp_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_has_kpp);
+DEFINE_CRYPTO_API(crypto_has_kpp);
 
 static void kpp_prepare_alg(struct kpp_alg *alg)
 {
@@ -113,22 +113,22 @@ static void kpp_prepare_alg(struct kpp_alg *alg)
 	base->cra_flags |= CRYPTO_ALG_TYPE_KPP;
 }
 
-int crypto_register_kpp(struct kpp_alg *alg)
+int CRYPTO_API(crypto_register_kpp)(struct kpp_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
 	kpp_prepare_alg(alg);
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_kpp);
+DEFINE_CRYPTO_API(crypto_register_kpp);
 
-void crypto_unregister_kpp(struct kpp_alg *alg)
+void CRYPTO_API(crypto_unregister_kpp)(struct kpp_alg *alg)
 {
 	crypto_unregister_alg(&alg->base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_kpp);
+DEFINE_CRYPTO_API(crypto_unregister_kpp);
 
-int kpp_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(kpp_register_instance)(struct crypto_template *tmpl,
 			  struct kpp_instance *inst)
 {
 	if (WARN_ON(!inst->free))
@@ -138,7 +138,7 @@ int kpp_register_instance(struct crypto_template *tmpl,
 
 	return crypto_register_instance(tmpl, kpp_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(kpp_register_instance);
+DEFINE_CRYPTO_API(kpp_register_instance);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Key-agreement Protocol Primitives");
diff --git a/include/crypto/internal/kpp.h b/include/crypto/internal/kpp.h
index 0a6db8c4a9a0..f69e1e311ef4 100644
--- a/include/crypto/internal/kpp.h
+++ b/include/crypto/internal/kpp.h
@@ -7,6 +7,8 @@
  */
 #ifndef _CRYPTO_KPP_INT_H
 #define _CRYPTO_KPP_INT_H
+
+#include <crypto/api.h>
 #include <crypto/kpp.h>
 #include <crypto/algapi.h>
 
@@ -159,7 +161,9 @@ static inline void *kpp_instance_ctx(struct kpp_instance *inst)
  *
  * Return: zero on success; error code in case of error
  */
-int crypto_register_kpp(struct kpp_alg *alg);
+DECLARE_CRYPTO_API(crypto_register_kpp, int,
+	(struct kpp_alg *alg),
+	(alg));
 
 /**
  * crypto_unregister_kpp() -- Unregister key-agreement protocol primitive
@@ -170,7 +174,9 @@ int crypto_register_kpp(struct kpp_alg *alg);
  *
  * @alg:	algorithm definition
  */
-void crypto_unregister_kpp(struct kpp_alg *alg);
+DECLARE_CRYPTO_API(crypto_unregister_kpp, void,
+	(struct kpp_alg *alg),
+	(alg));
 
 /**
  * kpp_register_instance() - Register a KPP template instance.
@@ -178,8 +184,9 @@ void crypto_unregister_kpp(struct kpp_alg *alg);
  * @inst: The KPP template instance to be registered.
  * Return: %0 on success, negative error code otherwise.
  */
-int kpp_register_instance(struct crypto_template *tmpl,
-			  struct kpp_instance *inst);
+DECLARE_CRYPTO_API(kpp_register_instance, int,
+	(struct crypto_template *tmpl, struct kpp_instance *inst),
+	(tmpl, inst));
 
 /*
  * KPP spawn related functions.
@@ -193,9 +200,9 @@ int kpp_register_instance(struct crypto_template *tmpl,
  * @mask: The mask bismask to pass on to the lookup.
  * Return: %0 on success, a negative error code otherwise.
  */
-int crypto_grab_kpp(struct crypto_kpp_spawn *spawn,
-		    struct crypto_instance *inst,
-		    const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_kpp, int,
+	(struct crypto_kpp_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 /**
  * crypto_drop_kpp() - Release a spawn previously bound via crypto_grab_kpp().
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 2d9c4de57b69..f4b0af4afdb7 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -9,6 +9,7 @@
 #ifndef _CRYPTO_KPP_
 #define _CRYPTO_KPP_
 
+#include <crypto/api.h>
 #include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
@@ -107,9 +108,13 @@ struct kpp_alg {
  * Return: allocated handle in case of success; IS_ERR() is true in case of
  *	   an error, PTR_ERR() returns the error code.
  */
-struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_kpp, struct crypto_kpp *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
-int crypto_has_kpp(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_has_kpp, int,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline struct crypto_tfm *crypto_kpp_tfm(struct crypto_kpp *tfm)
 {
-- 
2.39.3

