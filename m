Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AF7C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C973122D6D
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ddEZtJwc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfHUOdI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43936 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbfHUOdI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so2251248wrn.10
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aI11eOfvUHWceFRi+8iF4u67GyVnjyFicxzOIJeHmqs=;
        b=ddEZtJwcsiZncsOlztMjOo2Rph0rOlKCbabKpMj8fxxRifPIZGzpXtAq9jKbNvCmQv
         lQ+T6aHvHHpbOU4Q/qfnKuQeu9uHBaUm2nVZUdfB9qcd8HqdPpGNQxayvjQtnoZdi4gw
         AWVHiGxGwGH37pDaL44Rldv5YGrpb+9y4Ecu6fpYcOTKvUDcuOQTxLU1UghkDh0G/B4Z
         1v5orHWU2Oy1NBuTXu6XUDFsabccXaKux4OJdB67pSrXEDWzUUV8qFE5nSOeuemlfVzq
         f79bk06E6gL458kS6RXktd+rV6C+1iqqpK0NxMQS25jqT38WWhYb8pdfllSXUtQhdTzb
         zeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aI11eOfvUHWceFRi+8iF4u67GyVnjyFicxzOIJeHmqs=;
        b=rmhIcXWMwqT5715U9qtJdPr50sl1O8m6joBJcqpqrRGEFsSsFuMjtu99SheS0AzzRY
         Yz4hQTG6fka+D7zkMoaw6KhYxZ6yt6x685e3B9SthPnbkDg6xYx48O20/rVCt7s/5Yki
         g8f9t+2/RDHSsmyDROdzns1vfQZwiwMLLX6IeCQj83ZYR30P9m0IQr17eKawDUQI4JoU
         32v0kI6T0MGmWLkRczGvGJpJEre/wOJkBh9EruaGODawMEUEkuOsKWIODx+GsNbDckU5
         wy3tU5Q02orYjhu7jPRs8niUf7dXDKJ0klj5nWB6mqECpAHVNF7omHClUOtj/+SVTZ1x
         NvGA==
X-Gm-Message-State: APjAAAVabuRtx+04IJRGMHgdBB37RX/9ezJTeq/pzJ5yKYXOIV0mOFYk
        dpyhncKkRUwok/ZtsOg9frFwxy+02W6fyg==
X-Google-Smtp-Source: APXvYqynbLUtC/vFnaXEkJCgmKX2Fm1+Qczr1ZmYHrVeYXsyWTOv1a98gbNUSDD4/zSfZ19u4Ao7cQ==
X-Received: by 2002:adf:d4c6:: with SMTP id w6mr42017542wrk.98.1566397986351;
        Wed, 21 Aug 2019 07:33:06 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 04/17] crypto: arm/aes-ce - replace tweak mask literal with composition
Date:   Wed, 21 Aug 2019 17:32:40 +0300
Message-Id: <20190821143253.30209-5-ard.biesheuvel@linaro.org>
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
 arch/arm/crypto/aes-ce-core.S | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index a3ca4ac2d7bb..bb6ec1844370 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -382,13 +382,10 @@ ENDPROC(ce_aes_ctr_encrypt)
 	veor		\out, \out, \tmp
 	.endm
 
-	.align		3
-.Lxts_mul_x:
-	.quad		1, 0x87
-
 ce_aes_xts_init:
-	vldr		d30, .Lxts_mul_x
-	vldr		d31, .Lxts_mul_x + 8
+	vmov.i32	d30, #0x87		@ compose tweak mask vector
+	vmovl.u32	q15, d30
+	vshr.u64	d30, d31, #7
 
 	ldrd		r4, r5, [sp, #16]	@ load args
 	ldr		r6, [sp, #28]
-- 
2.17.1

