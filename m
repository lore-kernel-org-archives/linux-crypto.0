Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD04C43219
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiDFREY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbiDFREI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5DD4922D8
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 081ED619B0
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6996CC385A1;
        Wed,  6 Apr 2022 14:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255256;
        bh=3xQ+IicuJxqqbSbGdLZz0hgbQcodwyR88fOD06OHSSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzYiTxoI9DwsbcT1Uav2SIU5om2VwRat3kFVSH/+AWm/Ce3qPCLw4+y/KuXtrgobv
         0kQ4UVwrI4mknyQzCV4ZCVDo5MJIKdG0v0XyNLEU0g74aab7f+Z4yGFK3L8+UGzuyw
         Q3vgAChT3rEeG/YrOtFfNz0q8Q/TRzu+9uFs5trR7BCbnlH3khDk7zwWUk3GqRwxdT
         eKWVfcFdk7rkCvFYznQysBzeG8RKTS1ka2jck8rslU4mrE15RIQVuj4OLEw2TGp9T3
         FrJb3/a58/HQE7ZCZods0WpW7zTYMpfh/UmTJvMdgy85DmA/fatqUYq3AL3USPMFtP
         VIr2X0jpQ9dnA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 8/8] crypto: safexcel - reduce alignment of stack buffer
Date:   Wed,  6 Apr 2022 16:27:15 +0200
Message-Id: <20220406142715.2270256-9-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=960; h=from:subject; bh=3xQ+IicuJxqqbSbGdLZz0hgbQcodwyR88fOD06OHSSo=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaNC33cNzLbEs2ctiZcRkxp9Jz9syQOEHvI9dgDi Q9VvunOJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jQgAKCRDDTyI5ktmPJCI4DA DAtL7mc/MboQUat0d9C03b7ZxT7QAcu99P/I8DjwzQh2xGP1jTjX5oPQ3RIzmfDnXNYBFqpSxd6eyo 3y4CjAG/aEa+2gFdgC/+yQQfUnU5Hmvsh6PxgM1ZcJS+OA6jTODNGwvdm3VAleb66AcyaSqo6kYtvq zJH4g7d36CLzlp8D5gI7MsetFoud/YZN7/adlx6mYxAftKnZ7wT6qUQivZF15y/a4zIUgrJiO2y2p6 Q7XDJBRSudlhAxLrOZF4ts9mzEAESqx+rf+4VQ5YDRpfl/JJ+rROtroOO81PrFdxcwGSnz0eyBjM6G M+mWwxidmpsmbsyG1w/clZcuY14vxUFHL600gYa6GnCqjQfi5FN8btJxaMPPigki+hQsLAjHdcFtAF MP0/FyprXAgoZ3PvJbvnP4gcbYGxFLrhV8s4f7EjoYeDuAmBMLe6O/LXT9o3SlfTPYGtJTnLeVpUiw P/+1MJjbN2Cwcl2eW+4cmFVHwcrNrUJ4kpGMuqyoj+jQM=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that skcipher, AEAD and ahash have all been updated to use a request
structure that itself is not aligned for DMA, we can relax the alignment
requirement of the EIP197 stack buffers as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b5033803714a..25020f034f47 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -66,7 +66,7 @@
 					       CRYPTO_MINALIGN) +		\
 					 sizeof(struct safexcel_cipher_req))
 #define EIP197_REQUEST_ON_STACK(name, type, size) \
-	char __##name##_desc[size] CRYPTO_MINALIGN_ATTR; \
+	char __##name##_desc[size] CRYPTO_REQ_MINALIGN_ATTR; \
 	struct type##_request *name = (void *)__##name##_desc
 
 /* Xilinx dev board base offsets */
-- 
2.30.2

