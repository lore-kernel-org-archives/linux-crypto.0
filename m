Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE909C433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D542070C
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593579160;
	bh=KEi79IolVNpiJ2INYl43lQ+EFmszSn1YMCAb3JfpSUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lly3nIHMhP4lPl8p724XwLa5BUAN2bTni+GkH/ba6LY11Mr5yuUZ5Zb49+ixRI7Dw
	 Yninq0JNAGI5xKCBkoSDJG5oiCRPn20rJrNzE7gDcyxDDn0ybD/vRMUKNKG2kph9E4
	 ISm+yU8eNCMHH2KoT8IZZ1jNuokYVExDINdLS0gQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgGAEwj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgGAEwi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 00:52:38 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE62E2078D;
        Wed,  1 Jul 2020 04:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593579150;
        bh=KEi79IolVNpiJ2INYl43lQ+EFmszSn1YMCAb3JfpSUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1mvDNK0vUr4Uk3ikoIHZNNv/3p2vDNorZdbuV6VrOiIbqmv79S3C5HK8wdxzpuNe
         1wSuMMsrxyXfduZFcISQBZT4sWE2VJYknHBhtrfVCLlst1HXrrvdGx7sg+Fi5SHrk7
         2qozWi++h1MGdAiMJy+bypWEuNEvjXtjXnEjXFgs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH 5/6] crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
Date:   Tue, 30 Jun 2020 21:52:16 -0700
Message-Id: <20200701045217.121126-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701045217.121126-1-ebiggers@kernel.org>
References: <20200701045217.121126-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
allocate memory.

drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c: sun8i_ce_cipher
drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c: sun8i_ss_cipher
drivers/crypto/amlogic/amlogic-gxl-core.c: meson_cipher
drivers/crypto/axis/artpec6_crypto.c: artpec6_crypto_common_init
drivers/crypto/bcm/cipher.c: spu_skcipher_rx_sg_create
drivers/crypto/caam/caamalg.c: aead_edesc_alloc
drivers/crypto/caam/caamalg_qi.c: aead_edesc_alloc
drivers/crypto/caam/caamalg_qi2.c: aead_edesc_alloc
drivers/crypto/caam/caamhash.c: hash_digest_key
drivers/crypto/cavium/cpt/cptvf_algs.c: process_request
drivers/crypto/cavium/nitrox/nitrox_aead.c: nitrox_process_se_request
drivers/crypto/cavium/nitrox/nitrox_skcipher.c: nitrox_process_se_request
drivers/crypto/ccp/ccp-crypto-aes-cmac.c: ccp_do_cmac_update
drivers/crypto/ccp/ccp-crypto-aes-galois.c: ccp_crypto_enqueue_request
drivers/crypto/ccp/ccp-crypto-aes-xts.c: ccp_crypto_enqueue_request
drivers/crypto/ccp/ccp-crypto-aes.c: ccp_crypto_enqueue_request
drivers/crypto/ccp/ccp-crypto-des3.c: ccp_crypto_enqueue_request
drivers/crypto/ccp/ccp-crypto-sha.c: ccp_crypto_enqueue_request
drivers/crypto/chelsio/chcr_algo.c: create_cipher_wr
drivers/crypto/hisilicon/sec/sec_algs.c: sec_alloc_and_fill_hw_sgl
drivers/crypto/hisilicon/sec2/sec_crypto.c: sec_alloc_req_id
drivers/crypto/inside-secure/safexcel_cipher.c: safexcel_queue_req
drivers/crypto/inside-secure/safexcel_hash.c: safexcel_ahash_enqueue
drivers/crypto/ixp4xx_crypto.c: ablk_perform
drivers/crypto/marvell/cesa/cipher.c: mv_cesa_skcipher_dma_req_init
drivers/crypto/marvell/cesa/hash.c: mv_cesa_ahash_dma_req_init
drivers/crypto/marvell/octeontx/otx_cptvf_algs.c: create_ctx_hdr
drivers/crypto/n2_core.c: n2_compute_chunks
drivers/crypto/picoxcell_crypto.c: spacc_sg_to_ddt
drivers/crypto/qat/qat_common/qat_algs.c: qat_alg_skcipher_encrypt
drivers/crypto/qce/skcipher.c: qce_skcipher_async_req_handle
drivers/crypto/talitos.c : talitos_edesc_alloc
drivers/crypto/virtio/virtio_crypto_algs.c: __virtio_crypto_skcipher_do_req
drivers/crypto/xilinx/zynqmp-aes-gcm.c: zynqmp_aes_aead_cipher

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[EB: avoid overly-long lines]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  12 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  12 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c     |   6 +-
 drivers/crypto/axis/artpec6_crypto.c          |  20 ++-
 drivers/crypto/bcm/cipher.c                   |  72 ++++++++---
 drivers/crypto/caam/caamalg.c                 |   6 +-
 drivers/crypto/caam/caamalg_qi.c              |   6 +-
 drivers/crypto/caam/caamalg_qi2.c             |   8 +-
 drivers/crypto/caam/caamhash.c                |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c        |  18 ++-
 drivers/crypto/cavium/nitrox/nitrox_aead.c    |   4 +-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |  16 +--
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |   1 +
 drivers/crypto/ccp/ccp-crypto-aes-galois.c    |   1 +
 drivers/crypto/ccp/ccp-crypto-aes-xts.c       |   1 +
 drivers/crypto/ccp/ccp-crypto-aes.c           |   2 +
 drivers/crypto/ccp/ccp-crypto-des3.c          |   1 +
 drivers/crypto/ccp/ccp-crypto-sha.c           |   1 +
 drivers/crypto/chelsio/chcr_algo.c            |   7 +-
 drivers/crypto/hisilicon/sec/sec_algs.c       |  24 ++--
 drivers/crypto/hisilicon/sec2/sec_crypto.c    |   4 +-
 .../crypto/inside-secure/safexcel_cipher.c    |  47 +++++++
 drivers/crypto/inside-secure/safexcel_hash.c  |  18 +++
 drivers/crypto/ixp4xx_crypto.c                |   6 +-
 drivers/crypto/marvell/cesa/cipher.c          |  18 ++-
 drivers/crypto/marvell/cesa/hash.c            |   6 +
 .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  30 ++---
 drivers/crypto/n2_core.c                      |   3 +-
 drivers/crypto/picoxcell_crypto.c             |  17 ++-
 drivers/crypto/qat/qat_common/qat_algs.c      |  12 +-
 drivers/crypto/qce/skcipher.c                 |   1 +
 drivers/crypto/talitos.c                      | 117 ++++++++++++------
 drivers/crypto/virtio/virtio_crypto_algs.c    |   3 +-
 drivers/crypto/xilinx/zynqmp-aes-gcm.c        |   1 +
 34 files changed, 360 insertions(+), 143 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index b957061424a1..138759dc8190 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -185,7 +185,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -211,7 +212,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -236,7 +238,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -262,7 +265,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 5d9d0fedcb06..9a23515783a6 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -169,7 +169,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -195,7 +196,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -220,7 +222,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -246,7 +249,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 411857fad8ba..466552acbbbb 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -54,7 +54,8 @@ static struct meson_alg_template mc_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -79,7 +80,8 @@ static struct meson_alg_template mc_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 62ba0325a618..1a46eeddf082 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2630,7 +2630,8 @@ static struct ahash_alg hash_algos[] = {
 			.cra_name = "sha1",
 			.cra_driver_name = "artpec-sha1",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
 			.cra_alignmask = 3,
@@ -2653,7 +2654,8 @@ static struct ahash_alg hash_algos[] = {
 			.cra_name = "sha256",
 			.cra_driver_name = "artpec-sha256",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
 			.cra_alignmask = 3,
@@ -2677,7 +2679,8 @@ static struct ahash_alg hash_algos[] = {
 			.cra_name = "hmac(sha256)",
 			.cra_driver_name = "artpec-hmac-sha256",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
 			.cra_alignmask = 3,
@@ -2696,7 +2699,8 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "artpec6-ecb-aes",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
 			.cra_alignmask = 3,
@@ -2717,6 +2721,7 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_driver_name = "artpec6-ctr-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
@@ -2738,7 +2743,8 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "artpec6-cbc-aes",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
 			.cra_alignmask = 3,
@@ -2759,7 +2765,8 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_name = "xts(aes)",
 			.cra_driver_name = "artpec6-xts-aes",
 			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
 			.cra_alignmask = 3,
@@ -2790,6 +2797,7 @@ static struct aead_alg aead_algos[] = {
 			.cra_driver_name = "artpec-gcm-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index a353217a0d33..8a7fa1ae1ade 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -3233,7 +3233,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-iproc",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		.ivsize = AES_BLOCK_SIZE,
@@ -3256,7 +3258,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-iproc",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = AES_BLOCK_SIZE,
@@ -3279,7 +3283,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(aes))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-iproc",
 			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = AES_BLOCK_SIZE,
@@ -3302,7 +3308,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(des))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3325,7 +3333,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3348,7 +3358,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha224),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha224-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3371,7 +3383,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3394,7 +3408,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha384),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha384-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3417,7 +3433,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha512),cbc(des))",
 			.cra_driver_name = "authenc-hmac-sha512-cbc-des-iproc",
 			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES_BLOCK_SIZE,
