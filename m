Return-Path: <SRS0=KYaN=WN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2B9C3A59B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 05:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F5D21744
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 05:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566020252;
	bh=sM9SVnToSEC9JTKhN4ZYvkSNHVjxoXICvqe16ZAr7GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=m0HzAjOgK6nFxCEURKm0q2MlgDFmh2LF0AqSp9ciHyJVZZgaidan4Stj+HNwANiKL
	 edhfPybaSR6Tsdkf9rgTDcfpbmgGFCBn+Wup7P7l/ce3XjqIup7343+Io51hnLZKYW
	 4473Stqsw+ntFxs7TmklXVupRkEXzFtvZjHoLvMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfHQFhb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Aug 2019 01:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfHQFhb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Aug 2019 01:37:31 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8197321019;
        Sat, 17 Aug 2019 05:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566020249;
        bh=sM9SVnToSEC9JTKhN4ZYvkSNHVjxoXICvqe16ZAr7GA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IczFTDtt63sxCNnWmjNUemvnl9aZTXtR6Y+LLmLZPoRUTWX7XteO/0vLvNvMXjbLg
         9ThLUkxPtKecM5g5dcjc85PesMGXb4hRC4uUhEZoXwH487PDjkKDx3VNmiCQnl570I
         4yIMOJRtqQSWDXFlzuZFDsJyrdPoiV0qZpoS9+dI=
Date:   Fri, 16 Aug 2019 22:37:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] crypto: sha256 - Use get_unaligned_be32 to get
 input, memzero_explicit
Message-ID: <20190817053728.GD8209@sol.localdomain>
Mail-Followup-To: Hans de Goede <hdegoede@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190816211611.2568-1-hdegoede@redhat.com>
 <20190816211611.2568-5-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816211611.2568-5-hdegoede@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 16, 2019 at 11:16:09PM +0200, Hans de Goede wrote:
> Use get_unaligned_be32 in the lib/crypto/sha256.c sha256_transform()
> implementation so that it can be used with unaligned buffers too,
> making it more generic.
> 
> And use memzero_explicit for better clearing of sensitive data.
> 
> Note unlike other patches in this series this commit actually makes
> functional changes to the sha256 code as used by the purgatory code.
> 
> This fully aligns the lib/crypto/sha256.c sha256_transform()
> implementation with the one from crypto/sha256_generic.c allowing us
> to remove the latter in further patches in this series.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  lib/crypto/sha256.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index b8114028d06f..09a435d845fc 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -14,7 +14,7 @@
>  #include <linux/bitops.h>
>  #include <linux/string.h>
>  #include <crypto/sha256.h>
> -#include <asm/byteorder.h>
> +#include <asm/unaligned.h>
>  
>  static inline u32 Ch(u32 x, u32 y, u32 z)
>  {
> @@ -33,7 +33,7 @@ static inline u32 Maj(u32 x, u32 y, u32 z)
>  
>  static inline void LOAD_OP(int I, u32 *W, const u8 *input)
>  {
> -	W[I] = __be32_to_cpu(((__be32 *)(input))[I]);
> +	W[I] = get_unaligned_be32((__u32 *)input + I);
>  }
>  
>  static inline void BLEND_OP(int I, u32 *W)
> @@ -201,7 +201,7 @@ static void sha256_transform(u32 *state, const u8 *input)
>  
>  	/* clear any sensitive info... */
>  	a = b = c = d = e = f = g = h = t1 = t2 = 0;
> -	memset(W, 0, 64 * sizeof(u32));
> +	memzero_explicit(W, 64 * sizeof(u32));
>  }
>  

There's also an unaligned access in sha256_final() which needs to be fixed.

- Eric
