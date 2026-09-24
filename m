Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A019149BD74;
	Thu, 24 Sep 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790261903; cv=none; b=Fxmtd1cVjy3kg02NoxnCQOHMpI/FhnIPvC5BF1ABOfMeqk/VE6rojf0XWeD50GnOS7u5SdyR1P8SjOYZDjZySvzuuG2WAIrob7L02K9Hr+Mwm4CCG9FQS5ck/a+pfBHfxYHYqOvLDFX74wzJWilOhpe91SvAscJR6AsYUTyBbZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790261903; c=relaxed/simple;
	bh=Pv9is5h4USJHc3Kzav1YALl7yvM7IrZRsj8hM4t94K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Abj429QUrvz8RvN8KSqK/P38g7jguDQ5J120RSjYtsDqRqter01xfWSjadfkwEdLdjE8suSLXhhOb8nZGweklqFpOHOZgfNZFguESdqsMr1wj0CpobiG/doPHDZDyep7aKrZTY4LYIAK3hlSmB99efMhHbuD7mL6SGRlVNHYo7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZ3RR0wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZ3RR0wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974811F000FF;
	Thu, 24 Sep 2026 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790261892;
	bh=UZ6iFFyAzpJmp3mAuNI50frHmht+mNjiiWRlqSNZIuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IZ3RR0wngUOBduzPhVmPqqP5uRxbpB1SibgFettW2P9cYDYeRimY6nqiCLT22+MIE
	 N3KGx9BA/VMt6QwtBGQXcfFrCCYBbe5SgGzsn+mJOyW2rukgkKCSLbWxSQvEgI43Pb
	 nLwPWlYeAl4ZSnlAVaw8BMVG1p7uOY0wubIb9m9+kkPVCVyiI4x82h4ahOIqNeV1VE
	 yrJxQsXruk9HPVBA4lc6tXrKOe4M+eB6guRNK+wenOqwoQWkbv3/DYLTcFxbsI0GjW
	 sKgAhN1riCNqM3Iy9luRIembdcjMNdGq2A30OncTyx6lFVFlTPHY1r2fFsij4duhSJ
	 uv338pEeJyp0w==
Date: Thu, 24 Sep 2026 10:58:06 -0400
From: Nathan Chancellor <nathan@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH v4 11/13] lib/crypto: sha2: Provide functions for
 zeroizing SHA2 hmac_sha* structures
Message-ID: <20260924145806.GA1949494@ax162>
References: <20260916095022.604354-1-thuth@redhat.com>
 <20260916095022.604354-12-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916095022.604354-12-thuth@redhat.com>

Hi Thomas,

On Wed, Sep 16, 2026 at 11:50:13AM +0200, Thomas Huth wrote:
> In certain cases crypto code functions need to zeroize their local SHA2
> hmac_sha*_key or hmac_sha*_ctx structures after use to avoid leaking
> sensitive material on the stack.
> Provide hmac_sha*_zeroize_key() and hmac_sha*_zeroize_ctx() helper
> functions that can be used with __cleanup() to automatically zeroize
> the structure when it goes out of scope.
> 
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/crypto/sha2.h | 73 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
> 
> diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
> index 7bb8fe169daf2..22fbc37ae8407 100644
> --- a/include/crypto/sha2.h
> +++ b/include/crypto/sha2.h
> @@ -7,6 +7,7 @@
>  #define _CRYPTO_SHA2_H
>  
>  #include <linux/types.h>
> +#include <linux/string.h>

I am seeing a build failure with CONFIG_CFI=y after this patch landed in
-next as commit 09eb210b7deb ("lib/crypto: sha2: Provide functions for
zeroizing SHA2 hmac_sha* structures").

  $ printf 'CONFIG_%s=y\n' CFI KEXEC_FILE >kernel/configs/repro.config

  $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper defconfig repro.config arch/x86/purgatory/
  ld.lld: error: undefined symbol: __memset
  >>> referenced by string.c
  >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memset_5)

  ld.lld: error: undefined symbol: __memmove
  >>> referenced by string.c
  >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memmove_6)
  make[6]: *** [arch/x86/purgatory/Makefile:80: arch/x86/purgatory/purgatory.chk] Error 1
  ...

This comes from the instances of KCFI_REFERENCE in
arch/x86/include/asm/string_64.h. Maybe __DISABLE_EXPORTS should be set
for the full purgatory to avoid this? I am juggling a lot of stuff at
the moment so just this report instead of a full patch.

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index cde8463b4d84..aa5b48c47e4f 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -11,8 +11,6 @@ $(obj)/string.o: $(srctree)/arch/x86/boot/compressed/string.c FORCE
 $(obj)/sha256.o: $(srctree)/lib/crypto/sha256.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-CFLAGS_sha256.o := -D__DISABLE_EXPORTS
-
 # When profile-guided optimization is enabled, llvm emits two different
 # overlapping text sections, which is not supported by kexec. Remove profile
 # optimization flags.
@@ -38,6 +36,7 @@ PURGATORY_CFLAGS += -fpic -fvisibility=hidden
 PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
 PURGATORY_CFLAGS += -fno-stack-protector
 PURGATORY_CFLAGS += -D__NO_FORTIFY
+PURGATORY_CFLAGS += -D__DISABLE_EXPORTS
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-- 
Cheers,
Nathan
