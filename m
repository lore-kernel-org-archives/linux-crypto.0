Return-Path: <SRS0=nygc=5L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11434C2D0E9
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 19:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBFED206E6
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 19:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PcUVhKbS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCZT6V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 15:58:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37654 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbgCZT6V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 15:58:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id a32so3441143pga.4
        for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2020 12:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OTZW/xLJ1BGsM+V9a0Wd+8MrhnBqRKDutU8ctncjlHo=;
        b=PcUVhKbSFbaawYyYC8+zR2qy1gp/S0ozs7s298FEoX75NUCNOTOxZpUwkL/2BUIKbU
         1UuJ46D+uHnscvV5NwwYd2RvxJVn1lErDXqA54/Vlor6COuKu6nGflBx5lrs48i7/ZtN
         MDbZWsbZGH13AgWUH7a3rjhfQdyNBesbopTiYcTHUKsDsB1EB38myZ9ZCY0wgMvH9VOK
         OBUFs2yI+vQmfSglrQOEMCEe26acxGIhqKOE3iQE1MkeNugqOljlZIvptYte5zZ3ns2O
         6rZC9FL6Pj9kl42VVhXVFVkdkqfXF7y4ikn8FRIvNTv5uvQg+PZ1lwoNMskxyzJQuqQ6
         Y7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OTZW/xLJ1BGsM+V9a0Wd+8MrhnBqRKDutU8ctncjlHo=;
        b=eJvXYHgTdfydx2qd9uoCVOLx5jDgJjBFJJi1Ri3nmt6DFk9W5o9UI2pd4fgNBmW//2
         k+uzL9iAwlUgXSTKGZDpSPBZGVK64DCj7QYNML+51TYWBiZ/MaUmxS7gei71zNLZhdz+
         JREK1t5f5Z6E2Y+XQHqT8CfxGHX3nVrxXt6w9lEiRGsL+9n+K0QNPjCGrCenzZiyC+sX
         PuUKqo/htLa8/5pwcCcb7faiD8ihT7v6VoOGqQO1hEL3XHtn0jWoecpB3cJid4rWNT2C
         fV6cK4U5jnLI6zoGavCYNyCNrcZLRGMvHtRvUP9WEGqNfVPtGU/fsF/8eptfA3IXyQL5
         SsZg==
X-Gm-Message-State: ANhLgQ3LJqVgGMoxQpF607mUb6IqmdefVUpVOsOkR5mroCbZ/AKsehfd
        IUUvJ3qyJVvxOINWHcv/kXgUVjAwvsJSWS9/pah5KA==
X-Google-Smtp-Source: ADFU+vv9iYKelWkUk09S1YsFIpTByaYuAZxyhNxkqT/sKiyO5bU/yo1RpcYkW97YrXfQw4yo3szrTepwkZwCv6bwvZA=
X-Received: by 2002:a63:4453:: with SMTP id t19mr9656195pgk.381.1585252699540;
 Thu, 26 Mar 2020 12:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200326080104.27286-1-masahiroy@kernel.org> <20200326080104.27286-16-masahiroy@kernel.org>
 <CAKwvOdnG4F6+Ndfj+=BoV6OidJjWS_dYtjvyCEJ6nyxkSQc3rg@mail.gmail.com> <CAHmME9p_N2cpMt20Gf1kWTRnj36nwrceFxEui2MU0kFu3WOdww@mail.gmail.com>
In-Reply-To: <CAHmME9p_N2cpMt20Gf1kWTRnj36nwrceFxEui2MU0kFu3WOdww@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 26 Mar 2020 12:58:06 -0700
Message-ID: <CAKwvOdmLWqVq_EQk2S4FUSUCU7yoppYD4oiL+P7taWoDTyrb9w@mail.gmail.com>
Subject: Re: [PATCH v2 15/16] x86: update AS_* macros to binutils >=2.23,
 supporting ADX and AVX2
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 26, 2020 at 12:48 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Mar 26, 2020 at 11:55 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> > I see four checks for CONFIG_AS_AVX2 in:
> > net/netfilter/nft_set_pipapo.c
> > net/netfilter/nf_tables_api.c
> > net/netfilter/Makefile
> > net/netfilter/nft_set_pipapo_avx2.h
>
> That code isn't in Linus' tree right now is it? Does it make sense for

Indeed, it seems I was grepping in my checkout of -next.

> us to see which subsystem trees (crypto, netfilter, raid, etc) are
> submitted to 5.7? Or would you rather this patchset be rebased now on
> next?

I think rebasing on -next is the way to go.  I usually generate my
patches off of that, though some trees that don't feed into -next are
technically further ahead.

-- 
Thanks,
~Nick Desaulniers
