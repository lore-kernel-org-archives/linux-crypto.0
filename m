From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert "hwrng: core - zeroize buffers with random data"
Date: Wed, 8 Feb 2017 17:57:23 -0800
Message-ID: <CA+55aFwBdG42kk8J0t2tufHE=OUk4qWXEkFyySNgU3Ru2TA-tQ@mail.gmail.com>
References: <20170208002331.29408-1-david.daney@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: David Daney <david.daney@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33672 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdBIB5l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2017 20:57:41 -0500
In-Reply-To: <20170208002331.29408-1-david.daney@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan, Herbert? The zeroes in /dev/hwrng output are obviously
complete crap, so there's something badly wrong somewhere.

The locking, for example, is completely buggered. There's even a
comment about it, but that comment makes the correct observation of
"but y'know: randomness". But the memset() also being outside the lock
makes a complete joke of the whole thing.

Is the hwrng thing even worth maintaining? Compared to something like
/dev/urandom, it clearly does not do a very good job.

So I'm inclined to take the revert, but I'm also somewhat inclined to
simply mark this crud broken when we have other things that clearly do
a lot better.

              Linus

On Tue, Feb 7, 2017 at 4:23 PM, David Daney <david.daney@cavium.com> wrote:
> This reverts commit 2cc751545854d7bd7eedf4d7e377bb52e176cd07.
