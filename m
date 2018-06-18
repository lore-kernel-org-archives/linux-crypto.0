From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 3/5] crypto: arm/speck - add NEON-accelerated
 implementation of Speck-XTS
Date: Tue, 19 Jun 2018 00:04:01 +0200
Message-ID: <CAKv+Gu-vSpMgNcaJTjwjttCFrCeZMWPM5R30-7VeyhDPMjgKKA@mail.gmail.com>
References: <20180214184223.254359-1-ebiggers@google.com>
 <20180214184223.254359-4-ebiggers@google.com>
 <bf0d6851c95b40ca970949229e6e6a00@agner.ch>
 <CAKv+Gu_VLcp7gxH-8OY-XoHyB=SKVRYRG5D3KV_fNQ4zn4hgFQ@mail.gmail.com>
 <CAKv+Gu-J9Ho8GY4EC7k_K3Wg4W_aC2kPryMD0e0SKY+biJOdDw@mail.gmail.com>
 <8396d433caf1155f9ca422c6bad3200b@agner.ch>
 <CAKv+Gu8OnTY7ezbkU5-EzVHp3vvPr_okkOoWfOjkdxhSqSqhBg@mail.gmail.com>
 <20180618215657.GB8022@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jeffrey Walton <noloader@gmail.com>, Greg Kaiser <gkaiser@google.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Michael Halcrow <mhalcrow@google.com>, Patrik Torstensson <totte@google.com>,
 Stefan Agner <stefan@agner.ch>, Paul Lawrence <paullawrence@google.com>,
 linux-fscrypt@vger.kernel.org,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alex Cope <alexcope@google.com>, linux-crypto-owner@vger.kernel.org,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Paul Crowley <paulcrowley@google.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180618215657.GB8022@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 18 June 2018 at 23:56, Eric Biggers <ebiggers@google.com> wrote:
> On Sun, Jun 17, 2018 at 01:10:41PM +0200, Ard Biesheuvel wrote:
>> >>>>> +
>> >>>>> +     // One-time XTS preparation
>> >>>>> +
>> >>>>> +     /*
>> >>>>> +      * Allocate stack space to store 128 bytes worth of tweaks.  For
>> >>>>> +      * performance, this space is aligned to a 16-byte boundary so that we
>> >>>>> +      * can use the load/store instructions that declare 16-byte alignment.
>> >>>>> +      */
>> >>>>> +     sub             sp, #128
>> >>>>> +     bic             sp, #0xf
>> >>>>
>> >>>>
>> >>>> This fails here when building with CONFIG_THUMB2_KERNEL=y
>> >>>>
>> >>>>   AS      arch/arm/crypto/speck-neon-core.o
>> >>>>
>> >>>> arch/arm/crypto/speck-neon-core.S: Assembler messages:
>> >>>>
>> >>>> arch/arm/crypto/speck-neon-core.S:419: Error: r13 not allowed here --
>> >>>> `bic sp,#0xf'
>> >>>> arch/arm/crypto/speck-neon-core.S:423: Error: r13 not allowed here --
>> >>>> `bic sp,#0xf'
>> >>>> arch/arm/crypto/speck-neon-core.S:427: Error: r13 not allowed here --
>> >>>> `bic sp,#0xf'
>> >>>> arch/arm/crypto/speck-neon-core.S:431: Error: r13 not allowed here --
>> >>>> `bic sp,#0xf'
>> >>>>
>> >>>> In a quick hack this change seems to address it:
>> >>>>
>> >>>>
>> >>>> -       sub             sp, #128
>> >>>> -       bic             sp, #0xf
>> >>>> +       mov             r6, sp
>> >>>> +       sub             r6, #128
>> >>>> +       bic             r6, #0xf
>> >>>> +       mov             sp, r6
>> >>>>
>> >>>> But there is probably a better solution to address this.
>> >>>>
>> >>>
>> >>> Given that there is no NEON on M class cores, I recommend we put something like
>> >>>
>> >>> THUMB(bx pc)
>> >>> THUMB(nop.w)
>> >>> THUMB(.arm)
>> >>>
>> >>> at the beginning and be done with it.
>> >>
>> >> I mean nop.n or just nop, of course, and we may need a '.align 2' at
>> >> the beginning as well.
>> >
>> > Wouldn't it be preferable to have it assemble it in Thumb2 too? It seems
>> > that bic sp,#0xf is the only issue...
>> >
>>
>> Well, in general, yes. In the case of NEON code, not really, since the
>> resulting code will not be smaller anyway, because the Thumb2 NEON
>> opcodes are all 4 bytes. Also, Thumb2-only cores don't have NEON
>> units, so all cores that this code can run on will be able to run in
>> ARM mode.
>>
>> So from a maintainability pov, having code that only assembles in one
>> way is better than having code that must compile both to ARM and to
>> Thumb2 opcodes.
>>
>> Just my 2 cents, anyway.
>
> I don't have too much of a preference, though Stefan's suggested 4 instructions
> can be reduced to 3, which also matches what aes-neonbs-core.S does:
>
>         sub             r12, sp, #128
>         bic             r12, #0xf
>         mov             sp, r12
>
> Ard, is the following what you're suggesting instead?
>

Yes, but after looking at the actual code, I prefer the change above.
The access occurs only once, not in the loop so the additional
instructions should not affect performance.

Apologies for the noise.

> diff --git a/arch/arm/crypto/speck-neon-core.S b/arch/arm/crypto/speck-neon-core.S
> index 3c1e203e53b9..c989ce3dc057 100644
> --- a/arch/arm/crypto/speck-neon-core.S
> +++ b/arch/arm/crypto/speck-neon-core.S
> @@ -8,6 +8,7 @@
>   */
>
>  #include <linux/linkage.h>
> +#include <asm/assembler.h>
>
>         .text
>         .fpu            neon
> @@ -233,6 +234,12 @@
>   * nonzero multiple of 128.
>   */
>  .macro _speck_xts_crypt        n, decrypting
> +
> +       .align          2
> +       THUMB(bx pc)
> +       THUMB(nop)
> +       THUMB(.arm)
> +
>         push            {r4-r7}
>         mov             r7, sp
>
> @@ -413,6 +420,8 @@
>         mov             sp, r7
>         pop             {r4-r7}
>         bx              lr
> +
> +       THUMB(.thumb)
>  .endm
>
>  ENTRY(speck128_xts_encrypt_neon)
