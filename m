From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 11:17:44 +0200
Message-ID: <3285940.H0AFyT7Fqa@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <5156735.IWW3yRWKpB@tauon.chronox.de> <CAK8P3a3687Na9Rhi78_46trr94_kPjCFzTCWFJrzUGo90bwN6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60674 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdGRJRv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 05:17:51 -0400
In-Reply-To: <CAK8P3a3687Na9Rhi78_46trr94_kPjCFzTCWFJrzUGo90bwN6w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 18. Juli 2017, 11:16:10 CEST schrieb Arnd Bergmann:

Hi Arnd,

> I guess ideally you just move the inner half of lrng_get_jent(),
> i.e. everything inside of the spinlock, plus the buffer, into that file.
> That should keep the low-level side separate from the caller.

Yes, I concur.

Thanks.

Ciao
Stephan
