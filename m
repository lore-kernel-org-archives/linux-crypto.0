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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9719CC2D0B1
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D86720661
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 11:41:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uMw7orJq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgBFLla (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:41:30 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33527 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFLl3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 06:41:29 -0500
Received: by mail-qk1-f196.google.com with SMTP id h4so5210652qkm.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 03:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qu7ooKR6DgewFpJKq46pIZD5BtoS5iVf4kRfIooEK68=;
        b=uMw7orJqxVfVoqrcXx0BZGUZ+WbJ8MWHwzr0LEbX7sRPEToqOismvLQvjvzsPRm6EV
         relXJWugDDne+z2RIgHhAQI0s96cxg1lsaBrNuWvBSRVXzcGichpSfNVFYauMBCPhqK6
         41htdGPLxqm3x97QXsT+dFMP0zOvFaZfsm5dvQ1aa6qn1vrLlGddLTcDxomHkYMr+s6f
         bQYbe/X6kVMxLq0BQaKbX7RfZRxXoT3dEpgu0uv38wnliCbLMdP4q66enJq6MygWKUoB
         QYgmXbGAXtUN3dgQbcvrCQdBuo2vEjvSOyHToDDESClEa0HLKhYwe29L0nYL2D8OoLAa
         HX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qu7ooKR6DgewFpJKq46pIZD5BtoS5iVf4kRfIooEK68=;
        b=EFeOgveBJHG0Uw8stMaIFUcxk9uLzM4v31+GN6UOxr68IeWTA7rYupq1VxqudfI0jk
         H+CjMKSijI89cdcWRNiNtlyRz6gdl4pcHTi7dKunWLBp1dA8pEjrPppnjJDlFErJ89XE
         c+e8OvB7iQ5mZgZuJmY7rFalPy0LagKnz2jPnNmbU0PdXXvIyfCCcWr8pXzEEnVmngOq
         +qRN5f4CgLqTpC+JwCv1Aym6gRsot8ZBPGLVW6oi5z9gqKYqL28KNcYVo0+qNHB2OAcy
         4qQV7xFy1yTJjMAbYTE7oj1xzlY+mMoGfqMVLWN71oTud47URT7pPVtEZVeU9ZBU8C2I
         QGBQ==
X-Gm-Message-State: APjAAAWIZpgpJg1slTYiTTFbHU2fArWVly4BEDSkuj0OdiEAEonb5KZ/
        qO1qitwqNqBU/UQvUg7yr09k5JWs
X-Google-Smtp-Source: APXvYqz2djPdV8c6dNH56nUw3S8TWpzDUui5mnIAp7hN7MlCw7kq9F9soVW/CYW7HEv5Pifr2q0S3g==
X-Received: by 2002:a05:620a:210b:: with SMTP id l11mr2014170qkl.69.1580989288654;
        Thu, 06 Feb 2020 03:41:28 -0800 (PST)
Received: from gateway.troianet.com.br ([2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id g37sm1507283qte.60.2020.02.06.03.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:41:28 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v3 3/3] crypto: qce - handle AES-XTS cases that qce fails
Date:   Thu,  6 Feb 2020 08:39:47 -0300
Message-Id: <20200206113947.31396-4-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206012036.25614-1-cotequeiroz@gmail.com>
References: <20200206012036.25614-1-cotequeiroz@gmail.com>
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
index a3536495b6b0..377714cea23a 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -227,9 +227,14 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
+	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
+	 * is not a multiple of it; pass such requests to the fallback
+	 */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256)
-	     || req->cryptlen <= aes_sw_max_len)) {
+	     || req->cryptlen <= aes_sw_max_len)
+	     || (IS_XTS(rctx->flags) && req->cryptlen > QCE_SECTOR_SIZE &&
+		 req->cryptlen % QCE_SECTOR_SIZE)) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
 		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
