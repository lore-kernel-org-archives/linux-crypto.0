Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634B6C43217
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 17:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242343AbiKRRVo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 12:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbiKRRVl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 12:21:41 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743392F03B
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:21:40 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x2so8087478edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aBnx0UjYWHFOugieo61rxhK1NYH631ucDHVcVLIUyL0=;
        b=WqAvU1Rz4ZqPy5A/GuoUURtSueLb1U75hDmzuJQSQcSGGPvOMXDbrJiBv1zQoxR2ng
         m6bCObZMlesyHfvEoZR+F3T0wm9Sp/mYgq3/tcOZf2UY1o9SLVOvdQaJjMtjjc+3GU+w
         yERgh668hu6omxoIsL35BMNBSLSkzpjjY3zKqVuh4E8vjoHQ0O0Hz8hSQDRQm3ciHEaN
         YPL04IirxV6bb1xVhzjVNO/ZxeWUEx2VjSOc13duauvYdh7p2UwmzCCny1YjnzVp6MX1
         RUgzhkYcX4FwUOjQo2fT+ow5At6cN9xRX5ytBlUYWgJcAgLDYwwpQcpZZWz6FlE2ylZl
         9vFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBnx0UjYWHFOugieo61rxhK1NYH631ucDHVcVLIUyL0=;
        b=Yy0/yevXTMx7wToVgDkisK8vBJvRdsNjjUkJENxkT0gfovlavf6h0XliIpyjsMP+jQ
         X/Qw1PXVdBo+4ZcSEwsLYz7buOiMquu2wlmBLsQ1s3ehf5e3y4MQi0tcImzw+XqxLuaB
         gQrVYpPLvEYXq4Z1aAoIZyTd83hsANvMsN87K+q0WQL6pZWe+aLVbJLEFOcrslYlsqP1
         pQrGqoqO8+/4q6ZihNAE6pfuo2VjHoXrwjArQ4KdpBbSzeb7zZjHfjbqZi/XDsw82Q90
         VMqmDqQ7zHaA4YH7WBsdxZ0JaarOzf+OH/GRhTpP5Zf5Rj4/7v2xSCqXR1h16C6e3BvI
         jAnQ==
X-Gm-Message-State: ANoB5pneIxgDtXDHDjel6f5qXPq5dQEoY9uFxnPUOGz4S2iM9DWPtx9L
        Aj031anspsR1xLLKenuhu+jqNjL31e+BaBhgy80vbAFaCFA=
X-Google-Smtp-Source: AA0mqf4Crl2ISLsn3C9JDaINEURRIKiSQB5cGcGK+FrLyfHVJGytaQccpcGEkSMOZb79q10cebl3QX0NjHdYUPxpPpg=
X-Received: by 2002:aa7:c04f:0:b0:45c:f13b:4b96 with SMTP id
 k15-20020aa7c04f000000b0045cf13b4b96mr7013650edo.129.1668792098642; Fri, 18
 Nov 2022 09:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20221118090220.398819-1-ebiggers@kernel.org>
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Fri, 18 Nov 2022 09:21:02 -0800
Message-ID: <CABCJKucCZfS_QygPnun1jxQnfjRbNh5rCwb=-8Z06m7aE7mjDQ@mail.gmail.com>
Subject: Re: [PATCH 0/11] crypto: CFI fixes
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 1:04 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series fixes some crashes when CONFIG_CFI_CLANG (Control Flow
> Integrity) is enabled, with the new CFI implementation that was merged
> in 6.1 and is supported on x86.  Some of them were unconditional
> crashes, while others depended on whether the compiler optimized out the
> indirect calls or not.  This series also simplifies some code that was
> intended to work around limitations of the old CFI implementation and is
> unnecessary for the new CFI implementation.
>
> Eric Biggers (11):
>   crypto: x86/aegis128 - fix crash with CFI enabled
>   crypto: x86/aria - fix crash with CFI enabled
>   crypto: x86/nhpoly1305 - eliminate unnecessary CFI wrappers
>   crypto: x86/sha1 - fix possible crash with CFI enabled
>   crypto: x86/sha256 - fix possible crash with CFI enabled
>   crypto: x86/sha512 - fix possible crash with CFI enabled
>   crypto: x86/sm3 - fix possible crash with CFI enabled
>   crypto: arm64/nhpoly1305 - eliminate unnecessary CFI wrapper
>   crypto: arm64/sm3 - fix possible crash with CFI enabled
>   crypto: arm/nhpoly1305 - eliminate unnecessary CFI wrapper
>   Revert "crypto: shash - avoid comparing pointers to exported functions
>     under CFI"

Thanks for the patches, Eric!  These look good to me.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
