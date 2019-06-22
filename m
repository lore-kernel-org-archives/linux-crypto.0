Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2794EC48BE0
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8262084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LBDjv8Xx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFVAbz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39197 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVAbz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so8094331wma.4
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=92I3Q15kMAvGJYoPL2kO9fMeWG/QF51hQZh+CfnwyBs=;
        b=LBDjv8XxLfee39Wm3xMYXaiNilyhIaY/2GH0kCwHHUtMfBamaXv55VDVqjvu1IJQSX
         4/ozgWQ2h1Je/aD4DRWRolwtDvPaWTjZ+BFLo/0Pg/dMfduGnPxgi4BWKtjBLQ4lOOGv
         7xjaWjX+n0NJlqpceducq2VjZRkOvn1zAznnSJKMZOz6X3DBrI2b8vYoVugdvgxZW0JZ
         dW4zYi0GwvP7BkEhpF4sj7XsuCWdJZ3O47Z40dAE89+LgT8E8FSPC0Sl9iGVb3qtpbPZ
         jR32DcTA/7WC6aiNk1BFOJGkHOUHXnORtN3qLA5AsUrAza2qZKo8d2sjRsuGZVq57xhn
         zKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=92I3Q15kMAvGJYoPL2kO9fMeWG/QF51hQZh+CfnwyBs=;
        b=E01UX49vZ4/4FZ/JD3rBsSHp2ApXMV7jHvhW5wm9fpSIw5ZHxyL+MNLH/VWFqdij/C
         697j/vSiDFuwTQz8uIAuJ2rxuiN+1GcI9Y5BD8jvZ6ENC+5blfVH17zW0Rt0nIr28eGx
         xb5/VCP9kJH0BLgTTTxi1qR+PyOYUlevLI3PcuJPjhhxR7GgcUe0HigzmDUBJ15ph/Ad
         PGWwnuSIh5CyAluoAF4PK27wz7prCLhFWeF7K/JuIVmR6YL/awd1GMwRsf23eGidh/JC
         xbt1FD7CNz7ShT+z+I3/JSI6mdOyteFGcXZwMFNFSHNSWzySMquGQm7W6denuFl+gobO
         0Vog==
X-Gm-Message-State: APjAAAUSEAzgpkmY0NUGhNWrvJaxAXVJ0FcZQx/L9gTeXw35qvhWyHJ3
        0+JdL0qJWHMuIw2kGDNS33SuMqBuYpI3W4YN
X-Google-Smtp-Source: APXvYqzAt1ajEwMFfc7/P2yQ63mZT5Lt6ldNavNTFYrT0b2Ppl6JqFuP6xtuXFigFyBDeI8KH7STqw==
X-Received: by 2002:a7b:c301:: with SMTP id k1mr5436642wmj.43.1561163512819;
        Fri, 21 Jun 2019 17:31:52 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 08/30] crypto: nitrox/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:50 +0200
Message-Id: <20190622003112.31033-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 7e4a5e69085e..927915b285de 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -7,7 +7,7 @@
 #include <crypto/aes.h>
 #include <crypto/skcipher.h>
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/xts.h>
 
 #include "nitrox_dev.h"
@@ -257,8 +257,14 @@ static int nitrox_aes_decrypt(struct skcipher_request *skreq)
 static int nitrox_3des_setkey(struct crypto_skcipher *cipher,
 			      const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(cipher, key)) ?:
-	       nitrox_skcipher_setkey(cipher, 0, key, keylen);
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(cipher), key,
+					 keylen);
+	if (unlikely(err))
+		return err;
+
+	return nitrox_skcipher_setkey(cipher, 0, key, keylen);
 }
 
 static int nitrox_3des_encrypt(struct skcipher_request *skreq)
-- 
2.20.1

