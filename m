Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697B1C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 368BF206DD
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SoSJIbaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfG2Jz2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 05:55:28 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43035 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfG2Jz2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 05:55:28 -0400
Received: by mail-ed1-f67.google.com with SMTP id e3so58776037edr.10
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 02:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NlP37yJWnRvCf/6oy+/WBuYp7kupTFflC6d63icZ58U=;
        b=SoSJIbaL6UDouyPmXQ0huDbosGSu9Isuwe7Yqkvh6mkGCDYVGNJaHf3FeflNwyWl6Z
         Wv2J+4M/SfwgRbBiUnN5KUugVWUN0x+VS4xkHGO6NT1GC481YsydBeXS37ZUBSr5UjSN
         PZIgQh84T+34fpWtHlHu00M9BS9EWty1FaHo0J3Nosdhfw9HZsWB10lC4DJoHXbdkMe/
         LQvuGA4PoWlBoFDskPtzyRRlJwzUv1WNpevPs4AdBl44Zi3Irhiw4ZYkrvRlfoute4b8
         GJ+Ij3deiTYyjsqP3UpGBD6HuRjlryiLzVVFTnrvIhQRlu/lQfD5Q3DRDbY3BQR6c2VF
         Mceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NlP37yJWnRvCf/6oy+/WBuYp7kupTFflC6d63icZ58U=;
        b=Qt5uVBYr01Ht1MyGWKZyTbsVc5hJbZE4RXtS/avtc85ZDWUsNL8iHt5BGdxvfOGEBi
         IqsqXEDGBBpyEGvOM7Azph4ym5bQAjlTiEWYW+92q+kiJUEAzNwu7ukimUI3P7SwQOb6
         fje+1SoLaCFUQrOw2NVIWPbSAW+6pFjRoCfHmayqgGgk4lgEqebbPTd27izou6hfCVpq
         2KgoRwmSuyXcxDSuZCVAtAqzk4KF0hNMyTG3T/bV9w11dKlWfOIfKj5P6W4TgEVuv+Cg
         yL91z7qrkIeMyWqeidSFnTV1B00EB/PUgAAAW79FskoYMnKirv/tYeCMcmH0Hpsb12th
         0SOQ==
X-Gm-Message-State: APjAAAXsaFMTeclFq0WW24Swq97pQTqozbE35iSG9lrm8GrKfeINfs0J
        +f5sGBDxLB5SNCogqKTMDyQ535LT8mwVcg==
X-Google-Smtp-Source: APXvYqwXmKDINViOqoAIEQYx5JexZCPjcbfkFEi7sRznT6c+6VU/L37pWvagkWcdvYfA4JcjoAQWDw==
X-Received: by 2002:a50:a4ef:: with SMTP id x44mr96841532edb.304.1564394126141;
        Mon, 29 Jul 2019 02:55:26 -0700 (PDT)
Received: from mba13.hotspot.parkpalaceresidence.com ([212.92.108.154])
        by smtp.gmail.com with ESMTPSA id b15sm16211987edb.46.2019.07.29.02.55.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 02:55:25 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, geert@linux-m68k.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] asm-generic: make simd.h a mandatory include/asm header
Date:   Mon, 29 Jul 2019 12:55:21 +0300
Message-Id: <20190729095521.1916-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The generic aegis128 software crypto driver recently gained support
for using SIMD intrinsics to increase performance, for which it
uncondionally #include's the <asm/simd.h> header. Unfortunately,
this header does not exist on many architectures, resulting in
build failures.

Since asm-generic already has a version of simd.h, let's make it
a mandatory header so that it gets instantiated on all architectures
that don't provide their own version.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/asm-generic/Kbuild | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 6f4536d70b8e..adff14fcb8e4 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -3,3 +3,5 @@
 # asm headers that all architectures except um should have
 # (This file is not included when SRCARCH=um since UML borrows several
 # asm headers from the host architecutre.)
+
+mandatory-y += simd.h
-- 
2.17.1

