From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 2/4] random: conditionally compile code depending on LRNG
Date: Tue, 18 Jul 2017 10:37:40 +0200
Message-ID: <1590546.5d4hGCCWgT@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <1830340.t0pR7po4tk@positron.chronox.de> <CAK8P3a2aQ8nJUjo76Vwt-vkPUoa9BT616ZVZWsVykHHiz4Pdpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60620 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751357AbdGRIhz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 04:37:55 -0400
In-Reply-To: <CAK8P3a2aQ8nJUjo76Vwt-vkPUoa9BT616ZVZWsVykHHiz4Pdpw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 18. Juli 2017, 10:13:55 CEST schrieb Arnd Bergmann:

Hi Arnd,

> On Tue, Jul 18, 2017 at 9:58 AM, Stephan Müller <smueller@chronox.de> wrote:
> > When selecting the LRNG for compilation, disable add_disk_randomness and
> > its supporting function.
> > 
> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > CC: Arnd Bergmann <arnd@arndb.de>
> > CC: Jason A. Donenfeld <Jason@zx2c4.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> I think this needs a better explanation. Why do we ignore the extra
> entropy here?

I was not sure whether to add all the details about the reason into the patch 
submission.

The reason is explained here in [1] page 3 and re-iterated in [2].

The gist is the following:

A HID or block device event providing entropy to the respective individual 
noise sources processing generates an interrupt. These interrupts are also 
processed by the interrupt noise source. The majority of entropy is delivered 
by the high-resolution time stamp of the occurrence of such an event. Now, 
that event is processed twice in the legacy /dev/random implementation: once 
by the HID or block device noise source and once by the interrupt noise 
source. Thus, the two time stamps of the one event (HID noise source and 
interrupt noise source, or block device noise source and interrupt noise 
source) used as a basis for entropy are highly correlated. Correlation or even 
a possible reuse of the same random value diminishes entropy significantly.

The additional data provided via the block noise source (block device number) 
has no real entropy.

Bottom line: for entropy, the HID and block device noise sources are just a 
derivative of the interrupt noise source. Thus, discarding the block device 
noise source will not lose any entropy. Regarding the HID noise source, only 
the key/mouse event numbers are injected into the LRNG without attributing any 
entropy to them.

[1] http://www.chronox.de/lrng/doc/lrng.pdf

[2] https://www.spinics.net/lists/linux-crypto/msg26316.html

Ciao
Stephan
