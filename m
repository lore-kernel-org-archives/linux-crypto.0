Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71553C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46ADE20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lxl9PrJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfF0MDk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45076 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF0MDi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so2222286wre.12
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lHSDR9hXz2RwY61iATw9G3CVofBqY/r65kgmZpFGRhg=;
        b=lxl9PrJnhI5+1RKLQdy37HaAxqgTejXCmY77oXYc9yYiUbVPn49XRaatmT+GGeI7du
         s5aPFueXIDzd9HvnqxGNEspbrLMasMqHr1k1p6jpQNZgEt3mFabaWX/n1DR75ppSHif+
         Fy2LrQJIEl6XOqNF2YfJtN2ghAX0m1XfM7teupYfSZ/cGfcjI566xG3HUrJBzACTpEU1
         DqoSNy/av/IqQjyBr05PVtLvVQ+erHXjthP3HG48zW0gX3gMvSBWKiVK/bXCA14Jrq0c
         rFtoQUqamSfQ9+i/Np1nrdnlroxrOMP4Xd3FQrEfMYsdiIvIue1mlUFTb993je4CIrJF
         nCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lHSDR9hXz2RwY61iATw9G3CVofBqY/r65kgmZpFGRhg=;
        b=UNHRkhb4ubSnx2VSg7mf5dmF8RqyEzzboVu730KCEdYIFyfD5PrKE7MAM6SpzfNmo5
         OuwoEkECYWTufrLEt6srJX1p7+2jjWU7yFp6Z8st/m7jYNIps90pbsLoc0ylnyAdishQ
         e1hPDWvtaBKZyyafZS+PnhxiZYtxqIDOf850VNU7bJQ1a/wNsPbB4M0N9dL4K8X5syy1
         peAECNziOMvUeqQAyTaQRT9EdSldRuX6sabJFvIPOKAxfPHl9zNX645Ir9PPrjMv3nKe
         2/8tEvc50HV4WZB8V1Ea+sPObSPttKYoukpJ+okTgiYjmjdk48Cu3GGe4NONM/v34XoJ
         Scbg==
X-Gm-Message-State: APjAAAVxL3kMTPv7wzZa15dt/fIJYHObV58GbnYaeJTQG7iTuBy1OLzW
        c1byDldxZbBU55MF6NuLN5UHvgJmeBNH8A==
X-Google-Smtp-Source: APXvYqzhiDtihGTn5I8y3Tjztii3/fcnXma8G/A5OM7/ZE3EYeitfok2hLL/zwwFb+ggNG+H96Axcg==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr3117881wrp.312.1561637016060;
        Thu, 27 Jun 2019 05:03:36 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:35 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 09/30] crypto: ccp/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:53 +0200
Message-Id: <20190627120314.7197-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/ccp-crypto-des3.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 91482ffcac59..0ca0469d7a1e 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -17,7 +17,7 @@
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "ccp-crypto.h"
 
@@ -42,10 +42,9 @@ static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
 	struct ccp_crypto_ablkcipher_alg *alg =
 		ccp_crypto_ablkcipher_alg(crypto_ablkcipher_tfm(tfm));
-	u32 *flags = &tfm->base.crt_flags;
 	int err;
 
-	err = __des3_verify_key(flags, key);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1

