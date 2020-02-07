Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF564C04EB5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 15:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0628214AF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 15:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fit4zGJR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgBGPDF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 10:03:05 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41965 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgBGPDF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 10:03:05 -0500
Received: by mail-qk1-f193.google.com with SMTP id d11so2457256qko.8
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2020 07:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+KsiVAJvgTf7V6v0DOa/NLUACdLizAHWtfht9qDR3k=;
        b=Fit4zGJR9rlBS6Mi8CgLoY7IBS5YAJ4qcquNhSUl927Xx6TPym+HCxM0NeaqeKiE3p
         MQR69echXgiTAt/cOysNVBi++gmd38dlAnJQtvuR4AQgPIkt3IS2l3nBfi/BIZdc5rVi
         T0O6d1RVHImn+fvRff4xo8sUsaXC7Rb6O4Ip46EjIp1UT48vUEm3GT35DW42HP9IcFbT
         PIvaxhY+p5+pAPQexruy1CmI9I15EA9DWYVBHWMaue1QlUplj7ngHeuW2ixtpO+TePTm
         nVo8bGtdQ8QXozJmVcTw3PvYCIkZia93FMz9YXcYIgtqCrvqB7sPoLMHv1Z9AbRgsNxf
         HIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+KsiVAJvgTf7V6v0DOa/NLUACdLizAHWtfht9qDR3k=;
        b=Lo3+TrWaUPsYwNa8vqg1bVspvoKlvAbNHM6sbiOJggmLOP/NCXJR60BDQSN1vNdMkT
         kiQqy8h2US3ox/gikPaZezFicjzU4XtLMOzg+6bTqq/8q40AboKLFkoji6R8+LnfEx9X
         eB0fPjun80ziAY1GzWAK1W7tlPH+a7ZTTAWWCNdaPt3Kb2L5iYUZVEMXaHwMzHk0VZ3J
         VB0N2BKYpxukKcDwXMzBOgTPoIUdHDE+s0itD18k1gz9mr9CXgqearvMlrlOM7Ve96yZ
         m9OuBmXdI11obo6rgwvlFXcqWMWL0EzUI0MfbCTo7zxsm+gDNNleBQZ1pLmzHDRqBvCY
         v4Qw==
X-Gm-Message-State: APjAAAUW4AVPvgTTc3C1gAtRpnM8+fqZW+6AQLt+5B9tVASVv8zAClbn
        VXPJU/A3htAXvbul0t0U1KR1pHvw
X-Google-Smtp-Source: APXvYqxm2lweBQJLRUIqaUZsqXEYWuP34WkA79r2gcy5te6bq0gIzwUjeNywze9WXei66ex+xntClQ==
X-Received: by 2002:ae9:dc85:: with SMTP id q127mr7538151qkf.460.1581087783461;
        Fri, 07 Feb 2020 07:03:03 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id c10sm420740qkm.56.2020.02.07.07.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:03:02 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v5 3/3] crypto: qce - handle AES-XTS cases that qce fails
Date:   Fri,  7 Feb 2020 12:02:27 -0300
Message-Id: <20200207150227.31014-4-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200207150227.31014-1-cotequeiroz@gmail.com>
References: <20200207150227.31014-1-cotequeiroz@gmail.com>
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

--
v4 -> v5
Adapted to [v5 2/3] paretheses change

v3 -> v4
No change

v2 -> v3
Corrected style issues pointed out by checkpatch.pl

v1 -> v2
Patch was first added to the series

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
index fc7c940b5a43..a4f6ec1b64c7 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -227,9 +227,14 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
+	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
+	 * is not a multiple of it; pass such requests to the fallback
+	 */
 	if (IS_AES(rctx->flags) &&
-	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
-	     req->cryptlen <= aes_sw_max_len)) {
+	    (((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
+	      req->cryptlen <= aes_sw_max_len) ||
+	     (IS_XTS(rctx->flags) && req->cryptlen > QCE_SECTOR_SIZE &&
+	      req->cryptlen % QCE_SECTOR_SIZE))) {
 		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 
 		skcipher_request_set_sync_tfm(subreq, ctx->fallback);
