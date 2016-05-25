From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Wed, 25 May 2016 12:06:24 +0200
Message-ID: <7211115.EdoBLRGZ1i@wuerfel>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com> <6297051.TAxtzW5OIB@wuerfel> <5745085D.6000104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Matt Mackall <mpm@selenic.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5745085D.6000104@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday, May 25, 2016 7:35:17 AM CEST Sudip Mukherjee wrote:
> On Tuesday 24 May 2016 02:05 AM, Arnd Bergmann wrote:
> > On Monday, May 23, 2016 6:14:08 PM CEST Sudip Mukherjee wrote:
> >> We have been getting build warning about:
> >> drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_read':
> >> drivers/char/hw_random/stm32-rng.c:82:19: warning: 'sr' may be used
> >>                                      uninitialized in this function
> >>
> >> On checking the code it turns out that sr can never be used
> >> uninitialized as sr is getting initialized in the while loop and while
> >> loop will always execute as the minimum value of max can be 32.
> >> So just initialize sr to 0 while declaring it to silence the compiler.
> >>
> >> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> >> ---
> >
> > I notice that you are using a really old compiler. While this warning
> > seems to be valid in the sense that the compiler should figure out that
> > the variable might be used uninitialized, please update your toolchain
> > before reporting other such problems, as gcc-4.6 had a lot more false
> > positives that newer ones (5.x or 6.x) have.
> 
> yes, i need to upgrade gcc in my travis bot. But in my local system I am 
> having gcc-4.8.4 and there also I am having this error and i am sure 
> 4.8.4 is still being used by many people.

Right, the change from gcc-4.8 to 4.9 is what drastically changed hte
maybe-uninitialized warnings, introducing a number of additional warnings
(many of them correct) but removing many others (mostly false positives).
I tend to care only about the ones in 4.9+ for this reason. I haven't
run statistics on this in a while, but I guess we could consider turning
off this warning for 4.8 and earlier (though IIRC the switch to turn it
off only appeared in 4.9).

BTW, regarding your build infrastructure, I'd also recommend building
with 'make -s' to make the output more compact.

	Arnd
