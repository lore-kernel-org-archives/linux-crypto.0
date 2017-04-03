From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH 7/7] crypto, x86, LLVM: aesni - fix token pasting
Date: Mon, 3 Apr 2017 16:14:38 -0700
Message-ID: <20170403231438.GB145051@google.com>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-8-md@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Michael Davidson <md@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33284 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdDCXOk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 19:14:40 -0400
Received: by mail-pg0-f48.google.com with SMTP id x125so134196286pgb.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Apr 2017 16:14:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170317001520.85223-8-md@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

El Thu, Mar 16, 2017 at 05:15:20PM -0700 Michael Davidson ha dit:

> aes_ctrby8_avx-x86_64.S uses the C preprocessor for token pasting
> of character sequences that are not valid preprocessor tokens.
> While this is allowed when preprocessing assembler files it exposes
> an incompatibilty between the clang and gcc preprocessors where
> clang does not strip leading white space from macro parameters,
> leading to the CONCAT(%xmm, i) macro expansion on line 96 resulting
> in a token with a space character embedded in it.
> 
> While this could be fixed by deleting the offending space character,
> the assembler is perfectly capable of handling the token pasting
> correctly for itself so it seems preferable to let it do so and to
> get rid or the CONCAT(), DDQ() and XMM() preprocessor macros.
> 
> Signed-off-by: Michael Davidson <md@google.com>
> ---
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> index a916c4a61165..5f6a5af9c489 100644
> --- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> +++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> @@ -65,7 +65,6 @@
>  #include <linux/linkage.h>
>  #include <asm/inst.h>
>  
> -#define CONCAT(a,b)	a##b
>  #define VMOVDQ		vmovdqu
>  
>  #define xdata0		%xmm0
> @@ -92,8 +91,6 @@
>  #define num_bytes	%r8
>  
>  #define tmp		%r10
> -#define	DDQ(i)		CONCAT(ddq_add_,i)
> -#define	XMM(i)		CONCAT(%xmm, i)
>  #define	DDQ_DATA	0
>  #define	XDATA		1
>  #define KEY_128		1
> @@ -131,12 +128,12 @@ ddq_add_8:
>  /* generate a unique variable for ddq_add_x */
>  
>  .macro setddq n
> -	var_ddq_add = DDQ(\n)
> +	var_ddq_add = ddq_add_\n
>  .endm
>  
>  /* generate a unique variable for xmm register */
>  .macro setxdata n
> -	var_xdata = XMM(\n)
> +	var_xdata = %xmm\n
>  .endm
>  
>  /* club the numeric 'id' to the symbol 'name' */

Any feedback on this patch?

Thanks

Matthias
