From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm64/aes - do not call
 crypto_unregister_skcipher twice on error
Date: Fri, 24 Nov 2017 15:55:59 +1100
Message-ID: <20171124045558.GA14676@gondor.apana.org.au>
References: <1511338114-39583-1-git-send-email-clabbe@baylibre.com>
 <CAKv+Gu9m3v_iMdg8ngX-3x1HT+c8D52dhjJ=MiTp11VByD=ewA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:39076 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752801AbdKXE6x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 23:58:53 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9m3v_iMdg8ngX-3x1HT+c8D52dhjJ=MiTp11VByD=ewA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 22, 2017 at 08:55:14AM +0000, Ard Biesheuvel wrote:
>
> Would this also fix it?

Looks good.  Could you resubmit with a sign-off?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
