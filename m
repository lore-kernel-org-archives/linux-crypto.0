From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 10:53:13 +0200
Message-ID: <9620599.PVNUmZQuZk@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <5020806.nso7MErEBx@positron.chronox.de> <20170718084959.GA25267@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170718084959.GA25267@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 18. Juli 2017, 10:49:59 CEST schrieb Greg Kroah-Hartman:

Hi Greg,
> 
> > This issue was discussed during the inclusion of the Jitter RNG C code
> > into
> > the kernel.
> 
> Ok, that was then, this is now, why not change it now?  How does
> including types.h change anything?

At the time of discussion, I had no issue compiling it with types.h, but on 
other architectures, there were some issues. Allow me to check back with the 
developer who notified me about this issue to see whether types.h can be 
included.

Ciao
Stephan
