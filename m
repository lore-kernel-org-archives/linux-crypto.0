From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Tue, 18 Jul 2017 21:00:10 -0400
Message-ID: <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <150039607.torZXMN7kc@positron.chronox.de>
 <20170718085212.GB25267@kroah.com> <1780567.qGdv4EjEMp@positron.chronox.de> <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38867 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdGSBAM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 21:00:12 -0400
In-Reply-To: <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 5:08 PM, Theodore Ts'o <tytso@mit.edu> wrote:

> I've been trying to take the best features and suggestions from your
> proposal and integrating them into /dev/random already.

A good approach.

> Things that I've chosen not take is basically because I disbelieve
> that the Jitter RNG is valid. ...

The biggest problem with random(4) is that you cannot generate good
output without a good seed & just after boot, especially first boot on
a new system, you may not have enough entropy. A user space process
cannot do it soon enough and all the in-kernel solutions (unless you
have a hardware RNG) pose difficulties.

The only really good solution I know of is to find a way to provide a
chunk of randomness early in the boot process. John Denker has a good
discussion of doing this by modifying the kernel image & Ted talks of
doing it via the boot loader. Neither looks remarkably easy. Other
approaches like making the kernel read a seed file or passing a
parameter on the kernel command line have been suggested but, if I
recall right, rejected.

As I see it, the questions about Jitter, or any other in-kernel
generator based on timing, are whether it is good enough to be useful
until we have one of the above solutions or useful as a
defense-in-depth trick after we have one. I'd say yes to both.

There's been a lot of analysis. Stephan has a detailed rationale & a
lot of test data in his papers & the Havege papers also discuss
getting entropy from timer operations. I'd say the best paper is
McGuire et al:
https://static.lwn.net/images/conf/rtlws11/random-hardware.pdf

There is enough there to convince me that grabbing some (256?) bits
from such a generator early in the initialization is worthwhile.

> So I have been trying to do the evolution thing already.
> ...

> I'm obviously biased, but I don't see I see the Raison d'Etre for
> merging LRNG into the kernel.

Nor I.
