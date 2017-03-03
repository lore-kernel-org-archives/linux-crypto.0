From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Fri, 3 Mar 2017 20:04:32 +0800
Message-ID: <20170303120432.GA26540@gondor.apana.org.au>
References: <CALaQ_hoafES-K1ds-XUPC6h4VnHX_ebym4LYjeuq1jHdbLYuDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Nathan Royce <nroycea+kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALaQ_hoafES-K1ds-XUPC6h4VnHX_ebym4LYjeuq1jHdbLYuDQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 03, 2017 at 04:36:18AM -0600, Nathan Royce wrote:
> I do have ECB selected as well:
> DM_CRYPT=y
> CRYPTO_ECB=y
> CRYPTO_XTS=y
> 
> name         : ecb(aes)
> driver       : ecb-aes-s5p
> module       : kernel
> priority     : 100
> refcnt       : 1
> selftest     : passed
> internal     : no
> type         : ablkcipher
> async        : yes
> blocksize    : 16
> min keysize  : 16
> max keysize  : 32
> ivsize       : 0
> geniv        : <default>
> //still no "xts" can be found in the list

Weird.  So you can't find any instances of xts in /proc/crypto
at all? Even if the self-test fails it should still register an
entry there...

In any case, I think disabling the s5p driver should work at
least.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
