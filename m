Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322D9C3A5A3
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 20:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015D32080F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 20:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="U75GJORV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfH2UAU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 16:00:20 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46821 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfH2UAT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 16:00:19 -0400
Received: by mail-ed1-f66.google.com with SMTP id z51so5324046edz.13
        for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2019 13:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aYf/lCZC1gwMIR9/lhwT5M/JPgKzeUqjFNgwUcFRWFg=;
        b=U75GJORVMHIr0iUVnntJaP5CkG0L6J04X+1V/ZPN5uW3dQqnBj8pdaROlXs8b4Z1SG
         DR1yBHet2NvJnJhuzP0i5c/qQ5sBWpaG0KlB9URDDEL2UqurL8fMaEild5hR6irruZ3I
         WwlNUWnUuDyL8bRkDmAo8qYqSmnG/ayXfekSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aYf/lCZC1gwMIR9/lhwT5M/JPgKzeUqjFNgwUcFRWFg=;
        b=DBun3p7SX2tn4H4k4fKd8Q9wblOhAT5/mOkfOE8eHGBt30BnaI3EPVu30UU2gCq46+
         GtyaYV9S+K4RybDmbFZj7N5jtS2bvwuApWdtVIcdK5xdvE9sSTAiB+iMOH8TS3979hk0
         QREl8TmMkA5PwPUg0bTxeGkJR8szvU7/HxFJLQEUqv+WNjQgiRWuuarq/pl+3sODkg1P
         6UbPGdclmwFiGoKmvWVA6tzPODrUEamlGqui9EzRI0BYZHK5lmING38LAEp8isQNmrnH
         yhgqsEJ4oQ+ROUDltuV+E12TeasXnAzRUHR8JN9jBOQUGRbTFWT0pdSRcOwy5OrTQrig
         Exwg==
X-Gm-Message-State: APjAAAVclk3UowlC+PcKsOuNnK4hMplkQ0DrnQsh/AJBopMNnS8DwYnV
        KLKPiKSCoHWjy6h/YsIpttRoNmkwp/U=
X-Google-Smtp-Source: APXvYqzPdB0oLyxq+DXZGI8bqSgItR55AdgIe+NVyEoii7KCMMvtSaLp+VqG/a/0cWy+TNZIYz03Jw==
X-Received: by 2002:a50:f592:: with SMTP id u18mr11689146edm.296.1567108817644;
        Thu, 29 Aug 2019 13:00:17 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id j2sm507760ejj.34.2019.08.29.13.00.17
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2019 13:00:17 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id b16so4646722wrq.9
        for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2019 13:00:17 -0700 (PDT)
X-Received: by 2002:a5d:4a4e:: with SMTP id v14mr13235010wrs.200.1567108513590;
 Thu, 29 Aug 2019 12:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190806154347.GD25897@zn.tnic> <20190806155034.GP2349@hirez.programming.kicks-ass.net>
In-Reply-To: <20190806155034.GP2349@hirez.programming.kicks-ass.net>
From:   Thomas Garnier <thgarnie@chromium.org>
Date:   Thu, 29 Aug 2019 12:55:00 -0700
X-Gmail-Original-Message-ID: <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
Message-ID: <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
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

On Tue, Aug 6, 2019 at 8:51 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Aug 06, 2019 at 05:43:47PM +0200, Borislav Petkov wrote:
> > On Tue, Jul 30, 2019 at 12:12:44PM -0700, Thomas Garnier wrote:
> > > These patches make some of the changes necessary to build the kernel as
> > > Position Independent Executable (PIE) on x86_64. Another patchset will
> > > add the PIE option and larger architecture changes.
> >
> > Yeah, about this: do we have a longer writeup about the actual benefits
> > of all this and why we should take this all? After all, after looking
> > at the first couple of asm patches, it is posing restrictions to how
> > we deal with virtual addresses in asm (only RIP-relative addressing in
> > 64-bit mode, MOVs with 64-bit immediates, etc, for example) and I'm
> > willing to bet money that some future unrelated change will break PIE
> > sooner or later.

The goal is being able to extend the range of addresses where the
kernel can be placed with KASLR. I will look at clarifying that in the
future.

>
> Possibly objtool can help here; it should be possible to teach it about
> these rules, and then it will yell when violated. That should avoid
> regressions.
>

I will look into that as well.
