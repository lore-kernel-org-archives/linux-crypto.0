From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: Add IV generation algorithms
Date: Tue, 29 Nov 2016 15:28:25 +0800
Message-ID: <20161129072824.GA5240@gondor.apana.org.au>
References: <1479723009-11113-1-git-send-email-binoy.jayan@linaro.org>
 <1479723009-11113-2-git-send-email-binoy.jayan@linaro.org>
 <20161128124722.GB2257@gondor.apana.org.au>
 <CAHv-k_93FRosd4GeW3NB6fPmjYUNZoe+p+i4ZnwBQqB605bxUA@mail.gmail.com>
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
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHv-k_93FRosd4GeW3NB6fPmjYUNZoe+p+i4ZnwBQqB605bxUA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 29, 2016 at 10:15:40AM +0530, Binoy Jayan wrote:
>
> Thank you for the reply. The dm-crypt changes are also included as
> part of this patchset. It has been tested for functionality as well.
> More information can be found in the cover letter including the test
> procedure etc.
> 
> https://lkml.org/lkml/2016/11/21/168

Sorry, I don't know how I missed that :)

But that begs the question, who is supposed to use crypto_geniv_set_ctx?
I thought it was dm-crypt but your patch doesn't contain any uses
of it at all.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
