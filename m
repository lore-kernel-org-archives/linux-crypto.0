From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Fri, 30 Dec 2016 18:27:23 +0800
Message-ID: <20161230102723.GA15713@gondor.apana.org.au>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
 <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
 <20161222085509.GA2160@gondor.apana.org.au>
 <CAHv-k_-EKq2g=Wb+YkPVp9gCXTDEyrxZhQpT5JMSw=WtZ1OC9w@mail.gmail.com>
 <20161223075114.GA3580@gondor.apana.org.au>
 <CAHv-k_9SynECq7qDbrW59=LsV_WNj+9Ffa=6tATyNKOt36he6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <gmazyland@gmail.com>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHv-k_9SynECq7qDbrW59=LsV_WNj+9Ffa=6tATyNKOt36he6Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 29, 2016 at 02:53:25PM +0530, Binoy Jayan wrote:
>
> When we keep these in dm-crypt and if more than one key is used
> (it is actually more than one parts of the original key),
> there are more than one cipher instance created - one for each
> unique part of the key. Since the crypto requests are modelled
> to go through the template ciphers in the order:
> 
> "essiv -> cbc -> aes"
> 
> a particular cipher instance of the IV (essiv in this example) is
> responsible to encrypt an entire bigger block. If this bigger block
> is to be later split into 512 bytes blocks and then encrypted using
> the other cipher instance depending on the following formula:
> 
> key_index = sector & (key_count - 1)

This is just a matter of structuring the key for the IV generator.
The IV generator's key in this case should be a combination of the
key to the underlying CBC plus the set of all keys for the IV
generator itself.  It should then allocate the required number of
tfms as is currently done by crypt_alloc_tfms in dm-crypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
