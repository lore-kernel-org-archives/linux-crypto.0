Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B96C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 23:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B7F4208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 23:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CfxhObTV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392707AbfIFX3X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 19:29:23 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34890 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391276AbfIFX3X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 19:29:23 -0400
Received: by mail-ed1-f66.google.com with SMTP id t50so8021584edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 16:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eqinxltb4P+tBqyuO4WEtRUcfdT4qbszA3gfVj1CVng=;
        b=CfxhObTVAmcNKpN/uttdeqMFFuot/dgQ8oBhunu1p3A2/KXMdnJc7eTmTJi6e2ocMn
         NDFZD/Qh8ub6N+V6n8nGKJNHUKm6leUg+lflNX9keuez69bvdXFvHkCOlVvCSi5FCwQp
         GqpsxbxIXF0lypQ9v5DbU9u4VRzHE/ky6Ttco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eqinxltb4P+tBqyuO4WEtRUcfdT4qbszA3gfVj1CVng=;
        b=SsJ3dApIRRFVLpsunw0/6zcHoiSd6SEP9pIaAmgWZQLdacKzNM2KypUuRXDGoYx52x
         63IZZJRnKel1zVs/RC/Ubty7NEVGLR7oyemoMZSefbqWMXJ+ZQuLf3eiZ8BuvVpvpEa7
         R/fjITaSp2UR94SdNI2SR4w06gHGxtLl+vFayLQaxqmeGgzcEx2eVgnfn9NB4FZNd8hw
         q8/LbvxL+/VM/2cyLxyWMjtopr5EznWNxFdkR1EpJnWTM88P5qbA6YqGJoeTQwzaAezo
         ZHLKfs0dCvM3o3X6itj3Jk8duYyeN+Oje/GErDUozJdgrW/K077+Fb9rGTOLqNSMpIjs
         ZYyA==
X-Gm-Message-State: APjAAAVJDpAG/W19xIQ6aA4oj7+yHMQ17e4sGnN/NFQ96JR0CwoDKa+b
        PO+lTvkDOnydlZRyZ01XJxt+jtuL9Cs=
X-Google-Smtp-Source: APXvYqxTbQ+/RtCi92AZVDqPKceL4jQt2sqcxb3W8WmlfYyV/6bioz4ReKGoGehp2QVKQXllisoTGA==
X-Received: by 2002:aa7:d456:: with SMTP id q22mr4657857edr.262.1567812561825;
        Fri, 06 Sep 2019 16:29:21 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id f36sm1111125ede.28.2019.09.06.16.29.21
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2019 16:29:21 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id w13so8143921wru.7
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 16:29:21 -0700 (PDT)
X-Received: by 2002:adf:de08:: with SMTP id b8mr8516944wrm.200.1567812179254;
 Fri, 06 Sep 2019 16:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190806154347.GD25897@zn.tnic> <20190806155034.GP2349@hirez.programming.kicks-ass.net>
 <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
In-Reply-To: <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
From:   Thomas Garnier <thgarnie@chromium.org>
Date:   Fri, 6 Sep 2019 16:22:47 -0700
X-Gmail-Original-Message-ID: <CAJcbSZEc07UJtWyM5i-DGRpNTtoxoY7cDpdyDh3N-Bb+G3s0gA@mail.gmail.com>
Message-ID: <CAJcbSZEc07UJtWyM5i-DGRpNTtoxoY7cDpdyDh3N-Bb+G3s0gA@mail.gmail.com>
Subject: Re: [PATCH v9 00/11] x86: PIE support to extend KASLR randomization
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Maran Wilson <maran.wilson@oracle.com>,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 29, 2019 at 12:55 PM Thomas Garnier <thgarnie@chromium.org> wrote:
>
> On Tue, Aug 6, 2019 at 8:51 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, Aug 06, 2019 at 05:43:47PM +0200, Borislav Petkov wrote:
> > > On Tue, Jul 30, 2019 at 12:12:44PM -0700, Thomas Garnier wrote:
> > > > These patches make some of the changes necessary to build the kernel as
> > > > Position Independent Executable (PIE) on x86_64. Another patchset will
> > > > add the PIE option and larger architecture changes.
> > >
> > > Yeah, about this: do we have a longer writeup about the actual benefits
> > > of all this and why we should take this all? After all, after looking
> > > at the first couple of asm patches, it is posing restrictions to how
> > > we deal with virtual addresses in asm (only RIP-relative addressing in
> > > 64-bit mode, MOVs with 64-bit immediates, etc, for example) and I'm
> > > willing to bet money that some future unrelated change will break PIE
> > > sooner or later.
>
> The goal is being able to extend the range of addresses where the
> kernel can be placed with KASLR. I will look at clarifying that in the
> future.
>
> >
> > Possibly objtool can help here; it should be possible to teach it about
> > these rules, and then it will yell when violated. That should avoid
> > regressions.
> >
>
> I will look into that as well.

Following a discussion with Kees. I will explore objtool in the
follow-up patchset as we still have more elaborate pie changes in the
second set. I like the idea overall and I think it would be great if
it works.
