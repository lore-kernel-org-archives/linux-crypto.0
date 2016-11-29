From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH] crypto: Add IV generation algorithms
Date: Tue, 29 Nov 2016 13:16:46 +0530
Message-ID: <CAHv-k___PJA9t=V8Kh1_WVq=K_yBfmD2rUzE-xAd_SCrEgOjUA@mail.gmail.com>
References: <1479723009-11113-1-git-send-email-binoy.jayan@linaro.org>
 <1479723009-11113-2-git-send-email-binoy.jayan@linaro.org>
 <20161128124722.GB2257@gondor.apana.org.au> <CAHv-k_93FRosd4GeW3NB6fPmjYUNZoe+p+i4ZnwBQqB605bxUA@mail.gmail.com>
 <20161129072824.GA5240@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161129072824.GA5240@gondor.apana.org.au>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 29 November 2016 at 12:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> But that begs the question, who is supposed to use crypto_geniv_set_ctx?
> I thought it was dm-crypt but your patch doesn't contain any uses
> of it at all.

No one is using it as of now. It was just a thought to pass context
information, instead of making it part of the context which is shared
among dm-crypt and geniv.

-Binoy
