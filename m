Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A5BC35247
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 21:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3955220720
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 21:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ays4k29y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgBFVCs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 16:02:48 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39277 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBFVCs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 16:02:48 -0500
Received: by mail-qk1-f195.google.com with SMTP id w15so68854qkf.6
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2020 13:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p+/JuyW4us5GRMHekSlNiyHwnxrpzKYQWiN0BPd3e+Y=;
        b=ays4k29yRF7fVVbOr37GIn/gjqZ7QUFTZPPYXPzthUsCy0dTUjsw+DPQOexbOXc4Ha
         WjHHq+wpzWs1xaQ4+TykKW0y8sIlNHzMD1udYpLd5VTqJuROlWtr6SzvTNdWCVYgJqLZ
         PhG74E5mqA7irh7fkbmdmo73VcE2C6ULboUfkunRpHe0gBZ1jcY+1Ff/1wjpzpPzzPzV
         1I/f/IoiBkCHlImVgV3YWwFqAycQN8cXWRpEpku5QYX9hIw3ILKBpIfSynSbhwsJ21zF
         YRUq1TkBXtvWjwrcXIELsiMBvyKDucxqkYHbBTL/PAErGWRB0iRGCCl2QkwaqgU5X+XL
         sKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p+/JuyW4us5GRMHekSlNiyHwnxrpzKYQWiN0BPd3e+Y=;
        b=HMgJeQQSPnHwN3u2bKpbRX9IRPSU0Q6/737u9Zv1YSrzYBFH+eR7R1H0ZT4uAaKD2f
         MRdB34D+XuyzMIF4AJXK13s04RXOgt5kje6JhGchF06VmOwmbni+nW5cOSbMtznOL5dN
         6nNuNdPN9KhtCRtyHXfM3q1zOIR8ivIAbgkFDrAPoF3V+Mws2DaeUYt8ujfmYzCY/Vne
         xD9u8T07PJj7P0mCiia4j80lATCBa7+LGty0xKj52E/WUHKe8BHGORWUY2qQiEmXN3Tm
         vnV/ScOF+g5Hp9F/EE1E93Xe8xt1tnz+GA/XZ+MNdF8VTpNyCOHJeO/ROfkpIzQQUfHD
         AXhw==
X-Gm-Message-State: APjAAAXDFxK3F+zW+9Y26oXVl/n2d+hvQQfQM4VF8PQ2cg0XfY21gXiP
        oI6/w0MdNa9tGsbuhuF03jwdxa0q
X-Google-Smtp-Source: APXvYqyC4hQwlcLi6S4ru7ziahVM4yZPSZ9TB4Zy5OeI33q7llka67Ko7KtxLRF3vdnOyZhk1Jc3lQ==
X-Received: by 2002:a37:4a51:: with SMTP id x78mr4047482qka.445.1581022967257;
        Thu, 06 Feb 2020 13:02:47 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id o12sm252869qke.79.2020.02.06.13.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 13:02:46 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH v4 3/3] crypto: qce - handle AES-XTS cases that qce fails
Date:   Thu,  6 Feb 2020 18:02:07 -0300
Message-Id: <20200206210207.21849-3-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200206210207.21849-1-cotequeiroz@gmail.com>
References: <20200206210207.21849-1-cotequeiroz@gmail.com>
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
v3 -> v4
no change

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
index e55348bba36f..9458db683679 100644
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
