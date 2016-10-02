From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm64/sha256 - add support for SHA256 using NEON
 instructions
Date: Sun, 2 Oct 2016 22:46:50 +0800
Message-ID: <20161002144650.GI18268@gondor.apana.org.au>
References: <1475189503-9175-1-git-send-email-ard.biesheuvel@linaro.org>
 <1475189503-9175-2-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu8J9rHA2opKqHQr74GU6xxwMpaJak1mNpRVpOf=+BZ81w@mail.gmail.com>
 <CAKv+Gu_M+FcuDSaGsJYjD96=Q1iXyFDD3KWy=4vUbeLWRgrHJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Andy Polyakov <appro@openssl.org>,
        Victor Chong <victor.chong@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45242 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbcJBOq7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Oct 2016 10:46:59 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_M+FcuDSaGsJYjD96=Q1iXyFDD3KWy=4vUbeLWRgrHJw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 01, 2016 at 07:58:56PM -0700, Ard Biesheuvel wrote:
>
> Please disregard this patch for now. I will follow up with a more
> elaborate series for SHA256 on arm64

Thanks for the heads up.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
