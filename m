Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C8DC4CEC9
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 18:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F0C9206A5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 18:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gDWUdqbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389805AbfIMSgn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 14:36:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39587 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389788AbfIMSgm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 14:36:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so2897711wrj.6
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 11:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=pj41kIDb9Coue4E/MdelRN5iEuUFhPMsEolC9yFleNw=;
        b=gDWUdqbm1Ed95qny4mrCx8qNYok1fDg0pMqFxi5Oau1NrQhaAaZXWvKsthlK0RLmv6
         zEs2o21RT1+pHZY7lQnWlwkUGuB0TVTP1iwINFSIK22MFxpiSA8YfyVsvSfWMqyaEPYe
         uX1+4f6nYjHgfY40zHKR4S34CDUGqcy9ceQdg3p/0EKdDHP4ZAVvVlVhGlcgemNDsKcT
         FG6eHrMi01tFxZigeLDUMHPmYgODBnZNRvw7WTV8dOe2InZgpx0Y0CjmGB2cFrobcqTu
         j2ZtiIfJpiOXXL231q/3hdjXygYX2y+TsXjTqtudqom3ho7n5JjnQRnGfAdo7L4sofNa
         aCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pj41kIDb9Coue4E/MdelRN5iEuUFhPMsEolC9yFleNw=;
        b=Mg8UfbVqEE1m8kz3t/KoZzFrASy6O35bsei0x3sqPxaApzxzMeDGVHRSHam6+Nk5OG
         AJ0SvRr1UJ1Ar1pIQfLzWCHU4IUb+hMOjzw7B088AcHO7yxX6WWIHfe+BpmQteol+zUk
         55ZsDxgUAEvb22l6wXp0eWreE+NaLRMPa9xRT5kv127LJsL55eUpvfMR8tGM21OD+0Y7
         ov5UAK4cvJbUtZ2DPo6ekJiSEB8QO8W7ZmIcIvbds4BoSFjTNx78hUPO6QhNWMizbzs/
         fYajMI6rbRzgiacfI5lle9AQ3aSOzjm88PrDZlyHtYXrIJP4w0jrN9TGCkvsHSomTG7j
         mCtQ==
X-Gm-Message-State: APjAAAV9a9BdhLl9ePvLv8DKjECQ6nN8kjhfGmoYmSSUy9nf8PJ0RiYk
        fT5Hs4kKmUbsfHeGdU5jIf8KJxV+Dd9ZBPWZ
X-Google-Smtp-Source: APXvYqxoAdp2qOIhfs1UrkERTgr5SSXLDqQjs2MVZ8QcCSsZGUQlkWoSWix2JuF8nyN8WHO4SBQ7fA==
X-Received: by 2002:a5d:6846:: with SMTP id o6mr2911647wrw.73.1568399800446;
        Fri, 13 Sep 2019 11:36:40 -0700 (PDT)
Received: from e111045-lin.c.hoisthospitality.com ([135.196.99.211])
        by smtp.gmail.com with ESMTPSA id q10sm56216611wrd.39.2019.09.13.11.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 11:36:39 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, yvan.roux@linaro.org,
        maxim.kuvyrkov@linaro.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: aegis128-neon - use Clang compatible cflags for ARM
Date:   Fri, 13 Sep 2019 19:36:18 +0100
Message-Id: <20190913183618.6817-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The next version of Clang will start policing compiler command line
options, and will reject combinations of -march and -mfpu that it
thinks are incompatible.

This results in errors like

  clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
  architecture does not support it [-Winvalid-command-line-argument]
  /tmp/aegis128-neon-inner-5ee428.s: Assembler messages:
            /tmp/aegis128-neon-inner-5ee428.s:73: Error: selected
  processor does not support `aese.8 q2,q14' in ARM mode

when buiding the SIMD aegis128 code for 32-bit ARM, given that the
'armv7-a' -march argument is considered to be compatible with the
ARM crypto extensions. Instead, we should use armv8-a, which does
allow the crypto extensions to be enabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 0d2cdd523fd9..e76d8bd2f72c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -93,7 +93,7 @@ obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
 
 ifeq ($(ARCH),arm)
-CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv7-a -mfloat-abi=softfp
+CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv8-a -mfloat-abi=softfp
 CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
-- 
2.17.1

