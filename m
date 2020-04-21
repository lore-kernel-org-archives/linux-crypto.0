Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA9EC54FCC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 21:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 229AC20724
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 21:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gs/3/cWE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDUVr2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgDUVr1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 17:47:27 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9FAC0610D5;
        Tue, 21 Apr 2020 14:47:27 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id r25so114046oij.4;
        Tue, 21 Apr 2020 14:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ciFxuebc3h6Mj9upZD+rKZQRQtufTSVOmAvk3Fhrb+8=;
        b=Gs/3/cWErnL1HK8vIip6HFCoT7YMdHo0kk2KUYaTPGJky+4xtFirvwaHEqkI2HtIlI
         wdq6VA7psR1fXgv6wI1orD4p2STd+anwQuQW5O9+FdTxMBI06LLpWvehmvNIEUNO1k8q
         f9PJKl3I1ELE0rCVmxNstw09SGrK3JBX8bG/K80JrHUp9CfMSB5S0UTwaRUVol14eQDV
         Qsd30+PKtlCSprW6IlVcZTCs7UFzEFXizN/N40nehfoPEI1FNm0ldX22Ywk/vI/Wsqrs
         oOmuqbCmlq0ydX+1pgVmuu9PnpUQJsy7oUlUnxhmzaedwnAL2fq9ZGOQvwXDDokabntb
         qdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ciFxuebc3h6Mj9upZD+rKZQRQtufTSVOmAvk3Fhrb+8=;
        b=Hx4hUEVLYcIEs4SRgPiNRh0A95hHe2VgG+lLMf9y9DBJx8rPbb6f2FLeZCiA05oYUb
         1cJ4kVSv6TqMJC6uOyeJAAlQc+OQPc9EjxTEkbDBmpLlOFXkbes0ACn6YJvuK9BYz9l9
         fWAREtCDIeQdtAtZuo78+WpsysdPjt7FJ+TwA8vMEnv/WTlk7xpoF/NUL76YrlmLD5gr
         LOwu4AJATpGwpFV831ENS4vIlUm/7W83GvACgCPDCg7+JECWPgBNbHq/Tz3EbqIma7i6
         Dh2qdwBGySttFUeZor6HHtaglBkWjuUm/o7OzgywDfiAUPe4khXHmE6rJzBT/YMqo3M7
         CCuQ==
X-Gm-Message-State: AGi0PuYsaSlu/2m9v3abhWhJzKhqOXCKEfw1Qz88K0TjNzxoadvPQiFr
        LlpijQxEav9o+GP+Wz1y+xY=
X-Google-Smtp-Source: APiQypLih2QqVaNUU4RcIddRD2JnsowfGXCnT47rR8H2Zr7F15q8n/3P7JuWAH36ltMiMagM66Im9Q==
X-Received: by 2002:aca:b104:: with SMTP id a4mr4908325oif.103.1587505646764;
        Tue, 21 Apr 2020 14:47:26 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id l187sm1042137oig.0.2020.04.21.14.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 14:47:26 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dmitry Golovin <dima@golovin.in>
Subject: [PATCH] lib/mpi: Fix 64-bit MIPS build with Clang
Date:   Tue, 21 Apr 2020 14:47:04 -0700
Message-Id: <20200421214703.47883-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When building 64r6_defconfig with CONFIG_MIPS32_O32 disabled and
CONFIG_CRYPTO_RSA enabled:

lib/mpi/generic_mpih-mul1.c:37:24: error: invalid use of a cast in a
inline asm context requiring an l-value: remove the cast
or build with -fheinous-gnu-extensions
                umul_ppmm(prod_high, prod_low, s1_ptr[j], s2_limb);
                ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/mpi/longlong.h:664:22: note: expanded from macro 'umul_ppmm'
                 : "=d" ((UDItype)(w0))
                         ~~~~~~~~~~^~~
lib/mpi/generic_mpih-mul1.c:37:13: error: invalid use of a cast in a
inline asm context requiring an l-value: remove the cast
or build with -fheinous-gnu-extensions
                umul_ppmm(prod_high, prod_low, s1_ptr[j], s2_limb);
                ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/mpi/longlong.h:668:22: note: expanded from macro 'umul_ppmm'
                 : "=d" ((UDItype)(w1))
                         ~~~~~~~~~~^~~
2 errors generated.

This special case for umul_ppmm for MIPS64r6 was added in
commit bbc25bee37d2b ("lib/mpi: Fix umul_ppmm() for MIPS64r6"), due to
GCC being inefficient and emitting a __multi3 intrinsic.

There is no such issue with clang; with this patch applied, I can build
this configuration without any problems and there are no link errors
like mentioned in the commit above (which I can still reproduce with
GCC 9.3.0 when that commit is reverted). Only use this definition when
GCC is being used.

This really should have been caught by commit b0c091ae04f67 ("lib/mpi:
Eliminate unused umul_ppmm definitions for MIPS") when I was messing
around in this area but I was not testing 64-bit MIPS at the time.

Link: https://github.com/ClangBuiltLinux/linux/issues/885
Reported-by: Dmitry Golovin <dima@golovin.in>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 lib/mpi/longlong.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index 2dceaca27489c..bfff2e398ffed 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -653,7 +653,7 @@ do {						\
 	**************  MIPS/64  **************
 	***************************************/
 #if (defined(__mips) && __mips >= 3) && W_TYPE_SIZE == 64
-#if defined(__mips_isa_rev) && __mips_isa_rev >= 6
+#if defined(__mips_isa_rev) && __mips_isa_rev >= 6 && defined(CONFIG_CC_IS_GCC)
 /*
  * GCC ends up emitting a __multi3 intrinsic call for MIPS64r6 with the plain C
  * code below, so we special case MIPS64r6 until the compiler can do better.

base-commit: ae83d0b416db002fe95601e7f97f64b59514d936
-- 
2.26.2

