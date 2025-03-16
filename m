Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D4B44C63
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088070; cv=none; b=FVgjaKcExrcooGyt4ZMprzkAdToCDpQJScPXpT/J1omHVbhMDY5o7gQoOunKC8+awFOTP15CprOO9z9dVMcOt1P3o1qnkjU0K5kdHn53dBuN2KClyepoNnrth0zQHYySMug2Gt46NqKesPVE9z/GvJNu940aCm9A0I39EGTZK7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088070; c=relaxed/simple;
	bh=ddNRWsdGGqBDeuiFDYPzCbdGPbtTdZDTUPPrDaT9PmM=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=XPR0uQyKEHH+SDcDQ6I0KskLPedXqvSmQXocntUs9b+bspnqfmJiiavjG32ZfXrD7NdL/rZwA5SXhUpwyeGahW/0ZepWnDJiIZqHzQN6P/AfmJZacuRviX5v5PH6fVxVkgHEqt9aLEQzobj71Nj/72of1708arrG241G66wSeWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DLBBVVKh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DLBBVVKh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Q4pO4RxoHfagEQq+YhSipkYuL1KZTbuucOXbGN2cM28=; b=DLBBVVKhL8qocctiisJxmDGg42
	QQFumf+713RRV6N2TLMj/ZlFe9uxtYAJg/IJO00SOHPKSI1YznNAY84J+8zEdxKAz+SOGOXLyRlfx
	KVruOz6PgC0/iA5WoXHBNf+nE/pUbDcEGwD3Ek8i4/IU5JMlnvpgQ3fnvyPMIsdiCN7ZHz2QxDGlh
	egGTCdgk7M9hnU+9Kv6SJuGqtkGYk8E039bfs6f/goXH3jrLoVmebrsitE8kgpzgd+z4U1H+/IzxX
	KMXWvR9w2FoBlGyzW8m+PIkE+XNj38jycttKkNeNGJWVDlgkKiiZqLpkG+Y6QCQqfgi5sjUOgSok5
	UnVrVLag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcga-006xYA-06;
	Sun, 16 Mar 2025 09:21:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:04 +0800
Date: Sun, 16 Mar 2025 09:21:04 +0800
Message-Id: <4c5dd170be8ca11935b7ed206464ab809b8e8ea8.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 01/11] crypto: nx - Migrate to scomp API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Ard Biesheuvel <ardb@kernel.org>

The only remaining user of 842 compression has been migrated to the
acomp compression API, and so the NX hardware driver has to follow suit,
given that no users of the obsolete 'comp' API remain, and it is going
to be removed.

So migrate the NX driver code to scomp. These will be wrapped and
exposed as acomp implementation via the crypto subsystem's
acomp-to-scomp adaptation layer.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/nx-842.c            | 33 +++++++++++++++------------
 drivers/crypto/nx/nx-842.h            | 15 ++++++------
 drivers/crypto/nx/nx-common-powernv.c | 31 ++++++++++++-------------
 drivers/crypto/nx/nx-common-pseries.c | 33 +++++++++++++--------------
 4 files changed, 58 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 82214cde2bcd..b950fcce8a9b 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -101,9 +101,13 @@ static int update_param(struct nx842_crypto_param *p,
 	return 0;
 }
 
-int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
+void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 {
-	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct nx842_crypto_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&ctx->lock);
 	ctx->driver = driver;
@@ -114,22 +118,23 @@ int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
 		kfree(ctx->wmem);
 		free_page((unsigned long)ctx->sbounce);
 		free_page((unsigned long)ctx->dbounce);
-		return -ENOMEM;
+		kfree(ctx);
+		return ERR_PTR(-ENOMEM);
 	}
 
-	return 0;
+	return ctx;
 }
-EXPORT_SYMBOL_GPL(nx842_crypto_init);
+EXPORT_SYMBOL_GPL(nx842_crypto_alloc_ctx);
 
-void nx842_crypto_exit(struct crypto_tfm *tfm)
+void nx842_crypto_free_ctx(void *p)
 {
-	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct nx842_crypto_ctx *ctx = p;
 
 	kfree(ctx->wmem);
 	free_page((unsigned long)ctx->sbounce);
 	free_page((unsigned long)ctx->dbounce);
 }
