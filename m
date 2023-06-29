Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B77EB64D7
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jun 2023 03:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjF2DOI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Jun 2023 23:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjF2DNx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2023 23:13:53 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F52733
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 20:13:46 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51d9865b848so243860a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 20:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688008425; x=1690600425;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xsP6l6F2Ynxmy6UfbGE0U5XGQemQAiefdBx9y2MwRzY=;
        b=eQkYxzGNHpI5+2909zX/oQbDRP4FFWn6O4dV/gd5eI0l8R1J9UPLisGQMGK0IdrvBa
         MKwOBi5pobtMqNhaRMbK7R2bsIpI1DG+6ZVdWpbwFyFTWiNKDllADBgrKCDgBZyeswTJ
         c3zsCNlcDo3qm+44r68Hn7Vs9FnopKpndmowo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688008425; x=1690600425;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xsP6l6F2Ynxmy6UfbGE0U5XGQemQAiefdBx9y2MwRzY=;
        b=fyVYZUlxyY6N8PsTtzUkj8OegYaoKM767rMw/L5K00E1tzaw2oNFPqPY0lOl8UIvx7
         xvF3qIDhsrcM3KkRgOWkFzLLXtT46V9Si8IOCBBWzdU1dr+80eLekuuqKms1kLQ3mDjv
         2htOiYbodRFEQ6O9t/ghB15A35melt1PgHKI9oONCKVWajNzvy8lcTm1K9/BApdcMSoM
         F/BN140ck7WBCQAaEmqHfRqIORr1FJKvLMNjFVFn35/ztYV0bIn5CcJsvPNf6g4eZ6Uw
         hPg1z1dzh1dssRb0dSKi5VpShvp3rQU6ysjhtAIGUwPveqWkwq/NAN0x8xD3uOUdqTW7
         mTiw==
X-Gm-Message-State: AC+VfDwkv0AgF6k+jY53pRyGGpRxmrvIr0q0UgH25lEGqzL5deOWCc5C
        rWQFBQV5VQCVWZv6BzkE3XEHlZ65j7vLq82rcOLY4clH
X-Google-Smtp-Source: ACHHUZ73RvqvlHUlp9qhNmuEQpJ+An6yLl9UO8jRXrAmHfel2prNuwZvDEuKNUVRoalGMmbPW13i2Q==
X-Received: by 2002:aa7:c947:0:b0:51a:2c81:72ee with SMTP id h7-20020aa7c947000000b0051a2c8172eemr23896980edt.20.1688008424859;
        Wed, 28 Jun 2023 20:13:44 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id b17-20020aa7c6d1000000b0051de018af1esm217441eds.59.2023.06.28.20.13.42
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 20:13:43 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-51d9890f368so237366a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 20:13:42 -0700 (PDT)
X-Received: by 2002:aa7:da44:0:b0:51d:9605:28fc with SMTP id
 w4-20020aa7da44000000b0051d960528fcmr7619337eds.41.1688008422437; Wed, 28 Jun
 2023 20:13:42 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 28 Jun 2023 20:13:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
Message-ID: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
Subject: Build error in crypto/marvell/cesa/cipher.c
To:     Kees Cook <keescook@chromium.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

So I don't see anything that has changed, and I suspect the only
change is that my compiler version changed, but my arm64 build fails
right now with FORTIFY_STRING enabled.

On arm64 I now get this warning:

  In function 'fortify_memcpy_chk',
    inlined from 'mv_cesa_des3_ede_setkey' and
drivers/crypto/marvell/cesa/cipher.c:307:2:
  ./include/linux/fortify-string.h:583:25: error: call to
'__write_overflow_field' declared with attribute warning: detected
write beyond size of field (1st parameter); maybe use struct_group()?
[-Werror=attribute-warning[

but I haven't been compiling regularly enough to know when this
warning suddenly started showing up.

I enabled the cesa driver on x86-64 (by also letting it build with
COMPILE_TEST), and I do *not* see this warning on x86-64, which makes
me think it's the compiler version that matters here.

On my arm64 setup, I have gcc-13.1.1, while my x86-64 build is still 12.3.1.

But I think the warning is correct.  The problem is that the 'ctx'
pointer is wrongly typed, and it's using "struct mv_cesa_des_ctx"
(which has a "key[]" size of DES_KEY_SIZE).

And it *should* use "struct mv_cesa_des3_ctx" which has otherwise the
same layout, but the right key size (DES3_EDE_KEY_SIZE).

Fixing that type fixes the warning.

I'm actually surprised that gcc-12 doesn't seem to warn about this.
Kees? This looks like a rather obvious overflow, which makes me think
I'm missing something.

I get a similar error in 'irdma_clr_wqes()' at
drivers/infiniband/hw/irdma/uk.c:103 (and same thing on line 105). I
don't see what the right solution there is, but it looks like we have

        IRDMA_CQP_WQE_SIZE = 8
        __le64 elem[IRDMA_CQP_WQE_SIZE];

and it's doing a 4kB memset to that element. The mistake is not as
obvious as in the cesa driver.

Kees, any idea why I'm seeing it now? Is it the new
-fstrict-flex-arrays=3? And if so, why? None of this is about flex
arrays...

Anyway, please forward me fixes so that I can have a working arm64
test build again....

               Linus
