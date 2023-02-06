Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98619C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 05:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBFFI4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Feb 2023 00:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBFFIz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2023 00:08:55 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C515166D7
        for <linux-crypto@vger.kernel.org>; Sun,  5 Feb 2023 21:08:53 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOtkG-007tZR-5C; Mon, 06 Feb 2023 13:08:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 13:08:48 +0800
Date:   Mon, 6 Feb 2023 13:08:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Haren Myneni <haren@us.ibm.com>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Subject: [PATCH] crypto: nx - Fix sparse warnings
Message-ID: <Y+CLYNHmCDFKb+gD@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This driver generates a large number of sparse warnings due to
two issues.

First of all the structure nx842_devdata is defined inline causing
the __rcu tag to be added to all users of it.  This easily fixed by
splitting up the struct definition.

The second issue is with kdoc markers being incomplete.  The trivial
case of nx842_exec_vas has been fixed, while the other incomplete
documentation has simply been downgraded to normal C comments.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 4547d8401a22..62bb048baa25 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -73,7 +73,7 @@ static int (*nx842_powernv_exec)(const unsigned char *in,
 				unsigned int inlen, unsigned char *out,
 				unsigned int *outlenp, void *workmem, int fc);
 
-/**
+/*
  * setup_indirect_dde - Setup an indirect DDE
  *
  * The DDE is setup with the DDE count, byte count, and address of
@@ -90,7 +90,7 @@ static void setup_indirect_dde(struct data_descriptor_entry *dde,
 	dde->address = cpu_to_be64(nx842_get_pa(ddl));
 }
 
-/**
+/*
  * setup_direct_dde - Setup single DDE from buffer
  *
  * The DDE is setup with the buffer and length.  The buffer must be properly
@@ -112,7 +112,7 @@ static unsigned int setup_direct_dde(struct data_descriptor_entry *dde,
 	return l;
 }
 
-/**
+/*
  * setup_ddl - Setup DDL from buffer
  *
  * Returns:
@@ -182,9 +182,6 @@ static int setup_ddl(struct data_descriptor_entry *dde,
 	CSB_ERR(csb, msg " at %lx", ##__VA_ARGS__,		\
 		(unsigned long)be64_to_cpu((csb)->address))
 
-/**
- * wait_for_csb
- */
 static int wait_for_csb(struct nx842_workmem *wmem,
 			struct coprocessor_status_block *csb)
 {
@@ -633,8 +630,8 @@ static int nx842_exec_vas(const unsigned char *in, unsigned int inlen,
  * @inlen: input buffer size
  * @out: output buffer pointer
  * @outlenp: output buffer size pointer
- * @workmem: working memory buffer pointer, size determined by
- *           nx842_powernv_driver.workmem_size
+ * @wmem: working memory buffer pointer, size determined by
+ *        nx842_powernv_driver.workmem_size
  *
  * Returns: see @nx842_powernv_exec()
  */
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 3ea334b7f820..35f2d0d8507e 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -123,14 +123,16 @@ struct ibm_nx842_counters {
 	atomic64_t decomp_times[32];
 };
 
-static struct nx842_devdata {
+struct nx842_devdata {
 	struct vio_dev *vdev;
 	struct device *dev;
 	struct ibm_nx842_counters *counters;
 	unsigned int max_sg_len;
 	unsigned int max_sync_size;
 	unsigned int max_sync_sg;
-} __rcu *devdata;
+};
+
+static struct nx842_devdata __rcu *devdata;
 static DEFINE_SPINLOCK(devdata_mutex);
 
 #define NX842_COUNTER_INC(_x) \
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
