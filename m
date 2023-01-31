Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F90DC636CC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjAaIL3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjAaIL2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:11:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF25A2CFF7
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54AF961422
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 08:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ADBC433D2
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 08:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675152686;
        bh=bls1TOMGwuVBnvGOci8f6h/mk74RnVQlKJSq1IwnxE4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t507yDR7qYmGWqQi7iYXkbTyW3GZ4taTVM6TTeci9v0reBZB/decRlM3nryL59sRK
         CY1EEMwNtth4XLAhRSughtS7cIqlWiVOrlNxHJoAmL/1lne0QmNOH+x1oeI18/VutM
         OKG04SS5+p2Iv2jSKT99XwybJfjRcJm2b197h1zFTtdsod6P+HkVUljZ+peSMo+8KR
         606fWdjyMJT2tnJiHkGGqWV4B4m+tC1zZhNLTndBUNdJc7UU7YH3BnFBGfDziTNDU4
         iebKH++gZZI+JHRfQFUr7MszRWuu5kYiZ6dxgFE5sHzObWl8jd7ZoSVWymzLrJyLLn
         JkViOvqlAdwpQ==
Received: by mail-lj1-f170.google.com with SMTP id d8so2797098ljq.9
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:11:26 -0800 (PST)
X-Gm-Message-State: AO0yUKWwnmK0xgIly88j3vg9AOrikh3Uq0BqHxccEzTvnv8y2xpilMKi
        4kfTeAIuapv5X5Xd4ygvnSgtV+x5jGxBCn10HS8=
X-Google-Smtp-Source: AK7set9qlfRp83h8dD5zGyekf25bVuitp7xllPAtk+To3swqQsCEBLoj26P0UQ6nvHyERryFvIc0rdgfG0iKRFKtg8Q=
X-Received: by 2002:a2e:8006:0:b0:290:50e9:4b21 with SMTP id
 j6-20020a2e8006000000b0029050e94b21mr1196792ljg.178.1675152684741; Tue, 31
 Jan 2023 00:11:24 -0800 (PST)
MIME-Version: 1.0
References: <20230131012624.6230-1-peter@n8pjl.ca>
In-Reply-To: <20230131012624.6230-1-peter@n8pjl.ca>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 31 Jan 2023 09:11:13 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG7m9aYjStESRu7r-7qN0ursAi5jY33EpEOTLbPxUS8Ow@mail.gmail.com>
Message-ID: <CAMj1kXG7m9aYjStESRu7r-7qN0ursAi5jY33EpEOTLbPxUS8Ow@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] crypto: x86/blowfish - Cleanup and convert to
 ECB/CBC macros
To:     Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 31 Jan 2023 at 02:26, Peter Lafreniere <peter@n8pjl.ca> wrote:
>
> We can acheive a reduction in code size by cleaning up unused logic in
> assembly functions, and by replacing handwritten ECB/CBC routines with
> helper macros from 'ecb_cbc_helpers.h'.
>
> Additionally, these changes can allow future x86_64 optimized
> implementations to take advantage of blowfish-x86_64's fast 1-way and
> 4-way functions with less code churn.
>

'future x86_64 optimized implementations' of blowfish? That is a joke, right?

> When testing the patch, I saw a few percent lower cycle counts per
> iteration on Intel Skylake for both encryption and decryption. This
> is merely a single observation and this series has not been rigorously
> benchmarked, as performance changes are not expected.
>
> v1 -> v2:
>  - Fixed typo that caused an assembler failure
>  - Added note about performance to cover letter
>
> Peter Lafreniere (3):
>   crypto: x86/blowfish - Remove unused encode parameter
>   crypto: x86/blowfish - Convert to use ECB/CBC helpers
>   crypto: x86/blowfish - Eliminate use of SYM_TYPED_FUNC_START in asm
>

Tested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>


>  arch/x86/crypto/blowfish-x86_64-asm_64.S |  71 ++++----
>  arch/x86/crypto/blowfish_glue.c          | 200 +++--------------------
>  2 files changed, 55 insertions(+), 216 deletions(-)
>
> --
> 2.39.1
>
