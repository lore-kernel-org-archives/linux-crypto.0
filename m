Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D9CC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2CB122CED
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GIRqgq3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfICQnv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46148 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQnv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id m3so9422597pgv.13
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vb3yeqqCuXjboCdKiVDdUqWWVOWb7cOxAkDE/WzQmrQ=;
        b=GIRqgq3llkN/QIzSBJ/mhA5AUejcOaEkhxSPOK40hrmkt4nfNseLML5eIsAf6FpSWK
         OpqfWnty1g828PKFwQamifIM5nN5+JMDXMpIU2z86HYckDuQkPtnyhYG4IgYvBjctRg1
         yN8ghbRtKJo0nZVgDp21kZcBBOZNt+iSBjRr4Q83ap41K0Ybhmash/+m1IfwdcKkcHmR
         SfIFH1t6LfwCBoJijEWjdy9AXuYtbNO3dOomtdQquoKlScB5kSYUUR3M9SPJAdvanKA7
         al6i3cKFmXcdCJ11kM29nnPPl0vZTr/e797QtnabP6UOb8TO/1ixhwhjL0QjcE5icm7d
         0XAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vb3yeqqCuXjboCdKiVDdUqWWVOWb7cOxAkDE/WzQmrQ=;
        b=EuHFr7bpdEMw+rgVz391j3MsKHJHrE3tk2iq5JejFAWRR7fAuSm6A5fFUY+tmIk2xV
         Y8OMcWxV/r/7TYSU17Qw/2HtD3GenwXXLuqcIRncFYSXQFsIF7kzlIFq3x61YllFEK0O
         0CHtkPy+lEVic/kfButt/EnrSSE2ZV8ioS/xuRK0eyqcqs0rROQdDXjxS4ixDu4iBpit
         gpa9/LrXrZ3D6VxfWfH+NpBBChxNR4Q7GIFtFjy6lmzSZJRaqgfNpCpwYRHKbi3h1h+E
         YmbUXVHd09wYGxJjpbrzbK48c0O/QZDq01lX82QNkq2QSUtMqfX4PHQtsfKnlOg/6vMW
         M9NA==
X-Gm-Message-State: APjAAAU00AEBNff5AJf9ahyKM3dAQlOjsNMaQpEfSo2oR92+UuVQFwpR
        ljq/8+K8xQ3mQzKFU0d0mb44RUuNeaJxFMqR
X-Google-Smtp-Source: APXvYqwfUWT4n3+dKmXAqI/PTLVdGETTBdNKBfAWkI03YGLidEoXOl8QV0BLCcsJuT+Ll+n8TiRyNQ==
X-Received: by 2002:a17:90a:fd8c:: with SMTP id cx12mr182813pjb.95.1567529030150;
        Tue, 03 Sep 2019 09:43:50 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 05/17] crypto: arm/aes-neonbs - replace tweak mask literal with composition
Date:   Tue,  3 Sep 2019 09:43:27 -0700
Message-Id: <20190903164339.27984-6-ard.biesheuvel@linaro.org>
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

