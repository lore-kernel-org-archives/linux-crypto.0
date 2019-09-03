Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD77AC3A5A7
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 945ED22CED
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Seh3SnO7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbfICQnu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40400 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbfICQnt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id y10so2212266pll.7
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aI11eOfvUHWceFRi+8iF4u67GyVnjyFicxzOIJeHmqs=;
        b=Seh3SnO7oiwdT24476RxHEDvAApEq55bf0yH1t/nmi12tYD+r2wdiyZUIw5lLTgxw5
         nImaN4v64wqOcsGJjjuJLbYLCiLLd9G+viS+G8F9QVD/cnn9odNSCzhicQwuRbrvCPqN
         5Z+mdw1MUcw2+c4AUQcubUfDMAfv2EqqBkhDzKz3Z/q7/GqmJSB2xtkea7HgtvHx5q2R
         ftc8C5c6EKIFwqyPL+OUD8frAZmld6nc9L7ojMJ6hd0LO0YxTLdaMnrDEQKslwBwZlmB
         yMYPQ3prX685iew4wa4l4X4PKRsv9vub9L/JHNKTUHd+boTHyYjIFs4VWbejkNf5xSPB
         jxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aI11eOfvUHWceFRi+8iF4u67GyVnjyFicxzOIJeHmqs=;
        b=H1md8dSpqbeVObkxBI0HoCyd/quSXKMcLd2mPpKBOLovqyJULNM+DtqGNEYNsaYtYB
         uFH0ZFfKnd1sCukoHgroXXY6GnZiN5NZmMQQJyL/lR3S1aBDRslB/M3gtla0E6atAj8w
         R9cLwnmXi+wJdw+eSErUyiX3+FBFGik7/cBUljOO7VnD7t/kuZ9AcWh6RjvZxmY9JWMz
         ewNotF79TENmwz0rz7yWVoxzgQL/WE6SJYWw53A4Ytolg9oMTVQk7fewVWxuiXcShwys
         UBtRvffq+E85y90vQY4IAMA3ymCXT9V0PeTiHWcxBeGYoIZC5MvzTtU+6jP20mBI605f
         Za7g==
X-Gm-Message-State: APjAAAXQIhfMYcY6/Qh65C7n1wJ7DUouWIRXmJWhwd5COjtVMFlZt3Ek
        n50VXv3SGKvsu/LwudRj0MdD9ek6H2ifK/pl
X-Google-Smtp-Source: APXvYqytI0Rq7eo6Do1aUaFKBp32v0geiDf21mb7gIn2mUKf1M2wCeebK4Ys46jxum8y4Gal33n4NQ==
X-Received: by 2002:a17:902:166:: with SMTP id 93mr19789458plb.320.1567529028847;
        Tue, 03 Sep 2019 09:43:48 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 04/17] crypto: arm/aes-ce - replace tweak mask literal with composition
Date:   Tue,  3 Sep 2019 09:43:26 -0700
Message-Id: <20190903164339.27984-5-ard.biesheuvel@linaro.org>
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

