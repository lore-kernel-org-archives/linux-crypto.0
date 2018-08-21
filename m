From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm64/aes-modes - get rid of literal load of
 addend vector
Date: Tue, 21 Aug 2018 20:19:51 +0200
Message-ID: <CAKv+Gu9DV52L1if+Arnrndn6J4SB_W_0MjSq292Z-qMzhgzLAg@mail.gmail.com>
References: <20180821164614.31513-1-ard.biesheuvel@linaro.org>
 <CAKwvOd=Mh5s+TcSFzwruKq-yZjuMYgXZoG+jqKz5cOhE11cfeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Will Deacon <will.deacon@arm.com>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Nick Desaulniers <ndesaulniers@google.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKwvOd=Mh5s+TcSFzwruKq-yZjuMYgXZoG+jqKz5cOhE11cfeA@mail.gmail.com>
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

On 21 August 2018 at 20:04, Nick Desaulniers <ndesaulniers@google.com> wrote:
> On Tue, Aug 21, 2018 at 9:46 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>>
>> Replace the literal load of the addend vector with a sequence that
>> composes it using immediates. While at it, tweak the code that refers
>> to it so it does not clobber the register, so we can take the load
>> out of the loop as well.
>>
>> This results in generally better code, but also works around a Clang
>> issue, whose integrated assembler does not implement the GNU ARM asm
>> syntax completely, and does not support the =literal notation for
>> FP registers.
>
> Would you mind linking to the issue tracker for:
> https://bugs.llvm.org/show_bug.cgi?id=38642
>
> And maybe the comment from the binutils source? (or arm32 reference
> manual you mentioned in https://lkml.org/lkml/2018/8/21/589)
> https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=gas/testsuite/gas/aarch64/programmer-friendly.s;h=6254c6476efdc848648b05068be0574e7addc85d;hb=HEAD#l11
>
> They can help provide more context to future travelers.
>

Sure, if it helps.

>>
>> Cc: Nick Desaulniers <ndesaulniers@google.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/crypto/aes-modes.S | 18 ++++++++++++------
>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
>> index 483a7130cf0e..e966620ee230 100644
>> --- a/arch/arm64/crypto/aes-modes.S
>> +++ b/arch/arm64/crypto/aes-modes.S
>> @@ -225,6 +225,14 @@ AES_ENTRY(aes_ctr_encrypt)
>>         enc_prepare     w22, x21, x6
>>         ld1             {v4.16b}, [x24]
>>
>> +       /* compose addend vector { 1, 2, 3, 0 } in v8.4s */
>> +       movi            v7.4h, #1
>> +       movi            v8.4h, #2
>> +       uaddl           v6.4s, v7.4h, v8.4h
>
> Clever; how come you didn't `movi v6.4h, #3` or `saddl`?  Shorter
> encoding?  Or does it simplify the zips later?

Encodings are always 32 bits on AArch64, so that does not make a difference.

> Since the destination
> is larger, does this give us the 0?
>

Yes.

> The following zip1/zip2 block is a little tricky. Can you help me
> understand it better?
>

Please see below.

>> +       zip1            v8.8h, v7.8h, v8.8h
>
> If zip1 takes the upper half, wouldn't that be zeros, since we moved
> small constants into them, above?
>
>> +       zip1            v8.4s, v8.4s, v6.4s
>> +       zip2            v8.8h, v8.8h, v7.8h
>
> From the docs [0], it looks like zip1/zip2 is used for interleaving
> two vectors, IIUC?  In our case we're interleaving three vectors; v6,
> v7, and v8 into v8?
>

No, the first register is only the destination register in this case,
not a source register.

> And we don't need a second zip2 because...?  Don't we need (or are
> more interested in) the bottom half of v6?
>

To clarify, these are the consecutive values of each of the registers,
using 16-bit elements:

v7 := { 1, 1, 1, 1, 0, 0, 0, 0 }
v8 := { 2, 2, 2, 2, 0, 0, 0, 0 }
v6 := { 3, 0, 3, 0, 3, 0, 3, 0 }
v8 := { 1, 2, 1, 2, 1, 2, 1, 2 }
v8 := { 1, 2, 3, 0, 1, 2, 3, 0 }
v8 := { 1, 0, 2, 0, 3, 0, 0, 0 }


> Note to self: Page 6 [1] seems like a useful doc on arrangement specifiers.
>
> To get { 1, 2, 3, 0 }, does ARM have something like iota/lane
> id+swizzle instructions, ie:
>
> iota -> { 0, 1, 2, 3 }
> swizzle -> { 1, 2, 3, 0 }
>

AArch64 has the ext instruction, which concatenates n trailing bytes
of one source register with 16-n leading bytes of another. This can be
used, e.g., to implement a byte sized rotate when using the same
register for both inputs.


> [0] http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0802a/UADDL_advsimd_vector.html
> [1] https://www.uio.no/studier/emner/matnat/ifi/INF5063/h17/timeplan/armv8-neon.pdf
>
>> +
>>         umov            x6, v4.d[1]             /* keep swabbed ctr in reg */
>>         rev             x6, x6
>>  .LctrloopNx:
>> @@ -232,17 +240,16 @@ AES_ENTRY(aes_ctr_encrypt)
>>         bmi             .Lctr1x
>>         cmn             w6, #4                  /* 32 bit overflow? */
>>         bcs             .Lctr1x
>> -       ldr             q8, =0x30000000200000001        /* addends 1,2,3[,0] */
>>         dup             v7.4s, w6
>>         mov             v0.16b, v4.16b
>>         add             v7.4s, v7.4s, v8.4s
>>         mov             v1.16b, v4.16b
>> -       rev32           v8.16b, v7.16b
>> +       rev32           v7.16b, v7.16b
>>         mov             v2.16b, v4.16b
>>         mov             v3.16b, v4.16b
>> -       mov             v1.s[3], v8.s[0]
>> -       mov             v2.s[3], v8.s[1]
>> -       mov             v3.s[3], v8.s[2]
>> +       mov             v1.s[3], v7.s[0]
>> +       mov             v2.s[3], v7.s[1]
>> +       mov             v3.s[3], v7.s[2]
>>         ld1             {v5.16b-v7.16b}, [x20], #48     /* get 3 input blocks */
>>         bl              aes_encrypt_block4x
>>         eor             v0.16b, v5.16b, v0.16b
>> @@ -296,7 +303,6 @@ AES_ENTRY(aes_ctr_encrypt)
>>         ins             v4.d[0], x7
>>         b               .Lctrcarrydone
>>  AES_ENDPROC(aes_ctr_encrypt)
>> -       .ltorg
>>
>>
>>         /*
>> --
>> 2.17.1
>>
>
>
> --
> Thanks,
> ~Nick Desaulniers
