Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DD4C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 20:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiKRUxm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 15:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKRUxl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 15:53:41 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AA71DA6D
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 12:53:39 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i29so1254217edj.11
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 12:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4epwfWNAzokGySOk696EuwX6VQFGPzhxiCCwLrWo4K4=;
        b=lvh+5iqnoeMbqTOFUgRekkXgzoI+MUVzPn1tcdkSUgSKJQztDaC9tgv6JTyqvzjPCt
         6QCeOhOH4wIoMK/GqZiqfDRZI9yBFwxgugjWlGIjJleqRSbdDRZuwJv6432mSI4Vh7Ng
         FtBkZLFRIa6BR67JUByTGzkaN+ZlupUogRSrONV+tmalD34zqdxq9bjNqJkdKqPELQXq
         Bh/fej5k0CLMb+XHbmPO36AsHDdJogbYvdj3qAlKkcVs7aUMONgaTeBaSebNbMPvZWN+
         sHtlJZRvmqW5i2XIh0Ed/+tkw0nQMLKzC8ksZSDS2uhT1bNxY7W4W1X7sXeS4odbfRts
         phVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4epwfWNAzokGySOk696EuwX6VQFGPzhxiCCwLrWo4K4=;
        b=buAe75FAkUN6x598TDx1FWaqRsxr0OtBDwwjynTtHcY5ZoJULAILlPCAkgLcbc4RYp
         F+tz/jGaANZ94U4BaDRRu8ghYaAOcP6BS+4v9TP1uK0vfapbK+IZoc2XzmQK+Io/TZ5+
         1TpPV4x/mAXlKQ8RNDlMfpqTYspC5bOtNq8o/0stqTg+tEXhAroA6IrR7v3nt7dIcf6u
         GWP6xkDZqJWUWxqntyz7CenEWrZNKfYkuBiMbdoL5MMpWnWRQMtyBIEGmM1h2AAE3ax9
         GulToFPbDx+nW89LAwti0E0OASLh/ZfkET2vZSY2EHUXDY+kNsU1wMyE+U4GgxY7HB47
         +mLw==
X-Gm-Message-State: ANoB5pkXYXE0Q14EPVtoHQXPvUlzBEGpPGKpg3P+jMsZ+sC2w64scW+q
        qpt8PeO1HbtBPJabh9/ueGsf9Of1J17n7F7fyFM3mg==
X-Google-Smtp-Source: AA0mqf5YWCm1mzMk/0OKxVn/peyI0qePhqRSuyYH5snmbxNtGbwGrmWQr+Ir83u3YT/kD4JHAstWgvryrD5kyWVXWUQ=
X-Received: by 2002:a05:6402:3893:b0:461:b033:90ac with SMTP id
 fd19-20020a056402389300b00461b03390acmr5885951edb.257.1668804818395; Fri, 18
 Nov 2022 12:53:38 -0800 (PST)
MIME-Version: 1.0
References: <20221118194421.160414-1-ebiggers@kernel.org> <20221118194421.160414-9-ebiggers@kernel.org>
 <Y3fmskgfAb/xxzpS@sol.localdomain> <CABCJKudPXbDx2MSURDxGanTLhBkJjpMx=G=2RPDi6+96LGxcvw@mail.gmail.com>
In-Reply-To: <CABCJKudPXbDx2MSURDxGanTLhBkJjpMx=G=2RPDi6+96LGxcvw@mail.gmail.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Fri, 18 Nov 2022 12:53:01 -0800
Message-ID: <CABCJKueoEkn7rWnDs7hb0nm84kKyyQuj5EVS_MtFNcfdT0D-EA@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] crypto: x86/sm4 - fix crash with CFI enabled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 12:27 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Fri, Nov 18, 2022 at 12:10 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > Sami, is it expected that a CFI check isn't being generated for the indirect
> > call to 'func' in sm4_avx_cbc_decrypt()?  I'm using LLVM commit 4a7be42d922af0.
>
> If the compiler emits an indirect call, it should also emit a CFI
> check. What's the assembly code it generates here?

With CONFIG_RETPOLINE, the check is emitted as expected, but I can
reproduce this issue without retpolines. It looks like the cfi-type
attribute is dropped from the machine instruction in one of the X86
specific passes. I'll take a look.

Sami
