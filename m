From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Fri, 17 Mar 2017 19:47:33 +0100
Message-ID: <CACT4Y+Ysvjz+UzEi0dTtsNxxnG7WXTiZPr+KSk8HHwSu7vX1ew@mail.gmail.com>
References: <20170317001520.85223-1-md@google.com> <20170317001520.85223-7-md@google.com>
 <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net>
 <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com>
 <CAG_fn=WooTLkzex3hqPgO5pr7GsK3v7Z5riSA7K+-_S=S7rmBQ@mail.gmail.com> <20170317180350.63jjysejk2i6vkon@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alexander Potapenko <glider@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Davidson <md@google.com>,
        Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org,
        kbuild-all@01.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:35568 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdCQSsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 14:48:08 -0400
Received: by mail-ua0-f178.google.com with SMTP id q7so49152920uaf.2
        for <linux-crypto@vger.kernel.org>; Fri, 17 Mar 2017 11:47:55 -0700 (PDT)
In-Reply-To: <20170317180350.63jjysejk2i6vkon@pd.tnic>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 17, 2017 at 7:03 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Mar 17, 2017 at 01:32:00PM +0100, Alexander Potapenko wrote:
>> > IIUC there's only a handful of VLAIS instances in LLVM code, why not
>> Sorry, "kernel code", not "LLVM code".
>> > just drop them for the sake of better code portability?
>
> And what happens if someone else adds a variable thing like this
> somewhere else, builds with gcc, everything's fine and patch gets
> applied? Or something else llvm can't stomach.
>
> Does that mean there'll be the occasional, every-so-often whack-a-mole
> patchset from someone, fixing the kernel build with llvm yet again?


This problem is more general and is not specific to clang. It equally
applies to different versions of gcc, different arches and different
configs (namely, anything else than what a developer used for
testing). A known, reasonably well working solution to this problem is
a system of try bots that test patches before commit with different
compilers/configs/archs. We already have such system in the form of
0-day bots. It would be useful to extend it with clang as soon as
kernel builds.
