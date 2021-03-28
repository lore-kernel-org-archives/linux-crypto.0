Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3258C433DB
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Mar 2021 01:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3CB61991
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Mar 2021 01:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhC1Bk5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 21:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhC1Bk5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 21:40:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96F5C0613B1;
        Sat, 27 Mar 2021 18:40:56 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so6926062pjb.1;
        Sat, 27 Mar 2021 18:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EYlwxcDk4ihQ5s3x3P7ksmY5Gg85jPzumVOLCa8dw0M=;
        b=o1Fc+wj4hv6iR8+09o6x3h0lu6UgGFnCqykm7zGC6oKgvj1d3pAk4ZGy7V2PAfJ7lA
         enKq88Wj5vpdBPLqpUz7fwaNBvsBZEMvAE9xAm21iXiwNXIxGE49Gcd96DvuTX97qBEg
         duKeSA0Yt/vgV7mMrwTktXrdXXoX4IOiPdzKy1BRjD2ruQj9D8wXEbah5jaGJx0dWuyQ
         T5hehJaX6TQFUce6XRXMIlZ568ApRk7QA62mTXOHaxpVZjdwRtBqtoMhghAIQuHUe8fo
         7jrrOFVyX2nZpz6OdLcWtmOj26EQ79ZOyr6u8nY5NITEPLlcx772b46ArwgYF0xizZ1/
         87oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EYlwxcDk4ihQ5s3x3P7ksmY5Gg85jPzumVOLCa8dw0M=;
        b=sGdUa5ylgAQQ35Uy1anBFFDxjjZemo/sB1XSd0uQYDA0YhLOvI/fh1VbUJVrDP4Yd5
         h5Igbu3SUFWpBvkPDki7d4s+4gGt2zF4uysPyxjjIqRmGvRCdf7BQmBcPsovCEYtWXuv
         qFeTzVjIDsCcIh7IDu24ehBRy7ebJeZeoHic0zCeRiYFrXq6la2nLKhwC5J21cgNbVWA
         kdRHUkR37TKVbBq56riu/4aQXnCpt2abYSKA3ZNcVC5++5+TTtFPwbfNpKKF8bciwsZf
         iQUECSq88xBTInkgPtxn/HgSxCw92pK6Yp8tSlNqh1rx+MIDw9xp6WnQOEDC68/kBz4x
         XJqg==
X-Gm-Message-State: AOAM533HWIFAq1IKSjI8AOjaptQ45FL3rz7xCUw3Hqkjn4BcURb+Q7/b
        EZHFVGgwmanM7h7q0sxJa4ohO8+Q/SWZozmY
X-Google-Smtp-Source: ABdhPJz9ViHiVzmx5Hcb5TBLwpVFQooCzsrwwjUY+1aG18ShcUakO4gHC8rgIJjJM+ihDMsJWxkUkA==
X-Received: by 2002:a17:902:c60b:b029:e7:3b60:34ad with SMTP id r11-20020a170902c60bb02900e73b6034admr2614094plr.7.1616895655852;
        Sat, 27 Mar 2021 18:40:55 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id 27sm13477476pgq.51.2021.03.27.18.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 18:40:55 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-crypto@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: mips: add poly1305-core.S to .gitignore
Date:   Sat, 27 Mar 2021 18:40:52 -0700
Message-Id: <20210328014052.8645-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

poly1305-core.S is an auto-generated file, so it should be ignored.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
---
 arch/mips/crypto/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 arch/mips/crypto/.gitignore

diff --git a/arch/mips/crypto/.gitignore b/arch/mips/crypto/.gitignore
new file mode 100644
index 000000000000..4882ba199071
--- /dev/null
+++ b/arch/mips/crypto/.gitignore
@@ -0,0 +1 @@
+poly1305-core.S
-- 
2.31.0

