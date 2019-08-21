Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17404C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFCFE21655
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W+2rpNaU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfHUOdK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35656 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbfHUOdK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so2394221wmg.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vb3yeqqCuXjboCdKiVDdUqWWVOWb7cOxAkDE/WzQmrQ=;
        b=W+2rpNaUkXMImvHppqPtNDzaji/3lCx3sOC5o5KgOYCyHJxvSkVigtjsqzcEM86oOW
         Wo8T3gLwXICLt5yJKQJnRs+fYCUf/aXFSqOHxoRgQaY0EpX8FJG2N+dlKw8EAwq3jOfR
         7OsLvKl51bgd3PlXkIOaWz0IM4dfrHpYKErZg/Bi7SS8Lcdkz9NpHt4q5EGUtH5KwUrD
         HzVm5HyHlimIP2D9PACbCijc8bM6/Y0Nh1Tv9/EbQeCQJOfUQn7jAP0ZPloaY3IHTMuT
         jOhIClaDtJLmytlqEhcIOkChA0Hc+ONOy25zCsrDGUMDiuFDo8vyuihSa6vrP2wqR/gl
         dQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vb3yeqqCuXjboCdKiVDdUqWWVOWb7cOxAkDE/WzQmrQ=;
        b=O649VN9BW6sJhJgCUMVou7H/CBz7iKUIXYgcgiu0BEpGJ2xgiVE2fIZGkuBrarElck
         CmX8QET0KGt7eAhaPEjd6xA5HeFClB5ZfjOiFnSA/pNwMdcfGlJpbNToaVDVebfi9a3P
         +MIVW3VqFEc9kHEHXV8bb0FKSH63jEdMWXw/uiriqbMYyAoqxr4oCnc7ACra0vCirPl2
         q8FMopOCXoVsoOr9K0iCj72bBmkuMOnjyrQHduuh13a6cWhdNMgYSXW9h2CyJ4Q1Vvgr
         YStHOp9jeOJAve5M5qbH9mtblYDNUnzmyOSo2F7NQNGR5sl8UEKV+E2GWZ2/DGX7eenW
         oAmQ==
X-Gm-Message-State: APjAAAX1+6ipSnqLM9NvtFlsFayM43i44pUbgGi0TJHwVXVHkxmyM0PF
        ued0J6q+IkUltrT7IO69QtyYJ2VlH+Y9RQ==
X-Google-Smtp-Source: APXvYqxEpkGz6IMVc+9zpGjCo//RCVSpk6WW8sPW9ALsh9pzj6rjWH+ILn2DMCGOgkbNfwQOXifUjg==
X-Received: by 2002:a1c:d185:: with SMTP id i127mr365113wmg.63.1566397987951;
        Wed, 21 Aug 2019 07:33:07 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/17] crypto: arm/aes-neonbs - replace tweak mask literal with composition
Date:   Wed, 21 Aug 2019 17:32:41 +0300
Message-Id: <20190821143253.30209-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the vector load from memory sequence with a simple instruction
sequence to compose the tweak vector directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-neonbs-core.S | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-core.S b/arch/arm/crypto/aes-neonbs-core.S
index d3eab76b6e1b..bb75918e4984 100644
--- a/arch/arm/crypto/aes-neonbs-core.S
+++ b/arch/arm/crypto/aes-neonbs-core.S
@@ -887,10 +887,6 @@ ENDPROC(aesbs_ctr_encrypt)
 	veor		\out, \out, \tmp
 	.endm
 
-	.align		4
-.Lxts_mul_x:
-	.quad		1, 0x87
-
 	/*
 	 * aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		     int blocks, u8 iv[])
@@ -899,7 +895,9 @@ ENDPROC(aesbs_ctr_encrypt)
 	 */
 __xts_prepare8:
 	vld1.8		{q14}, [r7]		// load iv
-	__ldr		q15, .Lxts_mul_x	// load tweak mask
+	vmov.i32	d30, #0x87		// compose tweak mask vector
+	vmovl.u32	q15, d30
+	vshr.u64	d30, d31, #7
 	vmov		q12, q14
 
 	__adr		ip, 0f
-- 
2.17.1

