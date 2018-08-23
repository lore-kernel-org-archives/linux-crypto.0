From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto: arm64/aes-modes - get rid of literal load of
 addend vector
Date: Thu, 23 Aug 2018 23:39:55 +0100
Message-ID: <CAKv+Gu9Txzh+XvodgkduoFf2pvOom_=rDw_h9XS76oCnADPnpw@mail.gmail.com>
References: <20180823164845.20055-1-ard.biesheuvel@linaro.org>
 <CAKwvOdmar-LrU-B7kEo+t5fUS2LOLqX35d-p7v03qXwD8wtG_g@mail.gmail.com>
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
In-Reply-To: <CAKwvOdmar-LrU-B7kEo+t5fUS2LOLqX35d-p7v03qXwD8wtG_g@mail.gmail.com>
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

On 23 August 2018 at 21:04, Nick Desaulniers <ndesaulniers@google.com> wrote:
> On Thu, Aug 23, 2018 at 9:48 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>>
>> Replace the literal load of the addend vector with a sequence that
>> performs each add individually. This sequence is only 2 instructions
>> longer than the original, and 2% faster on Cortex-A53.
>>
>> This is an improvement by itself, but also works around a Clang issue,
>> whose integrated assembler does not implement the GNU ARM asm syntax
>> completely, and does not support the =literal notation for FP registers
>> (more info at https://bugs.llvm.org/show_bug.cgi?id=38642)
>>
>> Cc: Nick Desaulniers <ndesaulniers@google.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> v2: replace convoluted code involving a SIMD add to increment four BE counters
>>     at once with individual add/rev/mov instructions
>>
>>  arch/arm64/crypto/aes-modes.S | 16 +++++++++-------
>>  1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
>> index 483a7130cf0e..496c243de4ac 100644
>> --- a/arch/arm64/crypto/aes-modes.S
>> +++ b/arch/arm64/crypto/aes-modes.S
>> @@ -232,17 +232,19 @@ AES_ENTRY(aes_ctr_encrypt)
>>         bmi             .Lctr1x
>>         cmn             w6, #4                  /* 32 bit overflow? */
>>         bcs             .Lctr1x
>> -       ldr             q8, =0x30000000200000001        /* addends 1,2,3[,0] */
>> -       dup             v7.4s, w6
>> +       add             w7, w6, #1
>>         mov             v0.16b, v4.16b
>> -       add             v7.4s, v7.4s, v8.4s
>> +       add             w8, w6, #2
>>         mov             v1.16b, v4.16b
>> -       rev32           v8.16b, v7.16b
>> +       add             w9, w6, #3
>>         mov             v2.16b, v4.16b
>> +       rev             w7, w7
>>         mov             v3.16b, v4.16b
>> -       mov             v1.s[3], v8.s[0]
>> -       mov             v2.s[3], v8.s[1]
>> -       mov             v3.s[3], v8.s[2]
>> +       rev             w8, w8
>> +       mov             v1.s[3], w7
>> +       rev             w9, w9
>> +       mov             v2.s[3], w8
>> +       mov             v3.s[3], w9
>
> Just curious about the order of movs and revs here, is this some kind
> of manual scheduling?
>

Yes. Interleaving ALU and SIMD instructions gives a speedup on some
cores, and doesn't hurt others. Beyond that, it's just putting as much
space between the write of a register and the subsequent read.

> Regardless,
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>

Thanks!

>>         ld1             {v5.16b-v7.16b}, [x20], #48     /* get 3 input blocks */
>>         bl              aes_encrypt_block4x
>>         eor             v0.16b, v5.16b, v0.16b
>> --
>> 2.18.0
>>
>
>
> --
> Thanks,
> ~Nick Desaulniers
