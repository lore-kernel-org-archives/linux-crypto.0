Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731EEC54EBD
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 22:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjAFWH0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Jan 2023 17:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbjAFWHL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2023 17:07:11 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83E984BEA
        for <linux-crypto@vger.kernel.org>; Fri,  6 Jan 2023 14:07:09 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id h10so1897091qvq.7
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jan 2023 14:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l9dqVddWwlNIkWBEkX2eMMbroRQSsxPmZhf5UK2bJx4=;
        b=O6fLaeMkOAI9qlrlbD9V9hqb0FRi+3fYwY656X3zqlxsNXYgmUCLgJYTFwJVKAjthE
         irUaeSLWBxwa416jiNkQxJky4pxbLUW3S/rzOYcjecUxbP1aO1xBadn5G83AJZJjM0GP
         8LNX+VfdzXkl4XSINWkZYmRr2ww9tgPFY2yho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9dqVddWwlNIkWBEkX2eMMbroRQSsxPmZhf5UK2bJx4=;
        b=OKJP9hSm5Ce/yOGJ0Aphd1qhENEf/hYraYp2lwYOFiJKmX5rIsMidOnnVZvt8/TRa+
         WMeaTmKd2SkS3APW2XEBqHWeJkRNTLTbe3DD9ycTSmSXI5mZ55LG/HmecV2CnWFWwtYN
         30xksSsCC1hzvUJWraQ4EYCrsPZqwWa92WF3LVKp+nb8CdtR7Yc5TPx3o+/CwRZ1aHn1
         rrDcHlqEgKfppjADjmk8KuB+gnC3if3i/50ukYegib5QwMUU3VEXrJffoLhnD0F1/ZKD
         JEy26BvqnfVEPUy7HwKIxBD4D14NlwBwc69CDMJ4QQ8gVgDoX3XmgCj3Z3IR2+Tatut0
         zraA==
X-Gm-Message-State: AFqh2kpxNpVQQRqVYeNgnJjJ+amWB/mF8l+ZaYlrsQb1/TuRYiH7OG+R
        tM9eUpG46YtJeFPs9FznI8F1oLucWAKXzoTz
X-Google-Smtp-Source: AMrXdXvP+I6q7mOdoaQ0LpzyQNITtGufGwnRWs6y/0jd2tj4OMMbqo3sFnxkVMtunUeM56KPgcSecQ==
X-Received: by 2002:a05:6214:5907:b0:531:b5c1:20ca with SMTP id lp7-20020a056214590700b00531b5c120camr35095505qvb.36.1673042828717;
        Fri, 06 Jan 2023 14:07:08 -0800 (PST)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com. [209.85.219.49])
        by smtp.gmail.com with ESMTPSA id bk25-20020a05620a1a1900b006ff8ac9acfdsm1204743qkb.49.2023.01.06.14.07.07
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 14:07:07 -0800 (PST)
Received: by mail-qv1-f49.google.com with SMTP id p17so1929121qvn.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Jan 2023 14:07:07 -0800 (PST)
X-Received: by 2002:a05:6214:1185:b0:4c6:608c:6b2c with SMTP id
 t5-20020a056214118500b004c6608c6b2cmr2661817qvv.130.1673042827328; Fri, 06
 Jan 2023 14:07:07 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com> <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
 <Y7STv9+p248zr+0a@zx2c4.com> <10302240-51ec-0854-2c86-16752d67a9be@opteya.com>
 <Y7dV1lVUYjqs8fh0@zx2c4.com> <CAHk-=wijEC_oDzfUajhmp=ZVnzMTXgjxHEcxAfaHiNQm4iAcqA@mail.gmail.com>
 <CAHk-=wiO4rp8oVmj6i6vvC97gNePLN-SxhSK=UozA88G6nxBGQ@mail.gmail.com> <Y7iV18CqKAa4gO9r@casper.infradead.org>
In-Reply-To: <Y7iV18CqKAa4gO9r@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 6 Jan 2023 14:06:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj7jenrb6UNjv--xLC4hrjJDsCFxuaHw1e67a4ihVEmUw@mail.gmail.com>
Message-ID: <CAHk-=wj7jenrb6UNjv--xLC4hrjJDsCFxuaHw1e67a4ihVEmUw@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, tglx@linutronix.de,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 6, 2023 at 1:42 PM Matthew Wilcox <willy@infradead.org> wrote:
>
>
> I'd be more inclined to do:
>
> typedef unsigned int vm_flags_t[2];

No, that's entirely invalid.

Never *ever* use arrays in C for type safety. Arrays are not type
safe. They can't be assigned sanely, and they silently become pointers
(which also aren't type-safe, since they end up converting silently to
'void *').

If you want to use the type system to enforce things, and you don't
want to rely on sparse, you absolutely have to use a struct (or union)
type.

So something like

   typedef struct { u64 val; } vm_flags_t;

would be an option.

              Linus
