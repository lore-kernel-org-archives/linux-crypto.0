From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: crypto_memneq not backported to 3.10
Date: Mon, 1 May 2017 16:30:01 +0200
Message-ID: <CAHmME9r9Jj=WtQxhxqtwWHFxwJV6KzMWO7qdsvhfG8R3B1qbJw@mail.gmail.com>
References: <CAHmME9qjWeskvkVJCNnY1Xm7uAu4=gnuSsxX5KMf3kt6kqF9ow@mail.gmail.com>
 <20170409132514.GA3970@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        security@kernel.org
To: Willy Tarreau <w@1wt.eu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:53791 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1951067AbdEAOaF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 May 2017 10:30:05 -0400
In-Reply-To: <20170409132514.GA3970@1wt.eu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Willy,

On Sun, Apr 9, 2017 at 3:25 PM, Willy Tarreau <w@1wt.eu> wrote:
>
> Hi Jason,
>
> On Sun, Apr 09, 2017 at 02:59:53PM +0200, Jason A. Donenfeld wrote:
> > Hey Willy,
> >
> > Linux 3.10 is inexplicably missing crypto_memneq, making all crypto
> > mac comparisons use non constant-time comparisons. Bad news bears.
> >
> > 3.12 got these backported with
> > d68e944a8fcb2c6212b38064771c9f5af7b0b92c,
> > afe5a791d374e50a06ada7f4eda4e921e1b77996, and possibly others. I'd
> > suggest following suit, since many people are relying on this kernel
> > to do safe crypto.
>
> Interesting. I remembered seeing some crypto_memneq stuff in the past,
> and in fact there was one patch talking about this but trimmed down to
> only affect other parts since crypto_memneq is indeed not part of 3.10.
>
> I'll check if the 3.12 patches above can be safely backported, and I'll
> have to re-apply the missing part of the one that was trimmed down
> (commit 620c411 ("crypto: more robust crypto_memneq")).

I'm vaguely wondering if you ever decided on backporting this. After I
reported the issue to Ubiquiti -- a random vendor doing ipsec with
3.10 -- they actually released a backport of these functions in a
security update for their stuff. So I imagine others might want this
sort of thing too.

Jason
