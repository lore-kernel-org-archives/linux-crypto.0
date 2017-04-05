From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] crypto: arm64/sha: use %c constraint code in ASM_EXPORT
Date: Wed, 5 Apr 2017 18:21:39 +0100
Message-ID: <e228a810-3f53-a8d6-29c5-428b9870842b@arm.com>
References: <20170405165603.87264-1-mka@chromium.org>
 <CAKv+Gu-7tX6THETVA+M0UrC6rJ4id2AsHi2XfhDEmxCJ_tdwKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Grant Grundler <grundler@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Hackmann <ghackmann@google.com>,
        Michael Davidson <md@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-7tX6THETVA+M0UrC6rJ4id2AsHi2XfhDEmxCJ_tdwKw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/04/17 18:08, Ard Biesheuvel wrote:
> Hoi Matthias!
> 
> On 5 April 2017 at 17:56, Matthias Kaehlcke <mka@chromium.org> wrote:
>> From: Greg Hackmann <ghackmann@google.com>
>>
>> The current definition of ASM_EXPORT doesn't work properly with clang,
>> according to https://bugs.llvm.org//show_bug.cgi?id=27250#c3 it relies on
>> gcc specific behavior. Change the constraint from an intermediate to an
>> output expression which works with both gcc and clang.
>>
>> From: Greg Hackmann <ghackmann@google.com>
>> Commit-message-by: Matthias Kaehlcke <mka@chromium.org>
>> Signed-off-by: Greg Hackmann <ghackmann@google.com>
>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> ---
>>  arch/arm64/crypto/sha1-ce-glue.c | 2 +-
>>  arch/arm64/crypto/sha2-ce-glue.c | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
>> index aefda9868627..c71e94ba0e43 100644
>> --- a/arch/arm64/crypto/sha1-ce-glue.c
>> +++ b/arch/arm64/crypto/sha1-ce-glue.c
>> @@ -18,7 +18,7 @@
>>  #include <linux/module.h>
>>
>>  #define ASM_EXPORT(sym, val) \
>> -       asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
>> +       asm(".globl " #sym "; .set " #sym ", %c0" :: "I"(val));
>>
>>  MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
>>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
>> index 7cd587564a41..381b5fb2dcb2 100644
>> --- a/arch/arm64/crypto/sha2-ce-glue.c
>> +++ b/arch/arm64/crypto/sha2-ce-glue.c
>> @@ -18,7 +18,7 @@
>>  #include <linux/module.h>
>>
>>  #define ASM_EXPORT(sym, val) \
>> -       asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
>> +       asm(".globl " #sym "; .set " #sym ", %c0" :: "I"(val));
>>
>>  MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
>>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
> 
> I am fine with this change, although I would really like to add a
> better reference to the commit log. It is *very* difficult to find any
> documentation regarding non-trivial uses of inline asm constraints,
> and if %c0 is the correct syntax, surely we can quote something better
> than a LLVM bugzilla entry? Also, where does the distinction between
> 'intermediate' vs 'output' expression come from?

FWIW, GCC docs do say (under the helpfully-obvious "x86 operand
modifiers" section[1]):

	c	Require a constant operand and print the constant
		expression with no punctuation.

Which more or less makes sense in this this context too. As an aside,
though, since this is emitting a general integer argument to an
assembler directive, and not an operand to an ADD instruction, how come
we're using "I" and not "i" as the constraint in the first place?

Robin.

[1]:https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#x86-Operand-Modifiers

> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
