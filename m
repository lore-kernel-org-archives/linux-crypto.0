Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0959BCA9EBC
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33752084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HEX+83ux"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387593AbfJXNYL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:24:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34289 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387516AbfJXNYL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:24:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so20942686wrr.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lIZcqfC0xhMTbTw2eMsrTKpkwPVrbw6wba0eQebSEA0=;
        b=HEX+83uxGppuiEYtz0BN0OY3n15lrqBsTgXIjr1kLKborsEFlEAnqjvqySTWN/itZH
         9idihEpi5ygJCZHTUr+Rahl0sdt7awAfiEiiNfh9YQajTDdzI7EGKq4SksUx7HFKsKTd
         eSPMddzNym/6WaTm1xoD0/0cOdAfXjnh0W4TP5yDcLOSCdeHVD/8Z+bgCQEIKJR0UEf8
         pB+wbP6m5eSPhZKwfUGYK1M312r9+ytYS7VphNbLnyOGOayYrPH/O4pS0brzlfywDF4z
         HExQTP6sEthmV8PlnW9UUH2KsOz2a285tPkdU+ZBvp/raUtrnGt50m2PGelfYFYHGILF
         XUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIZcqfC0xhMTbTw2eMsrTKpkwPVrbw6wba0eQebSEA0=;
        b=bT3Gpa8rLfCTk2ZGJPUGMA+za+S1kdY8KiM0dZQHIVSaanoN+wDHNfHGYd//VFhLnq
         ty/m3MQ4qB7icNozRn7e3DFqG0+rp8mD7n4bA/OoDW3JXDyPvBlMMsSyZHEF0GI+VjD+
         NdiVcd2dg5TpEuE6+f+wpe8QQVTH+c8aH2XFguhk96NCEMo7bnzXk5di1v36mdHx4RJF
         FAizTHi5TGUcbZyC1J65cn2aBtcGv3O+tmdwgTn/Qu8rrqDeQM8DjAw63TVkL0hABbkG
         CGDYIa3cpHdbmk1bL7/PeYPeWwlDV03UofLIDwcmn0uJPA+8Cz7ougRGRRA6+gmr4oQk
         o1XA==
X-Gm-Message-State: APjAAAVnqRNtbRn+ech6ctloRWZBNCM7ifUptEQXQ7dv5IT+Q2qqJw8y
        NuhiJHuT/3hdS4ihvKaZL1ilwKO/W9trBuln
X-Google-Smtp-Source: APXvYqyiJvR8nSugvtaqqa222EL75kz7TBLfILj8bSxp/C3t2ll5+xsUD6vm0JSO1ClDtKBl4ieypg==
X-Received: by 2002:a5d:4382:: with SMTP id i2mr3957338wrq.387.1571923448698;
        Thu, 24 Oct 2019 06:24:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:24:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 11/27] crypto: nitrox - remove cra_type reference to ablkcipher
Date:   Thu, 24 Oct 2019 15:23:29 +0200
Message-Id: <20191024132345.5236-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Setting the cra_type field is not necessary for skciphers, and ablkcipher
will be removed, so drop the assignment from the nitrox driver.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index ec3aaadc6fd7..97af4d50d003 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -493,7 +493,6 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
-		.cra_type = &crypto_ablkcipher_type,
 		.cra_module = THIS_MODULE,
 	},
 	.min_keysize = AES_MIN_KEY_SIZE,
-- 
2.20.1

