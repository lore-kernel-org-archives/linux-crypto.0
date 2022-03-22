Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB95C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 18:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbiCVSbI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 14:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240413AbiCVSbI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 14:31:08 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3CC8BE17
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 11:29:40 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h7so13792671lfl.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 11:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s7fGS2THKosBu353nmhFTYnuK74oZhJix6ssyL7knBQ=;
        b=Q/ZAdDUNaeSeKURz7X4B2cBhM6bNXJWO2xu3e29wki3/WuCjnbZ82m1VywcC7gHSKD
         H9PkeROEneN6EmxZABVo727EtN9zLqdiAke3RVkes/bdmZ76eQ4mDBg23CtRHP7GBYTG
         20z98gmaXsaOS7HD7PH1Wzt9H+PEEaXY+7i5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s7fGS2THKosBu353nmhFTYnuK74oZhJix6ssyL7knBQ=;
        b=j0/f9TV5QjGs4E2RGTxzOCdzhz/hfIrT/jdCVTXqs+UYAeQevln2/RNbKUVgyQleZR
         JYYwi9e3dpQwfR8BXegEbJTNmdM4yG5Odc6+Oah8Yqd62nEjq+EoGvB0OjI/il5t3QIU
         yuUMu0cKcwFvtR91e7uhVE/vUlh5rgIpi28eAwTeyxfyTI7IFpZlN4ReDK97ouu8h/81
         zJLqK/EVtsUk30dhzXsEUnUuu65f27/QS5fuwPw9DV5xXQHKbvGuqYCymCCv/qPDv7x3
         RsHRBjNrOGTlLTWmyoXPiAz4R2RbvrD9fgLdMMOb/Tvks5vpaiXbKaPOKkoBVjIK7HY0
         Ze7Q==
X-Gm-Message-State: AOAM532ETUS8hmC40HsNPtdJAPuF+IQnwGYumHKpU4Kp1U0nMhuVR1yH
        /q2hz41q2erQPtpvvo1PndvYDLkSI6ZHs95UhOw=
X-Google-Smtp-Source: ABdhPJxfXTt4N/RbPutrd/C5QjDgp+Tgt8LFjIHltGFGUkbyYxHodJZaqcdQjYcvVQKPBF6o2gG4VA==
X-Received: by 2002:ac2:57db:0:b0:44a:23ce:b7f5 with SMTP id k27-20020ac257db000000b0044a23ceb7f5mr9988990lfo.235.1647973778660;
        Tue, 22 Mar 2022 11:29:38 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id b3-20020a056512304300b004488e49f2fasm2271210lfb.129.2022.03.22.11.29.38
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 11:29:38 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id q14so11861955ljc.12
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 11:29:38 -0700 (PDT)
X-Received: by 2002:a2e:9904:0:b0:247:ec95:fdee with SMTP id
 v4-20020a2e9904000000b00247ec95fdeemr20248728lji.291.1647973777786; Tue, 22
 Mar 2022 11:29:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220217162848.303601-1-Jason@zx2c4.com> <20220322155820.GA1745955@roeck-us.net>
 <YjoC5kQMqyC/3L5Y@zx2c4.com> <d5c23f68-30ba-a5eb-6bea-501736e79c88@roeck-us.net>
 <YjoTJFRook+rGyDI@zx2c4.com>
In-Reply-To: <YjoTJFRook+rGyDI@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Mar 2022 11:29:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiq3bKDdt7noWOaMnDL-yYfFHb1CEsNkk8huq4O7ByetA@mail.gmail.com>
Message-ID: <CAHk-=wiq3bKDdt7noWOaMnDL-yYfFHb1CEsNkk8huq4O7ByetA@mail.gmail.com>
Subject: Re: [PATCH v1] random: block in /dev/urandom
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
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

On Tue, Mar 22, 2022 at 11:19 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The first point is why we had to revert this patch. But the second one
> is actually a bit dangerous: you might write in a perfectly good seed to
> /dev/urandom, but what you read out for the subsequent seed may be
> complete deterministic crap. This is because the call to write_pool()
> goes right into the input pool and doesn't touch any of the "fast init"
> stuff, where we immediately mutate the crng key during early boot.

Christ, how I hate the crazy "no entropy means that we can't use it".

It's a disease, I tell you.

And it seems to be the direct cause of this misfeature.

By all means the code can say "I can't credit this as entropy", but
the fact that it then doesn't even mix it into the fast pool is just
wrong, wrong, wrong.

I think *that* is what we should fix. The fact is, urandom has
long-standing semantics as "don't block", and that it shouldn't care
about the (often completely insane) entropy crediting rules.

But that "don't care about entropy rules" should then also mean "oh,
we'll mix things in even if we don't credit entropy".

I hope that's the easy fix you are thinking about.

              Linus
