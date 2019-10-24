Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFCECA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1B32166E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CHB38qnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732125AbfJXNYe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:24:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54548 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731935AbfJXNYe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:24:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id g7so2829956wmk.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gafT1c0FgkNr2xD+zkDSgemAEsZK/gkAa/8lkYnPPKw=;
        b=CHB38qnmiIoWY26c3wRxuzk+ZOSa7lwUYBKbyXFt+GT9s2qCB78UmvViVvoiQM7QTY
         rW2Rcd6SGJIGgGVFNX0SJQXjO+WQVjD4QkIgV0+UI5iEFxbOyFlyTAx0uxmVAn/COzNa
         ZzY0Bz17VitJ6ppDTaokb69HwslnO20Mo6PNP4LQbUHsHC/kX1f+Al6G3aWrHGy7jvdv
         30OisuNk6PgBOI27Znki2YEYKb2BtGep5t8l/NUS1bxAoMb29C03ETB/wv32800J7BBz
         KwB8Gti8rHMxcu+7DWapIuAph1mtDeASezoAay2t19YtwNGS+qginVZDnBYSm5G+v2XW
         O0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gafT1c0FgkNr2xD+zkDSgemAEsZK/gkAa/8lkYnPPKw=;
        b=DJ2CmXCpJeRPmM8cRzQkY2H2CUQUOoGll5A/4jXJ0cxIPMSIPdKnnsaSXrJrPJcrVa
         NVsrZhL/3FkRFFenHLLINUSTtC9QTw3p9Y6F6EpPwv1a98eXaga/alpDV6p8Tjz3lwG6
         61RDSg2Q+9MVJ1/AKr58uRkLXFxRQYACGFar9tLq0+FxLHDURiGE660PHlUvAKQE5hM3
         GjiPXDWWz7expvNR9+Mrg1Hco8Jj4zJHzoWobjQRd3rd+NL+rG3MKz4ChpT3IqzglTEj
         Qawd/0xfVvzvgbdpuMGKoPqRVfOswNlg678MWQvfSBERMfhpHjB2hIQEeSVcFS6N/o5I
         RtOw==
X-Gm-Message-State: APjAAAXxan3IF8rIFVPqozu1O/Mn5MPushjY7o6UVLpz7aSjDFDwYPO5
        a5J/H3ZrzmzOO0rIxK94Zkh22HTmLMzY86tU
X-Google-Smtp-Source: APXvYqylavvVBkkME63FbqEWNpFeVOHYol92i8elmCht1vf/qMPHxvNflkj3oX9akZNufJ8WOdgm6A==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr4782947wma.16.1571923471290;
        Thu, 24 Oct 2019 06:24:31 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:24:30 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 27/27] crypto: nx - remove stale comment referring to the blkcipher walk API
Date:   Thu, 24 Oct 2019 15:23:45 +0200
Message-Id: <20191024132345.5236-28-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These drivers do not use either the deprecated blkcipher or the current
skcipher walk API, so this comment must refer to a previous state of the
driver that no longer exists. So drop the comments.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/nx/nx-aes-ccm.c | 5 -----
 drivers/crypto/nx/nx-aes-gcm.c | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 84fed736ed2e..4c9362eebefd 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -525,11 +525,6 @@ static int ccm_aes_nx_decrypt(struct aead_request *req)
 	return ccm_nx_decrypt(req, req->iv, req->assoclen);
 }
 
-/* tell the block cipher walk routines that this is a stream cipher by
- * setting cra_blocksize to 1. Even using blkcipher_walk_virt_block
- * during encrypt/decrypt doesn't solve this problem, because it calls
- * blkcipher_walk_done under the covers, which doesn't use walk->blocksize,
- * but instead uses this tfm->blocksize. */
 struct aead_alg nx_ccm_aes_alg = {
 	.base = {
 		.cra_name        = "ccm(aes)",
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 898220e159d3..19c6ed5baea4 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -467,11 +467,6 @@ static int gcm4106_aes_nx_decrypt(struct aead_request *req)
 	return gcm_aes_nx_crypt(req, 0, req->assoclen - 8);
 }
 
-/* tell the block cipher walk routines that this is a stream cipher by
- * setting cra_blocksize to 1. Even using blkcipher_walk_virt_block
- * during encrypt/decrypt doesn't solve this problem, because it calls
- * blkcipher_walk_done under the covers, which doesn't use walk->blocksize,
- * but instead uses this tfm->blocksize. */
 struct aead_alg nx_gcm_aes_alg = {
 	.base = {
 		.cra_name        = "gcm(aes)",
-- 
2.20.1