@@ -3440,7 +3458,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-md5-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3463,7 +3483,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha1-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3486,7 +3508,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha224-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3509,7 +3533,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha256-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3532,7 +3558,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha384-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3555,7 +3583,9 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
 			.cra_driver_name = "authenc-hmac-sha512-cbc-des3-iproc",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
+				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
 		 .ivsize = DES3_EDE_BLOCK_SIZE,
@@ -3811,7 +3841,8 @@ static struct iproc_alg_s driver_algs[] = {
 				    .cra_name = "md5",
 				    .cra_driver_name = "md5-iproc",
 				    .cra_blocksize = MD5_BLOCK_WORDS * 4,
-				    .cra_flags = CRYPTO_ALG_ASYNC,
+				    .cra_flags = CRYPTO_ALG_ASYNC |
+						 CRYPTO_ALG_ALLOCATES_MEMORY,
 				}
 		      },
 	 .cipher_info = {
@@ -4508,7 +4539,9 @@ static int spu_register_skcipher(struct iproc_alg_s *driver_alg)
 	crypto->base.cra_priority = cipher_pri;
 	crypto->base.cra_alignmask = 0;
 	crypto->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
-	crypto->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	crypto->base.cra_flags = CRYPTO_ALG_ASYNC |
+				 CRYPTO_ALG_ALLOCATES_MEMORY |
+				 CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	crypto->init = skcipher_init_tfm;
 	crypto->exit = skcipher_exit_tfm;
@@ -4547,7 +4580,8 @@ static int spu_register_ahash(struct iproc_alg_s *driver_alg)
 	hash->halg.base.cra_ctxsize = sizeof(struct iproc_ctx_s);
 	hash->halg.base.cra_init = ahash_cra_init;
 	hash->halg.base.cra_exit = generic_cra_exit;
-	hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				    CRYPTO_ALG_ALLOCATES_MEMORY;
 	hash->halg.statesize = sizeof(struct spu_hash_export_s);
 
 	if (driver_alg->auth_info.mode != HASH_MODE_HMAC) {
@@ -4591,7 +4625,7 @@ static int spu_register_aead(struct iproc_alg_s *driver_alg)
 	aead->base.cra_alignmask = 0;
 	aead->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
 
-	aead->base.cra_flags |= CRYPTO_ALG_ASYNC;
+	aead->base.cra_flags |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 	/* setkey set in alg initialization */
 	aead->setauthsize = aead_setauthsize;
 	aead->encrypt = aead_encrypt;
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b2f9882bc010..4e15e82cbf78 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3433,7 +3433,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
@@ -3446,7 +3447,8 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_aead_init;
 	alg->exit = caam_aead_exit;
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 27e36bdf6163..efe8f15a4a51 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2502,7 +2502,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
@@ -2515,7 +2516,8 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_aead_init;
 	alg->exit = caam_aead_exit;
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 1e90412afea2..48f08c9cfcbf 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -2912,7 +2912,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init_skcipher;
 	alg->exit = caam_cra_exit;
@@ -2925,7 +2926,8 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init_aead;
 	alg->exit = caam_cra_exit_aead;
@@ -4545,7 +4547,7 @@ static struct caam_hash_alg *caam_hash_alloc(struct device *dev,
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 
 	t_alg->alg_type = template->alg_type;
 	t_alg->dev = dev;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 27ff4a3d037e..e8a6d8bc43b5 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1927,7 +1927,7 @@ caam_hash_alloc(struct caam_hash_template *template,
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 
 	t_alg->alg_type = template->alg_type;
 
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 1be1adffff1d..80ba6956adab 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -339,7 +339,8 @@ static int cvm_enc_dec_init(struct crypto_skcipher *tfm)
 }
 
 static struct skcipher_alg algs[] = { {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -356,7 +357,8 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -373,7 +375,8 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -389,7 +392,8 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
 	.base.cra_alignmask	= 7,
@@ -406,7 +410,8 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
 	.base.cra_alignmask	= 7,
@@ -423,7 +428,8 @@ static struct skcipher_alg algs[] = { {
 	.decrypt		= cvm_decrypt,
 	.init			= cvm_enc_dec_init,
 }, {
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
 	.base.cra_alignmask	= 7,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/cavium/nitrox/nitrox_aead.c
index dce5423a5883..1be2571363fe 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -522,7 +522,7 @@ static struct aead_alg nitrox_aeads[] = { {
 		.cra_name = "gcm(aes)",
 		.cra_driver_name = "n5_aes_gcm",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -541,7 +541,7 @@ static struct aead_alg nitrox_aeads[] = { {
 		.cra_name = "rfc4106(gcm(aes))",
 		.cra_driver_name = "n5_rfc4106",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 18088b0a2257..a553ac65f324 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -388,7 +388,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cbc(aes)",
 		.cra_driver_name = "n5_cbc(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -407,7 +407,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "ecb(aes)",
 		.cra_driver_name = "n5_ecb(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -426,7 +426,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cfb(aes)",
 		.cra_driver_name = "n5_cfb(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -445,7 +445,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "xts(aes)",
 		.cra_driver_name = "n5_xts(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -464,7 +464,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "rfc3686(ctr(aes))",
 		.cra_driver_name = "n5_rfc3686(ctr(aes))",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -483,7 +483,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cts(cbc(aes))",
 		.cra_driver_name = "n5_cts(cbc(aes))",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -502,7 +502,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cbc(des3_ede)",
 		.cra_driver_name = "n5_cbc(des3_ede)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -521,7 +521,7 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "n5_ecb(des3_ede)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 5eba7ee49e81..11a305fa19e6 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -378,6 +378,7 @@ int ccp_register_aes_cmac_algs(struct list_head *head)
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "cmac(aes)");
 	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "cmac-aes-ccp");
 	base->cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_ALLOCATES_MEMORY |
 			  CRYPTO_ALG_KERN_DRIVER_ONLY |
 			  CRYPTO_ALG_NEED_FALLBACK;
 	base->cra_blocksize = AES_BLOCK_SIZE;
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index 9e8f07c1afac..1c1c939f5c39 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -172,6 +172,7 @@ static struct aead_alg ccp_aes_gcm_defaults = {
 	.maxauthsize = AES_BLOCK_SIZE,
 	.base = {
 		.cra_flags	= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize	= AES_BLOCK_SIZE,
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 04b2517df955..8a1c4ab72daa 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -243,6 +243,7 @@ static int ccp_register_aes_xts_alg(struct list_head *head,
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->drv_name);
 	alg->base.cra_flags	= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK;
 	alg->base.cra_blocksize	= AES_BLOCK_SIZE;
diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 51e12fbd1159..e6dcd8cedd53 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -212,6 +212,7 @@ static const struct skcipher_alg ccp_aes_defaults = {
 	.init			= ccp_aes_init_tfm,
 
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
@@ -229,6 +230,7 @@ static const struct skcipher_alg ccp_aes_rfc3686_defaults = {
 	.init			= ccp_aes_rfc3686_init_tfm,
 
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= CTR_RFC3686_BLOCK_SIZE,
diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 9c129defdb50..ec97daf0fcb7 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -136,6 +136,7 @@ static const struct skcipher_alg ccp_des3_defaults = {
 	.init			= ccp_des3_init_tfm,
 
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index b0cc2bd73af8..5aa1af21f69f 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -486,6 +486,7 @@ static int ccp_register_sha_alg(struct list_head *head,
 	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->drv_name);
 	base->cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_ALLOCATES_MEMORY |
 			  CRYPTO_ALG_KERN_DRIVER_ONLY |
 			  CRYPTO_ALG_NEED_FALLBACK;
 	base->cra_blocksize = def->block_size;
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 4c2553672b6f..009d0d3e13b7 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -4445,6 +4445,7 @@ static int chcr_register_alg(void)
 			driver_algs[i].alg.skcipher.base.cra_module = THIS_MODULE;
 			driver_algs[i].alg.skcipher.base.cra_flags =
 				CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_NEED_FALLBACK;
 			driver_algs[i].alg.skcipher.base.cra_ctxsize =
 				sizeof(struct chcr_context) +
@@ -4456,7 +4457,8 @@ static int chcr_register_alg(void)
 			break;
 		case CRYPTO_ALG_TYPE_AEAD:
 			driver_algs[i].alg.aead.base.cra_flags =
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
+				CRYPTO_ALG_ALLOCATES_MEMORY;
 			driver_algs[i].alg.aead.encrypt = chcr_aead_encrypt;
 			driver_algs[i].alg.aead.decrypt = chcr_aead_decrypt;
 			driver_algs[i].alg.aead.init = chcr_aead_cra_init;
@@ -4476,7 +4478,8 @@ static int chcr_register_alg(void)
 			a_hash->halg.statesize = SZ_AHASH_REQ_CTX;
 			a_hash->halg.base.cra_priority = CHCR_CRA_PRIORITY;
 			a_hash->halg.base.cra_module = THIS_MODULE;
-			a_hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+			a_hash->halg.base.cra_flags =
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 			a_hash->halg.base.cra_alignmask = 0;
 			a_hash->halg.base.cra_exit = NULL;
 
diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index c27e7160d2df..9d366964c39c 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -932,7 +932,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "hisi_sec_aes_ecb",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -951,7 +952,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "hisi_sec_aes_cbc",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -970,7 +972,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "ctr(aes)",
 			.cra_driver_name = "hisi_sec_aes_ctr",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -989,7 +992,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "xts(aes)",
 			.cra_driver_name = "hisi_sec_aes_xts",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1009,7 +1013,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "ecb(des)",
 			.cra_driver_name = "hisi_sec_des_ecb",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1028,7 +1033,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "cbc(des)",
 			.cra_driver_name = "hisi_sec_des_cbc",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1047,7 +1053,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "hisi_sec_3des_cbc",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
@@ -1066,7 +1073,8 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "hisi_sec_3des_ecb",
 			.cra_priority = 4001,
-			.cra_flags = CRYPTO_ALG_ASYNC,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
 			.cra_alignmask = 0,
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 64614a9bdf21..e2074724e93d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1435,7 +1435,7 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
 		.cra_name = sec_cra_name,\
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
-		.cra_flags = CRYPTO_ALG_ASYNC,\
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,\
 		.cra_blocksize = blk_size,\
 		.cra_ctxsize = sizeof(struct sec_ctx),\
 		.cra_module = THIS_MODULE,\
@@ -1558,7 +1558,7 @@ static int sec_aead_decrypt(struct aead_request *a_req)
 		.cra_name = sec_cra_name,\
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
-		.cra_flags = CRYPTO_ALG_ASYNC,\
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,\
 		.cra_blocksize = blk_size,\
 		.cra_ctxsize = sizeof(struct sec_ctx),\
 		.cra_module = THIS_MODULE,\
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 0c5e80c3f6e3..1ac3253b7903 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1300,6 +1300,7 @@ struct safexcel_alg_template safexcel_alg_ecb_aes = {
 			.cra_driver_name = "safexcel-ecb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1337,6 +1338,7 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 			.cra_driver_name = "safexcel-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1374,6 +1376,7 @@ struct safexcel_alg_template safexcel_alg_cfb_aes = {
 			.cra_driver_name = "safexcel-cfb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1411,6 +1414,7 @@ struct safexcel_alg_template safexcel_alg_ofb_aes = {
 			.cra_driver_name = "safexcel-ofb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1485,6 +1489,7 @@ struct safexcel_alg_template safexcel_alg_ctr_aes = {
 			.cra_driver_name = "safexcel-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1545,6 +1550,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des = {
 			.cra_driver_name = "safexcel-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1582,6 +1588,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
 			.cra_driver_name = "safexcel-ecb-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1642,6 +1649,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1679,6 +1687,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 			.cra_driver_name = "safexcel-ecb-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1751,6 +1760,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1786,6 +1796,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1821,6 +1832,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1856,6 +1868,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1891,6 +1904,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1927,6 +1941,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1963,6 +1978,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -1999,6 +2015,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2035,6 +2052,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2071,6 +2089,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2107,6 +2126,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2143,6 +2163,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2179,6 +2200,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2215,6 +2237,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2251,6 +2274,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2285,6 +2309,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2319,6 +2344,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2353,6 +2379,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2387,6 +2414,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2421,6 +2449,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2534,6 +2563,7 @@ struct safexcel_alg_template safexcel_alg_xts_aes = {
 			.cra_driver_name = "safexcel-xts-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = XTS_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2646,6 +2676,7 @@ struct safexcel_alg_template safexcel_alg_gcm = {
 			.cra_driver_name = "safexcel-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2769,6 +2800,7 @@ struct safexcel_alg_template safexcel_alg_ccm = {
 			.cra_driver_name = "safexcel-ccm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2832,6 +2864,7 @@ struct safexcel_alg_template safexcel_alg_chacha20 = {
 			.cra_driver_name = "safexcel-chacha20",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -2993,6 +3026,7 @@ struct safexcel_alg_template safexcel_alg_chachapoly = {
 			/* +1 to put it above HW chacha + SW poly */
 			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
@@ -3032,6 +3066,7 @@ struct safexcel_alg_template safexcel_alg_chachapoly_esp = {
 			/* +1 to put it above HW chacha + SW poly */
 			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
@@ -3110,6 +3145,7 @@ struct safexcel_alg_template safexcel_alg_ecb_sm4 = {
 			.cra_driver_name = "safexcel-ecb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3147,6 +3183,7 @@ struct safexcel_alg_template safexcel_alg_cbc_sm4 = {
 			.cra_driver_name = "safexcel-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3184,6 +3221,7 @@ struct safexcel_alg_template safexcel_alg_ofb_sm4 = {
 			.cra_driver_name = "safexcel-ofb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3221,6 +3259,7 @@ struct safexcel_alg_template safexcel_alg_cfb_sm4 = {
 			.cra_driver_name = "safexcel-cfb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3273,6 +3312,7 @@ struct safexcel_alg_template safexcel_alg_ctr_sm4 = {
 			.cra_driver_name = "safexcel-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3332,6 +3372,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3441,6 +3482,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_cbc_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sm3-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = SM4_BLOCK_SIZE,
@@ -3476,6 +3518,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3510,6 +3553,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_ctr_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sm3-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3578,6 +3622,7 @@ struct safexcel_alg_template safexcel_alg_rfc4106_gcm = {
 			.cra_driver_name = "safexcel-rfc4106-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3622,6 +3667,7 @@ struct safexcel_alg_template safexcel_alg_rfc4543_gcm = {
 			.cra_driver_name = "safexcel-rfc4543-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
@@ -3713,6 +3759,7 @@ struct safexcel_alg_template safexcel_alg_rfc4309_ccm = {
 			.cra_driver_name = "safexcel-rfc4309-ccm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 43962bc709c6..16a467969d8e 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -992,6 +992,7 @@ struct safexcel_alg_template safexcel_alg_sha1 = {
 				.cra_driver_name = "safexcel-sha1",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1235,6 +1236,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha1 = {
 				.cra_driver_name = "safexcel-hmac-sha1",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1291,6 +1293,7 @@ struct safexcel_alg_template safexcel_alg_sha256 = {
 				.cra_driver_name = "safexcel-sha256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1347,6 +1350,7 @@ struct safexcel_alg_template safexcel_alg_sha224 = {
 				.cra_driver_name = "safexcel-sha224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1418,6 +1422,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha224 = {
 				.cra_driver_name = "safexcel-hmac-sha224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1489,6 +1494,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha256 = {
 				.cra_driver_name = "safexcel-hmac-sha256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1545,6 +1551,7 @@ struct safexcel_alg_template safexcel_alg_sha512 = {
 				.cra_driver_name = "safexcel-sha512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1601,6 +1608,7 @@ struct safexcel_alg_template safexcel_alg_sha384 = {
 				.cra_driver_name = "safexcel-sha384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1672,6 +1680,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha512 = {
 				.cra_driver_name = "safexcel-hmac-sha512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1743,6 +1752,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha384 = {
 				.cra_driver_name = "safexcel-hmac-sha384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1799,6 +1809,7 @@ struct safexcel_alg_template safexcel_alg_md5 = {
 				.cra_driver_name = "safexcel-md5",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1871,6 +1882,7 @@ struct safexcel_alg_template safexcel_alg_hmac_md5 = {
 				.cra_driver_name = "safexcel-hmac-md5",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -1952,6 +1964,7 @@ struct safexcel_alg_template safexcel_alg_crc32 = {
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_OPTIONAL_KEY |
 					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2041,6 +2054,7 @@ struct safexcel_alg_template safexcel_alg_cbcmac = {
 				.cra_driver_name = "safexcel-cbcmac-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2136,6 +2150,7 @@ struct safexcel_alg_template safexcel_alg_xcbcmac = {
 				.cra_driver_name = "safexcel-xcbc-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2232,6 +2247,7 @@ struct safexcel_alg_template safexcel_alg_cmac = {
 				.cra_driver_name = "safexcel-cmac-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2288,6 +2304,7 @@ struct safexcel_alg_template safexcel_alg_sm3 = {
 				.cra_driver_name = "safexcel-sm3",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SM3_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
@@ -2359,6 +2376,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sm3 = {
 				.cra_driver_name = "safexcel-hmac-sm3",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SM3_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index ad73fc946682..f478bb0a566a 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
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
diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index f133c2ccb5ae..45b4d7a29833 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -508,7 +508,8 @@ struct skcipher_alg mv_cesa_ecb_des_alg = {
 		.cra_name = "ecb(des)",
 		.cra_driver_name = "mv-ecb-des",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
 		.cra_alignmask = 0,
@@ -558,7 +559,8 @@ struct skcipher_alg mv_cesa_cbc_des_alg = {
 		.cra_name = "cbc(des)",
 		.cra_driver_name = "mv-cbc-des",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
 		.cra_alignmask = 0,
@@ -616,7 +618,8 @@ struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "mv-ecb-des3-ede",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
 		.cra_alignmask = 0,
@@ -669,7 +672,8 @@ struct skcipher_alg mv_cesa_cbc_des3_ede_alg = {
 		.cra_name = "cbc(des3_ede)",
 		.cra_driver_name = "mv-cbc-des3-ede",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
 		.cra_alignmask = 0,
@@ -741,7 +745,8 @@ struct skcipher_alg mv_cesa_ecb_aes_alg = {
 		.cra_name = "ecb(aes)",
 		.cra_driver_name = "mv-ecb-aes",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
 		.cra_alignmask = 0,
@@ -790,7 +795,8 @@ struct skcipher_alg mv_cesa_cbc_aes_alg = {
 		.cra_name = "cbc(aes)",
 		.cra_driver_name = "mv-cbc-aes",
 		.cra_priority = 300,
-		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index b971284332b6..bd0bd9ffd6e9 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
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
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 01bf4826c03e..90bb31329d4b 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -1301,7 +1301,7 @@ static int otx_cpt_aead_null_decrypt(struct aead_request *req)
 static struct skcipher_alg otx_cpt_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "cpt_xts_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1318,7 +1318,7 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "cpt_cbc_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1335,7 +1335,7 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "ecb(aes)",
 	.base.cra_driver_name = "cpt_ecb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1352,7 +1352,7 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cfb(aes)",
 	.base.cra_driver_name = "cpt_cfb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1369,7 +1369,7 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cbc(des3_ede)",
 	.base.cra_driver_name = "cpt_cbc_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_des3_ctx),
 	.base.cra_alignmask = 7,
@@ -1386,7 +1386,7 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "ecb(des3_ede)",
 	.base.cra_driver_name = "cpt_ecb_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_des3_ctx),
 	.base.cra_alignmask = 7,
@@ -1407,7 +1407,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha1_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1426,7 +1426,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha256_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1445,7 +1445,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha384),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha384_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1464,7 +1464,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha512_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1483,7 +1483,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha1_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1502,7 +1502,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha256_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1521,7 +1521,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha384),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha384_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1540,7 +1540,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha512_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1559,7 +1559,7 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "rfc4106(gcm(aes))",
 		.cra_driver_name = "cpt_rfc4106_gcm_aes",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 6a828bbecea4..d8aec5153b21 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1382,7 +1382,8 @@ static int __n2_register_one_skcipher(const struct n2_skcipher_tmpl *tmpl)
 	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-n2", tmpl->drv_name);
 	alg->base.cra_priority = N2_CRA_PRIORITY;
-	alg->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC;
+	alg->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			      CRYPTO_ALG_ALLOCATES_MEMORY;
 	alg->base.cra_blocksize = tmpl->block_size;
 	p->enc_type = tmpl->enc_type;
 	alg->base.cra_ctxsize = sizeof(struct n2_skcipher_context);
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 7384e91c8b32..cf84768f3e6d 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1226,6 +1226,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1251,6 +1252,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1274,7 +1276,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.base.cra_driver_name	= "cbc-des-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC,
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
 			.base.cra_module	= THIS_MODULE,
@@ -1298,7 +1301,8 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.base.cra_driver_name	= "ecb-des-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC,
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
 			.base.cra_module	= THIS_MODULE,
@@ -1321,6 +1325,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.base.cra_driver_name	= "cbc-des3-ede-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1345,6 +1350,7 @@ static struct spacc_alg ipsec_engine_algs[] = {
 			.base.cra_driver_name	= "ecb-des3-ede-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
@@ -1376,6 +1382,7 @@ static struct spacc_aead ipsec_engine_aeads[] = {
 						   "cbc-aes-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -1406,6 +1413,7 @@ static struct spacc_aead ipsec_engine_aeads[] = {
 						   "cbc-aes-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -1436,6 +1444,7 @@ static struct spacc_aead ipsec_engine_aeads[] = {
 						   "cbc-aes-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -1466,6 +1475,7 @@ static struct spacc_aead ipsec_engine_aeads[] = {
 						   "cbc-3des-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1497,6 +1507,7 @@ static struct spacc_aead ipsec_engine_aeads[] = {
 						   "cbc-3des-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1527,6 +1538,7 @@ static struct spacc_aead ipsec_engine_aeads[] = {
 						   "cbc-3des-picoxcell",
 				.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_NEED_FALLBACK |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1556,6 +1568,7 @@ static struct spacc_alg l2_engine_algs[] = {
 			.base.cra_driver_name	= "f8-kasumi-picoxcell",
 			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
 			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.base.cra_blocksize	= 8,
 			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 833d1a75666f..2238dd434ed3 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1213,7 +1213,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1230,7 +1230,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1247,7 +1247,7 @@ static struct aead_alg qat_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
 		.cra_priority = 4001,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
 		.cra_module = THIS_MODULE,
@@ -1265,7 +1265,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "qat_aes_cbc",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1283,7 +1283,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "ctr(aes)",
 	.base.cra_driver_name = "qat_aes_ctr",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = 1,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
@@ -1301,7 +1301,7 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "qat_aes_xts",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 9412433f3b21..13c202ef560b 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -404,6 +404,7 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 
 	alg->base.cra_priority		= 300;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->base.cra_ctxsize		= sizeof(struct qce_cipher_ctx);
 	alg->base.cra_alignmask		= 0;
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 9c6db7f698c4..7c547352a862 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2264,7 +2264,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2285,7 +2286,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2306,7 +2308,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2330,7 +2333,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha1-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -2352,7 +2356,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2373,7 +2378,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2394,7 +2400,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2418,7 +2425,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha224-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -2440,7 +2448,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2461,7 +2470,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2482,7 +2492,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2506,7 +2517,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha256-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -2528,7 +2540,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha384-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -2549,7 +2562,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha384-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -2571,7 +2585,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha512-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -2592,7 +2607,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-sha512-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -2614,7 +2630,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2635,7 +2652,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2655,7 +2673,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2678,7 +2697,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "authenc-hmac-md5-"
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -2699,7 +2719,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_name = "ecb(aes)",
 			.base.cra_driver_name = "ecb-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.setkey = skcipher_aes_setkey,
@@ -2712,7 +2733,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_name = "cbc(aes)",
 			.base.cra_driver_name = "cbc-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -2727,7 +2749,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_name = "ctr(aes)",
 			.base.cra_driver_name = "ctr-aes-talitos",
 			.base.cra_blocksize = 1,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -2742,7 +2765,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_name = "ecb(des)",
 			.base.cra_driver_name = "ecb-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.setkey = skcipher_des_setkey,
@@ -2755,7 +2779,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_name = "cbc(des)",
 			.base.cra_driver_name = "cbc-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
@@ -2770,7 +2795,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_name = "ecb(des3_ede)",
 			.base.cra_driver_name = "ecb-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.setkey = skcipher_des3_setkey,
@@ -2784,7 +2810,8 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_name = "cbc(des3_ede)",
 			.base.cra_driver_name = "cbc-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2804,7 +2831,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "md5",
 				.cra_driver_name = "md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2819,7 +2847,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2834,7 +2863,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha224",
 				.cra_driver_name = "sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2849,7 +2879,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2864,7 +2895,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha384",
 				.cra_driver_name = "sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2879,7 +2911,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "sha512",
 				.cra_driver_name = "sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2894,7 +2927,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(md5)",
 				.cra_driver_name = "hmac-md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2909,7 +2943,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "hmac-sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2924,7 +2959,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "hmac-sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2939,7 +2975,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "hmac-sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2954,7 +2991,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "hmac-sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2969,7 +3007,8 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "hmac-sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index cb8a6ea2a4bc..b2601958282e 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -597,7 +597,8 @@ static struct virtio_crypto_algo virtio_crypto_algs[] = { {
 		.base.cra_name		= "cbc(aes)",
 		.base.cra_driver_name	= "virtio_crypto_aes_cbc",
 		.base.cra_priority	= 150,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
 		.base.cra_module	= THIS_MODULE,
diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index cd11558893cd..27079354dbe9 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -364,6 +364,7 @@ static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
 		.cra_priority		= 200,
 		.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
 					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= ZYNQMP_AES_BLK_SIZE,
-- 
2.27.0

