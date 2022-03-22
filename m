Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20A7C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 16:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbiCVQXw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 12:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239075AbiCVQXT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 12:23:19 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020272E9E2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 09:21:44 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id p15so19947816lfk.8
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24K1hLJb9rmuEHEKW5a8QYhjnmRyomvMSDjxeIg/X38=;
        b=VYS/UqPlwEg8dUg0nl76d7UJ1IUszygkxcr1j2/1mvgghsV+p3mYrgwsp34aOKQ6tk
         ScvhZMD1nx0OBvbT+5UaohuxHTKJjXselVVpziaLmccjKez67+onMBakhk/M73Kxl+Ut
         p2gOZHShBVjr2xBbgB8NPD9eut9eQpbmThYAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24K1hLJb9rmuEHEKW5a8QYhjnmRyomvMSDjxeIg/X38=;
        b=MeVfkostNctflgbQ76MERYq6nKCRQtAoodmw+P/BKpCQ3SCwYUlxdqcTZbnAyZG0I3
         0k9j3SaEXZ4dI7uDYJYwuQm042UHGQO2lQaxu2+9oBUHt+WDT7YrwOrarPBMW7oxD4tW
         Sv6UamlW70GmjMBLhSTvlEQwfOxaTww8AWgxYc4gmpegu2nnHV/Ouj6iX6FZrWZVsFri
         QbmXI3tOK/gefrtUEW9qq0Cuvwcbekgj8dM8+IdKHcToG7ydjnacvXHwm/RxIWUffW9r
         NLfBkoBs+kmE74ZwWtZj8ktE1nigrmiit2SeZmh7OWVcLQmBzTp1RX7BWCKldbGtfzHL
         +YJw==
X-Gm-Message-State: AOAM530NBtEa0xPfbAUc9Zsl/yV41z3AXF0GninReHpIFG57wLPfEdkd
        Fn69D3yGkdPhuzRe6t7L8SktDecxtMDWi8LYhgM=
X-Google-Smtp-Source: ABdhPJwZ9GuCzZuD3X8CUGFpv9TBRWDJbK45Rjlpio0VaA6JneDfKpTHyMJy+sjg4mo4+AGWITQI3g==
X-Received: by 2002:ac2:5223:0:b0:448:5100:e427 with SMTP id i3-20020ac25223000000b004485100e427mr19113392lfl.87.1647966099481;
        Tue, 22 Mar 2022 09:21:39 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id bu9-20020a056512168900b004489c47d241sm2245803lfb.32.2022.03.22.09.21.37
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 09:21:38 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id bn33so24656388ljb.6
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 09:21:37 -0700 (PDT)
X-Received: by 2002:a2e:6f17:0:b0:248:124:9c08 with SMTP id
 k23-20020a2e6f17000000b0024801249c08mr19763021ljc.506.1647966097175; Tue, 22
 Mar 2022 09:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220217162848.303601-1-Jason@zx2c4.com> <20220322155820.GA1745955@roeck-us.net>
In-Reply-To: <20220322155820.GA1745955@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Mar 2022 09:21:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjH7rNyP_S7ut3EUPfa_dOYAP1T6yOxS6hdVi3zPV9SzA@mail.gmail.com>
Message-ID: <CAHk-=wjH7rNyP_S7ut3EUPfa_dOYAP1T6yOxS6hdVi3zPV9SzA@mail.gmail.com>
Subject: Re: [PATCH v1] random: block in /dev/urandom
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "David S . Miller" <davem@davemloft.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Michal Simek <monstr@monstr.eu>,
        Borislav Petkov <bp@alien8.de>, Guo Ren <guoren@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joshua Kinard <kumba@gentoo.org>,
        David Laight <David.Laight@aculab.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 22, 2022 at 8:58 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> This patch (or a later version of it) made it into mainline and causes a
> large number of qemu boot test failures for various architectures (arm,
> m68k, microblaze, sparc32, xtensa are the ones I observed). Common
> denominator is that boot hangs at "Saving random seed:". A sample bisect
> log is attached. Reverting this patch fixes the problem.

Ok, it was worth trying, but yeah, it clearly causes problems for
various platforms that can't do jitter entropy and have nothing else
happening either.

Will revert.

Thanks.

               Linus
