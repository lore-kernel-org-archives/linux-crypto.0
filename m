From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v12 4/4] LRNG - enable compile
Date: Tue, 18 Jul 2017 10:51:41 +0200
Message-ID: <CAK8P3a201uNh4nC2pQ49UE=DVHg5qSGf1q6LUfk8H106e+uxJw@mail.gmail.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de> <5071655.YFHJQhx4QD@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5071655.YFHJQhx4QD@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 9:59 AM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Add LRNG compilation support.
>
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index 53e3372..87e06ec 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -2,7 +2,15 @@
>  # Makefile for the kernel character device drivers.
>  #
>
> -obj-y                          +=3D mem.o random.o
> +obj-y                          +=3D mem.o
> +
> +ifeq ($(CONFIG_LRNG),y)
> +  obj-$(CONFIG_LRNG)           +=3D lrng.o
> +  lrng-y                       +=3D lrng_base.o lrng_chacha20.o
> +else
> +  obj-y                                +=3D random.o
> +endif

I think you can write the same in a more readable way without the
intermediate object:

ifdef CONFIG_LRNG
  obj-y                       +=3D lrng_base.o lrng_chacha20.o
else
  obj-y                       +=3D random.o
endif

      Arnd
