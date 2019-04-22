Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B6EC282E3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 420B22075A
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OVna7Czt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfDVL0J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 07:26:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52765 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfDVL0I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 07:26:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id a184so14045365wma.2;
        Mon, 22 Apr 2019 04:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+XVwqdd74qmNagFrB1WCVK88NxDfUzRVSLDeS0Nb5rI=;
        b=OVna7CztEp+7ApCTsemI8/wTEWaY6To7OYrbR0JLpxbxnfrC7KPBMvNKYX6S/EZG8A
         jxN8amQfaia4isGOUjO1WrpV5iLhDMDhBLxrR65TSPQf5gKHR/YmbFjcgWDGlTlN67q2
         IdTtp/Oswl0hFaCV/0LavWS45dWMUopa7jHGT1csFACBdeOAUOW2yvo7FUwubTxFFKZh
         34TIZyNQKWEl735G51pUTdK5/949anvcH1W3xy6F/+0JaWJVuamelcQFSULqY/72Jg0A
         s/fpLeQ8JLMHi8n3xsfajktFZc1xKpP+kRm6GDUL8Nt8PI1w5raNWM/ub7B+4JbsIynI
         rnyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+XVwqdd74qmNagFrB1WCVK88NxDfUzRVSLDeS0Nb5rI=;
        b=koLHnyq7jxPWXUjQtg7yMTxnduIGiCmln5jLa4I/UkEFA2J/sXjnvjagZHRHfAOKHX
         Wg+QX6/7m3UckobBI740p3KFUSyC62sFZJW/wZ/Iw31wB2O3lAmUQSuG+YzHnxbIKLoC
         degq2SpRz+S85nEIpS0kGujqZ/6YapCUgAU0efeWpYPPFA4SBk/AvtCbn8sFbEEe4Jh6
         aksCQzaVDe5LNO49V71l0ec0IN+Dxu7dvLq2yDG2xef2AepM0+tlMF0Rj8gvOGRsUjcj
         4mnWXBVX5AW4XOWemJtF3nEnW2bi+gyxrB5rq/2q8vWYsec+FduNp3EPsHiKiDeUnMbB
         84OA==
X-Gm-Message-State: APjAAAXS/ZLInxsmwY+ep/nZIHdDSaLiZsKlJAZoEG0VuBpJdkBhLwWg
        b6d6MUTNFWRimWzF2guiEAk=
X-Google-Smtp-Source: APXvYqy1wB13HD+ocOSubdoe3q+qmQeO9im6LrNojyGDO7kszwiC754RNfqeieDojb3xZerzAFG8uA==
X-Received: by 2002:a1c:1aca:: with SMTP id a193mr12365084wma.40.1555932365977;
        Mon, 22 Apr 2019 04:26:05 -0700 (PDT)
Received: from debian64.daheim (p5B0D75EE.dip0.t-ipconnect.de. [91.13.117.238])
        by smtp.gmail.com with ESMTPSA id y133sm13478793wmd.2.2019.04.22.04.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Apr 2019 04:26:03 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hIX5F-0001VQ-HV; Mon, 22 Apr 2019 13:26:01 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] crypto4xx: fix cfb and ofb "overran dst buffer" issues
Date:   Mon, 22 Apr 2019 13:25:59 +0200
Message-Id: <4d8f4f483feb713126bbdb789b095936819d9804.1555932334.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com>
References: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, crypto4xx CFB and OFB AES ciphers are
failing testmgr's test vectors.

|cfb-aes-ppc4xx encryption overran dst buffer on test vector 3, cfg="in-place"
|ofb-aes-ppc4xx encryption overran dst buffer on test vector 1, cfg="in-place"

This is because of a very subtile "bug" in the hardware that
gets indirectly mentioned in 18.1.3.5 Encryption/Decryption
of the hardware spec:

the OFB and CFB modes for AES are listed there as operation
modes for >>> "Block ciphers" <<<. Which kind of makes sense,
but we would like them to be considered as stream ciphers just
like the CTR mode.

