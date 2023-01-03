Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF9BC3DA7D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 20:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbjACU1D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 15:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238642AbjACU0n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 15:26:43 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EF314D3B
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 12:26:18 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id a16so25461199qtw.10
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 12:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWQdhtHM3K1oyggbO+2dMJUZwBODavvxc7yTyFJ0lYI=;
        b=YDVCUDbgAeW0hVhs/g4JjH8kmsFuPnrsSO3rAzaQ8238JVlCpbbDmM/of5LDiFQ3ZR
         LsAhZ7OQBiszg4rGxhyYNLNLxWf8NjQaNJc7Q3pNZtyzmOdKo7YOKp1HwocTpMcHw08J
         Lp1wNe7fgslKvAudNAcF7WhpB5/QExxKAzdR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWQdhtHM3K1oyggbO+2dMJUZwBODavvxc7yTyFJ0lYI=;
        b=ST2c0G4aqIbXcG6C3d8yHPXGZg63ahmxNjzhjTH5DtpmF5aSSyLEjlS/C7LZnQvRhx
         KCJPxBqYPBNGGUhHdVQIrJbU4+Iwo3lMVYPYYR6ZWowWwgt7vny8RG1qjCAntn0IQLla
         gX8mgyi4rJVQ2KrIfuCOvnwl9FbJob5xc7y91htLxlSEVAlPYteFs4oIuY2mbmym5opH
         +l+nRCV+h9u9PUBobacR0h0sOGuQIm+0FLasu/jqZWikxqMtUmd+riFT9O8suB5YFMk3
         gWJ4UGbJJtVAYQ15U7n1AV+k/jKt6PVr49udjECPS32UWU31uLxVf7q7YkF1yjt5dcuc
         UPbA==
X-Gm-Message-State: AFqh2kojwLO/vKoKGeXC9l4ilD2aAiyuLSqc5M1uIVEGGw0GJfaFvOOq
        3SZPI6y0ND/LV9mAQnPqmfc1QhnDzdq9Pq4M
X-Google-Smtp-Source: AMrXdXvcCEZuSnIOcKr67q4vk4lDEnvpAzK8zjEZQjOPKj1JZQKzj2kEqFI9+54TCc5IX36515tT0Q==
X-Received: by 2002:ac8:7c8d:0:b0:3a9:763b:4a61 with SMTP id y13-20020ac87c8d000000b003a9763b4a61mr60376739qtv.28.1672777576949;
        Tue, 03 Jan 2023 12:26:16 -0800 (PST)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com. [209.85.222.179])
        by smtp.gmail.com with ESMTPSA id br36-20020a05620a462400b006fc3fa1f589sm22735008qkb.114.2023.01.03.12.26.15
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 12:26:15 -0800 (PST)
Received: by mail-qk1-f179.google.com with SMTP id pj1so15352419qkn.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 12:26:15 -0800 (PST)
X-Received: by 2002:a05:620a:1379:b0:6fc:c48b:8eab with SMTP id
 d25-20020a05620a137900b006fcc48b8eabmr1659307qkl.216.1672777574921; Tue, 03
 Jan 2023 12:26:14 -0800 (PST)
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com> <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
In-Reply-To: <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 3 Jan 2023 12:25:59 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg4SRHF6AhYDcgyokN2BMjra91Ns4h9wWPachhf-x3=xQ@mail.gmail.com>
Message-ID: <CAHk-=wg4SRHF6AhYDcgyokN2BMjra91Ns4h9wWPachhf-x3=xQ@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        tglx@linutronix.de, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 3, 2023 at 12:15 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jan 3, 2023 at 12:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > That buffering cannot be done safely currently
>
> .. again, this is "your semantics" (the (b) in my humbug list), not
> necessarily reality for anybody else.

Just to make an example: fork() is already problematic for something
as fundamental as <stdio.h>.

That doesn't mean that we do a special fork-safe stdio.h
infrastructure in the kernel. It just means that people have to do
things like fflush(NULL) (or use variations of setbuf() and friends)
when they deal with fork() and stdio interactions.

The random number generator really isn't that different. Periodic
reseeding isn't something stdio has to deal with, but having a
timestamp in user space library and forcing a re-seed isn't unheard of
in other contexts.

You don't even need anything as fancy as an actual timer, because it
doesn't need *active* flushing, just a "oh, it's been too long since
we read the random data, let's do it again".

And yes, I bet it would be a good idea to have an actual library for
this that handles (and *documents*) these kinds of issues - exactly
like a <stdio.h>, just for randomness.

I just don't think it should be involved in the kernel - again exactly
like <stdio.h>.

            Linus
