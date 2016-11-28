From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: arm64/sha2: integrate OpenSSL implementations
 of SHA256/SHA512
Date: Mon, 28 Nov 2016 19:58:43 +0800
Message-ID: <20161128115843.GA2257@gondor.apana.org.au>
References: <1479642121-17912-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9SG5s=zddQaw+444191JGqmXfCh+AKyv3nZNqggmh=Kw@mail.gmail.com>
 <CAKv+Gu9RVFQ4SNzbHbNCFSXy01b+_dCeRc4bXgZagovGy9BYtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Andy Polyakov <appro@openssl.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38456 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754074AbcK1L7L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 06:59:11 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9RVFQ4SNzbHbNCFSXy01b+_dCeRc4bXgZagovGy9BYtQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 28, 2016 at 09:50:33AM +0000, Ard Biesheuvel wrote:
>
> Assuming that everyone is happy now (Will?), could we get this one
> queued for v4.10? The CRC stuff I sent over the past week can wait for
> v4.11 (and I should probably do a v2 roundup with everything
> combined), but this patch is good to go IMO

Sorry, I overlooked it because it wasn't in patchwork.  I have
applied it now and will push it out soon.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
