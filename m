Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBE3C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00A2220644
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BraVS9Pg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgFPPCj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 11:02:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30545 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729259AbgFPPCi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 11:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592319748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4a6Zh5VtOahCHiEkI6UTM2GXJZKDClKI/D5nRirBojI=;
        b=BraVS9PgXB2s9zXhzxad+JRZjC29yrOSgHPEHDTH39TSsxXxXiDASHHnwLmDA5GaEhhop/
        1Gi2ob7P/WTPd+5C3molbMqFD5MvMsImvEyStfhr7MUEDJJsqf2gXRzXzPN73Vwf/dQLay
        vUcAsteOyCw04Rw6YPrODnyGWOjJHOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-n9bJvbb2MEqM5c7V3tly9g-1; Tue, 16 Jun 2020 11:02:25 -0400
X-MC-Unique: n9bJvbb2MEqM5c7V3tly9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D752718A266D;
        Tue, 16 Jun 2020 15:02:23 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B7CCD7CAB7;
        Tue, 16 Jun 2020 15:02:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05GF2KAP028930;
        Tue, 16 Jun 2020 11:02:20 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05GF2Kud028926;
        Tue, 16 Jun 2020 11:02:20 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 16 Jun 2020 11:02:20 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2006161102020.28052@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
allocate memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c |    8 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c |    8 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c         |    4 -
 drivers/crypto/axis/artpec6_crypto.c              |   20 +++--
 drivers/crypto/bcm/cipher.c                       |   38 +++++-----
 drivers/crypto/caam/caamalg.c                     |    4 -
 drivers/crypto/caam/caamalg_qi.c                  |    4 -
 drivers/crypto/caam/caamalg_qi2.c                 |    6 -
 drivers/crypto/caam/caamhash.c                    |    2 
 drivers/crypto/cavium/cpt/cptvf_algs.c            |   12 +--
 drivers/crypto/cavium/nitrox/nitrox_aead.c        |    4 -
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c    |   16 ++--
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c          |    1 
 drivers/crypto/ccp/ccp-crypto-aes-galois.c        |    1 
 drivers/crypto/ccp/ccp-crypto-aes-xts.c           |    1 
 drivers/crypto/ccp/ccp-crypto-aes.c               |    2 
 drivers/crypto/ccp/ccp-crypto-des3.c              |    1 
 drivers/crypto/ccp/ccp-crypto-sha.c               |    1 
 drivers/crypto/chelsio/chcr_algo.c                |    6 -
 drivers/crypto/hisilicon/sec/sec_algs.c           |   16 ++--
 drivers/crypto/hisilicon/sec2/sec_crypto.c        |    4 -
 drivers/crypto/inside-secure/safexcel_cipher.c    |   47 +++++++++++++
 drivers/crypto/inside-secure/safexcel_hash.c      |   18 +++++
 drivers/crypto/ixp4xx_crypto.c                    |    6 +
 drivers/crypto/marvell/cesa/cipher.c              |   12 +--
 drivers/crypto/marvell/cesa/hash.c                |    6 +
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c  |   30 ++++----
 drivers/crypto/n2_core.c                          |    2 
 drivers/crypto/picoxcell_crypto.c                 |   17 ++++
 drivers/crypto/qat/qat_common/qat_algs.c          |   12 +--
 drivers/crypto/qce/sha.c                          |    2 
 drivers/crypto/qce/skcipher.c                     |    1 
 drivers/crypto/talitos.c                          |   78 +++++++++++-----------
 drivers/crypto/virtio/virtio_crypto_algs.c        |    2 
 drivers/crypto/xilinx/zynqmp-aes-gcm.c            |    1 
 35 files changed, 248 insertions(+), 145 deletions(-)

Index: linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_algs.c
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1267,7 +1267,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1284,7 +1284,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1301,7 +1301,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1319,7 +1319,7 @@ static struct skcipher_alg qat_skciphers
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "qat_aes_cbc",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1337,7 +1337,7 @@ static struct skcipher_alg qat_skciphers
 	.base.cra_name = "ctr(aes)",
 	.base.cra_driver_name = "qat_aes_ctr",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1355,7 +1355,7 @@ static struct skcipher_alg qat_skciphers
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "qat_aes_xts",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
Index: linux-2.6/drivers/crypto/ixp4xx_crypto.c
===================================================================
--- linux-2.6.orig/drivers/crypto/ixp4xx_crypto.c
+++ linux-2.6/drivers/crypto/ixp4xx_crypto.c
@@ -1402,7 +1402,8 @@ static int __init ixp_module_init(void)
 
 		/* block ciphers */
 		cra->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-				      CRYPTO_ALG_ASYNC;
