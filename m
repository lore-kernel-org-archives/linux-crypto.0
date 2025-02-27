Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588C92288EA;
	Thu, 27 Feb 2025 10:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740653621; cv=none; b=pJUzI+GjGwKbOUY5rvD1Gd6lu9wx1Dlaku1wvnQ0Rj1+MIt/YH/vUp1I/4lOq3JlZNoKjnAekuBMQ4wyeM51xwerCatPFL34c2/v4av4AGs73dYS4EVWJfHaG/aRQt6DTdrcq/sTQ6OXOtUoFwFf2Ma4r6tR4VlLeINYTMGaWy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740653621; c=relaxed/simple;
	bh=xMvaPdRrcmL6BJCVKZgOG4AoFPDlvs5iEvJIZcGu+rU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=l/SufJt4V+6OrYzXJ+SUJ7pCzmHZj9gXX1P6EC+kToOaKnzvp3SQLFlruHmfA86Q9zKXsKAnLbCXV/8+bxv8gxlR71/2vKGDYZZSFULFZvZPTX8+LJzTzyqh+cKGMRY+ia9UGxFcPbbNxqlUCV4VzG8s3COVsVJMXOOD1HOr0Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iGSJl3Gp; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iGSJl3Gp"
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 51RAqjb62113557
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 27 Feb 2025 02:52:45 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 51RAqjb62113557
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025021701; t=1740653566;
	bh=iYupelTJBZZSq7J8xhubWxdcLgejcAwSGpM6xMwz/24=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=iGSJl3GpZfFHJfjC+qMd2hf6ogdMv31YGNOE9B41XjmDAgij9l907e6ct3SkC87Co
	 K6OMb2OvJ9QloQe6swe+6fArWUCi7LLTg7Wo27N5JutC1yrYbtqZarM5Grp1eoFl/J
	 GwzRD8nzaHtZQpvj/O6dMjaWv86Gf9T9MZFKvs7+utHTMyMnadrNxUpgInZcO51gXD
	 yKYSUIcFhcwQ7e+M27Dx8jl4o21Uh/7qh95lGx4ObnXUBpyhIqzLnHXqXf7PoecYuk
	 iiEURvK109zM5c5nViWCvUOQ+3+lJ+h0fvkz6w06EIn5Evwcp/0XM3vpWaYwPfsfK/
	 9XWDNckbNowrg==
Date: Thu, 27 Feb 2025 02:52:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Eric Biggers <ebiggers@kernel.org>, Bill Wendling <morbo@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Justin Stitt <justinstitt@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH] x86/crc32: use builtins to improve code generation
User-Agent: K-9 Mail for Android
In-Reply-To: <20250227062859.GA2506@sol.localdomain>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com> <20250227062859.GA2506@sol.localdomain>
Message-ID: <68F134A3-5371-4E74-9942-2BC66984C18A@zytor.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On February 26, 2025 10:28:59 PM PST, Eric Biggers <ebiggers@kernel=2Eorg> =
wrote:
>On Wed, Feb 26, 2025 at 10:12:47PM -0800, Bill Wendling wrote:
>> For both gcc and clang, crc32 builtins generate better code than the
>> inline asm=2E GCC improves, removing unneeded "mov" instructions=2E Cla=
ng
>> does the same and unrolls the loops=2E GCC has no changes on i386, but
>> Clang's code generation is vastly improved, due to Clang's "rm"
>> constraint issue=2E
>>=20
>> The number of cycles improved by ~0=2E1% for GCC and ~1% for Clang, whi=
ch
>> is expected because of the "rm" issue=2E However, Clang's performance i=
s
>> better than GCC's by ~1=2E5%, most likely due to loop unrolling=2E
>>=20
>> Link: https://github=2Ecom/llvm/llvm-project/issues/20571#issuecomment-=
2649330009
>> Cc: Thomas Gleixner <tglx@linutronix=2Ede>
>> Cc: Ingo Molnar <mingo@redhat=2Ecom>
>> Cc: Borislav Petkov <bp@alien8=2Ede>
>> Cc: Dave Hansen <dave=2Ehansen@linux=2Eintel=2Ecom>
>> Cc: x86@kernel=2Eorg
>> Cc: "H=2E Peter Anvin" <hpa@zytor=2Ecom>
>> Cc: Eric Biggers <ebiggers@kernel=2Eorg>
>> Cc: Ard Biesheuvel <ardb@kernel=2Eorg>
>> Cc: Nathan Chancellor <nathan@kernel=2Eorg>
>> Cc: Nick Desaulniers <nick=2Edesaulniers+lkml@gmail=2Ecom>
>> Cc: Justin Stitt <justinstitt@google=2Ecom>
>> Cc: linux-kernel@vger=2Ekernel=2Eorg
>> Cc: linux-crypto@vger=2Ekernel=2Eorg
>> Cc: llvm@lists=2Elinux=2Edev
>> Signed-off-by: Bill Wendling <morbo@google=2Ecom>
>> ---
>>  arch/x86/Makefile         | 3 +++
>>  arch/x86/lib/crc32-glue=2Ec | 8 ++++----
>>  2 files changed, 7 insertions(+), 4 deletions(-)
>
>Thanks!  A couple concerns, though:
>
>> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>> index 5b773b34768d=2E=2E241436da1473 100644
>> --- a/arch/x86/Makefile
>> +++ b/arch/x86/Makefile
>> @@ -114,6 +114,9 @@ else
>>  KBUILD_CFLAGS +=3D $(call cc-option,-fcf-protection=3Dnone)
>>  endif
>>=20
>> +# Enables the use of CRC32 builtins=2E
>> +KBUILD_CFLAGS +=3D -mcrc32
>
>Doesn't this technically allow the compiler to insert CRC32 instructions
>anywhere in arch/x86/ without the needed runtime CPU feature check?  Norm=
ally
>when using intrinsics it's necessary to limit the scope of the feature
>enablement to match the runtime CPU feature check that is done, e=2Eg=2E =
by using
>the target function attribute=2E
>
>> diff --git a/arch/x86/lib/crc32-glue=2Ec b/arch/x86/lib/crc32-glue=2Ec
>> index 2dd18a886ded=2E=2Efdb94bff25f4 100644
>> --- a/arch/x86/lib/crc32-glue=2Ec
>> +++ b/arch/x86/lib/crc32-glue=2Ec
>> @@ -48,9 +48,9 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
>>  EXPORT_SYMBOL(crc32_le_arch);
>>=20
>>  #ifdef CONFIG_X86_64
>> -#define CRC32_INST "crc32q %1, %q0"
>> +#define CRC32_INST __builtin_ia32_crc32di
>>  #else
>> -#define CRC32_INST "crc32l %1, %0"
>> +#define CRC32_INST __builtin_ia32_crc32si
>>  #endif
>
>Do both gcc and clang consider these builtins to be a stable API, or do t=
hey
>only guarantee the stability of _mm_crc32_*() from immintrin=2Eh?  At lea=
st for
>the rest of the SSE and AVX stuff, I thought that only the immintrin=2Eh =
functions
>are actually considered stable=2E
>
>- Eric

There is that=2E=2E=2E also are there compiler versions that we support th=
at do not have -mcrc32 support?=20