To workaround this issue and stop the hardware from causing
"overran dst buffer" on crypttexts that are not a multiple
of 16 (AES_BLOCK_SIZE), we force the driver to use the scatter
buffers as the go-between.

As a bonus this patch also kills redundant pd_uinfo->num_gd
and pd_uinfo->num_sd setters since the value has already been
set before.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 31 +++++++++++++++++++---------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 06574a884715..920bd5e720b2 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -714,7 +714,23 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	size_t offset_to_sr_ptr;
 	u32 gd_idx = 0;
 	int tmp;
-	bool is_busy;
+	bool is_busy, force_sd;
+
+	/*
+	 * There's a very subtile/disguised "bug" in the hardware that
+	 * gets indirectly mentioned in 18.1.3.5 Encryption/Decryption
+	 * of the hardware spec:
+	 * *drum roll* the AES/(T)DES OFB and CFB modes are listed as
+	 * operation modes for >>> "Block ciphers" <<<.
+	 *
+	 * To workaround this issue and stop the hardware from causing
+	 * "overran dst buffer" on crypttexts that are not a multiple
+	 * of 16 (AES_BLOCK_SIZE), we force the driver to use the
+	 * scatter buffers.
+	 */
+	force_sd = (req_sa->sa_command_1.bf.crypto_mode9_8 == CRYPTO_MODE_CFB
+		|| req_sa->sa_command_1.bf.crypto_mode9_8 == CRYPTO_MODE_OFB)
+		&& (datalen % AES_BLOCK_SIZE);
 
 	/* figure how many gd are needed */
 	tmp = sg_nents_for_len(src, assoclen + datalen);
@@ -732,7 +748,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	}
 
 	/* figure how many sd are needed */
-	if (sg_is_last(dst)) {
+	if (sg_is_last(dst) && force_sd == false) {
 		num_sd = 0;
 	} else {
 		if (datalen > PPC4XX_SD_BUFFER_SIZE) {
@@ -807,9 +823,10 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	pd->sa_len = sa_len;
 
 	pd_uinfo = &dev->pdr_uinfo[pd_entry];
-	pd_uinfo->async_req = req;
 	pd_uinfo->num_gd = num_gd;
 	pd_uinfo->num_sd = num_sd;
+	pd_uinfo->dest_va = dst;
+	pd_uinfo->async_req = req;
 
 	if (iv_len)
 		memcpy(pd_uinfo->sr_va->save_iv, iv, iv_len);
@@ -828,7 +845,6 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		/* get first gd we are going to use */
 		gd_idx = fst_gd;
 		pd_uinfo->first_gd = fst_gd;
-		pd_uinfo->num_gd = num_gd;
 		gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
 		pd->src = gd_dma;
 		/* enable gather */
@@ -865,17 +881,14 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		 * Indicate gather array is not used
 		 */
 		pd_uinfo->first_gd = 0xffffffff;
-		pd_uinfo->num_gd = 0;
 	}
-	if (sg_is_last(dst)) {
+	if (!num_sd) {
 		/*
 		 * we know application give us dst a whole piece of memory
 		 * no need to use scatter ring.
 		 */
 		pd_uinfo->using_sd = 0;
 		pd_uinfo->first_sd = 0xffffffff;
-		pd_uinfo->num_sd = 0;
-		pd_uinfo->dest_va = dst;
 		sa->sa_command_0.bf.scatter = 0;
 		pd->dest = (u32)dma_map_page(dev->core_dev->device,
 					     sg_page(dst), dst->offset,
@@ -889,9 +902,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		nbytes = datalen;
 		sa->sa_command_0.bf.scatter = 1;
 		pd_uinfo->using_sd = 1;
-		pd_uinfo->dest_va = dst;
 		pd_uinfo->first_sd = fst_sd;
-		pd_uinfo->num_sd = num_sd;
 		sd = crypto4xx_get_sdp(dev, &sd_dma, sd_idx);
 		pd->dest = sd_dma;
 		/* setup scatter descriptor */
-- 
2.20.1

