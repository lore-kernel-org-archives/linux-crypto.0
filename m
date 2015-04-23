From: Bobby Powers <bobbypowers@gmail.com>
Subject: Re: Crypto Update for 4.1
Date: Thu, 23 Apr 2015 17:35:28 -0400
Message-ID: <CAArOQ2U-dSkbNba_dDiO6cgCXDZEQJ8iChBLxxPO=Hi_mn-2Ag@mail.gmail.com>
References: <20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150415033951.GA1406@gondor.apana.org.au>
	<CA+55aFyynQ75NfQy7Lp6t9Tp8+bp=LKG9Xw9q8KQqNoS+gGLmA@mail.gmail.com>
	<CA+55aFz8pr-J7K-EY5gjCV7ajJZC2tkFwjNG1xLXvQk0qAm2HA@mail.gmail.com>
	<CA+55aFwG1y6KSu-ZUMHXFnw69nRttS3LZW_pScvB6LCZjS02tA@mail.gmail.com>
	<20150416024252.GA11558@gondor.apana.org.au>
	<CA+55aFx+gm+=Xqr-wFN0Akg7=XJOtv3PDbHgVbo38p=DMv=3OQ@mail.gmail.com>
	<20150416030713.GA11668@gondor.apana.org.au>
	<CA+55aFyinAKD8E5Xj49r+5ByfPRvB4axSxJSWg6R6Zd=bDMHig@mail.gmail.com>
	<CAArOQ2Vrbm5xyWyaFNq44gxmK6m_7nxsQhxBXowE=7FrWbhHCA@mail.gmail.com>
	<CAKv+Gu8s=-qyX9MAcpyd39AtBVCa-+Ly1ue1zBwam_bHqqJuvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:32890 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbDWVf3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 17:35:29 -0400
In-Reply-To: <CAKv+Gu8s=-qyX9MAcpyd39AtBVCa-+Ly1ue1zBwam_bHqqJuvg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 4:10 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Hello Bobby,
>
> Would you be able to check whether the following patch fixes the crash?
>
> diff --git a/arch/x86/crypto/sha512-avx2-asm.S
> b/arch/x86/crypto/sha512-avx2-asm.S
> index a4771dcd1fcf..1f20b35d8573 100644
> --- a/arch/x86/crypto/sha512-avx2-asm.S
> +++ b/arch/x86/crypto/sha512-avx2-asm.S
> @@ -79,7 +79,7 @@ NUM_BLKS    = %rdx
>  c           = %rcx
>  d           = %r8
>  e           = %rdx
> -y3          = %rdi
> +y3          = %rsi
>
>  TBL   = %rbp
>

Tested-By: Bobby Powers <bobbypowers@gmail.com>


Thanks Ard.  Yes, this fixes things for me.  Good eye :)

yours,
Bobby
