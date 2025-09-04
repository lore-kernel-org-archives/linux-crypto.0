Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F82F3627;
	Thu,  4 Sep 2025 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001594; cv=none; b=LFE5OfA2HOtlzD8B76pv1EaYsyNxJTHZOReCSJv2wwz6iW0YbmmFvqFeTNW+Oin+Liy+6OM3X89/3QxCQHta9LUoiwA3K0NctdZpQU4cc8/6m6vs3I/hN0cuDJ8hLM8fhydW/2nq6HKD3JlCcNEqYM/PbNxxVFMR9X6oHaHCVQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001594; c=relaxed/simple;
	bh=CgPZkp+FoaTTLNdrQqm1gpEMooyF5LD3otEF4J0DnbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rzrnzI/nkkoqq2/bDJ878tKCjv/vlnmi+s2zkG8aTOK5bDktCcdUG7VDG18KM5AInZF1P486Fn0k7S/aBFw0mgJd0BpG2+E5DYnGqWyhPYSt7ynLUd0x32K8BRugX+tnko8jS/unc2NQO2Ewa98GawU+GjQOvE//lg2vWorpFCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lDDsKDGQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lDDsKDGQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuk7s004100;
	Thu, 4 Sep 2025 15:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=sHiqj
	szYSkt3sF1YoZyjRARxduAMRN5LCvZo04unzF8=; b=lDDsKDGQ3K5uUJJs9n9Ks
	Bh8RobgKzEITvevOH9swD7RYb8f/cjz/bYCPE97WtZAYrsdWLBKDqQBuObeJtKvz
	7aW3CgtJoSfZAgrOoA9o/16c6UsSPwcXY8J+Ucza3YyIjKNCyugOISo2qpMJyZjB
	aiSxXOH30xGOUG2Hi+JrGXb72BX2jgFvnWN7kKncSerTuSzVvtCA+thauGHA3O0U
	NZS70nVONuUMHFRhtA3XotUeSyahl9hIc+jpiB+2Aii0F44mUZ8ttREqbmbAqfvL
	gD0SA+8y97+qgZnERWnf4sb70uVmVcSkwZnJEtnkF/3EgSxu5YbzxwaNUKCC2TWC
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun006y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FELub040036;
	Thu, 4 Sep 2025 15:59:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7A000707;
	Thu, 4 Sep 2025 15:59:39 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-72;
	Thu, 04 Sep 2025 15:59:39 +0000
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
Subject: [PATCH RFC 071/104] crypto: fips140: convert crypto/sig.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:43 +0200
Message-Id: <20250904155216.460962-72-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: GAdsR9k7rhbFtNv0ZQ2EQiMqDsZ6D1ba
X-Proofpoint-GUID: GAdsR9k7rhbFtNv0ZQ2EQiMqDsZ6D1ba
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b76d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=8Ie_MMoHnmXKMj9mU8sA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX9uVha5NQ6lu/
 bB0Sk1/VMDKozTyylVYtGwgE6p2/DaeukTH8ae57COdXBcl9TsCjGg5S3GkPoDp2wrzAFQ2E+FB
 XSRNCynfo4taDCBCfZVmvTvr3OzHj/YAmLShRFvwLecXNXh2qA5O3eRLTBScW0WQv2iZ5TPDOc0
 pqWQGZZDyamDW+1RMnsXTMPTK/eKvlkqZU0juxp1wkBX3JbwmSFULKn0okTAurlyAs0JQq0x0eD
 7LenojIGbEzKztpG5PUl/KWjYGcfCT+uSPMU/Lqqe5+BiTlvqgt0pEC6VSzrrPrJYpbRA5phJuO
 9yIzbwM3IVKkh9DCdSJ+/Ps+BUP2XafHMNteKxiY1X5HAbdnT3JtfuW1vmDvM/5r4IsAren0Uo8
 kP19wV/xuUoidkOV40ev1DTAWsF7ZQ==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SIG2 --source crypto/sig.c --header include/crypto/sig.h include/crypto/internal/sig.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c          | 18 ++++++++++++++++++
 crypto/sig.c                  | 20 ++++++++++----------
 include/crypto/internal/sig.h | 20 +++++++++++++-------
 include/crypto/sig.h          |  5 ++++-
 4 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index eec551e120e2..c4e66d008be2 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -544,3 +544,21 @@ DEFINE_CRYPTO_API_STUB(crypto_shash_import_core);
 
 #endif
 