+				      CRYPTO_ALG_ASYNC |
+				      CRYPTO_ALG_ALLOCATES_MEMORY;
 		if (!cra->setkey)
 			cra->setkey = ablk_setkey;
 		if (!cra->encrypt)
@@ -1435,7 +1436,8 @@ static int __init ixp_module_init(void)
 
 		/* authenc */
 		cra->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-				      CRYPTO_ALG_ASYNC;
+				      CRYPTO_ALG_ASYNC |
+				      CRYPTO_ALG_ALLOCATES_MEMORY;
 		cra->setkey = cra->setkey ?: aead_setkey;
 		cra->setauthsize = aead_setauthsize;
 		cra->encrypt = aead_encrypt;
Index: linux-2.6/drivers/crypto/picoxcell_crypto.c
===================================================================
--- linux-2.6.orig/drivers/crypto/picoxcell_crypto.c
+++ linux-2.6/drivers/crypto/picoxcell_crypto.c
@@ -1226,6 +1226,7 @@ static struct spacc_alg ipsec_engine_alg
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1251,6 +1252,7 @@ static struct spacc_alg ipsec_engine_alg
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1274,7 +1276,8 @@ static struct spacc_alg ipsec_engine_alg
 			.base.cra_driver_name	= "cbc-des-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC,
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
 			.base.cra_module	= THIS_MODULE,
@@ -1298,7 +1301,8 @@ static struct spacc_alg ipsec_engine_alg
 			.base.cra_driver_name	= "ecb-des-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC,
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
 			.base.cra_module	= THIS_MODULE,
@@ -1321,6 +1325,7 @@ static struct spacc_alg ipsec_engine_alg
 			.base.cra_driver_name	= "cbc-des3-ede-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1345,6 +1350,7 @@ static struct spacc_alg ipsec_engine_alg
 			.base.cra_driver_name	= "ecb-des3-ede-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1376,6 +1382,7 @@ static struct spacc_aead ipsec_engine_ae
 						   "cbc-aes-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -1406,6 +1413,7 @@ static struct spacc_aead ipsec_engine_ae
 						   "cbc-aes-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -1436,6 +1444,7 @@ static struct spacc_aead ipsec_engine_ae
 						   "cbc-aes-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -1466,6 +1475,7 @@ static struct spacc_aead ipsec_engine_ae
 						   "cbc-3des-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1497,6 +1507,7 @@ static struct spacc_aead ipsec_engine_ae
 						   "cbc-3des-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1527,6 +1538,7 @@ static struct spacc_aead ipsec_engine_ae
 						   "cbc-3des-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1556,6 +1568,7 @@ static struct spacc_alg l2_engine_algs[]
 			.base.cra_driver_name	= "f8-kasumi-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.base.cra_blocksize	= 8,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
