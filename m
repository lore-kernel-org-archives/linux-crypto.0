Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B9CC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiDFRES (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiDFREC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403753441B8
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0BF2617A5
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416E4C385A6;
        Wed,  6 Apr 2022 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255247;
        bh=Q3oCQFiki9DLco1UQ5iuElNwlOisdXFKoDp04gwYszU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SECeHZDJMZVPzu9ercuUrYZ1Pw2VfZXxge7sRv2r66VUI7lD3hQqg0YV5v4nn5es7
         X1fac0nrHaK8ycUsv5pyZHUtz/0Zwe6XNXOLm7OUkviTjl31nQp2/vzZIlkfDKvqje
         p/06CgJugLIfQsi9aMAEz4xwAHBNdRJa+9I3LoJpPMiYro4vXjtR+U3VpcYlAjQViw
         Vh/MqbS0Ern9zC61kDWqx5Y1Bj8mSdFmYsEcZHL9wbWrNLVGoCP92eTTvL16BK7XOJ
         BXpJYJCLG2tc1CjTeAzj5eRU+AQDcphkI3LK9Lw0iIrKWoNrKNGm2BwOcYEY28mRzc
         dGP4c9REFxWMg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/8] crypto: safexcel - take request size after setting TFM
Date:   Wed,  6 Apr 2022 16:27:09 +0200
Message-Id: <20220406142715.2270256-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3832; h=from:subject; bh=Q3oCQFiki9DLco1UQ5iuElNwlOisdXFKoDp04gwYszU=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaM5M3ovuFsqWEZrVApIq3sd0577TzTx9haEmnVT THVAM4OJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jOQAKCRDDTyI5ktmPJGOMC/ 9iwsf75aoyKUiJQLitWw5zPgaEg3HR43F2bY2FJjMyfSX3vQvSw+MSnavKLqzSUgdVCiX02917uASv kpTSGuQVWgsBk9ySr4X4A6UBZAs4Ik2sOWJoFjkVI8jlO/kyot7e+crYia148ubAj7M138cMb7OCLj y8+9d1w2EeRaH35mAg8eR0yRtzm/0Ip+mK4EgIbxerj9z6DhBA72S31ZuH30HerD/ep0GgIPZ5d4en CjCLf9nxrAqRoVGQgWAjAt70JDHGg206isT2KL/OtYrZm0U/KhjWRwcMhansTwVILlCNRlVf2rZ4pD TpLpKsvEir2P0J8kZMozF1HAzgHxfq1+HiY4G7c7SX2n8ZuLwH0FcFRbQkblFtXOx0jI4F05HDrTT0 RflosD/II0WMh15Fn4OpRlhmcGfeZUa3h0g043YP+V3yiEN+rYFk5QKzdLNiUz6KMzC6UvKPI+vzkS zBgkrQNJRIe5k6FX5/nUVECYcrLc2u7LHhjO53zMnCgvc=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The skcipher, aead and ahash request structure types will no longer be
aligned for DMA, and the padding and re-alignment of the context buffer
region will be taken care of at runtime.

This means that we need to update the stack representation accordingly,
to ensure that the context pointer doesn't point past the allocation
after rounding.

Also, as getting at the context pointer of a skcipher_request will
involve a check of the underlying algo's cra_flags field, as it may need
to be aligned for DMA, defer grabbing the context pointer until after
setting the TFM.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.h        | 15 +++++++++------
 drivers/crypto/inside-secure/safexcel_cipher.c |  8 ++++----
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index ce1e611a163e..b5033803714a 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -56,12 +56,15 @@
 				 GFP_KERNEL : GFP_ATOMIC)
 
 /* Custom on-stack requests (for invalidation) */
-#define EIP197_SKCIPHER_REQ_SIZE	sizeof(struct skcipher_request) + \
-					sizeof(struct safexcel_cipher_req)
-#define EIP197_AHASH_REQ_SIZE		sizeof(struct ahash_request) + \
-					sizeof(struct safexcel_ahash_req)
-#define EIP197_AEAD_REQ_SIZE		sizeof(struct aead_request) + \
-					sizeof(struct safexcel_cipher_req)
+#define EIP197_SKCIPHER_REQ_SIZE	(ALIGN(sizeof(struct skcipher_request),	\
+					       CRYPTO_MINALIGN) +		\
+					 sizeof(struct safexcel_cipher_req))
+#define EIP197_AHASH_REQ_SIZE		(ALIGN(sizeof(struct ahash_request),	\
+					       CRYPTO_MINALIGN) +		\
+					 sizeof(struct safexcel_ahash_req))
+#define EIP197_AEAD_REQ_SIZE		(ALIGN(sizeof(struct aead_request),	\
+					       CRYPTO_MINALIGN) +		\
+					 sizeof(struct safexcel_cipher_req))
 #define EIP197_REQUEST_ON_STACK(name, type, size) \
 	char __##name##_desc[size] CRYPTO_MINALIGN_ATTR; \
 	struct type##_request *name = (void *)__##name##_desc
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index d68ef16650d4..6dc3e171f474 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1108,7 +1108,6 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm,
 static int safexcel_skcipher_exit_inv(struct crypto_tfm *tfm)
 {
 	EIP197_REQUEST_ON_STACK(req, skcipher, EIP197_SKCIPHER_REQ_SIZE);
-	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
 	struct safexcel_inv_result result = {};
 
 	memset(req, 0, sizeof(struct skcipher_request));
@@ -1117,13 +1116,13 @@ static int safexcel_skcipher_exit_inv(struct crypto_tfm *tfm)
 				      safexcel_inv_complete, &result);
 	skcipher_request_set_tfm(req, __crypto_skcipher_cast(tfm));
 
-	return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
+	return safexcel_cipher_exit_inv(tfm, &req->base,
+					skcipher_request_ctx(req), &result);
 }
 
 static int safexcel_aead_exit_inv(struct crypto_tfm *tfm)
 {
 	EIP197_REQUEST_ON_STACK(req, aead, EIP197_AEAD_REQ_SIZE);
-	struct safexcel_cipher_req *sreq = aead_request_ctx(req);
 	struct safexcel_inv_result result = {};
 
 	memset(req, 0, sizeof(struct aead_request));
@@ -1132,7 +1131,8 @@ static int safexcel_aead_exit_inv(struct crypto_tfm *tfm)
 				  safexcel_inv_complete, &result);
 	aead_request_set_tfm(req, __crypto_aead_cast(tfm));
 
-	return safexcel_cipher_exit_inv(tfm, &req->base, sreq, &result);
+	return safexcel_cipher_exit_inv(tfm, &req->base, aead_request_ctx(req),
+					&result);
 }
 
 static int safexcel_queue_req(struct crypto_async_request *base,
-- 
2.30.2

