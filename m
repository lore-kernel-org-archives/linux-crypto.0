Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:12767 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbfANJbI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 04:31:08 -0500
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/6] crypto: hkdf - RFC5869 Key Derivation Function
Date: Mon, 14 Jan 2019 10:30:39 +0100
Message-ID: <4734428.Gj5BGI4uxL@positron.chronox.de>
In-Reply-To: <20190112051252.GA639@sol.localdomain>
References: <20190103143227.9138-1-jlee@suse.com> <2423373.Zd5ThvQH5g@positron.chronox.de> <20190112051252.GA639@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 12. Januar 2019, 06:12:54 CET schrieb Eric Biggers:

Hi Eric,

[...]

> > The extract and expand phases use different instances of the underlying
> > keyed message digest cipher to ensure that while the extraction phase
> > generates a new key for the expansion phase, the cipher for the
> > expansion phase can still be used. This approach is intended to aid
> > multi-threaded uses cases.
> 
> I think you partially misunderstood what I was asking for.  One HMAC tfm is
> sufficient as long as HKDF-Expand is separated from HKDF-Extract, which
> you've done.  So just use one HMAC tfm, and in crypto_hkdf_seed() key it
> with the 'salt', and then afterwards with the 'prk'.

Ok, thanks for the clarification. I will remove the 2nd HMAC TFM then.
> 
> Also everywhere in this patchset, please avoid using the word "cipher" to
> refer to algorithms that are not encryption/decryption.  I know a lot of
> the crypto API docs do this, but I think it is a mistake and confusing. 
> Hash algorithms and KDFs are not "ciphers".

As you wish, I will refer to specific name of the cryptographic operation.

[...]

> > + * NOTE: In-place cipher operations are not supported.
> > + */
> 
> What does an "in-place cipher operation" mean in this context?  That the
> 'info' buffer must not overlap the 'dst' buffer? 

Correct, no overlapping.

> Maybe
> crypto_rng_generate() should check that for all crypto_rngs?  Or is it
> different for different crypto_rngs?

This is the case in general for all KDFs (and even RNGs). It is no technical 
or cryptographic error to have overlapping buffers. The only issue is that the 
result will not match the expected value.

The issue is that the input buffer to the generate function is an input to 
every round of the KDF. If the input and output buffer overlap, starting with 
the 2nd iteration of the KDF, the input is the output of the 1st round. Again, 
I do not think it is a cryptographic error though.

(To support my conclusion: A colleague of mine has proposed an update to the 
HKDF specification where the input data changes for each KDF round. This 
proposal was considered appropriate by one of the authors of HKDF.)

If the requested output is smaller or equal to the output block size of the 
KDF, overlapping buffers are even harmless since the implementation will 
calculate the correct output.

Due to that, I removed the statement. But I am not sure we should add a 
technical block to deny overlapping input/output buffers.

[...]
> > 
> > +	desc->flags = crypto_shash_get_flags(expand_kmd) &
> > +		      CRYPTO_TFM_REQ_MAY_SLEEP;
> 
> This line setting desc->flags doesn't make sense.  How is the user meant to
> control whether crypto_rng_generate() can sleep or not?  Or can it always
> sleep? Either way this part is wrong since the user can't get access to the
> HMAC tfm to set this flag being checked for.

Could you please help me why a user should set this flag? Isn't the 
implementation specifying that flag to allow identifying whether the 
implementation could or could not sleep? Thus, we simply copy the sleeping 
flag from the lower level keyed message digest implementation.

At least that is also the implementation found in crypto/hmac.c.

[...]

> > +		if (dlen < h) {
> > +			u8 tmpbuffer[CRYPTO_HKDF_MAX_DIGESTSIZE];
> > +
> > +			err = crypto_shash_finup(desc, &ctr, 1, tmpbuffer);
> > +			if (err)
> > +				goto out;
> > +			memcpy(dst, tmpbuffer, dlen);
> > +			memzero_explicit(tmpbuffer, h);
> > +			goto out;
> > +		} else {
> 
> No need for the 'else'.

Could you please help me why that else branch is not needed? If the buffer to 
be generated is equal or larger than the output block length of the keyed 
message digest, I would like to directly operate on the output buffer to avoid 
a memcpy.
> 
> > +			err = crypto_shash_finup(desc, &ctr, 1, dst);
> > +			if (err)
> > +				goto out;
> > +
> > +			prev = dst;
> > +			dst += h;
> > +			dlen -= h;
> > +			ctr++;
> > +		}
> > +	}

[...]
> 
> > +	struct crypto_shash *extract_kmd = ctx->extract_kmd;
> > +	struct crypto_shash *expand_kmd = ctx->expand_kmd;
> > +	struct rtattr *rta = (struct rtattr *)seed;
> > +	SHASH_DESC_ON_STACK(desc, extract_kmd);
> > +	u32 saltlen;
> > +	unsigned int h = crypto_shash_digestsize(extract_kmd);
> > +	int err;
> > +	const uint8_t null_salt[CRYPTO_HKDF_MAX_DIGESTSIZE] = { 0 };
> 
> static const
> 

Why would I want to turn that buffer into a static variable? All we need it 
for is in case there is no salt provided.

[...]

> > +
> > +	if (!RTA_OK(rta, slen))
> > +		return -EINVAL;
> > +	if (rta->rta_type != 1)
> > +		return -EINVAL;
> > +	if (RTA_PAYLOAD(rta) < sizeof(saltlen))
> > +		return -EINVAL;
> > +	saltlen = *((u32 *)RTA_DATA(rta));
> 
> I'm guessing you copied the weird "length as a rtattr payload" approach from
> the authenc template.  I think it's not necessary.  And it's overly
> error-prone, as shown by the authenc template getting the parsing wrong for
> years and you making the exact same mistake again here...
> (See https://patchwork.kernel.org/patch/10732803/)  How about just using a
> u32 at the beginning without the 'rtattr' preceding it?

I was not sure whether this approach would be acceptable. I very much would 
love to have a u32 pre-pended only without the RTA business.

I updated the implementation accordingly.
> 
[...]

> 
> > +	alg = &salg->base;
> 
> Check here that the underlying algorithm really is "hmac(" something?

I added a check for the presence of salg->setkey.
> 
> Alternatively it may be a good idea to simplify usage by making the template
> just take the unkeyed hash directly, like "hkdf(sha512)".  And if any users
> really need to specify a specific HMAC implementation then another template
> usable as "hkdf_base(hmac(sha512))" could be added later.
> 

I would not suggest this, because that rounds contrary to the concept of the 
kernel crypto API IMHO. The caller has to provide the wrapping cipher. It is 
perfectly viable to allow a caller to invoke a specific keyed message digest.

[...]

Thank you very much for your code review.

Ciao
Stephan
