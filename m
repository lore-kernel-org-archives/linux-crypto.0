From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add Ingenic JZ4780 hardware RNG driver
Date: Fri, 19 Aug 2016 18:24:12 +0530
Message-ID: <CANc+2y7YGGVVMHnbBVy7B6ZHyiUuLALvTeU6iVTP-9TYXjjHDA@mail.gmail.com>
References: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com> <CAH8yC8kt-+6tnzAc2bsu6GX4uX1bqVoE8sZXvCS34DDhGhP2XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
To: noloader-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH8yC8kt-+6tnzAc2bsu6GX4uX1bqVoE8sZXvCS34DDhGhP2XQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

> Please forgive my ignorance Prasanna...
>
> For the JZ4780 I have, there are two registers in play. The first is
> the control register which enables/disables the RNG. The control
> register is named ERNG. The second register is the data register, and
> it produces the random stream. The data register is named RNG. ERNG is
> located at 0x100000D8 and RNG is located at 0x100000DC. This kind of
> confuses me because I don't see where 0x100000D8 is ever added to
> those values (maybe its in the descriptor?):
>
> +#define REG_RNG_CTRL   0x0
> +#define REG_RNG_DATA   0x4

The base address 0x100000D8 is defined in jz4780.dtsi file.
REG_RNG_CTRL and REG_RNG_DATA are offsets. In jz4780_rng_readl and
jz4780_rng_writel functions the ioremap'd base address is added with
offset.

> Also, testing with a userland PoC for the device, you have to throttle
> reads from RNG register. If reads occur with a 0 delay, then the
> random value appears fixed. If the delay is too small, then you can
> watch random values being shifted-in in a barrel like fashion.
> Unfortunately, the manual did not discuss how long to wait for a value
> to be ready. I found spinning in a loop for 5000 was too small and
> witnessed the shifting; while spinning in a loop for 10000 avoided the
> shift observation. I don't what number of JIFFIES that translates to.

I can calculate the speed and make sure the delay is met in the
driver. Thanks a lot for providing this info.

> Finally, from looking at the native Ingenic driver (which was not very
> impressive), they enabled/disabled the RNG register on demand. There
> was also a [possible related] note in the manual about not applying
> VCC for over a second. I can only say "possibly related" because I was
> not sure if the register was part of the controller they were
> discussing. The userland PoC worked fine when enabling/disabling the
> RNG register. So I'm not sure about this (from jz4780_rng_probe):
>
> +       platform_set_drvdata(pdev, jz4780_rng);
> +       jz4780_rng_writel(jz4780_rng, 1, REG_RNG_CTRL);
> +       ret = hwrng_register(&jz4780_rng->rng);
>
> And this (from jz4780_rng_remove):
>
> +       jz4780_rng_writel(jz4780_rng, 0, REG_RNG_CTRL);
> +       hwrng_unregister(&jz4780_rng->rng);
>
> Anyway, I hope that helps you avoid some land mines (if they are present).

Looking at JZ4780 Programmers manual I could not find any info about
VCC. Can you point me to it?
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
