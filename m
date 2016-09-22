From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: gcm - Fix IV buffer size in crypto_gcm_setkey
Date: Thu, 22 Sep 2016 18:32:31 +0800
Message-ID: <20160922103231.GA5884@gondor.apana.org.au>
References: <CAAUqJDt=wXHbU1z5f_=r9tuJxUKDZKR1d9AURoDrye+iwnVrKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52192 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757193AbcIVKcl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:32:41 -0400
Content-Disposition: inline
In-Reply-To: <CAAUqJDt=wXHbU1z5f_=r9tuJxUKDZKR1d9AURoDrye+iwnVrKQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 16, 2016 at 02:07:40PM +0200, Ondrej Mosnáček wrote:
> The cipher block size for GCM is 16 bytes, and thus the CTR transform
> used in crypto_gcm_setkey() will also expect a 16-byte IV. However,
> the code currently reserves only 8 bytes for the IV, causing
> an out-of-bounds access in the CTR transform. This patch fixes
> the issue by setting the size of the IV buffer to 16 bytes.
> 
> Fixes: 84c911523020 ("[CRYPTO] gcm: Add support for async ciphers")
> Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
> ---
> I randomly noticed this while going over igcm.c for an unrelated
> reason. It seems the wrong buffer size never caused any noticeable
> problems (it's been there since 2007), but it should be corrected
> nonetheless...

Sorry, but your patch has been line-wrapped and doesn't apply.
Please resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
