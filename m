Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214C5C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 01:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E00FD2074D
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 01:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VArAoFdS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgCXB3o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 21:29:44 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:58497 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgCXB3o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 21:29:44 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b41b2cf2;
        Tue, 24 Mar 2020 01:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=+Xu1aIIocQxxSyjwcJCsITgsSrM=; b=VArAoF
        dSoDLHCpISEg26DC1Skrg7AZ1TGGcAiixPBk2WqYCFfF6tS61RXtiAslD2rLWU3g
        4SZmqi9REupjcYV0WRKnVtIFrK0KQmVYkxgYADgiQIR6WaGhccfH7ATiK38jsTWV
        AFbuUi8oR9UfvTc2AY2EoM/zliPr1GTIz9cEHZYJSbsaR+T2URWlykfSfbgQ/TU3
        qG1sZN1WUVyNs+aGCDepZD/rw7zGgxqLxdDWFsowamV/21iaojdyg9b307zfIipy
        +nhCufzoKQpdSsH2JoQKeYh/dlPEoxmUME8qhtfHYvHSD5uXeZDe4W2qLKzmbW3l
        mwEkNBxD9CTV3Asw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2f0c2bf5 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 24 Mar 2020 01:22:37 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id r5so10560977ilq.6;
        Mon, 23 Mar 2020 18:29:40 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3/yDVQKpf3ubsh0JI6Xr7YJXWFzW2NXVeLgpRgT8r09i93yJZK
        FRdi3l2LvIFmIocv24NzN1iBgkS1TKcu/JApEWQ=
X-Google-Smtp-Source: ADFU+vsZnLmmNFEGUtbGlg0l2rrxloMxuDwfOYE0grNhPVwv49YwImsTdzXnXY4lyRjaV7OGVqknY0zFwGfmGNe8vKs=
X-Received: by 2002:a92:cd4e:: with SMTP id v14mr24886394ilq.231.1585013379684;
 Mon, 23 Mar 2020 18:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200324001358.4520-1-masahiroy@kernel.org> <CAHmME9rdoo2Q3n4YA59GrVEh8uaCY_0-q+QVghjgG3WwcHkmug@mail.gmail.com>
 <CAK7LNATQG4ABWxkShbgTpW78M4FYY_9Fmg2GSxXDTE51yWF=MQ@mail.gmail.com>
In-Reply-To: <CAK7LNATQG4ABWxkShbgTpW78M4FYY_9Fmg2GSxXDTE51yWF=MQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 19:29:28 -0600
X-Gmail-Original-Message-ID: <CAHmME9psbhB8mR-DCnQw475xJLJ9SQLvX=p0LZj2c4p3WkoB_w@mail.gmail.com>
Message-ID: <CAHmME9psbhB8mR-DCnQw475xJLJ9SQLvX=p0LZj2c4p3WkoB_w@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] x86: remove always-defined CONFIG_AS_* options
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 23, 2020 at 6:53 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> The drm one was independent of the others,
> so I just sent it to drm ML separately.
> As for your 4, I just thought you would
> send a fixed version.
> But, folding everything in a series will clarify
> the patch dependency.
> OK, I will do it.

Great, thanks. The ones in that branch now are ready to go, so grab
them out of there.

> Who/which ML should I send it to?

This seems to make sense, IMHO, for x86 or just as a pull to Linus
(i.e. the "kbuild mailing list", in which case, you'd send a pull from
your tree).

Jason
