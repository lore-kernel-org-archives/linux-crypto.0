From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: ccree: enable support for hardware keys
Date: Thu, 19 Apr 2018 11:35:09 +0800
Message-ID: <20180419033509.dbzetnt4bv7lj7cb@gondor.apana.org.au>
References: <1522049540-10042-1-git-send-email-gilad@benyossef.com>
 <1522049540-10042-3-git-send-email-gilad@benyossef.com>
 <20180330172616.GB28120@gondor.apana.org.au>
 <CAOtvUMd6MMyQBHU4E=5DKXndhZw90=K1V1apD0uRRaMLyp-0Ag@mail.gmail.com>
 <20180403101905.GA4245@gondor.apana.org.au>
 <CAOtvUMdCBky5Ay1WOSjNZYm=4O63bBaT_mV589xPXJdZ=EPOHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMdCBky5Ay1WOSjNZYm=4O63bBaT_mV589xPXJdZ=EPOHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 09, 2018 at 11:42:31AM +0300, Gilad Ben-Yossef wrote:
>
> Please look again. The stub version of cc_is_hw_key() doing that is being
> replaced in this patch.

The point is that the existing mechanism was unused before and this
is new code.  So you can't really point to the stubbed-out function
as a precedent.
 
> The s390 key and the cryptocell keys are not the same:
> 
> Their is, I believe, is an AES key encrypted by some internal key/algorithm.
> 
> The cryptocell "key" is a token, which is internally comprised of one
> or two indexes, referencing slots in the internal memory in the
> hardware, and a key size, that describe the size of the key.
> 
> I thought it would be confusing to use "paes" to describe both, since
> they are not interchangeable.
> You would not be able to feed an paes key that works with the s390
> version to cryptocell and vice verse and get it work.

Thanks for the info.

> Having said, if you prefer to have "paes" simply designate
> "implementation specific token for an AES key" I'm perfectly fine with
> that.

Well by definition none of these hardware keys will be compatible
with each other so I don't really see the point of using individual
algorithm names such as paes or haes.  This would make sense only if
they were somehow compatible with each other.

So instead of using algorithm names, you really want refer to the
specific driver name, which means that they can all use the same
algorithm name.

> > As to your patch specifically, there is one issue where you're
> > directly dereferencing the key as a struct.  This is a no-no because
> > the key may have come from user-space.  You must treat it as a
> > binary blob.  The s390 code seems to do this correctly.
> 
> As noted above, the haes "key" is really a token encoding 3 different
> pieces of information:

My point is that you should not just cast it but instead do a
copy to properly aligned kernel memory.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
