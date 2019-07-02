Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382F1C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12C4021850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OGT3WCj2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfGBTm4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37970 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTmy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:54 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so18182002ljg.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8YyWMi1jO77As8cVPxq35RAv7TeBcYZ2R24IVOGIcG4=;
        b=OGT3WCj2HtxECpg7NfJSpD1KmuRBU7NWq738rqhEeeKUAcPzuh4+Diky8oujOL9mj4
         v7wQBrB9gMcs4OCtaBgMt4XVu1Xq4xFvqZNzyFeTL1I6pt1sTUSCOdGVKlAgny9aXQR4
         QXP6c9NNP9e46o8tCroK/X6g0IIEwf9yFtiCeXs86wotXZNYjC+AbsEdJVKhiYGE6S4i
         h5v2inineSzvJF1S8CdrrtZZ6snzRDJ4KrduWH7nt+tffAph98tE+KhOkIhE6mb7MlQ5
         NdrAO4LyMyzbUYTG9GlyKBZ35b69yl7vJ1T17XRkpG5oc/6ZzGAEkkSr2aFd/9ElbeBB
         vVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8YyWMi1jO77As8cVPxq35RAv7TeBcYZ2R24IVOGIcG4=;
        b=uY37dpZMAjNE91kZ5yihpXMXc70meT/3DQuMxu+bVBnAodSXutCCowzwvMJfsUUea/
         rUEfH1elPa8CS0jrYlNoFobH8Suop2czVQc7LTDrBJPWIuDHm6ypwsiMNW95YTOageAf
         oHcwhVQ17c8eXLbHNOTRyx43KPlmjpty02c4xZQtn1D3DUbLJd7VM7QPuN9yflnLKrJL
         N1jU4MhbeA0QT+hAuBPc1t6fWmYHkb3VIEOgh/gsB95axWMOi5DjS1AnSmKLv2cUk88u
         5oW9YunyHS8fIRmrVJHEtjJ+vykqzY+gbFRcJUlXRankRISv+N7gQp9hFBhJexCFOALh
         pxLQ==
X-Gm-Message-State: APjAAAW8Ls9cmSB/2NnEuIs83IeICX4glRaEWTWHp9SGZebusfO/i/N7
        TlqIlzSxCNLI1htADOiLOWiey4zRkKCcLTc3
X-Google-Smtp-Source: APXvYqyPKkCqR+mI0pGDYve0Qa2c/LUBczCdiJ7J77KXWiX4p/TP6MwI99WF5X9eran4flHAs9heEA==
X-Received: by 2002:a2e:8e90:: with SMTP id z16mr18659630ljk.4.1562096572467;
        Tue, 02 Jul 2019 12:42:52 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 32/32] crypto: arm/aes-scalar - unexport en/decryption routines
Date:   Tue,  2 Jul 2019 21:41:50 +0200
Message-Id: <20190702194150.10405-33-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The scalar table based AES routines are not used by other drivers, so
let's keep it that way and unexport the symbols.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-cipher-glue.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/crypto/aes-cipher-glue.c b/arch/arm/crypto/aes-cipher-glue.c
index f6c07867b8ff..26a2b81c2c12 100644
--- a/arch/arm/crypto/aes-cipher-glue.c
+++ b/arch/arm/crypto/aes-cipher-glue.c
@@ -14,10 +14,7 @@
 #include <linux/module.h>
 
 asmlinkage void __aes_arm_encrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
-EXPORT_SYMBOL(__aes_arm_encrypt);
-
 asmlinkage void __aes_arm_decrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
-EXPORT_SYMBOL(__aes_arm_decrypt);
 
 static void aes_arm_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-- 
2.17.1