+/*
+ * crypto/sig.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_SIG2)
+
+#include <crypto/sig.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_sig);
+
+#include <crypto/internal/sig.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_register_sig);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_sig);
+DEFINE_CRYPTO_API_STUB(sig_register_instance);
+DEFINE_CRYPTO_API_STUB(crypto_grab_sig);
+
+#endif
+
diff --git a/crypto/sig.c b/crypto/sig.c
index beba745b6405..c0217bd437f6 100644
--- a/crypto/sig.c
+++ b/crypto/sig.c
@@ -77,11 +77,11 @@ static const struct crypto_type crypto_sig_type = {
 	.algsize = offsetof(struct sig_alg, base),
 };
 
-struct crypto_sig *crypto_alloc_sig(const char *alg_name, u32 type, u32 mask)
+struct crypto_sig *CRYPTO_API(crypto_alloc_sig)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_sig_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_sig);
+DEFINE_CRYPTO_API(crypto_alloc_sig);
 
 static int sig_default_sign(struct crypto_sig *tfm,
 			    const void *src, unsigned int slen,
@@ -134,7 +134,7 @@ static int sig_prepare_alg(struct sig_alg *alg)
 	return 0;
 }
 
-int crypto_register_sig(struct sig_alg *alg)
+int CRYPTO_API(crypto_register_sig)(struct sig_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 	int err;
@@ -145,15 +145,15 @@ int crypto_register_sig(struct sig_alg *alg)
 
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_sig);
+DEFINE_CRYPTO_API(crypto_register_sig);
 
-void crypto_unregister_sig(struct sig_alg *alg)
+void CRYPTO_API(crypto_unregister_sig)(struct sig_alg *alg)
 {
 	crypto_unregister_alg(&alg->base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_sig);
+DEFINE_CRYPTO_API(crypto_unregister_sig);
 
-int sig_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(sig_register_instance)(struct crypto_template *tmpl,
 			  struct sig_instance *inst)
 {
 	int err;
@@ -167,16 +167,16 @@ int sig_register_instance(struct crypto_template *tmpl,
 
 	return crypto_register_instance(tmpl, sig_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(sig_register_instance);
+DEFINE_CRYPTO_API(sig_register_instance);
 
-int crypto_grab_sig(struct crypto_sig_spawn *spawn,
+int CRYPTO_API(crypto_grab_sig)(struct crypto_sig_spawn *spawn,
 		    struct crypto_instance *inst,
 		    const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_sig_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_sig);
+DEFINE_CRYPTO_API(crypto_grab_sig);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Public Key Signature Algorithms");
diff --git a/include/crypto/internal/sig.h b/include/crypto/internal/sig.h
index b16648c1a986..8efee2dfba72 100644
--- a/include/crypto/internal/sig.h
+++ b/include/crypto/internal/sig.h
@@ -7,6 +7,7 @@
 #ifndef _CRYPTO_INTERNAL_SIG_H
 #define _CRYPTO_INTERNAL_SIG_H
 
+#include <crypto/api.h>
 #include <crypto/algapi.h>
 #include <crypto/sig.h>
 
@@ -39,7 +40,9 @@ static inline void *crypto_sig_ctx(struct crypto_sig *tfm)
  *
  * Return: zero on success; error code in case of error
  */
-int crypto_register_sig(struct sig_alg *alg);
+DECLARE_CRYPTO_API(crypto_register_sig, int,
+	(struct sig_alg *alg),
+	(alg));
 
 /**
  * crypto_unregister_sig() -- Unregister public key signature algorithm
@@ -48,10 +51,13 @@ int crypto_register_sig(struct sig_alg *alg);
  *
  * @alg:	algorithm definition
  */
-void crypto_unregister_sig(struct sig_alg *alg);
+DECLARE_CRYPTO_API(crypto_unregister_sig, void,
+	(struct sig_alg *alg),
+	(alg));
 
-int sig_register_instance(struct crypto_template *tmpl,
-			  struct sig_instance *inst);
+DECLARE_CRYPTO_API(sig_register_instance, int,
+	(struct crypto_template *tmpl, struct sig_instance *inst),
+	(tmpl, inst));
 
 static inline struct sig_instance *sig_instance(struct crypto_instance *inst)
 {
@@ -74,9 +80,9 @@ static inline void *sig_instance_ctx(struct sig_instance *inst)
 	return crypto_instance_ctx(sig_crypto_instance(inst));
 }
 
-int crypto_grab_sig(struct crypto_sig_spawn *spawn,
-		    struct crypto_instance *inst,
-		    const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_sig, int,
+	(struct crypto_sig_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 static inline struct crypto_sig *crypto_spawn_sig(struct crypto_sig_spawn
 								   *spawn)
diff --git a/include/crypto/sig.h b/include/crypto/sig.h
index fa6dafafab3f..d6da8df9fd28 100644
--- a/include/crypto/sig.h
+++ b/include/crypto/sig.h
@@ -7,6 +7,7 @@
 #ifndef _CRYPTO_SIG_H
 #define _CRYPTO_SIG_H
 
+#include <crypto/api.h>
 #include <linux/crypto.h>
 
 /**
@@ -91,7 +92,9 @@ struct sig_alg {
  * Return: allocated handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_sig *crypto_alloc_sig(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_sig, struct crypto_sig *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline struct crypto_tfm *crypto_sig_tfm(struct crypto_sig *tfm)
 {
-- 
2.39.3

