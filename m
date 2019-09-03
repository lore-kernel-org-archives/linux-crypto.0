Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D450C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5301821881
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SrCoLNQG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfICQnw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45437 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQnw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so3543392pfb.12
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u8SkUbJP7rMNf0OKuHQI1V2U/tlAU0T6PVWrsyU6ges=;
        b=SrCoLNQGWEWY+LiuLHoDSzH1HJI+hFhrVVXSwTV0trNjF96FVGW+hcA3jkLGreECtK
         4nJ5yQAwAasjm375uzxkAngqjrDI+9C2Rw6VVUJ4SIBX/PEkPHfz7o/8/z4R0DAtc/0W
         OsQ5CRsRNR8jJfFe8ynCpi2Nbzx5+BJYSMsybD9jSSwTM7Up0Lhy97w3zuDRXcqlG0RH
         DsndUrof0s4Z1ff6s7ZcooT9D6CNtKzGXritmi0XU/rdi/lpXFatO3kvD9/lYMRtknNx
         pPfdZQajGErznYfYRK/KNmS0h/Boe5cgU+xwW91/flT5ug3n5IM1BfH1DlahE+eE3q5l
         Lu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u8SkUbJP7rMNf0OKuHQI1V2U/tlAU0T6PVWrsyU6ges=;
        b=ErIIVBi0TVri2SSvau8XT4G2FEqfV0eQiB0nqugxoEyz39iLgr+fot3nrbIMAMioOr
         HvVGRU3oGBntesqzDwcKKxCW9uHXBKRrQcQmjgO/OnjNE7xwTzx6CRAleyyyTibAgVnD
         DiyvUTDhCkd8AV4grVESjD1qxaifloi+QV4/vCUfhBvOxNUGtF+aMJX1FXxzzdiV+Nfv
         7cw+HK2Ysk1z2NYF8fbLaqyWgL/0olufcuDTQfrPcvjDp5qo0qJnzIaL92FUH+e/cyi/
         pi1H9KVPsmuCiaV+H+B9faMc95tB1yN3VGBME0cuxaufRKYGj4ApJSz8gCgBgwXC6XCw
         XdnQ==
X-Gm-Message-State: APjAAAVWm+pQjlkM0z9S0qftfGVFs0XO3G4RyZ2OpGsiymtViyo16/mF
        49Kx5R5cGwPo8CNA6a7274mXOFk63Ge7P0C0
X-Google-Smtp-Source: APXvYqz6Oh2niv/mU+yBwq33LT9lNf7XnsKUZryseKGXH6Q+UjqEWklspP5zItXHfmunohdGulcqAw==
X-Received: by 2002:a63:4823:: with SMTP id v35mr31163401pga.138.1567529031665;
        Tue, 03 Sep 2019 09:43:51 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 06/17] crypto: arm64/aes-neonbs - replace tweak mask literal with composition
Date:   Tue,  3 Sep 2019 09:43:28 -0700
Message-Id: <20190903164339.27984-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the vector load from memory sequence with a simple instruction
sequence to compose the tweak vector directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-neonbs-core.S | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index cf10ff8878a3..65982039fa36 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -730,11 +730,6 @@ ENDPROC(aesbs_cbc_decrypt)
 	eor		\out\().16b, \out\().16b, \tmp\().16b
 	.endm
 
-	.align		4
-.Lxts_mul_x:
-CPU_LE(	.quad		1, 0x87		)
-CPU_BE(	.quad		0x87, 1		)
-
 	/*
 	 * aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		     int blocks, u8 iv[])
@@ -806,7 +801,9 @@ ENDPROC(__xts_crypt8)
 	mov		x23, x4
 	mov		x24, x5
 
-0:	ldr		q30, .Lxts_mul_x
+0:	movi		v30.2s, #0x1
+	movi		v25.2s, #0x87
+	uzp1		v30.4s, v30.4s, v25.4s
 	ld1		{v25.16b}, [x24]
 
 99:	adr		x7, \do8
-- 
2.17.1

