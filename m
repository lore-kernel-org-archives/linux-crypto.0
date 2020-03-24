Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1419DC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 16:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1CF206F6
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585069118;
	bh=wv7V6OA+vnQKUw2Y4zY+fl+UxUMw0in7d1nJHJs3HkQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=j4RThhwM664FeQGOwPgNHPOtIAHJQHQdokChNRqNBX5tXwS9s+t5IsxKHxUzrJN8D
	 D7KGJEPLXYB4ltW4R5ohwDZd0e+xtjDDoSTZACHvqvWcRZZRNYHD/q8zOJToqgU7Bw
	 yM11Jy5AduEr31zdmjhjAfsGsa26itHU2VFFF4xo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCXQ6i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Mar 2020 12:58:38 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46894 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCXQ6i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Mar 2020 12:58:38 -0400
Received: by mail-lf1-f66.google.com with SMTP id q5so1972487lfb.13
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2020 09:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsR634IM9mmhNsoHiRslx4q1ur3OKG9sqLOfW3mTlvE=;
        b=Z4pJJsNRptNjfG3P3MoBuNrYlnzenPIYlkT2d80DcIZW7UeaJ7NzLHI1ja4yIjcDoc
         /iKfJJvm1iYP31UYLTqjCrBqL5Uar8necO8dCIgcOuI51Nj7AidT3P8YaYaCV6jUFzMJ
         fsKqZJnyfGhT7+0lEb4rByJaviH4S/tML+mT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsR634IM9mmhNsoHiRslx4q1ur3OKG9sqLOfW3mTlvE=;
        b=cFHJJjY+dluOGvYpSuT3IpSzU/vwe28AkswnyZS5anZfnBN4caSEiMbUSryXhC9i1T
         J+XHVOZ8mMrAcZPv8uylzSle+6dlwT2BZuLGo7/ghkeZSibOC7fFp6ZpvWV5o05zkYaq
         QE7+DTC+0UOsRYwIrwETHBvClmQjujnmtWDLsNapATaB9gs2dMWoQNhbyfWEOprH2M/P
         oM2cQ/r2EZzTEGbCJ5kVqyX2/yoY1mTEVVfIfY0/EL7ujPEXuZx9OPayMjrEL2XUZjoy
         /JYCR3qZVZOU+NrwGOf095UnoRz94nwTf64bF7/zCWNa3WvCOwmvdWJ1UuMywU5Wmk/e
         /XXg==
X-Gm-Message-State: ANhLgQ27mtevqix6+wiOAfRCVSJrwkqQykpe/y1QTh5Rqha9t7a9NVV0
        tuZM08zhWBx6nFGFjcOptqBXf9eCbcs=
X-Google-Smtp-Source: ADFU+vupcu9+qvWPx345vBsAWLLYNK+SuekBn4Pl8iGKX+nWgo4hZG/oUbXg+H7qyqV+R+CxGmgflw==
X-Received: by 2002:a05:6512:1085:: with SMTP id j5mr17049590lfg.183.1585069115852;
        Tue, 24 Mar 2020 09:58:35 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id b8sm6064209lfb.6.2020.03.24.09.58.35
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 09:58:35 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id r24so19449505ljd.4
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2020 09:58:35 -0700 (PDT)
X-Received: by 2002:a05:6512:10cf:: with SMTP id k15mr17550349lfg.142.1585068727556;
 Tue, 24 Mar 2020 09:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200324084821.29944-1-masahiroy@kernel.org>
In-Reply-To: <20200324084821.29944-1-masahiroy@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 24 Mar 2020 09:51:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjEi4VoT8qkBhrBtdZ27shyrPwo0ETpuOdxk5anHtQqhQ@mail.gmail.com>
Message-ID: <CAHk-=wjEi4VoT8qkBhrBtdZ27shyrPwo0ETpuOdxk5anHtQqhQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] x86, crypto: remove always-defined CONFIG_AS_* and
 cosolidate Kconfig/Makefiles
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        NeilBrown <neilb@suse.de>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx@lists.freedesktop.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 24, 2020 at 1:49 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> If it is OK to queue this up to Kbuild tree,
> I will send a pull request to Linus.

Looks fine to me, assuming we didn't now get some confusion due to
duplicate patches (I think Jason got his tree added to -next already).

And yeah, that end result looks much better.

             Linus
