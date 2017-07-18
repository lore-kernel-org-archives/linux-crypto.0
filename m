From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v12 4/4] LRNG - enable compile
Date: Tue, 18 Jul 2017 10:56:49 +0200
Message-ID: <2765965.2brO3pd8z3@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <5071655.YFHJQhx4QD@positron.chronox.de> <CAK8P3a201uNh4nC2pQ49UE=DVHg5qSGf1q6LUfk8H106e+uxJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a201uNh4nC2pQ49UE=DVHg5qSGf1q6LUfk8H106e+uxJw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 18. Juli 2017, 10:51:41 CEST schrieb Arnd Bergmann:

Hi Arnd,

> On Tue, Jul 18, 2017 at 9:59 AM, Stephan Müller <smueller@chronox.de> wrote:
> > Add LRNG compilation support.
> > 
> > diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> > index 53e3372..87e06ec 100644
> > --- a/drivers/char/Makefile
> > +++ b/drivers/char/Makefile
> > @@ -2,7 +2,15 @@
> > 
> >  # Makefile for the kernel character device drivers.
> >  #
> > 
> > -obj-y                          += mem.o random.o
> > +obj-y                          += mem.o
> > +
> > +ifeq ($(CONFIG_LRNG),y)
> > +  obj-$(CONFIG_LRNG)           += lrng.o
> > +  lrng-y                       += lrng_base.o lrng_chacha20.o
> > +else
> > +  obj-y                                += random.o
> > +endif
> 
> I think you can write the same in a more readable way without the
> intermediate object:
> 
> ifdef CONFIG_LRNG
>   obj-y                       += lrng_base.o lrng_chacha20.o
> else
>   obj-y                       += random.o
> endif

Thank you for the hint, it will be included.
> 
>       Arnd


Ciao
Stephan
