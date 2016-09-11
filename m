From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: algif_aead: AIO broken with more than one iocb
Date: Sun, 11 Sep 2016 08:43:00 -0400
Message-ID: <CAH8yC8knD0U4-BhgzkUfyHMm-KyNyDCx-3PPqQOm0bdVh4qjiA@mail.gmail.com>
References: <6245755.LbXSUvPjJL@positron.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34437 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755007AbcIKMnB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Sep 2016 08:43:01 -0400
Received: by mail-oi0-f47.google.com with SMTP id m11so249799344oif.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Sep 2016 05:43:01 -0700 (PDT)
In-Reply-To: <6245755.LbXSUvPjJL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> The AIO support for algif_aead is broken when submitting more than one iocb.
> The break happens in aead_recvmsg_async at the following code:
>

I think the kernel needs to take a half step back, and add the missing
self tests and test cases to be more proactive in detecting breaks
earlier. Speaking first hand, some of these breaks have existed for
months.

I don't take the position you can't break things. I believe you can't
make an omelet without breaking eggs; and if you're not breaking
something, then you're probably not getting anything done. The
engineering defect is not detecting the break.

Jeff
