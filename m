Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F61C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 20:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5889D2184E
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 20:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Td0bi4W8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfDKUgz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 16:36:55 -0400
Received: from mail-ua1-f45.google.com ([209.85.222.45]:34489 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbfDKUgx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 16:36:53 -0400
Received: by mail-ua1-f45.google.com with SMTP id c6so2512762uan.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 13:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LHThbCjbRRpzc8ii2OMzeBZem6XJJjKKjhIHY/St8eE=;
        b=Td0bi4W8T8i8LXYBoXjDvAZ16eEig1BUUpw2DskS8xfM6eLIhUg8UuHqaJIrZOj0Z5
         Z9X23/3OWlGennv2Ucci7a5DC88uXNwtiU3TQuf+6FQoc8KIa7IaSt8l1uicTO6X5G9S
         L9BvpPxwMN6/OkVNChPSZIrA3XTQ+hRZ/9aRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LHThbCjbRRpzc8ii2OMzeBZem6XJJjKKjhIHY/St8eE=;
        b=i0xfcodXmi7KJZTGpK49RAFvg0r6X8JXNS1IePITkktSVlD4Pjp7CZMuGPUt83GQ3l
         2noz4rXPvBs33IyTyQo9zqi3xC5YKlgQmzOIHTwGk5iH1Qa7rjd11aBP5eyBcYxje6q3
         pGX307TByYA7WACeVDIvE6GfaOox7Ow2WxWxcCT9eoso73XBlmiZG6zrh5RBN+HAT4jI
         0dEjVx4kCjxUQ3ionso2IHpRNtolx2wS6XhcSS2uXUIz5cv6ENdu+w7GTHF5TZLZn++G
         ANj72lIQeHaC2kv8pUtiseLR0FvqVcPo56UVWKyPxKDWy1HiBWWpKbbYL4kBkl43vsjX
         ucgA==
X-Gm-Message-State: APjAAAUYXyQ/WmSUBZj7FjD4Na7KRpArxE20M5PSG/dnJFIlqHT4789a
        j23vnsMivF49d8lvBk2Yc8WQY6blj5Y=
X-Google-Smtp-Source: APXvYqy67Tip/YGPH38Rl5oqQNV2uMBn7Pm9RLMRN9+Ttmoy0YP7UHQPu1BgLNnURF8xLzALLYckzQ==
X-Received: by 2002:ab0:685a:: with SMTP id a26mr25671148uas.130.1555015010994;
        Thu, 11 Apr 2019 13:36:50 -0700 (PDT)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com. [209.85.221.181])
        by smtp.gmail.com with ESMTPSA id r199sm12410942vke.30.2019.04.11.13.36.49
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 13:36:50 -0700 (PDT)
Received: by mail-vk1-f181.google.com with SMTP id g24so1684378vki.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 13:36:49 -0700 (PDT)
X-Received: by 2002:a1f:7d4e:: with SMTP id y75mr28798331vkc.53.1555015009326;
 Thu, 11 Apr 2019 13:36:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXu5jL-5C1ZGZ1JgaNFqK-z1Pp1N1X8gD3_ysKTCa=omD+_VQ@mail.gmail.com>
 <20190321175122.GA1587@sol.localdomain> <20190410031734.GB7140@sol.localdomain>
 <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
 <20190410190729.GA120258@gmail.com> <CAGXu5j+Gfvj9G6s_UQTw6hE11gJb1edt3BXzpbDQdc_dpcHgag@mail.gmail.com>
 <20190410231156.GB120258@gmail.com> <CAGXu5jKg+oN7yUY=N69U93afOVHBPgwz6Osf=eMDPfiwbzEqmw@mail.gmail.com>
 <20190411175823.GC225654@gmail.com> <CAGXu5j+u3f3qUVkQO+zYLN7BDh3r7w-W3k3aa+qdAP11k7A1dw@mail.gmail.com>
 <20190411192607.GD225654@gmail.com>
In-Reply-To: <20190411192607.GD225654@gmail.com>
From:   Kees Cook <keescook@chromium.org>
Date:   Thu, 11 Apr 2019 13:36:37 -0700
X-Gmail-Original-Message-ID: <CAGXu5jJo0jXhB5Xy0fryrYPy7zN2RhSsMb0r0DPQ91dNR0zPCA@mail.gmail.com>
Message-ID: <CAGXu5jJo0jXhB5Xy0fryrYPy7zN2RhSsMb0r0DPQ91dNR0zPCA@mail.gmail.com>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 12:26 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Well, I guess I'll just add __GFP_COMP so I at least don't get spammed with
> useless bug reports.

Thanks, I appreciate it.

> But I don't think it's in any way acceptable to change the semantics of the
> kernel's page allocator but only under some obscure config option, don't
> document it anywhere, ignore the known problems for years, say that the option
> is broken anyway so it shouldn't be used, and have to exchange 15 emails to get
> anything resembling an explanation.

I understand what you mean, yeah. I'm sorry I wasn't clear about it
earlier. What do you think might help the situation as far as
documentation?

-- 
Kees Cook
