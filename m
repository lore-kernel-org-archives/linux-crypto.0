From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: dm-crypt optimization
Date: Thu, 22 Dec 2016 16:59:27 +0800
Message-ID: <20161222085927.GB2160@gondor.apana.org.au>
References: <CAHv-k_98w-9whFiCLAnTGL2QAirExsix_S8ZWc8tM7wj=gzD6Q@mail.gmail.com>
 <bf5e7237-2f5c-3fc6-c7d6-38c3b13ac2c3@gmail.com>
 <CAHv-k_-K9dOiM+Pm_wqVJrvmNYhjtS82-emKVZ8OjsoMHf+7hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <gmazyland@gmail.com>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, private-kwg@linaro.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHv-k_-K9dOiM+Pm_wqVJrvmNYhjtS82-emKVZ8OjsoMHf+7hg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 22, 2016 at 01:55:59PM +0530, Binoy Jayan wrote:
>
> > Support of bigger block sizes would be unsafe without additional mechanism that provides
> > atomic writes of multiple sectors. Maybe it applies to 4k as well on some devices though...)
> 
> Did you mean write to the crypto output buffers or the actual disk write?
> I didn't quite understand how the block size for encryption affects atomic
> writes as it is the block layer which handles them. As far as dm-crypt is,
> concerned it just encrypts/decrypts a 'struct bio' instance and submits the IO
> operation to the block layer.

I think Milan's talking about increasing the real block size, which
would obviously require the hardware to be able to write that out
atomically, as otherwise it breaks the crypto.

But if we can instead do the IV generation within the crypto API,
then the block size won't be an issue at all.  Because you can
supply as many blocks as you want and they would be processed
block-by-block.

Now there is a disadvantage to this approach, and that is you
have to wait for the whole thing to be encrypted before you can 
start doing the IO.  I'm not sure how big a problem that is but
if it is bad enough to affect performance, we can look into adding
some form of partial completion to the crypto API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
