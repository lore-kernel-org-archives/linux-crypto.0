Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3497EC282E1
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03E94206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 11:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tjp8SXOz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfDVL0H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 07:26:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51675 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfDVL0G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 07:26:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id 4so14069856wmf.1;
        Mon, 22 Apr 2019 04:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTvdBrVDEPSw1Qe1gZEOJsxviDk6CdfjxJvT+L/zDAA=;
        b=Tjp8SXOzrMESpmxjlBPjr3ZbIqxFoV5dI4A2R49YmaUMkmo5XTqIvoaLt3j2gnFW7Q
         FiqtF2mOn3RIfF5P4uhhJfsrSgif4nnfcQ57caQfrYCYa0hZJwrl88P2fRJw4xkyhdCB
         V7bDBYjlep5jdNvBWVpOT0IOjZNvc8QslBdqXxgAi5xb/ncfLVO55CBsXqGD8/4xDK6q
         VTlDYkltDB2NUAuQ3qlnyzcnvzksQrw4RkgjRrV2IQPnzIL0WxIBWjqSo0alfhxg6/L+
         3iRBtK2sSxyw7VEWqQ+KjEUfd50TtX0bd2TkEBOux+cqihmeKcpxkeEjvLPrfE6h6f/i
         fr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTvdBrVDEPSw1Qe1gZEOJsxviDk6CdfjxJvT+L/zDAA=;
        b=MngrBttMrYesfzcGRB65wddCn/JIH1+iL0xTJ/n4oK0Psk0g0JPUFG4ecWokV8SXIc
         IxJZOGMyQO2r8tZ6wc8J2WWHlRGp/O1XUmhyilvvB4VAo4japzc6K7fwqXPW8PqUgXM8
         YQ92qrnoJYxhX8Zr8zBx5g0EFmofj39k9beWZZqhyLIKmGqWdvSYZC9XLaofX5gZOhUo
         a0Qzi3mkWG1Kl6g65nkC37ETIY65wYQeFqdWMcd+axssDMODs3YzZLRFHi+7DnPCAcUg
         QypCX+ryqGsFpHrH84eG4pVx0ygXhbUOU/0Pu0cZrWQhVSoVi4urpY/KwoCotfHIsw4L
         UCIg==
X-Gm-Message-State: APjAAAXGy2B4XnNBo1XzvTjMTO17tnFJ/Sv0XMeVP5kE7J+sOo7ZripC
        L79S+q8eXmeJGXE2iQ8z29A=
X-Google-Smtp-Source: APXvYqwyluy6sBFqh6a9nIS4RkaQ7W1hpfM68JaIex4+YwlQy+dH7BEEuLhZS0/F5Zrnc5P6Hu4nQw==
X-Received: by 2002:a1c:6c04:: with SMTP id h4mr11985333wmc.135.1555932364322;
        Mon, 22 Apr 2019 04:26:04 -0700 (PDT)
Received: from debian64.daheim (p5B0D75EE.dip0.t-ipconnect.de. [91.13.117.238])
        by smtp.gmail.com with ESMTPSA id f1sm9964774wrt.87.2019.04.22.04.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Apr 2019 04:26:03 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hIX5F-0001VN-GW; Mon, 22 Apr 2019 13:26:01 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] crypto4xx: fix ctr-aes missing output IV
Date:   Mon, 22 Apr 2019 13:25:58 +0200
Message-Id: <4c860f87b9339da1d1f700ba6a56a7a5e2eb14da.1555932334.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 8efd972ef96a ("crypto: testmgr - support checking skcipher output IV")
caused the crypto4xx driver to produce the following error:

| ctr-aes-ppc4xx encryption test failed (wrong output IV)
| on test vector 0, cfg="in-place"

This patch fixes this by reworking the crypto4xx_setkey_aes()
function to:

 - not save the iv for ECB (as per 18.2.38 CRYP0_SA_CMD_0:
   "This bit mut be cleared for DES ECB mode or AES ECB mode,
   when no IV is used.")

 - instruct the hardware to save the generated IV for all
   other modes of operations that have IV and then supply
   it back to the callee in pretty much the same way as we
   do it for cbc-aes already.

 - make it clear that the DIR_(IN|OUT)BOUND is the important
   bit that tells the hardware to encrypt or decrypt the data.
   (this is cosmetic - but it hopefully prevents me from
    getting confused again).

 - don't load any bogus hash when we don't use any hash
   operation to begin with.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 4092c2aad8e2..3458c5a085d9 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -141,9 +141,10 @@ static int crypto4xx_setkey_aes(struct crypto_skcipher *cipher,
 	/* Setup SA */
 	sa = ctx->sa_in;
 
-	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, (cm == CRYPTO_MODE_CBC ?
-				 SA_SAVE_IV : SA_NOT_SAVE_IV),
-				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, (cm == CRYPTO_MODE_ECB ?
+				 SA_NOT_SAVE_IV : SA_SAVE_IV),
+				 SA_NOT_LOAD_HASH, (cm == CRYPTO_MODE_ECB ?
+				 SA_LOAD_IV_FROM_SA : SA_LOAD_IV_FROM_STATE),
 				 SA_NO_HEADER_PROC, SA_HASH_ALG_NULL,
 				 SA_CIPHER_ALG_AES, SA_PAD_TYPE_ZERO,
 				 SA_OP_GROUP_BASIC, SA_OPCODE_DECRYPT,
@@ -162,6 +163,11 @@ static int crypto4xx_setkey_aes(struct crypto_skcipher *cipher,
 	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
 	sa = ctx->sa_out;
 	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+	/*
+	 * SA_OPCODE_ENCRYPT is the same value as SA_OPCODE_DECRYPT.
+	 * it's the DIR_(IN|OUT)BOUND that matters
+	 */
+	sa->sa_command_0.bf.opcode = SA_OPCODE_ENCRYPT;
 
 	return 0;
 }
-- 
2.20.1

