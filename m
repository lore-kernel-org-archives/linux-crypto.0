Return-Path: <SRS0=bf8p=XK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7367C4CECD
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 18:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D1F20650
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 18:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDpr1LCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfIOSfz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Sep 2019 14:35:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51824 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbfIOSfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Sep 2019 14:35:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so7657485wme.1;
        Sun, 15 Sep 2019 11:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lspMjLiionZILkbBr8xfiqwsFdKOXlG6Qqe5s5HG7c=;
        b=BDpr1LCcQBR8RMm+cBgOIclbkpAVbLmO1JLnUiOzNq/PIurUa2s2f92YPB3ZKTopCR
         MRAYLgrv9CWU5oG5nOtlquC6N85TVGGYrMeARJJpdGLIPbcqgmTtBVT3DUCFKVY0hc7G
         n6oPbmLkQGjyqa2qVUur8LC5d/wrdeLfHreFpKuLEQJP5wKG1ffm+9gySglEj3TABwBr
         Ly/t0K+kQlF0ck4Eq8zAMfC2N8uLJYv8k6siXy7Ym69TVO6PQRTziISyR3pYSpbnudRD
         Msox/dobtnl8zwnoLyePA4tJ0Y+Y8JmYIauAE1rjoDMA9cu1/rsBySEUva62htVazwzc
         jUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lspMjLiionZILkbBr8xfiqwsFdKOXlG6Qqe5s5HG7c=;
        b=bjjcQWpjcz5X1rcblXt7SUKCUyAMLfZGFlwLbiWOx0PNrin6AHUDBXC7B8Y3C5ItEn
         YXSuxOk2T4ij1jZn2XOPaCnl8rnSgwTSBftxJmi+lsRhPWMnOk77MoLJtVT+6AYn9JIn
         lUEP1IHA9tOoGbNBsTsUI2XdOBbEaCAycDCaXFeBvoPC1X3Y4MM2tYOMWHVShXn+iA7K
         Gyv5igUa2T7EgpDVfd4mJkuEs5TDW0dZdD64rDHM0XZo9eSGJgUMlV/hvL9hdugFwzlH
         1bfCU6wCmTc60AJzl8ZZQQsyLoFUIDFftkuDn28K/rx3dZzMtdxFdPdDQQylNDgby7zV
         oE3Q==
X-Gm-Message-State: APjAAAXBbwt+mDUKqbGAnJ/PWJpRLVoMriDjNu08SIkuvVQui8DclRI/
        VZGDKU28k87YsAskiIsCDgQ=
X-Google-Smtp-Source: APXvYqxaHaJ3pIakOfUWi1LNN/GOhxVtf6MMn4HmvmZuJr5tm/FKdc97pvTfhJrcS2rbUqLHLMFrzA==
X-Received: by 2002:a1c:a94b:: with SMTP id s72mr11109366wme.9.1568572551931;
        Sun, 15 Sep 2019 11:35:51 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id t203sm11365202wmf.42.2019.09.15.11.35.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 11:35:51 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] crypto: sun4i-ss: erase key after use
Date:   Sun, 15 Sep 2019 20:35:36 +0200
Message-Id: <20190915183536.3835-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When a TFM is unregistered, the sun4i-ss driver does not clean the key used,
leaking it in memory.
This patch adds this absent key cleaning.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org> # 4.3+
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index fa4b1b47822e..60d99370a4ec 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -503,6 +503,8 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
 {
 	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
+
+	memzero_explicit(op->key, op->keylen);
 	crypto_free_sync_skcipher(op->fallback_tfm);
 }
 
-- 
2.21.0

