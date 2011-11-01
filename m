From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: Hardware acceleration indication in af_alg
Date: Tue, 1 Nov 2011 12:59:40 +0000
Message-ID: <20111101125940.GA5072@totoro>
References: <4EAFE96E.9080601@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57011 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1KAM7p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Nov 2011 08:59:45 -0400
Received: by wwi36 with SMTP id 36so3046821wwi.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Nov 2011 05:59:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4EAFE96E.9080601@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Nikos,

On Tue, Nov 01, 2011 at 01:43:26PM +0100, Nikos Mavrogiannopoulos wrote:
> On 10/28/2011 06:24 PM, Nikos Mavrogiannopoulos wrote:
> 
> >>> I can imagine, an alternative approach and perhaps better
> >>> approach would be to measure the speed of the kernel provided
> >>> algorithm against a software implementation, but there are many
> >>> other factors that could influence the results. Therefore, it is
> >>> perhaps better to just make the assumption that hardware
> >>> acceleration is faster which is made in the kernel anyhow.
> >> You have to be careful to distinguish between hardware
> >> acceleration that is directly available to user-space (such as
> >> AESNI) and those that aren't.
> > How can this be done? The only driver field that could be used for
> > that is cra_priority and it seems it typically set to 300
> > irrespective of instruction based crypto or external device.
> 
> I suppose that no answer means there is no way. In that case would you
> consider this or a similar patch to indicate whether a driver provides
> an algorithm not available to userspace via other means (e.g.
> instruction set)? This would allow users of the kernel interfaces to
> avoid using software implementations or implementations that are
> available to userspace anyway.
[...]
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index de9adec..3e14cee 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -51,6 +51,11 @@
>  #define CRYPTO_ALG_DYING		0x00000040
>  #define CRYPTO_ALG_ASYNC		0x00000080
>  
> +/* Set this bit if the algorithm provided is hardware accelerated but
> + * not available to userspace via instruction set or so.
> + */
> +#define CRYPTO_ALG_KERN_ONLY            0x00000100

Would it be a bit clearer if this was CRYPTO_ALG_IS_UNPRIVILIGED and was 
set the other way round (so instruction set based ones that users can 
use)?  I had to do a double take with KERN_ONLY.

Jamie
