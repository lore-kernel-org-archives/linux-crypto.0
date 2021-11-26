Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27433C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 20:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhKZU11 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 15:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236513AbhKZUZ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 15:25:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094EAC0613FB;
        Fri, 26 Nov 2021 12:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C7462294;
        Fri, 26 Nov 2021 20:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7D3C53FAD;
        Fri, 26 Nov 2021 20:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637957988;
        bh=a0s2gfBWietgKO4JH0PNWWcxxCfP3DUg5GlbyFnS0hs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E7DmdJOmjwVfimksFXilYgRFugV24ViMgoFEjJi6fTRk53x9ErkXvdAaKISr/VTzn
         SUZB9Uh+IiEcZqLUNf4W9iO5dk++0sldocgQW9YGwlQZmNEWH56WR1Wu/4WbAX7tO1
         CmGjTb2UN9uw10GqOpFuhmsOvCrBWbcfT8/xHCYToIosZh2YVeWayxPSqvgesUzouC
         WCrGwoD964D7ddpv8xShKcGAjsAJYB7H/DndpaCvGZEByp+fRzIpeYb/8uLMnifJAe
         aTe6pUiqqzQq1nUZ+6QrnEVnpJNOvnyYFXKQ5Sf+IfjveuwDTxhfaNfmfX85tqBISF
         4oDOLcRNVDOTQ==
Received: by mail-wm1-f42.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so7513205wme.4;
        Fri, 26 Nov 2021 12:19:48 -0800 (PST)
X-Gm-Message-State: AOAM531oB6p6uRfBYfWIu9EO05KRszkPlwcdAZ4d0PSYNCMVv4cvPCJE
        eggYnHaEne76c8WUPRqur0zvkIPEuD1Kow2GSXI=
X-Google-Smtp-Source: ABdhPJz71/waTta7JgF/geLHgSsIO5CbXPWZ0x5mbSBBYj0q5j8zzOZzGV/JPWNvtUxQCqCYRgc/10cMEUpCWtNsy1s=
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr18302939wmb.1.1637957987118;
 Fri, 26 Nov 2021 12:19:47 -0800 (PST)
MIME-Version: 1.0
References: <20211126143329.2689618-1-arnd@kernel.org> <CAHmME9rotnZRzqeD43FJmSX6-i2CwvUVpXHrFkLGt+qVVdxK7A@mail.gmail.com>
 <CAK8P3a2KfmmGDbVHULWevB0hv71P2oi2ZCHEAqT=8dQfa0=cqQ@mail.gmail.com> <CAHmME9q3ihG6OukcbhgkzwMUY7y+N3tKrGu2aRHjkgmAv4j=WQ@mail.gmail.com>
In-Reply-To: <CAHmME9q3ihG6OukcbhgkzwMUY7y+N3tKrGu2aRHjkgmAv4j=WQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 26 Nov 2021 21:19:31 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1Jk8-mokkzo6Q4M5xoO+13fCgdh-A2bajD9HR7Xenn0w@mail.gmail.com>
Message-ID: <CAK8P3a1Jk8-mokkzo6Q4M5xoO+13fCgdh-A2bajD9HR7Xenn0w@mail.gmail.com>
Subject: Re: [PATCH] crypto: siphash - use _unaligned version by default
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 26, 2021 at 4:26 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Fri, Nov 26, 2021 at 10:18 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > I have not tested this specific patch on all platforms, but I did
> > extensive testing of the get_unaligned()/put_unaligned() helpers
> > in my rewrite earlier this year[1], making sure that these are NOPs
> > on all the important architectures, and that they prevent the use
> > of trapping ldrd/ldm instructions on ARMv6/ARMv7.
>
> If you're confident that the codegen doesn't change for ARMv8 and
> x86{,_64}, then:
>
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks

> We should probably Cc stable@, right?

Yes, I meant to add that but forgot.

> I'm preparing a patchset for DaveM's stable tree today, and I can take
> this in that patchset.

It's not urgent, but I think we need to fix it and get it into stable kernels
at some point. I'm happy with whatever timing works for you.

         Arnd
