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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220C4C2D0E4
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 10:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8BB2075E
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 10:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xhz+Dz7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgK0KSc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 05:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK0KSb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 05:18:31 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928D1C0613D1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2020 02:18:31 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id gj5so6831729ejb.8
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2020 02:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0J0jZ0+rETyNB7Etq+spWUEZel9AC+ydlL7rzWJts8=;
        b=Xhz+Dz7Ipj1oRT/U8J2szzGm3GhX7WMipJgFwhiHEyQ6/B3G2Fq+5IJLXxzrhA74/S
         HNhqn8fw6hnmOzdexO1JkXIEpWKhAN08hV6BZ4fFaH6tGswl61CGqLw00jmdwm/c85fD
         +WJwLbo/jtJJRxDT99yUolmMVUDMbMK6iosQsihAWVvQpj8g14/ZvNF5gza6cIpDZOuE
         Mm7F1FevT/aYbeYidgg/CqQL+vHtFPb85re1Un7S+KszT7vVv9YD+SRylEQ1rD8Xd71a
         1eUi8Xsn4nWKSQpLLahxvy69PwWYsrTv2GtNtjRILdz2qM2+qZrR/3OTax3xDeBZ7FSM
         FiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0J0jZ0+rETyNB7Etq+spWUEZel9AC+ydlL7rzWJts8=;
        b=TUfvQ/JCKfwJQHn+7S9cPn2+GIxfK3xGjDHmxAPX2B4brRcp5VCOEv7JNDRQOMJcYl
         mTkjxGZLBlKbtcrUuDSbzuWut66vHqP/ymHrXKhWCA5KXSDmyv4Dmgk2QZgEOaZmM5Zt
         7OzrlohYPXqbL1DYp3KwiZeHPPI1KMj5dAlHQoE36nLeW+egOaEPwVp3dIrzpxjHGb7t
         91/4la7we+vJUNs2ZVAN9MCNa1mS40lgPCiPlH6qzxTT1BJJDOncFy1XVvw37sWJLMMW
         xTSm+Bo8aqrxJhlgdc2z2FaKz0jZJiFx8Snt2pqGrprgqI8AjHqfDDVo9GF8fCOKroJO
         rgTA==
X-Gm-Message-State: AOAM532jIhbunE5LbO5BD2fxzqNVl/tp54i1dPn39ajDPbr5VQTHehbV
        S40y2YyjKUl3FrdCWNXDBd59zdFI0YeXwQ==
X-Google-Smtp-Source: ABdhPJyvlrzdmdSo2pkNf1MDp9RpGgEDDdPZnOoM+YSx4bMMJm/v4q3xQDJsUiE9/PawgjenuEUm6Q==
X-Received: by 2002:a17:906:85cf:: with SMTP id i15mr7043415ejy.373.1606472310035;
        Fri, 27 Nov 2020 02:18:30 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id f24sm4669457edx.90.2020.11.27.02.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 02:18:29 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] crypto: x86/poly1305-intel: Use TEST %reg,%reg instead of CMP $0,%reg
Date:   Fri, 27 Nov 2020 11:18:12 +0100
Message-Id: <20201127101812.72787-1-ubizjak@gmail.com>
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
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
index 7d568012cc15..71fae5a09e56 100644
--- a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
+++ b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
@@ -251,7 +251,7 @@ $code.=<<___;
 	mov	%rax,8($ctx)
 	mov	%rax,16($ctx)
 
-	cmp	\$0,$inp
+	test	$inp,$inp
 	je	.Lno_key
 ___
 $code.=<<___ if (!$kernel);
-- 
2.26.2