Index: linux-2.6/drivers/crypto/n2_core.c
===================================================================
--- linux-2.6.orig/drivers/crypto/n2_core.c
+++ linux-2.6/drivers/crypto/n2_core.c
@@ -1385,7 +1385,7 @@ static int __n2_register_one_skcipher(co
 	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-n2", tmpl->drv_name);
 	alg->base.cra_priority = N2_CRA_PRIORITY;
-	alg->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC;
+	alg->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 	alg->base.cra_blocksize = tmpl->block_size;
 	p->enc_type = tmpl->enc_type;
 	alg->base.cra_ctxsize = sizeof(struct n2_skcipher_context);
Index: linux-2.6/drivers/crypto/talitos.c
===================================================================
--- linux-2.6.orig/drivers/crypto/talitos.c
+++ linux-2.6/drivers/crypto/talitos.c
@@ -2264,7 +2264,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2285,7 +2285,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2306,7 +2306,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2330,7 +2330,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2352,7 +2352,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2373,7 +2373,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2394,7 +2394,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2418,7 +2418,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2440,7 +2440,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2461,7 +2461,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2482,7 +2482,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2506,7 +2506,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2528,7 +2528,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha384-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -2549,7 +2549,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha384-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -2571,7 +2571,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha512-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -2592,7 +2592,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-sha512-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -2614,7 +2614,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2635,7 +2635,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2655,7 +2655,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2678,7 +2678,7 @@ static struct talitos_alg_template drive
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2699,7 +2699,7 @@ static struct talitos_alg_template drive
 			.base.cra_name = "ecb(aes)",
 			.base.cra_driver_name = "ecb-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.setkey = skcipher_aes_setkey,
@@ -2712,7 +2712,7 @@ static struct talitos_alg_template drive
 			.base.cra_name = "cbc(aes)",
 			.base.cra_driver_name = "cbc-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -2727,7 +2727,7 @@ static struct talitos_alg_template drive
 			.base.cra_name = "ctr(aes)",
 			.base.cra_driver_name = "ctr-aes-talitos",
 			.base.cra_blocksize = 1,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -2742,7 +2742,7 @@ static struct talitos_alg_template drive
 			.base.cra_name = "ecb(des)",
 			.base.cra_driver_name = "ecb-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.setkey = skcipher_des_setkey,
@@ -2755,7 +2755,7 @@ static struct talitos_alg_template drive
 			.base.cra_name = "cbc(des)",
 			.base.cra_driver_name = "cbc-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
@@ -2770,7 +2770,7 @@ static struct talitos_alg_template drive
 			.base.cra_name = "ecb(des3_ede)",
 			.base.cra_driver_name = "ecb-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.setkey = skcipher_des3_setkey,
@@ -2784,7 +2784,7 @@ static struct talitos_alg_template drive
 			.base.cra_name = "cbc(des3_ede)",
 			.base.cra_driver_name = "cbc-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2804,7 +2804,7 @@ static struct talitos_alg_template drive
 				.cra_name = "md5",
 				.cra_driver_name = "md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2819,7 +2819,7 @@ static struct talitos_alg_template drive
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2834,7 +2834,7 @@ static struct talitos_alg_template drive
 				.cra_name = "sha224",
 				.cra_driver_name = "sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2849,7 +2849,7 @@ static struct talitos_alg_template drive
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2864,7 +2864,7 @@ static struct talitos_alg_template drive
 				.cra_name = "sha384",
 				.cra_driver_name = "sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2879,7 +2879,7 @@ static struct talitos_alg_template drive
 				.cra_name = "sha512",
 				.cra_driver_name = "sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2894,7 +2894,7 @@ static struct talitos_alg_template drive
 				.cra_name = "hmac(md5)",
 				.cra_driver_name = "hmac-md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2909,7 +2909,7 @@ static struct talitos_alg_template drive
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "hmac-sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2924,7 +2924,7 @@ static struct talitos_alg_template drive
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "hmac-sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2939,7 +2939,7 @@ static struct talitos_alg_template drive
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "hmac-sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2954,7 +2954,7 @@ static struct talitos_alg_template drive
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "hmac-sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2969,7 +2969,7 @@ static struct talitos_alg_template drive
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "hmac-sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
Index: linux-2.6/drivers/crypto/virtio/virtio_crypto_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/virtio/virtio_crypto_algs.c
+++ linux-2.6/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -590,7 +590,7 @@ static struct virtio_crypto_algo virtio_
 		.base.cra_name		= "cbc(aes)",
 		.base.cra_driver_name	= "virtio_crypto_aes_cbc",
 		.base.cra_priority	= 150,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
 		.base.cra_module	= THIS_MODULE,
Index: linux-2.6/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ linux-2.6/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -1303,7 +1303,7 @@ static int otx_cpt_aead_null_decrypt(str
 static struct skcipher_alg otx_cpt_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "cpt_xts_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1320,7 +1320,7 @@ static struct skcipher_alg otx_cpt_skcip
 }, {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "cpt_cbc_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1337,7 +1337,7 @@ static struct skcipher_alg otx_cpt_skcip
 }, {
 	.base.cra_name = "ecb(aes)",
 	.base.cra_driver_name = "cpt_ecb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1354,7 +1354,7 @@ static struct skcipher_alg otx_cpt_skcip
 }, {
 	.base.cra_name = "cfb(aes)",
 	.base.cra_driver_name = "cpt_cfb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1371,7 +1371,7 @@ static struct skcipher_alg otx_cpt_skcip
 }, {
 	.base.cra_name = "cbc(des3_ede)",
 	.base.cra_driver_name = "cpt_cbc_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_des3_ctx),
 	.base.cra_alignmask = 7,
@@ -1388,7 +1388,7 @@ static struct skcipher_alg otx_cpt_skcip
 }, {
 	.base.cra_name = "ecb(des3_ede)",
 	.base.cra_driver_name = "cpt_ecb_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_des3_ctx),
 	.base.cra_alignmask = 7,
@@ -1409,7 +1409,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha1_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1428,7 +1428,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha256_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1447,7 +1447,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha384),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha384_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1466,7 +1466,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha512_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1485,7 +1485,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha1),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha1_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1504,7 +1504,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha256),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha256_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1523,7 +1523,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha384),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha384_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1542,7 +1542,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "authenc(hmac(sha512),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha512_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1561,7 +1561,7 @@ static struct aead_alg otx_cpt_aeads[] =
 		.cra_name = "rfc4106(gcm(aes))",
 		.cra_driver_name = "cpt_rfc4106_gcm_aes",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
