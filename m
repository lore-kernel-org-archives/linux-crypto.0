Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2110C282E3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7119F206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7iCTAq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfDVL0H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 07:26:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38293 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfDVL0H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 07:26:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id f14so14868557wrj.5
        for <linux-crypto@vger.kernel.org>; Mon, 22 Apr 2019 04:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gw1Y1hBBLyajOdGRaJLbJoO/PxkJfUPf0LJQPWkaM0I=;
        b=D7iCTAq+hY107OlqVpJxOXs9d2kItATHbBPIDafkgLJTQ7sQb6NuedwTSLShsHXpN3
         XMAcWUacJ3fMgP0ohReq5KRnn0BXCx7tC52PqiqZAqrb02D6mZ+CUGlxb7ckL4tz15+N
         atBR5U4WPpNoWNN4R7NJn9KmNkd7rERYyVivuvlFY5ULW8pcYMnRLy2KFHWUfVrY7VyO
         9Kgbazu8WjL8Cm1vARD8cNTriK6dKj7fzsaEay59rsNAMp6/IZGKf71Vukr6DxBOZ2jM
         buxT9X/T3ZbpCLHdYj0OkKlG8APNZN9mxzFXhmqsnvXJD8/LcRXGNElw4E7kTsDETiZL
         klvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gw1Y1hBBLyajOdGRaJLbJoO/PxkJfUPf0LJQPWkaM0I=;
        b=Y+ZfHzM7LpQW8M9tihGD8v2K4TLEFNBRhr5yv8M9vm9k+yUsugQnGE4ejRcotDIa6/
         E/hymug+QRPAaKGZMxPeTAcfU3zeu8UVqg0Mhpqf+n0sNqfPtCYjKspLZNu2n4qfV7ZB
         zE/jSyhXfa7Rea4rfWplqF8Ko/BEHzXkZB79+r5wazd5oBtLABXJoMxqKpD4A9InGcb1
         UxK47a1vqkHI7ZS78T/oKZtD7XXcKd1QZF3ICGsX0tWdhhr4SY3+qVUADkI2nmCqKtBK
         lTboljdy2V0jimBWGU9oK0UkTE8oKP/n9wvulwR2Cq1+Rb+DVEDDP5iH0zx9bnOVqzUj
         B4Mg==
X-Gm-Message-State: APjAAAVCm2n0xgJG1ZPaflDPcK2UWsVjT8WVA4S84qfyRUWjSeqHki4d
        uw4D2hv9kccwL/nXU3TQ7qpvuT1q
X-Google-Smtp-Source: APXvYqw/wveRT1EcG3WQr4dkXDNbCDyuVqKc1/U9hHyhtMO3tCwDFQI19So1u2UgOIm08FEwG63Ndw==
X-Received: by 2002:a5d:5308:: with SMTP id e8mr12706704wrv.126.1555932365136;
        Mon, 22 Apr 2019 04:26:05 -0700 (PDT)
Received: from debian64.daheim (p5B0D75EE.dip0.t-ipconnect.de. [91.13.117.238])
        by smtp.gmail.com with ESMTPSA id g84sm16548952wmf.25.2019.04.22.04.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Apr 2019 04:26:03 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hIX5F-0001Va-J8; Mon, 22 Apr 2019 13:26:01 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto4xx: get rid of redundant using_sd variable
Date:   Mon, 22 Apr 2019 13:26:01 +0200
Message-Id: <16e18d2da9db4d4b715f7e73896f65e57592b4e0.1555932334.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f2832f561a239db6dff6da5550e6c97913a70b02.1555932334.git.chunkeey@gmail.com>
References: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com> <4d8f4f483feb713126bbdb789b095936819d9804.1555932334.git.chunkeey@gmail.com> <f2832f561a239db6dff6da5550e6c97913a70b02.1555932334.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

using_sd is used as a stand-in for sa_command_0.bf.scatter
that we need to set anyway, so we might as well just prevent
double-accounting.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 6 ++----
 drivers/crypto/amcc/crypto4xx_core.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 3e7d24ff3fa6..3934c2523762 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -539,7 +539,7 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 
 	req = skcipher_request_cast(pd_uinfo->async_req);
 
-	if (pd_uinfo->using_sd) {
+	if (pd_uinfo->sa_va->sa_command_0.bf.scatter) {
 		crypto4xx_copy_pkt_to_dst(dev, pd, pd_uinfo,
 					  req->cryptlen, req->dst);
 	} else {
@@ -593,7 +593,7 @@ static void crypto4xx_aead_done(struct crypto4xx_device *dev,
 	u32 icv[AES_BLOCK_SIZE];
 	int err = 0;
 
-	if (pd_uinfo->using_sd) {
+	if (pd_uinfo->sa_va->sa_command_0.bf.scatter) {
 		crypto4xx_copy_pkt_to_dst(dev, pd, pd_uinfo,
 					  pd->pd_ctl_len.bf.pkt_len,
 					  dst);
@@ -887,7 +887,6 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		 * we know application give us dst a whole piece of memory
 		 * no need to use scatter ring.
 		 */
-		pd_uinfo->using_sd = 0;
 		pd_uinfo->first_sd = 0xffffffff;
 		sa->sa_command_0.bf.scatter = 0;
 		pd->dest = (u32)dma_map_page(dev->core_dev->device,
@@ -901,7 +900,6 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		u32 sd_idx = fst_sd;
 		nbytes = datalen;
 		sa->sa_command_0.bf.scatter = 1;
-		pd_uinfo->using_sd = 1;
 		pd_uinfo->first_sd = fst_sd;
 		sd = crypto4xx_get_sdp(dev, &sd_dma, sd_idx);
 		pd->dest = sd_dma;
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 4ecc34fa8ebd..c624f8cd3d2e 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -64,7 +64,6 @@ union shadow_sa_buf {
 struct pd_uinfo {
 	struct crypto4xx_device *dev;
 	u32   state;
-	u32 using_sd;
 	u32 first_gd;		/* first gather discriptor
 				used by this packet */
 	u32 num_gd;             /* number of gather discriptor
-- 
2.20.1

