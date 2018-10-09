From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/3] crypto: crypto_xor - use unaligned accessors for
 aligned fast path
Date: Tue, 9 Oct 2018 10:38:27 +0200
Message-ID: <CAKv+Gu_aq7OV9=kOOLRGyqk=eF6+NizkU0nuvmZVWwJ_v97oRw@mail.gmail.com>
References: <20181008211554.5355-1-ard.biesheuvel@linaro.org>
 <20181008211554.5355-3-ard.biesheuvel@linaro.org>
 <20181009034725.GB718@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181009034725.GB718@sol.localdomain>
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

On 9 October 2018 at 05:47, Eric Biggers <ebiggers@kernel.org> wrote:
> Hi Ard,
>
> On Mon, Oct 08, 2018 at 11:15:53PM +0200, Ard Biesheuvel wrote:
>> On ARM v6 and later, we define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> because the ordinary load/store instructions (ldr, ldrh, ldrb) can
>> tolerate any misalignment of the memory address. However, load/store
>> double and load/store multiple instructions (ldrd, ldm) may still only
>> be used on memory addresses that are 32-bit aligned, and so we have to
>> use the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS macro with care, or we
>> may end up with a severe performance hit due to alignment traps that
>> require fixups by the kernel.
>>
>> Fortunately, the get_unaligned() accessors do the right thing: when
>> building for ARMv6 or later, the compiler will emit unaligned accesses
>> using the ordinary load/store instructions (but avoid the ones that
>> require 32-bit alignment). When building for older ARM, those accessors
>> will emit the appropriate sequence of ldrb/mov/orr instructions. And on
>> architectures that can truly tolerate any kind of misalignment, the
>> get_unaligned() accessors resolve to the leXX_to_cpup accessors that
>> operate on aligned addresses.
>>
>> So switch to the unaligned accessors for the aligned fast path. This
>> will create the exact same code on architectures that can really
>> tolerate any kind of misalignment, and generate code for ARMv6+ that
>> avoids load/store instructions that trigger alignment faults.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  crypto/algapi.c         |  7 +++----
>>  include/crypto/algapi.h | 11 +++++++++--
>>  2 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/crypto/algapi.c b/crypto/algapi.c
>> index 2545c5f89c4c..52ce3c5a0499 100644
>> --- a/crypto/algapi.c
>> +++ b/crypto/algapi.c
>> @@ -988,11 +988,10 @@ void crypto_inc(u8 *a, unsigned int size)
>>       __be32 *b = (__be32 *)(a + size);
>>       u32 c;
>>
>> -     if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
>> -         IS_ALIGNED((unsigned long)b, __alignof__(*b)))
>> +     if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
>>               for (; size >= 4; size -= 4) {
>> -                     c = be32_to_cpu(*--b) + 1;
>> -                     *b = cpu_to_be32(c);
>> +                     c = get_unaligned_be32(--b) + 1;
>> +                     put_unaligned_be32(c, b);
>>                       if (likely(c))
>>                               return;
>>               }
>> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
>> index 4a5ad10e75f0..86267c232f34 100644
>> --- a/include/crypto/algapi.h
>> +++ b/include/crypto/algapi.h
>> @@ -17,6 +17,8 @@
>>  #include <linux/kernel.h>
>>  #include <linux/skbuff.h>
>>
>> +#include <asm/unaligned.h>
>> +
>>  /*
>>   * Maximum values for blocksize and alignmask, used to allocate
>>   * static buffers that are big enough for any combination of
>> @@ -212,7 +214,9 @@ static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
>>               unsigned long *s = (unsigned long *)src;
>>
>>               while (size > 0) {
>> -                     *d++ ^= *s++;
>> +                     put_unaligned(get_unaligned(d) ^ get_unaligned(s), d);
>> +                     d++;
>> +                     s++;
>>                       size -= sizeof(unsigned long);
>>               }
>>       } else {
>> @@ -231,7 +235,10 @@ static inline void crypto_xor_cpy(u8 *dst, const u8 *src1, const u8 *src2,
>>               unsigned long *s2 = (unsigned long *)src2;
>>
>>               while (size > 0) {
>> -                     *d++ = *s1++ ^ *s2++;
>> +                     put_unaligned(get_unaligned(s1) ^ get_unaligned(s2), d);
>> +                     d++;
>> +                     s1++;
>> +                     s2++;
>>                       size -= sizeof(unsigned long);
>>               }
>>       } else {
>> --
>> 2.11.0
>>
>
> Doesn't __crypto_xor() have the same problem too?
>

More or less, and I was wondering what to do about it.

To fix __crypto_xor() correctly, we'd have to duplicate the code path
that operates on the u64[], u32[] and u16[] chunks, or we'll end up
with suboptimal code that uses the accessors even if the alignment
routine has executed first. This is the same issue Jason points out in
siphash.

Perhaps the answer is to add 'fast' unaligned accessors that may be
used on unaligned quantities only if
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set?

E.g.,

#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
#define get_unaligned_fast  get_unaligned
#else
#define get_unaligned_fast(x)  (*(x))
#endif

Arnd?
