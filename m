From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to ASM_EXPORT
Date: Tue, 18 Apr 2017 16:35:02 +0100
Message-ID: <CAKv+Gu_DHBT=2YA9h+ao3pZXgEV5KsO9ia+J90wtLuDX=a4+eg@mail.gmail.com>
References: <20170405183458.193068-1-mka@chromium.org> <CAP=VYLpejcYwXUMtCCkXmjXw=T1tBJLn21aVi-9v_VGmEinjRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matthias Kaehlcke <mka@chromium.org>,
        Greg Hackmann <ghackmann@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAP=VYLpejcYwXUMtCCkXmjXw=T1tBJLn21aVi-9v_VGmEinjRg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 April 2017 at 15:47, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> On Wed, Apr 5, 2017 at 2:34 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
>> The operand is an integer constant, make the constness explicit by
>> adding the modifier. This is needed for clang to generate valid code
>> and also works with gcc.
>
> Actually it doesn't work with all gcc.  I've got an older arm64 toolchain that I
> only use for syntax checking (and hence I don't care if it is the latest and
> greatest) and this commit breaks it:
>
> arch/arm64/crypto/sha1-ce-glue.c:21:2: error: invalid 'asm': invalid
> operand prefix '%c'
>   asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
>
> I'm currently reverting this change locally so I can continue to use the old
> toolchain:
>
> $ aarch64-linux-gnu-gcc --version
> aarch64-linux-gnu-gcc (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro
> GCC 2013.11) 4.8.3 20131202 (prerelease)
> Copyright (C) 2013 Free Software Foundation, Inc.
>
> $ aarch64-linux-gnu-as --version
> GNU assembler (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro GCC
> 2013.11) 2.24.0.20131220
> Copyright 2013 Free Software Foundation, Inc.
>
> Maybe it is finally too old and nobody cares, but I thought it worth a mention.
>

Thanks for the report. I think we care more about GCC 4.8 than about
Clang, which argues for reverting this patch.

I understand these issues must be frustrating if you are working on
this stuff, but to me, it is not entirely obvious why we want to
support Clang in the first place (i.e., what does it buy you if your
distro/environment is not already using Clang for userland), and why
the burden is on Linux to make modifications to support Clang,
especially when it comes to GCC extensions such as inline assembly
syntax.

It is ultimately up to the maintainers to decide what to do with this
patch, but my vote would be to revert it, especially given that the %c
placeholder prefix is not documented anywhere, and appears to simply
trigger some GCC internals that happen to do the right thing in this
case.

However, the I -> i change is arguably an improvement, and considering
that the following

asm("foo: .long %0" :: "i"(some value))

doesn't compile with clang either, I suggest you (Matthias) file a bug
against Clang to get this fixed, and we can propose another patch just
for the I->i change.

-- 
Ard.


>>
>> Also change the constraint of the operand from 'I' ("Integer constant
>> that is valid as an immediate operand in an ADD instruction", AArch64)
>> to 'i' ("An immediate integer operand").
>>
>> Based-on-patch-from: Greg Hackmann <ghackmann@google.com>
>> Signed-off-by: Greg Hackmann <ghackmann@google.com>
>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> ---
>> Changes in v2:
>> - Changed operand constraint from I to i
>> - Updated commit message
>> - Changed 'From' tag to 'Based-on-patch-from'
>>
>>  arch/arm64/crypto/sha1-ce-glue.c | 2 +-
>>  arch/arm64/crypto/sha2-ce-glue.c | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
>> index aefda9868627..6b520e3f3ab1 100644
>> --- a/arch/arm64/crypto/sha1-ce-glue.c
>> +++ b/arch/arm64/crypto/sha1-ce-glue.c
>> @@ -18,7 +18,7 @@
>>  #include <linux/module.h>
>>
>>  #define ASM_EXPORT(sym, val) \
>> -       asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
>> +       asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
>>
>>  MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
>>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
>> index 7cd587564a41..e3abe11de48c 100644
>> --- a/arch/arm64/crypto/sha2-ce-glue.c
>> +++ b/arch/arm64/crypto/sha2-ce-glue.c
>> @@ -18,7 +18,7 @@
>>  #include <linux/module.h>
>>
>>  #define ASM_EXPORT(sym, val) \
>> -       asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
>> +       asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
>>
>>  MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
>>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>> --
>> 2.12.2.715.g7642488e1d-goog
>>
