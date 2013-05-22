From: Julian Wollrath <jwollrath@web.de>
Subject: Re: [PATCH] crypto: sha256_ssse3 - fix stack corruption with SSSE3
 and AVX implementations
Date: Wed, 22 May 2013 16:51:24 +0200
Message-ID: <20130522165124.01696465@ilfaris>
References: <20130521140941.15997.83258.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:49407 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab3EVOvn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 May 2013 10:51:43 -0400
In-Reply-To: <20130521140941.15997.83258.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

> The _XFER stack element size was set too small, 8 bytes, when it
> needs to be 16 bytes. As _XFER is the last stack element used by
> these implementations, the 16 byte stores with 'movdqa' corrupt the
> stack where the value of register %r12 is temporarily stored. As
> these implementations align the stack pointer to 16 bytes, this
> corruption did not happen every time.
> 
> Patch corrects this issue.
> 
> Reported-by: Julian Wollrath <jwollrath@web.de>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Julian Wollrath <jwollrath@web.de>

Thank you for fixing this issue.

Best regards,
Julian Wollrath
> ---
>  arch/x86/crypto/sha256-avx-asm.S   |    2 +-
>  arch/x86/crypto/sha256-ssse3-asm.S |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha256-avx-asm.S
> b/arch/x86/crypto/sha256-avx-asm.S index 56610c4..642f156 100644
> --- a/arch/x86/crypto/sha256-avx-asm.S
> +++ b/arch/x86/crypto/sha256-avx-asm.S
> @@ -118,7 +118,7 @@ y2 = %r15d
>  
>  _INP_END_SIZE = 8
>  _INP_SIZE = 8
> -_XFER_SIZE = 8
> +_XFER_SIZE = 16
>  _XMM_SAVE_SIZE = 0
>  
>  _INP_END = 0
> diff --git a/arch/x86/crypto/sha256-ssse3-asm.S
> b/arch/x86/crypto/sha256-ssse3-asm.S index 98d3c39..f833b74 100644
> --- a/arch/x86/crypto/sha256-ssse3-asm.S
> +++ b/arch/x86/crypto/sha256-ssse3-asm.S
> @@ -111,7 +111,7 @@ y2 = %r15d
>  
>  _INP_END_SIZE = 8
>  _INP_SIZE = 8
> -_XFER_SIZE = 8
> +_XFER_SIZE = 16
>  _XMM_SAVE_SIZE = 0
>  
>  _INP_END = 0
> 
