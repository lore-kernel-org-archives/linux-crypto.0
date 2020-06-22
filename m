Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3AFC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 23:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F2720786
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 23:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxpsZkf4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgFVX2o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 19:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbgFVX2o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 19:28:44 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2746BC061573;
        Mon, 22 Jun 2020 16:28:44 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l6so17661813ilo.2;
        Mon, 22 Jun 2020 16:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gQRngbxyDaJsXc3eQ4RGxEukqq41ioPgAa6TX8jqgRA=;
        b=AxpsZkf41+RaD8t28rKrQKnH/b6eOIOKffLCW38yHSZfQWCnA0KL8WPiS7HqlCRw5S
         NMdHnlTnZy4sEpkx/DNdsEkoFkbPpS2rE5wqLZsM89SCQIlCgyJR1kNgeRz2qB/tfN8p
         iA9S0dGEAABSPWSMhkkqUdO7rUqZxbcb1kIR8mxj+lvAbXYpMLS9WDzoH710YsMHgOLA
         43SA+ZKxLSFqKzcSz6ZYtguNVcZnP9fLe3fsIFpbju+3hg8s01/6f9j4MgnJmW0FoqcN
         n/lHAsiOy+9DFD72ehHEcP0+l5r4mp7Eq8Dyf0fVriG3U53Fa3Yhhuc9IhPYWfrGj+6K
         UZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gQRngbxyDaJsXc3eQ4RGxEukqq41ioPgAa6TX8jqgRA=;
        b=f/9u7Dabo5Lm3ZQeNShFkAZFTR0yt9wFEkxX+LFx9l7mFHnHFod/0Q5DsFv4A9XC0y
         EDqd40Km32jtq7UuaEBZyqtuFdaB9eszFsxgrk3IeerDWFGPsFwcLsdN3NltPs75QFMe
         4Vni5DgEKz3U3Ln66CYehKazqJcBokpb6v/6GLHPjJ8Rq8s5vpLWpInKWNPIntFbPWD6
         QJbawbgzCHHl5iq92eQaqybXLHd29AqyXkaIg8RRab9odnl/3a/kkQ6ygdI6WNugLJZv
         eJ3yPLqAhIZlyZqZaFz+CNZzLV5Oo9cmCCvGukhGO+SxUA70gqYzb7dA1xPnQgnpBC9k
         gY6Q==
X-Gm-Message-State: AOAM531qUKye9ypnH8BTJ+SjsX0Leek+oxpJMDLmgdR83i4gfC8QUdkN
        oazYfhlyUlqs6dPARuq1nuQ=
X-Google-Smtp-Source: ABdhPJzu686r2Q4L6SG+W5IuL1xQdjU6azdzktB4Nv3RbLgK6KoHKHx+NRjXjiRNqG1f9sCOfFhxfg==
X-Received: by 2002:a92:d3cd:: with SMTP id c13mr20378677ilh.101.1592868523498;
        Mon, 22 Jun 2020 16:28:43 -0700 (PDT)
Received: from jiancai.svl.corp.google.com ([2620:15c:2ce:0:b7ed:16a3:9dc0:21bb])
        by smtp.googlemail.com with ESMTPSA id s17sm6800602ioj.10.2020.06.22.16.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 16:28:43 -0700 (PDT)
From:   Jian Cai <caij2003@gmail.com>
Cc:     caij2003@gmail.com, jiancai@google.com, ndesaulniers@google.com,
        manojgupta@google.com, sedat.dilek@gmail.com, maskray@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] crypto, x86: aesni: add compatibility with IAS
Date:   Mon, 22 Jun 2020 16:24:33 -0700
Message-Id: <20200622232434.162730-1-caij2003@gmail.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clang's integrated assembler complains "invalid reassignment of
non-absolute variable 'var_ddq_add'" while assembling
arch/x86/crypto/aes_ctrby8_avx-x86_64.S. It was because var_ddq_add was
reassigned with non-absolute values several times, which IAS did not
support. We can avoid the reassignment by replacing the uses of
var_ddq_add with its definitions accordingly to have compatilibility
with IAS.

Link: https://github.com/ClangBuiltLinux/linux/issues/1008
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Reported-by: Fangrui Song <maskray@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # build+boot Linux v5.7.5; clang v11.0.0-git
Signed-off-by: Jian Cai <caij2003@gmail.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index ec437db1fa54..494a3bda8487 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -127,10 +127,6 @@ ddq_add_8:
 
 /* generate a unique variable for ddq_add_x */
 
-.macro setddq n
-	var_ddq_add = ddq_add_\n
-.endm
-
 /* generate a unique variable for xmm register */
 .macro setxdata n
 	var_xdata = %xmm\n
@@ -140,9 +136,7 @@ ddq_add_8:
 
 .macro club name, id
 .altmacro
-	.if \name == DDQ_DATA
-		setddq %\id
-	.elseif \name == XDATA
+	.if \name == XDATA
 		setxdata %\id
 	.endif
 .noaltmacro
@@ -165,9 +159,8 @@ ddq_add_8:
 
 	.set i, 1
 	.rept (by - 1)
-		club DDQ_DATA, i
 		club XDATA, i
-		vpaddq	var_ddq_add(%rip), xcounter, var_xdata
+		vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
 		vptest	ddq_low_msk(%rip), var_xdata
 		jnz 1f
 		vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
@@ -180,8 +173,7 @@ ddq_add_8:
 	vmovdqa	1*16(p_keys), xkeyA
 
 	vpxor	xkey0, xdata0, xdata0
-	club DDQ_DATA, by
-	vpaddq	var_ddq_add(%rip), xcounter, xcounter
+	vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
 	vptest	ddq_low_msk(%rip), xcounter
 	jnz	1f
 	vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
-- 
2.27.0.111.gc72c7da667-goog

