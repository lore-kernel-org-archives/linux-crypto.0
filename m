Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0F4C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 17:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0DB22B4B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 17:38:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYG0kOTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgH0Rik (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgH0Rik (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 13:38:40 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C91FC061264
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 10:38:40 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id m22so8745529eje.10
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 10:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXKWjriGhujBv/DGQf3alBhqVGWIFwTOdYaLD9TTrR4=;
        b=UYG0kOTUt/JnsGk4juCGi7rsxwjIJGvG2wnb0x6BmnqgeT66puD1OZzaJ4mogxpLYR
         3VHsIobTFucZJMtPRPqwdZsSUPpQn27FtfHACAbfN3nI0IMPlWHYoESLQVkAteAXRz82
         TiF8MqFq7Mu+7Iwzu3SC1LWYMoCKJ7o8/SMhpLQopOlXUbCkQK6auHUfhVBDtgkRxqgK
         Yx9ulXDDx9UXp3G/wjkqFR3j8zPquZpaPKhdN+5wLwXVhi6ELPJZehRStzwCs0lUnLeh
         F+Z3cwHoNsHmL+YIF8GVERzbpRHs72sno3fkbV6mY14Kcubw8foCvDdAjYGTNW8q2woI
         6ivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXKWjriGhujBv/DGQf3alBhqVGWIFwTOdYaLD9TTrR4=;
        b=EWGv6/YjvOqu15sdboZz3BiPF+bJa8P7LZ4I1a5TIzYMhs6qTPXHhESsxYH3/3uasK
         +SCNTdcuoVjLzHIGJSUpoVKI1iNfELlm82tpAmd95LWcOZh5RrXckedCzqh72Hwd0T+T
         +tjqRaAR65fCnoA6cisXC+EIMMgxC4TTZyTzdJn2Rtt4X6Gx5DLPT1pdpm5U1ZVrjv1E
         2Ou7QibR3H6+TmsNbAItguvwpeQlUYPNuhvR046/SUcFHA+JCwiRBXMalpvgz4yPgr0M
         ga7YI99Md/aujMjs9q+q6vRL5SQZwBF7SoIYltxelv8g9sRsQ3Lnpw2mC1hJOLhpzMm0
         HF9Q==
X-Gm-Message-State: AOAM531zw6d9B8nKmbKRzbIhlO5Ky2T+6Ii+HIKnFnq61aXkqwHdGVNt
        fcIYdcXEKl+ecaUzGru03sZAYEZWzu6V/w==
X-Google-Smtp-Source: ABdhPJybv/WrWyMhLN26wkOo008brwZxbkETJnZYTw+Vb5JzxDEgOPIw1C4buo+sS2SvssyVUWnnKw==
X-Received: by 2002:a17:906:a3d6:: with SMTP id ca22mr21749711ejb.78.1598549918523;
        Thu, 27 Aug 2020 10:38:38 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id ch24sm2432872ejb.7.2020.08.27.10.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 10:38:38 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto/x86: Use XORL r32,32 in poly1305-x86_64-cryptogams.pl
Date:   Thu, 27 Aug 2020 19:38:31 +0200
Message-Id: <20200827173831.95039-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

x86_64 zero extends 32bit operations, so for 64bit operands,
XORL r32,r32 is functionally equal to XORQ r64,r64, but avoids
a REX prefix byte when legacy registers are used.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
index 137edcf038cb..7d568012cc15 100644
--- a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
+++ b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
@@ -246,7 +246,7 @@ $code.=<<___ if (!$kernel);
 ___
 &declare_function("poly1305_init_x86_64", 32, 3);
 $code.=<<___;
-	xor	%rax,%rax
+	xor	%eax,%eax
 	mov	%rax,0($ctx)		# initialize hash value
 	mov	%rax,8($ctx)
 	mov	%rax,16($ctx)
@@ -2853,7 +2853,7 @@ $code.=<<___;
 .type	poly1305_init_base2_44,\@function,3
 .align	32
 poly1305_init_base2_44:
-	xor	%rax,%rax
+	xor	%eax,%eax
 	mov	%rax,0($ctx)		# initialize hash value
 	mov	%rax,8($ctx)
 	mov	%rax,16($ctx)
@@ -3947,7 +3947,7 @@ xor128_decrypt_n_pad:
 	mov	\$16,$len
 	sub	%r10,$len
 	xor	%eax,%eax
-	xor	%r11,%r11
+	xor	%r11d,%r11d
 .Loop_dec_byte:
 	mov	($inp,$otp),%r11b
 	mov	($otp),%al
@@ -4085,7 +4085,7 @@ avx_handler:
 	.long	0xa548f3fc		# cld; rep movsq
 
 	mov	$disp,%rsi
-	xor	%rcx,%rcx		# arg1, UNW_FLAG_NHANDLER
+	xor	%ecx,%ecx		# arg1, UNW_FLAG_NHANDLER
 	mov	8(%rsi),%rdx		# arg2, disp->ImageBase
 	mov	0(%rsi),%r8		# arg3, disp->ControlPc
 	mov	16(%rsi),%r9		# arg4, disp->FunctionEntry
-- 
2.26.2

