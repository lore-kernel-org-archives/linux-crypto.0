Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CB5C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FB121850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qB2oh01+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfGBTmy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:54 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:40536 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfGBTmx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:53 -0400
Received: by mail-lj1-f178.google.com with SMTP id a21so18169992ljh.7
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y8bW1Oz9Gva4RHYCivhqTUhkqRq1s3Ji3bb3o0vH+Kk=;
        b=qB2oh01+ax1n1uskOVzYmXlI6RiNJYNT5T3orVG7VOHRda+I0Xgm7sIvWKthtxymhf
         wuCS1H1f1izwXMeuLa1hJJqP6wpxoZ1m9UQu4b5jvc6r6NTLDrEViVl/PGCRdOfqvLfa
         TPKxaRGYLeZSo1wcSIMCbbUve3Vya3IcQOc3OHkAYCtIykuTFIB7YRdK6HlSipqVpjdd
         eXYnNAB+70VsXwlNll+WTdvhakFqxBaW5CUe7y+HaNkEajywN4TjVcHoWujzy/y5GRNJ
         luymSMqAdrb3uzo5luodCVZ+UX+oQhDcrEbNZJJL6qKto07risN1QYCNVFrzxdazDShx
         0svQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y8bW1Oz9Gva4RHYCivhqTUhkqRq1s3Ji3bb3o0vH+Kk=;
        b=kiSiqk9LI+En7pAyZ6Qv6PnYbVUuDaQCrgY096xmu1OsI8I4B5m5isHG7wpYFcbrQG
         wmbdVMZIHDqOZ9HORJyWlAPbfdxOyhiy4JwpGBh+PJwmFZCB3nojGIkCqWc9dWNHI14U
         +ziUJy990sBpe5yYXtflY3QfzlxEufgk1EEVuxjYjuRweaqxhbA0Jm1hJgCm7vmkFys2
         6M2JfaPU/HcIqUqsnq6yUArQoE0I/baBChyrYOtdwA0NNKJ5hkYRhnXv7iKfTND2ldjY
         BrDCcYRGbF2XDlxvyMJDqMPK0f3PKmFIvAXp9vdwqpuph8cBO9a1QBrz2m+e6uM6QQBX
         Qf1Q==
X-Gm-Message-State: APjAAAVUbUfpCIuSqI7EWlnKUsgb5D72dgKF8hyUy8Hx6W2fEU74rW30
        c73BfvGlWumbZOsIIt6cldyTpSCLYwQkMK+9
X-Google-Smtp-Source: APXvYqweRe75cRZFloMKjjbYKRHpJlQZdMy1n1gHWSCmS4j1FVm/nZ1GnbTsBMJRw6AeLjFQpBHI7A==
X-Received: by 2002:a2e:9b84:: with SMTP id z4mr18657031lji.75.1562096571298;
        Tue, 02 Jul 2019 12:42:51 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 31/32] crypto: arm64/aes-cipher - switch to shared AES inverse Sbox
Date:   Tue,  2 Jul 2019 21:41:49 +0200
Message-Id: <20190702194150.10405-32-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-cipher-core.S | 40 +-------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
index 3a44eada2347..27dac259b359 100644
--- a/arch/arm64/crypto/aes-cipher-core.S
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -131,43 +131,5 @@ ENDPROC(__aes_arm64_encrypt)
 
 	.align		5
 ENTRY(__aes_arm64_decrypt)
-	do_crypt	iround, crypto_it_tab, __aes_arm64_inverse_sbox, 0
+	do_crypt	iround, crypto_it_tab, crypto_aes_inv_sbox, 0
 ENDPROC(__aes_arm64_decrypt)
-
-	.section	".rodata", "a"
-	.align		L1_CACHE_SHIFT
-	.type		__aes_arm64_inverse_sbox, %object
-__aes_arm64_inverse_sbox:
-	.byte		0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38
-	.byte		0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb
-	.byte		0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87
-	.byte		0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb
-	.byte		0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d
-	.byte		0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e
-	.byte		0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2
-	.byte		0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25
-	.byte		0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16
-	.byte		0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92
-	.byte		0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda
-	.byte		0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84
-	.byte		0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a
-	.byte		0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06
-	.byte		0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02
-	.byte		0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b
-	.byte		0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea
-	.byte		0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73
-	.byte		0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85
-	.byte		0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e
-	.byte		0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89
-	.byte		0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b
-	.byte		0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20
-	.byte		0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4
-	.byte		0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31
-	.byte		0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f
-	.byte		0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d
-	.byte		0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef
-	.byte		0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0
-	.byte		0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61
-	.byte		0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26
-	.byte		0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
-	.size		__aes_arm64_inverse_sbox, . - __aes_arm64_inverse_sbox
-- 
2.17.1

