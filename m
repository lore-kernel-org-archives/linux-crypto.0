From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in add_early_randomness()
Date: Mon, 17 Oct 2016 14:03:17 -0700
Message-ID: <CALCETrXGRf3z8gGw6fjeMCzb=X_OF6y0Rbhh-wAGjUVad8eaMg@mail.gmail.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
 <2711337.nAU4qxUyQs@tauon.atsec.com> <CALCETrVYuo1yNWyRQBRt3HwM4EJ7c5FAMZdEgnzKCHqMRCryXQ@mail.gmail.com>
 <1709183.xhj4cRUFK9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34015 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935767AbcJQVDn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 17:03:43 -0400
Received: by mail-vk0-f42.google.com with SMTP id b186so192956502vkb.1
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2016 14:03:42 -0700 (PDT)
In-Reply-To: <1709183.xhj4cRUFK9@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 17, 2016 at 11:36 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Montag, 17. Oktober 2016, 10:30:13 CEST schrieb Andy Lutomirski:
>
> Hi Andy,
>>
>> Sure, but shouldn't that be a separate patch covering the whole hw_crypto
>> core?
>
> I think that you are right -- there are many more cases where a memset(0) is
> warranted.
>
> Do you want to make this change or should I send a patch?

Can you do it?  I have my work cut out for me making sure that all the
known regressions get stomped quickly...
