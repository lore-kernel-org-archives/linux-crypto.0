Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9694C2D0E4
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 10:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6413321D91
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 10:00:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="btF/LXhg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgK0J7z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgK0J7z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 04:59:55 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CE9C0613D1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2020 01:59:54 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so6808554ejk.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2020 01:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQaIavt6JmD73JfevHJ2hS/Gbnjyr7lNVzrU1z1SpeY=;
        b=btF/LXhgCJxuyYPb3DnDvbUG173aASQfpLP9vdcD9hvbqNlZ7Fk7A+dvyojnCuesmR
         Uz2j2ubQJSBthWulRbZx6l+F4OifPuC/56kYRfKyArSo11Vr9gXNA0zBF9w9D2CeeYya
         HUKLzv4r+N1C7eREPX+RBs4CzdgdTXeXgtk6DBvfbIbBcOpLUz3lOOyQi5mG9CtnVOjt
         BQPlw8uUYjnRelQC6+o9AQ9UZKuE1x0NbJN2srtUbuFXHxYzR4VC1zodNnOojWCj0SPM
         QNgz3BgCeEyDnO5hw2LC/oRWJ5qeG4n/+AlY5IAIa+3oAASAU1naQP+W1MXXYplsdlkx
         8XYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQaIavt6JmD73JfevHJ2hS/Gbnjyr7lNVzrU1z1SpeY=;
        b=t8ZJOUqbYuaUJI6FRFac15Ps+FYRCYDpWXbz8QORDEgGhKV/+erUQxo48gcqd1pFyu
         mj97hzaeUCX4Tt62Uag2ZUXTlu5V+jKdaGeJWu202tPR75RkrYbTQzLHET0i1Zm1t3Ke
         Owkck+y4ZASUg1l6czqPSeCrgngMcLs/zu0pQpFW7G3PD8vo/E+0B2Ddcbgz7GRiNw9r
         r1A8cVui05pskfE81k1cKaZLQ9Who/bUWXRCnfxDRVouAXoxMNn0lcNbkBjx5OaFRUo4
         xxn+qW6Xnp9B1Q3znFU0I/oYWHesEUsCO9rVBCKSf89r7qWXLC0dZFqGAld6hDw2e7tD
         B2og==
X-Gm-Message-State: AOAM532pfwAzvjSLeB3CFPFH3rNzcAWvjsVFeTGLELkNSHhBSiuggbzv
        ljdotYSDYSZMyWiGwUsd9awXZVv8lYyxAw==
X-Google-Smtp-Source: ABdhPJyM9LI79fRZZ5u0Sc7V67o8HortdQLA/Zmdunj5vYcecFUXmsAugG3dyDguaOXLKXymS5UYfg==
X-Received: by 2002:a17:906:3608:: with SMTP id q8mr6824879ejb.39.1606471193369;
        Fri, 27 Nov 2020 01:59:53 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id k16sm2631212ejv.93.2020.11.27.01.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 01:59:52 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] crypto: x86/sha512-intel: Use TEST %reg,%reg instead of CMP $0,%reg
Date:   Fri, 27 Nov 2020 10:59:43 +0100
Message-Id: <20201127095943.62292-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CMP $0,%reg can't set overflow flag, so we can use shorter TEST %reg,%reg
instruction when only zero and sign flags are checked (E,L,LE,G,GE conditions).

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/crypto/sha512-avx-asm.S   | 2 +-
 arch/x86/crypto/sha512-ssse3-asm.S | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index 63470fd6ae32..684d58c8bc4f 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -278,7 +278,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 # "blocks" is the message length in SHA512 blocks
 ########################################################################
 SYM_FUNC_START(sha512_transform_avx)
-	cmp $0, msglen
+	test msglen, msglen
 	je nowork
 
 	# Allocate Stack Space
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index 7946a1bee85b..50812af0b083 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -280,7 +280,7 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 ########################################################################
 SYM_FUNC_START(sha512_transform_ssse3)
 
-	cmp $0, msglen
+	test msglen, msglen
 	je nowork
 
 	# Allocate Stack Space
-- 
2.26.2

