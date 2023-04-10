Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB14CC77B61
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Apr 2023 09:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjDJJKy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Apr 2023 05:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjDJJKZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2023 05:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26D33AA7
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 02:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D1E360EAB
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 09:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40B2C4339C
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681117823;
        bh=EnS4Za9wWGQUDLP6ZUsyP+vM/Yrl2QXc/bQ4IWvbCuY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iVF6eZh5N9u9+FtOTYoV70kKks1IFjl3juU3kbDgbm2QaGXUV62X9L5aVb5+jK1yK
         85NbDXTIZiPnp9JpNhlbMlO10N6guh4iVriRcqx8OPg2dECZ3oRP9HcN8DhVRCIJnR
         UaHJTsyil+3plUmpGMX9wujqnh+igYCXD6ZyBp7Z2xoWdE/w0gsv/MvP8XYxm/TuUs
         uMxYoUHsYfeh3wUhNC4e7MjRXCk9TG13Nz+RGFC66PwxPQcdd5jkgoewu4DHmxPqQl
         fXw2+P9VJSf5vhQ5lRyyL8Ops6t/6G/CqizL9DE1x+V0Jq7Hzdk3ukk24e1uUNzN/C
         7Fxrx0U6HAV/Q==
Received: by mail-lf1-f51.google.com with SMTP id r27so5680245lfe.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 02:10:23 -0700 (PDT)
X-Gm-Message-State: AAQBX9ewZdravQNCpez7SDLvUoemc62z1oUhlvinOeOFMXn06x70Fyjo
        H3cD+DNZieN7zZUimMwxfaN6BGCa+PhnGlZME9k=
X-Google-Smtp-Source: AKy350Y26/TLrecJNbfS01aqrFvgjqLsQ/36JJdiA2gAY3yVzVePPFNHMVhC1fMnD3I7dkIlxOpya+SgHv+IoqPa1uE=
X-Received: by 2002:ac2:4908:0:b0:4db:1c2a:a96e with SMTP id
 n8-20020ac24908000000b004db1c2aa96emr1761537lfi.9.1681117821725; Mon, 10 Apr
 2023 02:10:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230408152722.3975985-1-ardb@kernel.org> <CAMj1kXEtwDyaJASbpRGOf9P1pvoyt02HMN9pawq4QyRD8UzJoA@mail.gmail.com>
In-Reply-To: <CAMj1kXEtwDyaJASbpRGOf9P1pvoyt02HMN9pawq4QyRD8UzJoA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 10 Apr 2023 11:10:10 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH5PhrQbwAOvpGwqCU-TTmfK-=eYbbwbcxra=e_8wjX-g@mail.gmail.com>
Message-ID: <CAMj1kXH5PhrQbwAOvpGwqCU-TTmfK-=eYbbwbcxra=e_8wjX-g@mail.gmail.com>
Subject: Re: [PATCH 00/10] crypto: x86 - avoid absolute references
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 8 Apr 2023 at 17:32, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Sat, 8 Apr 2023 at 17:27, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > This is preparatory work for allowing the kernel to be built as a PIE
> > executable, which relies mostly on RIP-relative symbol references from
> > code, which don't need to be updated when a binary is loaded at an
> > address different from its link time address.
> >
> > Most changes are quite straight-forward, i.e., just adding a (%rip)
> > suffix is enough in many cases. However, some are slightly trickier, and
> > need some minor reshuffling of the asm code to get rid of the absolute
> > references in the code.
> >
> > Tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on a x86 CPU that
> > implements AVX, AVX2 and AVX512.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Cc: Kees Cook <keescook@chromium.org>
> >
> > Ard Biesheuvel (10):
>
> >   crypto: x86/camellia - Use RIP-relative addressing
> >   crypto: x86/cast5 - Use RIP-relative addressing
> >   crypto: x86/cast6 - Use RIP-relative addressing
> >   crypto: x86/des3 - Use RIP-relative addressing
>
> Note: the patches above are
>
> Co-developed-by: Thomas Garnier <thgarnie@chromium.org>
> Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
>
> but this got lost inadvertently - apologies.
>
> Herbert: will patchwork pick those up if I put them in a reply to each
> of those individual patches?
>

Never mind, I'll be sending out a v2 in any case.
