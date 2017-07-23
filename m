From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Sun, 23 Jul 2017 14:05:38 -0400
Message-ID: <CACXcFm=mQ9namu2R32fJDDRe_gEGxiAar=Hne6012Vnq9x+uRA@mail.gmail.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <150039607.torZXMN7kc@positron.chronox.de>
 <20170718085212.GB25267@kroah.com> <1780567.qGdv4EjEMp@positron.chronox.de>
 <20170718210816.o6c4iziaqj5dnnd3@thunk.org> <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com>
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
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36929 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdGWSFl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jul 2017 14:05:41 -0400
In-Reply-To: <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sandy Harris <sandyinchina@gmail.com> wrote:

> The biggest problem with random(4) is that you cannot generate good
> output without a good seed & just after boot, ...
>
> The only really good solution I know of is to find a way to provide a
> chunk of randomness early in the boot process. John Denker has a good
> discussion of doing this by modifying the kernel image & Ted talks of
> doing it via the boot loader. ...

Would it be enough to have a kernel module that does more-or-less what
the current shell scripts do, but earlier in the boot process? Throw
the stored data into the random(4) driver at module init time & update
it periodically later. This would not help much for first boot on a
new system, unless its store could be updated during install; Denker's
point that you need each system provisioned differently is important.
However it looks like it would be enough on other boots.

It also looks like it might be easier to implement & test. In
particular it is an isolated do-one-thing-well tool; the programmer
only needs to worry about his or her module, not several different
boot loaders or the procedures that distros have for CD images or
manufacturers for device setup.
