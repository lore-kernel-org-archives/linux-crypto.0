Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E50C352A1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A332082E
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 01:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yzoy27x5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgBFBVS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 20:21:18 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:33443 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBFBVS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 20:21:18 -0500
Received: by mail-qv1-f66.google.com with SMTP id z3so2125605qvn.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Feb 2020 17:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/1ESwDUhgAeafD/n9eQRw0vfxop8NhHhhipL993I18=;
        b=Yzoy27x5oB7SlIsr9zJTlbGsD97xzfzNH7pWz7xHtEFlg93rge+hgbp1jmkCqZtyzc
         SMp6dzgWH7I82GRt4CN28BTxdAaMlTVkk+AwEz5JLZuX07jzz9GR1i0uJGvRGsS3u1KE
         f31tya7JTg+VWh7MAsYQ4Ka97exDPjO13KphLT0bem3I/UD5Y7I/YCsisT255+j59yoY
         TNrA+EPYc9yg4lXQS73GuUPeImnS1qGr/DxFHrmooEEFTjv3K5P5hiSISKl9K+nQhHxK
         f6ysZMpUOSO6JjVs3hrszpg6HxLBR9N0zctHGZKhqt4nQ9UEeigBow8Ok2ZhCpE/IR2f
         Z4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/1ESwDUhgAeafD/n9eQRw0vfxop8NhHhhipL993I18=;
        b=XhRLWwTQv9U9hK7SFEziq4/tW+R5naUTNM9/P80F9bQmuFX2fbM1VI2HehfacxzAH2
         WO0AGpzy3ls/UG7qZMUByOB0ujgj1oKoGB8Lt3dub/CJn54ZJ8SHuQaOLNMlig4WpiSx
         Uz06Z0e4Q/8PwFt3+fzmipJSewzRlXoiIYnJj1H+QuWXae4TzReC/D8HW4Hv0yfftrcx
         pPUGUuwcaDGj44jC6XW5OfNejUpOEASegusjgSYX/dgA4qjifnTFK0IcT2auI6xmwU4o
         xZAxRTY2XyVVDQ4Kr7pgSjLWpvFo+UaiMTxGSMr8EeyypdsMSEZV5KJBEy0XnJhAXuB5
         WK0Q==
X-Gm-Message-State: APjAAAUfxnvPc6gp05wYQn/0krAjykMne9Zj8mx9t82lPdZk+knXVsFf
        YUn5nVP7sWEF94+O9xVyYtXNlcAT
X-Google-Smtp-Source: APXvYqzL8nfOo4sTh2ApTRJEul1egqV3793D2YGxn98hRolmj2RJGr+YYwVP1zsw9FJAfGHg4RK6/g==
X-Received: by 2002:ad4:464e:: with SMTP id y14mr401993qvv.143.1580952077117;
        Wed, 05 Feb 2020 17:21:17 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id c18sm719729qkk.5.2020.02.05.17.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 17:21:16 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v2 3/3] crypto: qce - handle AES-XTS cases that qce fails
Date:   Wed,  5 Feb 2020 22:20:36 -0300
Message-Id: <20200206012036.25614-4-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206012036.25614-1-cotequeiroz@gmail.com>
References: <20200203165334.6185-1-cotequeiroz@gmail.com>
 <20200206012036.25614-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QCE hangs when presented with an AES-XTS request whose length is larger
than QCE_SECTOR_SIZE (512-bytes), and is not a multiple of it.  Let the
fallback cipher handle them.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 629e7f34dc09..5006e74c40cd 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -15,8 +15,6 @@
 #include "regs-v5.h"
 #include "sha.h"
 
-#define QCE_SECTOR_SIZE		512
-
 static inline u32 qce_read(struct qce_device *qce, u32 offset)
 {
 	return readl(qce->base + offset);
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 282d4317470d..9f989cba0f1b 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -12,6 +12,9 @@
 #include <crypto/hash.h>
 #include <crypto/internal/skcipher.h>
 
+/* xts du size */
+#define QCE_SECTOR_SIZE			512
+
 /* key size in bytes */
 #define QCE_SHA_HMAC_KEY_SIZE		64
 #define QCE_MAX_CIPHER_KEY_SIZE		AES_KEYSIZE_256
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index a3536495b6b0..b7c0aaddd7d9 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -227,9 +227,13 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
+	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
+	 * is not a multiple of it; pass such requests to the fallback */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256)
-	     || req->cryptlen <= aes_sw_max_len)) {
+	     || req->cryptlen <= aes_sw_max_len)
+	     || (IS_XTS(rctx->flags) && req->cryptlen > QCE_SECTOR_SIZE &&
+	         req->cryptlen % QCE_SECTOR_SIZE)) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
 		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
