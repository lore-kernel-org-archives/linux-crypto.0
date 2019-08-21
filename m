Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E47C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0AD422D6D
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="agOKtmBy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfHUOdM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36526 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbfHUOdM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so2277266wrt.3
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u8SkUbJP7rMNf0OKuHQI1V2U/tlAU0T6PVWrsyU6ges=;
        b=agOKtmByQmfCXzPEkiehriCi58nAeqL7qeZj/0YiY7LK3xoamzSEPbd2SSrZxSRulu
         kAVHl25gcca2E3u0rJV0B7ghzDbobQEHdnpPaGnpGry9EdnXOQIyg0pem8VMSOPbTD02
         f2vgDT9T3PwWXUsGeRS5rrnZiZX61txuVBm4Oe7w307HfZ8W5fVxCioisG7qIVrIc3i3
         vYjat4r5r6ARM7af82GCZFdNpE1Sdyt9XRTY3ISQ3NtKOmYVf5inRglLFloGUr6KjZL4
         MH82DfHcvQfMUD074HqlPLOmawL9+vR4EZqsAD7yjz2FgPMKSSMvsxvvI9SCVq9XUBm+
         mrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u8SkUbJP7rMNf0OKuHQI1V2U/tlAU0T6PVWrsyU6ges=;
        b=Qy4a6LM49EILb5P1AeA9nj7H2BctgpA0yRt9fP3IiyN8UnzmtakuDWb8g2BV/g8Vuy
         ilG6maF9VYp2nZdYrP/WEzB0MqOrpe6VZ9zXfodcxJGKPo0y1UnVtYJqVA83pPBjBCRw
         E8DkkSu6b36W9D7Y8jszOF8YB5wYpBbbGy4w0hwIstFNwRLB5KyI3Ka98yFjR06UP+B3
         rtVOcxoG5Wm3NeIhW/JVZUZPTGqSVqMoqJ/HmZUNuA1KBiEYKFUJbvg+Bd0j8wgT4lBA
         c/vaug1rpufyMFJswoQcoZgDk1zURPBruMIpWcB4u7NhLeeGdthH/ZC8JA6P7B4XfuBZ
         8y6g==
X-Gm-Message-State: APjAAAVdkbuaQ+qaQtlPoCL4pOfZtyGCi3N4urv4H12FbDXxCIykJgAk
        c1oRps+81Zul06cgSul7hsTLZSRYmvL7XQ==
X-Google-Smtp-Source: APXvYqwjvfE1UHBa1Y+s02ZQVUx3gYOItjRH4aTP4+sLEjZ/MQiuMuJNQbJ875BxvXHBa8y0CaTlPA==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr255514wrp.103.1566397989579;
        Wed, 21 Aug 2019 07:33:09 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/17] crypto: arm64/aes-neonbs - replace tweak mask literal with composition
Date:   Wed, 21 Aug 2019 17:32:42 +0300
Message-Id: <20190821143253.30209-7-ard.biesheuvel@linaro.org>
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

