Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E788C4708D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 19:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbjACTX3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 14:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbjACTWz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 14:22:55 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C10A1705F
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 11:19:55 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id n205so8746702vkf.13
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 11:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ia/lu5+B5CRXWa8CF3j1BLcFKSU3j2P6kHuicKKTwhM=;
        b=ZqWN8gFUfoVI5wnLUXnodqgP701dqeLd5CSt/RsefZ5Qkl5jGfXYOorD034HuIvB5D
         Ht8gtKf8KI4dn/azdfqIH5esBFN2+qILBHpfWUbepKnmZuifWK677ycRTg3al4Q+XtGT
         msE8MlX8P1FMZr6Yemo2KVXiq2CyfjHgRvf5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ia/lu5+B5CRXWa8CF3j1BLcFKSU3j2P6kHuicKKTwhM=;
        b=QO60jI5o+RKdXIdw886lrJbbp2torn9NBZA5aMJq2Of9t7frsmVtHfaQ7siA0yq6i/
         XFKX2S8s4y4SS6hLJjbxNME6UNkStFqfkf4wDR00qiuMkLNZKfVwkktYvzS5tWjFIC0F
         i8Bp0Freoimh6G9wNEUn6srG1c9Av3mroGQML+g8j7B/3fal2/VLXextNYFq3Fer469A
         f78ySTlwXtOP3/EkL0V63DaWwe/VJEL39VWg/elGgvqPC4PLlucT6BX0I/S0VaQ21p1s
         i0qUWQifBpMC2lBjDX8UmieqBoQc5rHNs5oW+V7T34kEczqt/nkI73xxO5MmLo6JCglu
         2ghQ==
X-Gm-Message-State: AFqh2kp6UsJQSld9Gij7vWEDrE+TPldJxlxLlV5MVVcEU+AzLN8kWzV8
        3P0JWmLvmy3yW3lzXrNSJNVtZpQIq1bfWT98
X-Google-Smtp-Source: AMrXdXuln9ZNLhRqTO5lAfsfMyfyIWwXKisUR5LpsJHk4b9AVB9xw8R/QoiBsqwJpOtQdRSZ3cuEDQ==
X-Received: by 2002:a1f:a90e:0:b0:3d5:475f:94c with SMTP id s14-20020a1fa90e000000b003d5475f094cmr16092195vke.14.1672773594048;
        Tue, 03 Jan 2023 11:19:54 -0800 (PST)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com. [209.85.160.173])
        by smtp.gmail.com with ESMTPSA id ay34-20020a05620a17a200b006b929a56a2bsm22592675qkb.3.2023.01.03.11.19.53
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:19:53 -0800 (PST)
Received: by mail-qt1-f173.google.com with SMTP id z12so25328938qtv.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 11:19:53 -0800 (PST)
X-Received: by 2002:ac8:67da:0:b0:3a5:122:fb79 with SMTP id
 r26-20020ac867da000000b003a50122fb79mr1194253qtp.452.1672773592726; Tue, 03
 Jan 2023 11:19:52 -0800 (PST)
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
In-Reply-To: <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 3 Jan 2023 11:19:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
Message-ID: <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
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

On Tue, Jan 3, 2023 at 10:36 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> I have a rather different suggestion: make a special mapping.  Jason,
> you're trying to shoehorn all kinds of bizarre behavior into the core
> mm, and none of that seems to me to belong to the core mm.  Instead,
> have an actual special mapping with callbacks that does the right
> thing.  No fancy VM flags.

I don't disagree, but honestly, my deeper reaction is "this is not worth it".

I think the real issue here is that Jason has to prove that this is
such a big deal that the VM has to be modified *at*all* for this.

Honestly, "getrandom()" performance simply is not important enough to
design VM changes for.

Do some people care? Debatable. Jason cares, sure. But people have
gotten used to doing their own random number implementations if they
*really* care, and yes, they've gotten them wrong, or they've not
performed as well as they could, but on the whole this is still a
really tiny thing, and Jason is trying to micro-optimize something
that THE KERNEL SHOULD NOT CARE ABOUT.

This should all be in libc. Not in the kernel with special magic vdso
support and special buffer allocations. The kernel should give good
enough support that libc can do a good job, but the kernel should
simply *not* take the approach of "libc will get this wrong, so let's
just do all the work for it".

Let user space do their own percpu areas if they really care. And most
(as in 99.9%) of all user space won't care at all, and is perfectly
happy just doing a read() from /dev/urandom or using our existing
"getrandom()" without any super-clever vdso support with magic
temporary buffer handling.

Now, if the magic buffers were something cool that were a generic
concept that a lot of *other* cases would also kill for, that's one
thing. But this is such a small special case that absolutely *nobody*
has asked for, and that nothing else wants.

             Linus
