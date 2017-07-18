From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 11:10:28 +0200
Message-ID: <5156735.IWW3yRWKpB@tauon.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <20170718084959.GA25267@kroah.com> <CAK8P3a1g8_D6Z0d-LOjomGcxuX5v_Y9fJ_b9TEeOQ6izOneE=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60666 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdGRJKa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 05:10:30 -0400
In-Reply-To: <CAK8P3a1g8_D6Z0d-LOjomGcxuX5v_Y9fJ_b9TEeOQ6izOneE=g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 18. Juli 2017, 11:02:02 CEST schrieb Arnd Bergmann:

Hi Arnd,
> 
> I can see why the jitterentropy implementation avoids using kernel headers,
> the problem now is that part of it gets moved into a new header, and that
> already violates the original principle.
> 
> From my reading of the code, we could probably leave the structure
> definition in the crypto/jitterentropy.c, and have the statically
> allocated instance in the same file when CONFIG_LRNG is
> set,

That is a very good idea -- I will implement this approach.

> or provide a way to allocate an instance early (I assume you
> can't call jent_entropy_collector_alloc() here since you need
> the RNG long before kzalloc() works).

Correct. I cannot assume that any of the memory allocation routines are 
available.

Thank you.

Ciao
Stephan
