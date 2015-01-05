From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AEAD: add check for presence of auth tag
Date: Mon, 05 Jan 2015 11:26:48 +0100
Message-ID: <7639295.Yx6QIQScqO@tachyon.chronox.de>
References: <15957213.Wu7Np8vQse@tachyon.chronox.de> <20150105101901.GA24736@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150105101901.GA24736@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 5. Januar 2015, 21:19:01 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 30, 2014 at 10:16:03PM +0100, Stephan Mueller wrote:
> > The AEAD decryption operation requires the authentication tag to be
> > present as part of the cipher text buffer. The added check verifies that
> > the caller provides a cipher text buffer with at least the
> > authentication tag.
> > 
> > As the cipher text is provided as a scatterlist, loop through the
> > scatterlist until we know we have sufficient cipher text bytes to invoke
> > the AEAD decryption operation.
> 
> There is no need to vet the scatterlist.  For kernel users it's
> up to them to ensure that the length is valid with respect to the
> sg list.
> 
> For the user-space interface obviously you should ensure that a
> valid length is supplied.

Then it seems I misunderstood you in your last comments. I thought the check 
that the authentication tag is present should be moved to the crypto API so 
that all users benefit from it.

As the authentication tag is "inline" in the ciphertext data stream, the only 
way I see to check for its presence is to verify that sufficient ciphertext is 
provided.

If the AEAD user space interface should perform the check, then the code drop 
provided with patch v6 would already cover that.

Could you please help me understand where that check should be and what should 
be done at the crypto API level?

Thanks

-- 
Ciao
Stephan
