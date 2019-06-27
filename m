Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193B2C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E20CA2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eUw//aDf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfF0MDl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33228 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfF0MDh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so6920241wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nRSkthjePIj7g4MPUvkNKe1xlTbjlaOSbMbpn6GWkys=;
        b=eUw//aDfanezv6Mu7JNEFlS8yfPy9YrpfjEmEwHF2u84mezCx8cXuN9i/Cw1//+mK6
         y09QMp0fMIGyeY2yNsc1Ruy/CsutxsDPbv0SHRkKHb2KGiZq6UktbqjsS0VJv658sukX
         QcmeaLC8qKDLXhwgMEY48CDaVHxMxmDOSLxCLNzrOoFLRITvdY2j0X/AyUQFny2QaEux
         CKz+qOfodRGRYCePYbappm+sYCxHHZscra4bPum8wjrlR+tmI/co3Mst2cA5BQH4IFSi
         iE/DUkTGCPcNGihUK3i/aRTJ6g/p6dxuAOOy6G/of28Pq9EMPKq9FafobPx64NPwueA5
         Rv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nRSkthjePIj7g4MPUvkNKe1xlTbjlaOSbMbpn6GWkys=;
        b=RLO2z2tFslOzzBVIVAm7u54OwNMvU13qU+3wm+MIThhI1FaV6vgPg9XVKRIm7+M0x3
         Bqe3gENw/dtsnJw5ePRXZn9YYdpKX1uwku+gjCKVhwFi78ba2L37kfik/WEAWpFlGU4x
         vuIj5v1ke+bMVxvxDVSWLyHNUA36H0RxTn+xEah5OUEEte/KNadMc8bZXwNgxuiNdWra
         CRp5OhPJTUBDMgg4gQMKDSo3RBxMcoicik81g2EhqR6EGk9/6+53g3ypW3WPWEIm65Da
         A8KAJdQJOJCsGehAeGD/gTI+owUvkN8jF5+Usn3ZaoKnQiLdtIlvb6ZZ+k/sr7ebN854
         HrMg==
X-Gm-Message-State: APjAAAWyhPwFPtxQswoDqa1Ndd+L4YqlDR2tC/s9PATjJZhJDiFjXBvx
        xaudeZlAyrPMZoKjiKAmFIQErZdlQW6Kng==
X-Google-Smtp-Source: APXvYqyyTQryJQ9XSojeXcLFALqBtE/kWsJMI2PSrd53Rv14E5CQ/CnsL4DiXKUzBfRbr6a718/utQ==
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr3161873wmc.89.1561637015092;
        Thu, 27 Jun 2019 05:03:35 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:34 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 08/30] crypto: nitrox/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:52 +0200
Message-Id: <20190627120314.7197-9-ard.biesheuvel@linaro.org>
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
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 7e4a5e69085e..ab8ac05f00a1 100644
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
@@ -257,8 +257,13 @@ static int nitrox_aes_decrypt(struct skcipher_request *skreq)
 static int nitrox_3des_setkey(struct crypto_skcipher *cipher,
 			      const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(cipher, key)) ?:
-	       nitrox_skcipher_setkey(cipher, 0, key, keylen);
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
+
+	return nitrox_skcipher_setkey(cipher, 0, key, keylen);
 }
 
 static int nitrox_3des_encrypt(struct skcipher_request *skreq)
-- 
2.20.1