-EXPORT_SYMBOL_GPL(nx842_crypto_exit);
+EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 
 static void check_constraints(struct nx842_constraints *c)
 {
@@ -246,11 +251,11 @@ static int compress(struct nx842_crypto_ctx *ctx,
 	return update_param(p, slen, dskip + dlen);
 }
 
-int nx842_crypto_compress(struct crypto_tfm *tfm,
+int nx842_crypto_compress(struct crypto_scomp *tfm,
 			  const u8 *src, unsigned int slen,
-			  u8 *dst, unsigned int *dlen)
+			  u8 *dst, unsigned int *dlen, void *pctx)
 {
-	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct nx842_crypto_ctx *ctx = pctx;
 	struct nx842_crypto_header *hdr =
 				container_of(&ctx->header,
 					     struct nx842_crypto_header, hdr);
@@ -431,11 +436,11 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 	return update_param(p, slen + padding, dlen);
 }
 
-int nx842_crypto_decompress(struct crypto_tfm *tfm,
+int nx842_crypto_decompress(struct crypto_scomp *tfm,
 			    const u8 *src, unsigned int slen,
-			    u8 *dst, unsigned int *dlen)
+			    u8 *dst, unsigned int *dlen, void *pctx)
 {
-	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct nx842_crypto_ctx *ctx = pctx;
 	struct nx842_crypto_header *hdr;
 	struct nx842_crypto_param p;
 	struct nx842_constraints c = *ctx->driver->constraints;
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 887d4ce3cb49..f5e2c82ba876 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -3,7 +3,6 @@
 #ifndef __NX_842_H__
 #define __NX_842_H__
 
-#include <crypto/algapi.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -101,6 +100,8 @@
 #define LEN_ON_SIZE(pa, size)	((size) - ((pa) & ((size) - 1)))
 #define LEN_ON_PAGE(pa)		LEN_ON_SIZE(pa, PAGE_SIZE)
 
+struct crypto_scomp;
+
 static inline unsigned long nx842_get_pa(void *addr)
 {
 	if (!is_vmalloc_addr(addr))
@@ -182,13 +183,13 @@ struct nx842_crypto_ctx {
 	struct nx842_driver *driver;
 };
 
-int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver);
-void nx842_crypto_exit(struct crypto_tfm *tfm);
-int nx842_crypto_compress(struct crypto_tfm *tfm,
+void *nx842_crypto_alloc_ctx(struct nx842_driver *driver);
+void nx842_crypto_free_ctx(void *ctx);
+int nx842_crypto_compress(struct crypto_scomp *tfm,
 			  const u8 *src, unsigned int slen,
-			  u8 *dst, unsigned int *dlen);
-int nx842_crypto_decompress(struct crypto_tfm *tfm,
+			  u8 *dst, unsigned int *dlen, void *ctx);
+int nx842_crypto_decompress(struct crypto_scomp *tfm,
 			    const u8 *src, unsigned int slen,
-			    u8 *dst, unsigned int *dlen);
+			    u8 *dst, unsigned int *dlen, void *ctx);
 
 #endif /* __NX_842_H__ */
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 8c859872c183..fd0a98b2fb1b 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -9,6 +9,7 @@
 
 #include "nx-842.h"
 
+#include <crypto/internal/scompress.h>
 #include <linux/timer.h>
 
 #include <asm/prom.h>
@@ -1031,23 +1032,21 @@ static struct nx842_driver nx842_powernv_driver = {
 	.decompress =	nx842_powernv_decompress,
 };
 
-static int nx842_powernv_crypto_init(struct crypto_tfm *tfm)
+static void *nx842_powernv_crypto_alloc_ctx(void)
 {
-	return nx842_crypto_init(tfm, &nx842_powernv_driver);
+	return nx842_crypto_alloc_ctx(&nx842_powernv_driver);
 }
 
-static struct crypto_alg nx842_powernv_alg = {
-	.cra_name		= "842",
-	.cra_driver_name	= "842-nx",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= nx842_powernv_crypto_init,
-	.cra_exit		= nx842_crypto_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= nx842_crypto_compress,
-	.coa_decompress		= nx842_crypto_decompress } }
+static struct scomp_alg nx842_powernv_alg = {
+	.base.cra_name		= "842",
+	.base.cra_driver_name	= "842-nx",
+	.base.cra_priority	= 300,
+	.base.cra_module	= THIS_MODULE,
+
+	.alloc_ctx		= nx842_powernv_crypto_alloc_ctx,
+	.free_ctx		= nx842_crypto_free_ctx,
+	.compress		= nx842_crypto_compress,
+	.decompress		= nx842_crypto_decompress,
 };
 
 static __init int nx_compress_powernv_init(void)
@@ -1107,7 +1106,7 @@ static __init int nx_compress_powernv_init(void)
 		nx842_powernv_exec = nx842_exec_vas;
 	}
 
