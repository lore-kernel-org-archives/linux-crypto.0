From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Tue, 18 Jul 2017 10:32:10 +0200
Message-ID: <20170718083210.GB18340@kroah.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <2686871.50X2Wu6ijA@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2686871.50X2Wu6ijA@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 09:59:09AM +0200, Stephan Müller wrote:
> The LRNG with the following properties:
> 
> * noise source: interrupts timing with fast boot time seeding
> 
> * lockless LFSR to collect raw entropy
> 
> * use of standalone ChaCha20 based RNG with the option to use a
>   different DRNG selectable at compile time
> 
> * "atomic" seeding of secondary DRBG to ensure full entropy
>   transport
> 
> * instantiate one DRNG per NUMA node
> 
> Further details including the rationale for the design choices and
> properties of the LRNG together with testing is provided at [1].
> In addition, the documentation explains the conducted regression
> tests to verify that the LRNG is API and ABI compatible with the
> legacy /dev/random implementation.
> 
> [1] http://www.chronox.de/lrng.html

external references do not last as long as the kernel change log does :(

Also a "wholesale" replacement of random.c is a major thing, why not
just submit patches to fix it up to add the needed changes you feel are
necessary?  We don't like to have major changes like this, that's not
how kernel development is done.

thanks,

greg k-h
