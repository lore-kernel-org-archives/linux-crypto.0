From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Wed, 19 Jul 2017 08:25:55 +0200
Message-ID: <1660806.HVQ9M7P8eN@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <CACXcFmmFGYb-JteJZB8gS+uGJZ4zNLMU=AwPQf0td+xiG0+9Qw@mail.gmail.com> <20170719015133.aijabk36g7m6daek@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60716 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751663AbdGSGZ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 02:25:57 -0400
In-Reply-To: <20170719015133.aijabk36g7m6daek@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 19. Juli 2017, 03:51:33 CEST schrieb Theodore Ts'o:

Hi Theodore,

> If the real unpredictability is really coming from the interrupts
> changing the state of the CPU microarchitecture, the real question is
> how many interrupts do you need before you consider things
> "unpredictable" to an adequate level of security?  Arguing that we
> should turn down the "interrupts per bit of entropy" in
> drivers/char/random.c is a much more honest way of having that
> discussion.

Please answer on the concerns given in [1] which explains that we cannot allow 
turning that knob in the current implementation.

[1] https://www.spinics.net/lists/linux-crypto/msg26316.html

Ciao
Stephan
