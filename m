From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: Add IV generation algorithms
Date: Tue, 29 Nov 2016 15:50:12 +0800
Message-ID: <20161129075011.GA5331@gondor.apana.org.au>
References: <1479723009-11113-1-git-send-email-binoy.jayan@linaro.org>
 <1479723009-11113-2-git-send-email-binoy.jayan@linaro.org>
 <20161128124722.GB2257@gondor.apana.org.au>
 <CAHv-k_93FRosd4GeW3NB6fPmjYUNZoe+p+i4ZnwBQqB605bxUA@mail.gmail.com>
 <20161129072824.GA5240@gondor.apana.org.au>
 <CAHv-k___PJA9t=V8Kh1_WVq=K_yBfmD2rUzE-xAd_SCrEgOjUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47812 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755412AbcK2Hum (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 02:50:42 -0500
Content-Disposition: inline
In-Reply-To: <CAHv-k___PJA9t=V8Kh1_WVq=K_yBfmD2rUzE-xAd_SCrEgOjUA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 01:16:46PM +0530, Binoy Jayan wrote:
> 
> No one is using it as of now. It was just a thought to pass context
> information, instead of making it part of the context which is shared
> among dm-crypt and geniv.

OK in that case we should just get rid of it until it's actually
needed.  In any case, if there was a need for such information we
should try to embed it into either the key (per-tfm) or the IV
(per-request) as appropriate.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
