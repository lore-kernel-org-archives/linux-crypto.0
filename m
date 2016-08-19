From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH] Add Ingenic JZ4780 hardware RNG driver
Date: Fri, 19 Aug 2016 06:55:06 -0400
Message-ID: <CAH8yC8ny62Vf63cjtL8bUgGoRr-0BVGvqazs20S4JreJq+OBcg@mail.gmail.com>
References: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 17, 2016 at 11:35 AM, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> This patch adds support for hardware random number generator present in
> JZ4780 SoC.
>
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
>  ...
> +static int jz4780_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +       struct jz4780_rng *jz4780_rng = container_of(rng, struct jz4780_rng,
> +                                                       rng);
> +       u32 *data = buf;
> +       *data = jz4780_rng_readl(jz4780_rng, REG_RNG_DATA);
> +       return 4;
> +}

My bad, I should have spotted this earlier....

i686, x86_64 and some ARM will sometimes define a macro indicating
unaligned data access is allowed. For example, see
__ARM_FEATURE_UNALIGNED (cf.,
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0774f/chr1383660321827.html)
. MIPSEL does not define such a macro.

    # MIPS ci20 creator with GCC 4.6
    $ gcc -march=native -dM -E - </dev/null | grep -i align
    #define __BIGGEST_ALIGNMENT__ 8

If the MIPS CPU does not tolerate unaligned data access, then the
following could SIGBUS:

> +       u32 *data = buf;
> +       *data = jz4780_rng_readl(jz4780_rng, REG_RNG_DATA);

If GCC emits code that uses the MIPS unaligned load and store
instructions, then there's probably going to be a performance penalty.

Regardless of what the CPU tolerates, I believe unaligned data access
is undefined behavior in C/C++. I believe you should memcpy the value
into the buffer.

Jeff