-	ret = crypto_register_alg(&nx842_powernv_alg);
+	ret = crypto_register_scomp(&nx842_powernv_alg);
 	if (ret) {
 		nx_delete_coprocs();
 		return ret;
@@ -1128,7 +1127,7 @@ static void __exit nx_compress_powernv_exit(void)
 	if (!nx842_ct)
 		vas_unregister_api_powernv();
 
-	crypto_unregister_alg(&nx842_powernv_alg);
+	crypto_unregister_scomp(&nx842_powernv_alg);
 
 	nx_delete_coprocs();
 }
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 1660c5cf3641..080858d598f8 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -11,6 +11,7 @@
 #include <asm/vio.h>
 #include <asm/hvcall.h>
 #include <asm/vas.h>
+#include <crypto/internal/scompress.h>
 
 #include "nx-842.h"
 #include "nx_csbcpb.h" /* struct nx_csbcpb */
@@ -1008,23 +1009,21 @@ static struct nx842_driver nx842_pseries_driver = {
 	.decompress =	nx842_pseries_decompress,
 };
 
-static int nx842_pseries_crypto_init(struct crypto_tfm *tfm)
+static void *nx842_pseries_crypto_alloc_ctx(void)
 {
-	return nx842_crypto_init(tfm, &nx842_pseries_driver);
+	return nx842_crypto_alloc_ctx(&nx842_pseries_driver);
 }
 
-static struct crypto_alg nx842_pseries_alg = {
-	.cra_name		= "842",
-	.cra_driver_name	= "842-nx",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= nx842_pseries_crypto_init,
-	.cra_exit		= nx842_crypto_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= nx842_crypto_compress,
-	.coa_decompress		= nx842_crypto_decompress } }
+static struct scomp_alg nx842_pseries_alg = {
+	.base.cra_name		= "842",
+	.base.cra_driver_name	= "842-nx",
+	.base.cra_priority	= 300,
+	.base.cra_module	= THIS_MODULE,
+
+	.alloc_ctx		= nx842_pseries_crypto_alloc_ctx,
+	.free_ctx		= nx842_crypto_free_ctx,
+	.compress		= nx842_crypto_compress,
+	.decompress		= nx842_crypto_decompress,
 };
 
 static int nx842_probe(struct vio_dev *viodev,
@@ -1072,7 +1071,7 @@ static int nx842_probe(struct vio_dev *viodev,
 	if (ret)
 		goto error;
 
-	ret = crypto_register_alg(&nx842_pseries_alg);
+	ret = crypto_register_scomp(&nx842_pseries_alg);
 	if (ret) {
 		dev_err(&viodev->dev, "could not register comp alg: %d\n", ret);
 		goto error;
@@ -1120,7 +1119,7 @@ static void nx842_remove(struct vio_dev *viodev)
 	if (caps_feat)
 		sysfs_remove_group(&viodev->dev.kobj, &nxcop_caps_attr_group);
 
-	crypto_unregister_alg(&nx842_pseries_alg);
+	crypto_unregister_scomp(&nx842_pseries_alg);
 
 	of_reconfig_notifier_unregister(&nx842_of_nb);
 
@@ -1256,7 +1255,7 @@ static void __exit nx842_pseries_exit(void)
 
 	vas_unregister_api_pseries();
 
-	crypto_unregister_alg(&nx842_pseries_alg);
+	crypto_unregister_scomp(&nx842_pseries_alg);
 
 	spin_lock_irqsave(&devdata_spinlock, flags);
 	old_devdata = rcu_dereference_check(devdata,
-- 
2.39.5