Index: linux-2.6/drivers/crypto/qce/sha.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qce/sha.c
+++ linux-2.6/drivers/crypto/qce/sha.c
@@ -493,7 +493,7 @@ static int qce_ahash_register_one(const
 	base = &alg->halg.base;
 	base->cra_blocksize = def->blocksize;
 	base->cra_priority = 300;
-	base->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	base->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
 	base->cra_alignmask = 0;
 	base->cra_module = THIS_MODULE;
Index: linux-2.6/drivers/crypto/qce/skcipher.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qce/skcipher.c
+++ linux-2.6/drivers/crypto/qce/skcipher.c
@@ -404,6 +404,7 @@ static int qce_skcipher_register_one(con
 
 	alg->base.cra_priority		= 300;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->base.cra_ctxsize		= sizeof(struct qce_cipher_ctx);
 	alg->base.cra_alignmask		= 0;
Index: linux-2.6/drivers/crypto/marvell/cesa/cipher.c
===================================================================
--- linux-2.6.orig/drivers/crypto/marvell/cesa/cipher.c
+++ linux-2.6/drivers/crypto/marvell/cesa/cipher.c
@@ -508,7 +508,7 @@ struct skcipher_alg mv_cesa_ecb_des_alg
 		.cra_name = "ecb(des)",
 		.cra_driver_name = "mv-ecb-des",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
 		.cra_alignmask = 0,
@@ -558,7 +558,7 @@ struct skcipher_alg mv_cesa_cbc_des_alg
 		.cra_name = "cbc(des)",
 		.cra_driver_name = "mv-cbc-des",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
 		.cra_alignmask = 0,
@@ -616,7 +616,7 @@ struct skcipher_alg mv_cesa_ecb_des3_ede
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "mv-ecb-des3-ede",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
 		.cra_alignmask = 0,
@@ -669,7 +669,7 @@ struct skcipher_alg mv_cesa_cbc_des3_ede
 		.cra_name = "cbc(des3_ede)",
 		.cra_driver_name = "mv-cbc-des3-ede",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
 		.cra_alignmask = 0,
@@ -741,7 +741,7 @@ struct skcipher_alg mv_cesa_ecb_aes_alg
 		.cra_name = "ecb(aes)",
 		.cra_driver_name = "mv-ecb-aes",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
 		.cra_alignmask = 0,
@@ -790,7 +790,7 @@ struct skcipher_alg mv_cesa_cbc_aes_alg
 		.cra_name = "cbc(aes)",
 		.cra_driver_name = "mv-cbc-aes",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
 		.cra_alignmask = 0,
Index: linux-2.6/drivers/crypto/marvell/cesa/hash.c
===================================================================
--- linux-2.6.orig/drivers/crypto/marvell/cesa/hash.c
+++ linux-2.6/drivers/crypto/marvell/cesa/hash.c
@@ -921,6 +921,7 @@ struct ahash_alg mv_md5_alg = {
 			.cra_driver_name = "mv-md5",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
@@ -991,6 +992,7 @@ struct ahash_alg mv_sha1_alg = {
 			.cra_driver_name = "mv-sha1",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
@@ -1064,6 +1066,7 @@ struct ahash_alg mv_sha256_alg = {
 			.cra_driver_name = "mv-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
@@ -1298,6 +1301,7 @@ struct ahash_alg mv_ahmac_md5_alg = {
 			.cra_driver_name = "mv-hmac-md5",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
@@ -1368,6 +1372,7 @@ struct ahash_alg mv_ahmac_sha1_alg = {
 			.cra_driver_name = "mv-hmac-sha1",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
@@ -1438,6 +1443,7 @@ struct ahash_alg mv_ahmac_sha256_alg = {
 			.cra_driver_name = "mv-hmac-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
Index: linux-2.6/drivers/crypto/cavium/nitrox/nitrox_aead.c
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ linux-2.6/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -522,7 +522,7 @@ static struct aead_alg nitrox_aeads[] =
 		.cra_name = "gcm(aes)",
 		.cra_driver_name = "n5_aes_gcm",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -541,7 +541,7 @@ static struct aead_alg nitrox_aeads[] =
 		.cra_name = "rfc4106(gcm(aes))",
 		.cra_driver_name = "n5_rfc4106",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
Index: linux-2.6/drivers/crypto/chelsio/chcr_algo.c
===================================================================
--- linux-2.6.orig/drivers/crypto/chelsio/chcr_algo.c
+++ linux-2.6/drivers/crypto/chelsio/chcr_algo.c
@@ -4364,7 +4364,7 @@ static int chcr_register_alg(void)
 				CHCR_CRA_PRIORITY;
 			driver_algs[i].alg.skcipher.base.cra_module = THIS_MODULE;
 			driver_algs[i].alg.skcipher.base.cra_flags =
-				CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_NEED_FALLBACK;
 			driver_algs[i].alg.skcipher.base.cra_ctxsize =
 				sizeof(struct chcr_context) +
@@ -4376,7 +4376,7 @@ static int chcr_register_alg(void)
 			break;
 		case CRYPTO_ALG_TYPE_AEAD:
 			driver_algs[i].alg.aead.base.cra_flags =
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ALLOCATES_MEMORY;
 			driver_algs[i].alg.aead.encrypt = chcr_aead_encrypt;
 			driver_algs[i].alg.aead.decrypt = chcr_aead_decrypt;
 			driver_algs[i].alg.aead.init = chcr_aead_cra_init;
@@ -4396,7 +4396,7 @@ static int chcr_register_alg(void)
 			a_hash->halg.statesize = SZ_AHASH_REQ_CTX;
 			a_hash->halg.base.cra_priority = CHCR_CRA_PRIORITY;
 			a_hash->halg.base.cra_module = THIS_MODULE;
-			a_hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+			a_hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 			a_hash->halg.base.cra_alignmask = 0;
 			a_hash->halg.base.cra_exit = NULL;
 
Index: linux-2.6/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ linux-2.6/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -388,7 +388,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "cbc(aes)",
 		.cra_driver_name = "n5_cbc(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -407,7 +407,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "ecb(aes)",
 		.cra_driver_name = "n5_ecb(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -426,7 +426,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "cfb(aes)",
 		.cra_driver_name = "n5_cfb(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -445,7 +445,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "xts(aes)",
 		.cra_driver_name = "n5_xts(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -464,7 +464,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "rfc3686(ctr(aes))",
 		.cra_driver_name = "n5_rfc3686(ctr(aes))",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -483,7 +483,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "cts(cbc(aes))",
 		.cra_driver_name = "n5_cts(cbc(aes))",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -502,7 +502,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "cbc(des3_ede)",
 		.cra_driver_name = "n5_cbc(des3_ede)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -521,7 +521,7 @@ static struct skcipher_alg nitrox_skciph
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "n5_ecb(des3_ede)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
Index: linux-2.6/drivers/crypto/axis/artpec6_crypto.c
===================================================================
--- linux-2.6.orig/drivers/crypto/axis/artpec6_crypto.c
+++ linux-2.6/drivers/crypto/axis/artpec6_crypto.c
@@ -2634,7 +2634,8 @@ static struct ahash_alg hash_algos[] = {
 			.cra_name = "sha1",
 			.cra_driver_name = "artpec-sha1",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
 			.cra_alignmask = 3,
@@ -2657,7 +2658,8 @@ static struct ahash_alg hash_algos[] = {
 			.cra_name = "sha256",
 			.cra_driver_name = "artpec-sha256",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
 			.cra_alignmask = 3,
@@ -2681,7 +2683,8 @@ static struct ahash_alg hash_algos[] = {
 			.cra_name = "hmac(sha256)",
 			.cra_driver_name = "artpec-hmac-sha256",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
 			.cra_alignmask = 3,
@@ -2700,7 +2703,8 @@ static struct skcipher_alg crypto_algos[
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "artpec6-ecb-aes",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
 			.cra_alignmask = 3,
@@ -2721,6 +2725,7 @@ static struct skcipher_alg crypto_algos[
 			.cra_driver_name = "artpec6-ctr-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
@@ -2742,7 +2747,8 @@ static struct skcipher_alg crypto_algos[
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "artpec6-cbc-aes",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
 			.cra_alignmask = 3,
@@ -2763,7 +2769,8 @@ static struct skcipher_alg crypto_algos[
 			.cra_name = "xts(aes)",
 			.cra_driver_name = "artpec6-xts-aes",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
 			.cra_alignmask = 3,
@@ -2794,6 +2801,7 @@ static struct aead_alg aead_algos[] = {
 			.cra_driver_name = "artpec-gcm-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
Index: linux-2.6/drivers/crypto/cavium/cpt/cptvf_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ linux-2.6/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -339,7 +339,7 @@ static int cvm_enc_dec_init(struct crypt
 }
 
 static struct skcipher_alg algs[] = { {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -356,7 +356,7 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -373,7 +373,7 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -389,7 +389,7 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -406,7 +406,7 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
 	.base.cra_alignmask	= 7,
@@ -423,7 +423,7 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
 	.base.cra_alignmask	= 7,
Index: linux-2.6/drivers/crypto/xilinx/zynqmp-aes-gcm.c
===================================================================
--- linux-2.6.orig/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ linux-2.6/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -368,6 +368,7 @@ static struct zynqmp_aead_drv_ctx aes_dr
 		.cra_priority		= 200,
 		.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
 					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
Index: linux-2.6/drivers/crypto/inside-secure/safexcel_cipher.c
===================================================================
--- linux-2.6.orig/drivers/crypto/inside-secure/safexcel_cipher.c
+++ linux-2.6/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1300,6 +1300,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ecb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1337,6 +1338,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1374,6 +1376,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-cfb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1411,6 +1414,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ofb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1485,6 +1489,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1545,6 +1550,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1582,6 +1588,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ecb-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1642,6 +1649,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1679,6 +1687,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ecb-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1751,6 +1760,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1786,6 +1796,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1821,6 +1832,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1856,6 +1868,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1891,6 +1904,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1927,6 +1941,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1963,6 +1978,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1999,6 +2015,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2035,6 +2052,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2071,6 +2089,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2107,6 +2126,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2143,6 +2163,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2179,6 +2200,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2215,6 +2237,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2251,6 +2274,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2285,6 +2309,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2319,6 +2344,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2353,6 +2379,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2387,6 +2414,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2421,6 +2449,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2534,6 +2563,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-xts-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = XTS_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2646,6 +2676,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2769,6 +2800,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ccm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2832,6 +2864,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-chacha20",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2993,6 +3026,7 @@ struct safexcel_alg_template safexcel_al
 			/* +1 to put it above HW chacha + SW poly */
 			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
@@ -3032,6 +3066,7 @@ struct safexcel_alg_template safexcel_al
 			/* +1 to put it above HW chacha + SW poly */
 			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
@@ -3110,6 +3145,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ecb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3147,6 +3183,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3184,6 +3221,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ofb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3221,6 +3259,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-cfb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3273,6 +3312,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3332,6 +3372,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3441,6 +3482,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sm3-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = SM4_BLOCK_SIZE,
@@ -3476,6 +3518,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3510,6 +3553,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-authenc-hmac-sm3-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3578,6 +3622,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-rfc4106-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3622,6 +3667,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-rfc4543-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3713,6 +3759,7 @@ struct safexcel_alg_template safexcel_al
 			.cra_driver_name = "safexcel-rfc4309-ccm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
Index: linux-2.6/drivers/crypto/inside-secure/safexcel_hash.c
===================================================================
--- linux-2.6.orig/drivers/crypto/inside-secure/safexcel_hash.c
+++ linux-2.6/drivers/crypto/inside-secure/safexcel_hash.c
@@ -992,6 +992,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-sha1",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1235,6 +1236,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-hmac-sha1",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1291,6 +1293,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-sha256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1347,6 +1350,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-sha224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1418,6 +1422,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-hmac-sha224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1489,6 +1494,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-hmac-sha256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1545,6 +1551,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-sha512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1601,6 +1608,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-sha384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1672,6 +1680,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-hmac-sha512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1743,6 +1752,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-hmac-sha384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1799,6 +1809,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-md5",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1871,6 +1882,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-hmac-md5",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1952,6 +1964,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_OPTIONAL_KEY |
 					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2041,6 +2054,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-cbcmac-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2136,6 +2150,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-xcbc-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2232,6 +2247,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-cmac-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2288,6 +2304,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-sm3",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SM3_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2359,6 +2376,7 @@ struct safexcel_alg_template safexcel_al
 				.cra_driver_name = "safexcel-hmac-sm3",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SM3_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
Index: linux-2.6/drivers/crypto/bcm/cipher.c
===================================================================
--- linux-2.6.orig/drivers/crypto/bcm/cipher.c
+++ linux-2.6/drivers/crypto/bcm/cipher.c
@@ -3233,7 +3233,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-iproc",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		.ivsize = AES_BLOCK_SIZE,
@@ -3256,7 +3256,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-iproc",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = AES_BLOCK_SIZE,
@@ -3279,7 +3279,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-iproc",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = AES_BLOCK_SIZE,
@@ -3302,7 +3302,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(md5),cbc(des))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3325,7 +3325,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha1),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3348,7 +3348,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha224),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha224-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3371,7 +3371,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha256),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3394,7 +3394,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha384),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha384-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3417,7 +3417,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha512),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha512-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3440,7 +3440,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3463,7 +3463,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3486,7 +3486,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha224-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3509,7 +3509,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3532,7 +3532,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha384-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3555,7 +3555,7 @@ static struct iproc_alg_s driver_algs[]
 			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha512-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3811,7 +3811,7 @@ static struct iproc_alg_s driver_algs[]
 				    .cra_name = "md5",
 				    .cra_driver_name = "md5-iproc",
 				    .cra_blocksize = MD5_BLOCK_WORDS * 4,
-				    .cra_flags = CRYPTO_ALG_ASYNC,
+				    .cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 				}
 		      },
 	 .cipher_info = {
@@ -4508,7 +4508,7 @@ static int spu_register_skcipher(struct
 	crypto->base.cra_priority = cipher_pri;
 	crypto->base.cra_alignmask = 0;
 	crypto->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
-	crypto->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	crypto->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	crypto->init = skcipher_init_tfm;
 	crypto->exit = skcipher_exit_tfm;
@@ -4547,7 +4547,7 @@ static int spu_register_ahash(struct ipr
 	hash->halg.base.cra_ctxsize = sizeof(struct iproc_ctx_s);
 	hash->halg.base.cra_init = ahash_cra_init;
 	hash->halg.base.cra_exit = generic_cra_exit;
-	hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 	hash->halg.statesize = sizeof(struct spu_hash_export_s);
 
 	if (driver_alg->auth_info.mode != HASH_MODE_HMAC) {
@@ -4591,7 +4591,7 @@ static int spu_register_aead(struct ipro
 	aead->base.cra_alignmask = 0;
 	aead->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
 
-	aead->base.cra_flags |= CRYPTO_ALG_ASYNC;
+	aead->base.cra_flags |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 	/* setkey set in alg initialization */
 	aead->setauthsize = aead_setauthsize;
 	aead->encrypt = aead_encrypt;
Index: linux-2.6/drivers/crypto/caam/caamalg.c
===================================================================
--- linux-2.6.orig/drivers/crypto/caam/caamalg.c
+++ linux-2.6/drivers/crypto/caam/caamalg.c
@@ -3433,7 +3433,7 @@ static void caam_skcipher_alg_init(struc
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
@@ -3446,7 +3446,7 @@ static void caam_aead_alg_init(struct ca
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_aead_init;
 	alg->exit = caam_aead_exit;
Index: linux-2.6/drivers/crypto/caam/caamalg_qi.c
===================================================================
--- linux-2.6.orig/drivers/crypto/caam/caamalg_qi.c
+++ linux-2.6/drivers/crypto/caam/caamalg_qi.c
@@ -2502,7 +2502,7 @@ static void caam_skcipher_alg_init(struc
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
@@ -2515,7 +2515,7 @@ static void caam_aead_alg_init(struct ca
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_aead_init;
 	alg->exit = caam_aead_exit;
Index: linux-2.6/drivers/crypto/caam/caamalg_qi2.c
===================================================================
--- linux-2.6.orig/drivers/crypto/caam/caamalg_qi2.c
+++ linux-2.6/drivers/crypto/caam/caamalg_qi2.c
@@ -2912,7 +2912,7 @@ static void caam_skcipher_alg_init(struc
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init_skcipher;
 	alg->exit = caam_cra_exit;
@@ -2925,7 +2925,7 @@ static void caam_aead_alg_init(struct ca
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init_aead;
 	alg->exit = caam_cra_exit_aead;
@@ -4547,7 +4547,7 @@ static struct caam_hash_alg *caam_hash_a
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 
 	t_alg->alg_type = template->alg_type;
 	t_alg->dev = dev;
Index: linux-2.6/drivers/crypto/caam/caamhash.c
===================================================================
--- linux-2.6.orig/drivers/crypto/caam/caamhash.c
+++ linux-2.6/drivers/crypto/caam/caamhash.c
@@ -1927,7 +1927,7 @@ caam_hash_alloc(struct caam_hash_templat
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 
 	t_alg->alg_type = template->alg_type;
 
Index: linux-2.6/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
===================================================================
--- linux-2.6.orig/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ linux-2.6/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -378,6 +378,7 @@ int ccp_register_aes_cmac_algs(struct li
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "cmac(aes)");
 	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "cmac-aes-ccp");
 	base->cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_ALLOCATES_MEMORY |
 			  CRYPTO_ALG_KERN_DRIVER_ONLY |
 			  CRYPTO_ALG_NEED_FALLBACK;
 	base->cra_blocksize = AES_BLOCK_SIZE;
Index: linux-2.6/drivers/crypto/ccp/ccp-crypto-aes-galois.c
===================================================================
--- linux-2.6.orig/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ linux-2.6/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -172,6 +172,7 @@ static struct aead_alg ccp_aes_gcm_defau
 	.maxauthsize = AES_BLOCK_SIZE,
 	.base = {
 		.cra_flags	= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize	= AES_BLOCK_SIZE,
Index: linux-2.6/drivers/crypto/ccp/ccp-crypto-aes-xts.c
===================================================================
--- linux-2.6.orig/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ linux-2.6/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -243,6 +243,7 @@ static int ccp_register_aes_xts_alg(stru
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->drv_name);
 	alg->base.cra_flags	= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK;
 	alg->base.cra_blocksize	= AES_BLOCK_SIZE;
Index: linux-2.6/drivers/crypto/ccp/ccp-crypto-aes.c
===================================================================
--- linux-2.6.orig/drivers/crypto/ccp/ccp-crypto-aes.c
+++ linux-2.6/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -212,6 +212,7 @@ static const struct skcipher_alg ccp_aes
 	.init			= ccp_aes_init_tfm,
 
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
@@ -229,6 +230,7 @@ static const struct skcipher_alg ccp_aes
 	.init			= ccp_aes_rfc3686_init_tfm,
 
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= CTR_RFC3686_BLOCK_SIZE,
Index: linux-2.6/drivers/crypto/ccp/ccp-crypto-des3.c
===================================================================
--- linux-2.6.orig/drivers/crypto/ccp/ccp-crypto-des3.c
+++ linux-2.6/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -136,6 +136,7 @@ static const struct skcipher_alg ccp_des
 	.init			= ccp_des3_init_tfm,
 
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
Index: linux-2.6/drivers/crypto/ccp/ccp-crypto-sha.c
===================================================================
--- linux-2.6.orig/drivers/crypto/ccp/ccp-crypto-sha.c
+++ linux-2.6/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -491,6 +491,7 @@ static int ccp_register_sha_alg(struct l
 	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->drv_name);
 	base->cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_ALLOCATES_MEMORY |
 			  CRYPTO_ALG_KERN_DRIVER_ONLY |
 			  CRYPTO_ALG_NEED_FALLBACK;
 	base->cra_blocksize = def->block_size;
Index: linux-2.6/drivers/crypto/hisilicon/sec/sec_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/hisilicon/sec/sec_algs.c
+++ linux-2.6/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -932,7 +932,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "hisi_sec_aes_ecb",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -951,7 +951,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "hisi_sec_aes_cbc",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -970,7 +970,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "ctr(aes)",
 			.cra_driver_name = "hisi_sec_aes_ctr",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -989,7 +989,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "xts(aes)",
 			.cra_driver_name = "hisi_sec_aes_xts",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1009,7 +1009,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "ecb(des)",
 			.cra_driver_name = "hisi_sec_des_ecb",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1028,7 +1028,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "cbc(des)",
 			.cra_driver_name = "hisi_sec_des_cbc",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1047,7 +1047,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "hisi_sec_3des_cbc",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1066,7 +1066,7 @@ static struct skcipher_alg sec_algs[] =
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "hisi_sec_3des_ecb",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
Index: linux-2.6/drivers/crypto/hisilicon/sec2/sec_crypto.c
===================================================================
--- linux-2.6.orig/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ linux-2.6/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1427,7 +1427,7 @@ static int sec_skcipher_decrypt(struct s
 		.cra_name = sec_cra_name,\
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
-		.cra_flags = CRYPTO_ALG_ASYNC,\
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,\
 		.cra_blocksize = blk_size,\
 		.cra_ctxsize = sizeof(struct sec_ctx),\
 		.cra_module = THIS_MODULE,\
@@ -1550,7 +1550,7 @@ static int sec_aead_decrypt(struct aead_
 		.cra_name = sec_cra_name,\
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
-		.cra_flags = CRYPTO_ALG_ASYNC,\
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,\
 		.cra_blocksize = blk_size,\
 		.cra_ctxsize = sizeof(struct sec_ctx),\
 		.cra_module = THIS_MODULE,\
Index: linux-2.6/drivers/crypto/amlogic/amlogic-gxl-core.c
===================================================================
--- linux-2.6.orig/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ linux-2.6/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -54,7 +54,7 @@ static struct meson_alg_template mc_algs
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -79,7 +79,7 @@ static struct meson_alg_template mc_algs
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
Index: linux-2.6/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
===================================================================
--- linux-2.6.orig/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ linux-2.6/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -185,7 +185,7 @@ static struct sun8i_ce_alg_template ce_a
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -211,7 +211,7 @@ static struct sun8i_ce_alg_template ce_a
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -236,7 +236,7 @@ static struct sun8i_ce_alg_template ce_a
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -262,7 +262,7 @@ static struct sun8i_ce_alg_template ce_a
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
Index: linux-2.6/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
===================================================================
--- linux-2.6.orig/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ linux-2.6/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -169,7 +169,7 @@ static struct sun8i_ss_alg_template ss_a
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -195,7 +195,7 @@ static struct sun8i_ss_alg_template ss_a
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -220,7 +220,7 @@ static struct sun8i_ss_alg_template ss_a
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -246,7 +246,7 @@ static struct sun8i_ss_alg_template ss_a
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,

