From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/4] crypto: aesni - Enable one-sided zero copy for gcm(aes) request buffers
Date: Tue, 23 Jan 2018 07:06:35 +0100
Message-ID: <1797684.7ixjphp57z@tauon.chronox.de>
References: <20180122230403.52572-1-junaids@google.com> <20180122230403.52572-3-junaids@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com
To: Junaid Shahid <junaids@google.com>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59672 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbeAWGGi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jan 2018 01:06:38 -0500
In-Reply-To: <20180122230403.52572-3-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 23. Januar 2018, 00:04:01 CET schrieb Junaid Shahid:

Hi Junaid,

> gcmaes_encrypt/decrypt perform zero-copy crypto if both the source and
> destination satisfy certain conditions (single sglist entry located in
> low-mem or within a single high-mem page). But two copies are done
> otherwise, even if one of source or destination still satisfies the
> zero-copy conditions. This optimization is now extended to avoid the
> copy on the side that does satisfy the zero-copy conditions.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 256
> +++++++++++++++++++------------------ 1 file changed, 134 insertions(+),
> 122 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c
> b/arch/x86/crypto/aesni-intel_glue.c index 3bf3dcf29825..a46eb2d25f71
> 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -744,136 +744,148 @@ static int generic_gcmaes_set_authsize(struct
> crypto_aead *tfm, return 0;
>  }
> 
> +static bool is_mappable(struct scatterlist *sgl, unsigned long len)
> +{
> +	return (!PageHighMem(sg_page(sgl)) || sgl->offset + len <= PAGE_SIZE)
> +	       && len <= sgl->length;

Please integrate the patch https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg30542.html

@Herbert: If this patch series goes in, then the mentioned patch would not be 
needed for the current implementation, but only for stable.

Ciao
Stephan
