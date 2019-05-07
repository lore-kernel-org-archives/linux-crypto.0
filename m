Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FA5C004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 21:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70CC5206A3
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 21:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YehQViZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfEGVIH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 17:08:07 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:33457 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfEGVIG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 17:08:06 -0400
Received: by mail-vs1-f65.google.com with SMTP id z145so11316290vsc.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 May 2019 14:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NyT42HhZo+NoWlMcFfVHa74AFNvsodijHlMncKg590Q=;
        b=YehQViZvLM7Lmr9d7H2oBVwOnhxc/W7ZGb3C0R7fmfvEgavSj8wr0dWjHPOIOGCXVB
         ++EpCbZEDhD0i+6YXXoX1RK3f89W5kHuFQztGG9LtdCwHB6ZKLxVsTYZOa3dSuXWWfxY
         9ZMhyvs5cRAiCyhMUyX4IsaE2+u2EYpSjxKnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NyT42HhZo+NoWlMcFfVHa74AFNvsodijHlMncKg590Q=;
        b=t5qyAabf7/ynJeM5q+N29vtO3Xp8wSvATW8ENNStdEyK2ZFJ6RJ32qvpfvhT8qCCbt
         0R7ztoytpQAyrr/s63pogeer+xV/ktc/p8gUWMzxP9dwvIyZ6o0fzANekGCfk1gg+qLR
         3x8krHVuG4h3h4hgt7bMGS35TYRYkfwLVIGVWIBMH2YX1JXpsclYIuNcXrvGoEd6R8pa
         XZu5xhXp7i+erztwWL6akQqSzLB78gQnr9MIsUUhPoPiVXl2ohuNdNe39sZmYO9p64bq
         V+cu+H2LIaIDzOuyVwgXUjh1qbNXklJbHx1eTJGaPjzBtSj96+ACRqABh5t8AsK+oS5U
         o1lA==
X-Gm-Message-State: APjAAAVhJj4RAwatE52bKH7TkGznpHIBsDuJhcOKq5qWLIooLY/dKWP7
        1K++Chy4ugx53LjV8v2mjROh0QNQ+lI=
X-Google-Smtp-Source: APXvYqzy3iup+IHmLNXURrkBr5LZVeUupS9SpZNleLKbIYazUDANWN09Ol2KLhAUwKt+iYuM42MX2g==
X-Received: by 2002:a05:6102:403:: with SMTP id d3mr9927404vsq.131.1557263284947;
        Tue, 07 May 2019 14:08:04 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id u3sm5318228vsi.2.2019.05.07.14.08.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 14:08:03 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id j184so11280138vsd.11
        for <linux-crypto@vger.kernel.org>; Tue, 07 May 2019 14:08:03 -0700 (PDT)
X-Received: by 2002:a67:dd95:: with SMTP id i21mr13304046vsk.48.1557263282871;
 Tue, 07 May 2019 14:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190507161321.34611-1-keescook@chromium.org> <20190507170039.GB1399@sol.localdomain>
In-Reply-To: <20190507170039.GB1399@sol.localdomain>
From:   Kees Cook <keescook@chromium.org>
Date:   Tue, 7 May 2019 14:07:51 -0700
X-Gmail-Original-Message-ID: <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
Message-ID: <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Joao Moreira <jmoreira@suse.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 7, 2019 at 10:00 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > Given the above, the current efforts to improve the Linux security,
> > and the upcoming kernel support to compilers with CFI features, this
> > creates macros to be used to build the needed function definitions,
> > to be used in camellia, cast6, serpent, twofish, and aesni.
>
> So why not change the function prototypes to be compatible with common_glue_*_t
> instead, rather than wrapping them with another layer of functions?  Is it
> because indirect calls into asm code won't be allowed with CFI?

I don't know why they're not that way to begin with. But given that
the casting was already happening, this is just moving it to a place
where CFI won't be angry. :)

> >   crypto: x86/crypto: Use new glue function macros
>
> This one should be "x86/serpent", not "x86/crypto".

Oops, yes, that's my typo. I'll fix for v4. Do the conversions
themselves look okay (the changes are pretty mechanical)? If so,
Herbert, do you want a v4 with the typo fix, or do you want to fix
that up yourself?

Thanks!

-- 
Kees Cook
