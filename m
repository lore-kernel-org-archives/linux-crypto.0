Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AC1C63797
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Jan 2023 12:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjAOMQN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Jan 2023 07:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjAOMQL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Jan 2023 07:16:11 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AEFEC77
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:10 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso26886809pjl.2
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wohviZ5AvrjkuM7pQcDlfVJrclFly2Iud3REWsRmAw4=;
        b=lY7pD+T5ac0vU7tN+oT3cgxBrTlrow27QBa+Ul+yDnwo4ujhty+UqIMla6wQh4uopA
         fLdjIO/298xMCdgXYXH+755sNG07yPI29YYubpWXM+DG2Ejegv+d9yv/5uq6ejresUPQ
         wPUoPF4dznYt7YVMz9m6PaLnTAxIfO26e8foeMXuZmiQVa7xoKb9SD3FXjG1Hko/YSaW
         bcx+QG1E0JZGvhauEG3Q6r7Acnq7SA0R32MqsN0fuRcAjK51mHcbVW3cgVkrFlBsHq7+
         d7rFXFqzTYMA/z1MaXzsx6EJpTzidg9jDuliX1ky7DEiPguf4YBJxj/Ek4Df4mbumQri
         BAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wohviZ5AvrjkuM7pQcDlfVJrclFly2Iud3REWsRmAw4=;
        b=gAnGsypLhhCp1NGBEPGsDvzL/1my3+TOO8KZhr08qWIAqWRYn2TsSsVByinJrXWmLk
         GZHow2Bu9s6ydybHhpooYMuFGZ1d9j+ge/fubYpOfmBQg0jx1cP1KXBD0V1JxkOrJiVA
         d041XLXGqU3FgNJYGzExTltqp9jy+VnxnMaOhgkGAa8ikYMxWeFQRlmZUIUdsdrWTGLk
         mGdcdxuYKcsCeLLzU8boZd7yu0KnzbKXsAkqxYcOrvUv7vAQhFch9UzoiToRzvryp5vd
         m4ftbdvRoA2FX4wI2EWWRibOVHD0rj5ZS56A8wpwnrYz0+mHzhvm4EGDR03HMcnZ3Bs3
         vgkQ==
X-Gm-Message-State: AFqh2kpaRvNTRN13D3gRgCoebphDVPpIP+N6Jq4amM0h+Nc5hH3ytI5d
        On1nq/BtKUfPedHAa2CE20yZqdlBSKo=
X-Google-Smtp-Source: AMrXdXt4FAh+3/A863+VTauLOL/OD890p6vjJkx4xKG3mU4iSXKS8R9xQwU5CNQ9MhurdLHBFo+v9w==
X-Received: by 2002:a17:90a:8a84:b0:229:3660:1759 with SMTP id x4-20020a17090a8a8400b0022936601759mr7866277pjn.25.1673784968666;
        Sun, 15 Jan 2023 04:16:08 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e13-20020a63e00d000000b00485cbedd34bsm14361783pgh.89.2023.01.15.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 04:16:07 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     jbeulich@suse.com, ap420073@gmail.com
Subject: [PATCH 3/3] crypto: x86/aria-avx15 - fix build failure with old binutils
Date:   Sun, 15 Jan 2023 12:15:36 +0000
Message-Id: <20230115121536.465367-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115121536.465367-1-ap420073@gmail.com>
References: <20230115121536.465367-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The minimum version of binutils for kernel build is currently 2.23 and
it doesn't support GFNI.
So, it fails to build the aria-avx512 if the old binutils is used.
aria-avx512 requires GFNI, so it should not be allowed to build if the
old binutils is used.
The AS_AVX512 and AS_GFNI are added to the Kconfig to disable build
aria-avx512 if the old binutils is used.

Fixes: c970d42001f2 ("crypto: x86/aria - implement aria-avx512")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 arch/x86/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 688e848f740d..9bbfd01cfa2f 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -325,7 +325,7 @@ config CRYPTO_ARIA_AESNI_AVX2_X86_64
 
 config CRYPTO_ARIA_GFNI_AVX512_X86_64
 	tristate "Ciphers: ARIA with modes: ECB, CTR (AVX512/GFNI)"
-	depends on X86 && 64BIT
+	depends on X86 && 64BIT && AS_AVX512 && AS_GFNI
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
 	select CRYPTO_ALGAPI
-- 
2.34.1

