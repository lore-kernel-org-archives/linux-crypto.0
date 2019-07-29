Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7802FC7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 18:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3401620C01
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564424264;
	bh=NKiReXldm0X3FfeMBqbZIBoGUrZqk4cGqx4o5xN+r3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zcMrRo5GGYQ6ViCAZKrhii+EEfSdSBNiLTHVpnPEliPjAUks1pEJihzoxsilaZ/Gg
	 71rfUBhvHqSraLhIdZkfiTkqTURfq2oLQFlxgAbjvaSXYJDKiz2vXbgEgcawEfgwbz
	 H+HB/oCVTcLR5TMWZ36mhPZSGd2Z6DzKmA5oVKgU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfG2SRn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 14:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfG2SRn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 14:17:43 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30892206DD;
        Mon, 29 Jul 2019 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564424261;
        bh=NKiReXldm0X3FfeMBqbZIBoGUrZqk4cGqx4o5xN+r3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pdeZsfvPUcleRIoXCb5RAj7X28w3Jj2hHLeFjlxDOlBGrJ0TvZII3AC09ECb0H1j1
         U4Xn+Yf2Pb45/GD5yyVcMQJ6kRuuZ/d7x2PWvfFStOcRrKmpTS4nNYk12tQUgGwS5Q
         euUoKz2UwVF+2AcDBjYoCzWRKFuK1mTUzHdZvefw=
Date:   Mon, 29 Jul 2019 11:17:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190729181738.GB169027@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 09:10:38AM +0000, Pascal Van Leeuwen wrote:
> Hi Eric,
> 
> Thanks for your feedback!
> 
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Sunday, July 28, 2019 7:31 PM
> > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@davemloft.net; Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com>
> > Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for AEAD fuzz testing
> > 
> > Hi Pascal, thanks for the patch!
> > 
> > On Wed, Jul 24, 2019 at 11:35:17AM +0200, Pascal van Leeuwen wrote:
> > > The probability of hitting specific input length corner cases relevant
> > > for certain hardware driver(s) (specifically: inside-secure) was found
> > > to be too low. Additionally, for authenc AEADs, the probability of
> > > generating a *legal* key blob approached zero, i.e. most vectors
> > > generated would only test the proper generation of a key blob error.
> > >
> > > This patch address both of these issues by improving the random
> > > generation of data lengths (for the key, but also for the ICV output
> > > and the AAD and plaintext inputs), making the random generation
> > > individually tweakable on a per-ciphersuite basis.
> > >
> > > Finally, this patch enables fuzz testing for AEAD ciphersuites that do
> > > not have a regular testsuite defined as it no longer depends on that
> > > regular testsuite for figuring out the key size.
> > >
> > > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > 
> > More comments below, but first I see some test failures and warnings with this
> > patch applied:
> > 
> > alg: aead: authenc(hmac(sha1-generic),cbc-aes-aesni) decryption failed on test vector "random: alen=26 plen=594 authsize=20 klen=60";
> > expected_error=-22, actual_error=-74, cfg="random: may_sleep use_digest src_divs=[33.6%@+12, 18.23%@+2452, 13.7%@+3761,
> > 35.64%@+4019] iv_offset=43"
> >
> Interesting as the inside-secure driver also advertises this ciphersuite and does not generate such 
> an error.  My guess is you get an error here because plen is not a multiple of 16 and this is CBC
> (note to self: for block ciphers, emphasize legal lengths in the randomization ...), but the generic
> implementation returns -EINVAL while this ciphersuite returns -EBADMSG.
> Don't ask me what the actual correct error is in this case, I'm following generic with my driver.

EINVAL is for invalid lengths while EBADMSG is for inauthentic inputs.
Inauthentic test vectors aren't yet automatically generated (even after this
patch), so I don't think EBADMSG should be seen here.  Are you sure there isn't
a bug in your patch that's causing this?

Regardless, something needs to be done about this test failure.  Generally, when
improving the tests I've sent out any needed fixes for the generic, x86, arm,
and arm64 software crypto algorithms first, since those are the most commonly
used and the easiest for most people to test.

> 
> > alg: aead: empty test suite for authenc(hmac(sha1-ni),rfc3686(ctr(aes-generic)))
> > alg: aead: empty test suite for authenc(hmac(sha1-generic),rfc3686(ctr(aes-generic)))
> > alg: aead: authenc(hmac(sha256-generic),cbc-aes-aesni) decryption failed on test vector "random: alen=14 plen=6237 authsize=32
> > klen=72"; expected_error=-22, actual_error=-74, cfg="random: may_sleep use_digest src_divs=[93.90%@+2019, 4.74%@alignmask+4094,
> > 1.36%@+21] dst_divs=[100.0%@+4000]"
> >
> Idem
> 
> > alg: aead: empty test suite for authenc(hmac(sha256-ni),rfc3686(ctr-aes-aesni))
> > alg: aead: empty test suite for authenc(hmac(sha256-generic),rfc3686(ctr(aes-generic)))
> > alg: aead: empty test suite for authenc(hmac(sha384-avx2),rfc3686(ctr-aes-aesni))
> > alg: aead: empty test suite for authenc(hmac(sha384-generic),rfc3686(ctr(aes-generic)))
> 
> > alg: aead: authenc(hmac(sha512-generic),cbc-aes-aesni) decryption failed on test vector "random: alen=14 plen=406 authsize=12
> > klen=104"; expected_error=-22, actual_error=-74, cfg="random: may_sleep use_digest src_divs=[41.41%@+852, 58.59%@+4011]
> > dst_divs=[100.0%@alignmask+4017]"
> >
> Idem
> 
> > alg: aead: empty test suite for authenc(hmac(sha512-avx2),rfc3686(ctr-aes-aesni))
> > alg: aead: empty test suite for authenc(hmac(sha512-generic),rfc3686(ctr(aes-generic)))
> > 
> > 
> > Note that the "empty test suite" message shouldn't be printed (especially not at
> > KERN_ERR level!) if it's working as intended.
> > 
> That's not my code, that was already there. I already got these messages before my 
> modifications, for some ciphersuites. Of course if we don't want that, we can make
> it a pr_warn pr_dbg?

I didn't get these error messages before this patch.  They start showing up
because this patch changes alg_test_null to alg_test_aead for algorithms with no
test vectors.

> 
> > >  struct aead_test_suite {
> > >  	const struct aead_testvec *vecs;
> > >  	unsigned int count;
> > >  };
> > >
> > > +struct aead_test_params {
> > > +	struct len_range_set ckeylensel;
> > > +	struct len_range_set akeylensel;
> > > +	struct len_range_set authsizesel;
> > > +	struct len_range_set aadlensel;
> > > +	struct len_range_set ptxtlensel;
> > > +};
> > > +
> > >  struct cipher_test_suite {
> > >  	const struct cipher_testvec *vecs;
> > >  	unsigned int count;
> > > @@ -143,6 +156,10 @@ struct alg_test_desc {
> > >  		struct akcipher_test_suite akcipher;
> > >  		struct kpp_test_suite kpp;
> > >  	} suite;
> > > +
> > > +	union {
> > > +		struct aead_test_params aead;
> > > +	} params;
> > >  };
> > 
> > Why not put these new fields in the existing 'struct aead_test_suite'?
> > 
> > I don't see the point of the separate 'params' struct.  It just confuses things.
> > 
> Mostly because I'm not that familiar with C datastructures (I'm not a programmer
> and this is pretty much my first serious experience with C), so I didn't know how
> to do that / didn't want to break anything else :-)
> 
> So if you can provide some example on how to do that ...

I'm simply suggesting adding the fields of 'struct aead_test_params' to
'struct aead_test_suite'.

> > > +	alen = random_lensel(&lengths->akeylensel);
> > > +	clen = random_lensel(&lengths->ckeylensel);
> > > +	if ((alen >= 0) && (clen >= 0)) {
> > > +		/* Corect blob header. TBD: Do we care about corrupting this? */
> > > +#ifdef __LITTLE_ENDIAN
> > > +		memcpy((void *)vec->key, "\x08\x00\x01\x00\x00\x00\x00\x10", 8);
> > > +#else
> > > +		memcpy((void *)vec->key, "\x00\x08\x00\x01\x00\x00\x00\x10", 8);
> > > +#endif
> > 
> > Isn't this specific to "authenc" AEADs?  There needs to be something in the test
> > suite that says an authenc formatted key is needed.
> > 
> It's under the condition of seperate authentication (alen) and cipher (clen) keys,
> true AEAD's only have a single key. Because if they hadn't, they would also need
> this kind of key blob thing (at least for consistency) and need this code.
> 
> > > +
> > > +		/* Generate keys based on length templates */
> > > +		generate_random_bytes((u8 *)(vec->key + 8), alen);
> > > +		generate_random_bytes((u8 *)(vec->key + 8 + alen),
> > > +				      clen);
> > > +
> > > +		vec->klen = 8 + alen + clen;
> > > +	} else {
> > > +		if (clen >= 0)
> > > +			maxkeysize = clen;
> > > +
> > > +		vec->klen = maxkeysize;
> > > +
> > > +		/*
> > > +		 * Key: length in [0, maxkeysize],
> > > +		 * but usually choose maxkeysize
> > > +		 */
> > > +		if (prandom_u32() % 4 == 0)
> > > +			vec->klen = prandom_u32() % (maxkeysize + 1);
> > > +		generate_random_bytes((u8 *)vec->key, vec->klen);
> > > +	}

Sure, but why is this patch making the length selectors specific to AEADs that
use separate authentication and encryption keys?  It should work for both.

> > >  	vec->setkey_error = crypto_aead_setkey(tfm, vec->key, vec->klen);
> > 
> > The generate_random_aead_testvec() function is getting too long and complicated.
> >
> I'll ignore that comment to avoid starting some flame war ;-)
> 
> > It doesn't help that now the 'clen' variable is used for multiple different
> > purposes (encryption key length and ciphertext length).  
> >
> Ah yeah, actually I had seperate variables for that which I at some point merged to
> save some stack space. Blame it on me being oldschool ;-)
> 
> > Could you maybe factor out the key generation into a separate function?
> > 
> I could, if that would make people happy ...

Not sure why anyone would start a flame war.  This is just usual software
development: functions often get too long and complicated as people keep
patching in more stuff, so periodically there needs to be some refactoring to
keep the code understandable/maintainable/reviewable.  And I strongly believe
that contributors to the problem need to be responsible for doing their part,
and not assume that Someone Else will do it :-)

> > > +
> > > +/*
> > > + * List of length ranges sorted on increasing threshold
> > > + *
> > > + * 25% of each of the legal key sizes (128, 192, 256 bits)
> > > + * plus 25% of illegal sizes in between 0 and 1024 bits.
> > > + */
> > > +static const struct len_range_sel aes_klen_template[] = {
> > > +	{
> > > +	.len_lo = 0,
> > > +	.len_hi = 15,
> > > +	.threshold = 25,
> > > +	}, {
> > > +	.len_lo = 16,
> > > +	.len_hi = 16,
> > > +	.threshold = 325,
> > > +	}, {
> > > +	.len_lo = 17,
> > > +	.len_hi = 23,
> > > +	.threshold = 350,
> > > +	}, {
> > > +	.len_lo = 24,
> > > +	.len_hi = 24,
> > > +	.threshold = 650,
> > > +	}, {
> > > +	.len_lo = 25,
> > > +	.len_hi = 31,
> > > +	.threshold = 675,
> > > +	}, {
> > > +	.len_lo = 32,
> > > +	.len_hi = 32,
> > > +	.threshold = 975,
> > > +	}, {
> > > +	.len_lo = 33,
> > > +	.len_hi = 128,
> > > +	.threshold = 1000,
> > > +	}
> > > +};
> > 
> > Can you please move these to be next to the test vectors for each algorithm, so
> > things are kept in one place for each algorithm?
> > 
> Actually, these are supposed to be generic, to be shared across multiple
> test vectors. So what do you think would be the best place for them?

These are specific to AES, though.  So I'd expect to find them next to the plain
AES test vectors (aes_tv_template[]). 

> 
> > Also, perhaps these should use the convention '.proportion_of_total', like
> > 'struct testvec_config' already does, rather than '.threshold'?  That would be
> > more consistent with the existing test code, and would also make it slightly
> > easier to change the probabilities later.
> > 
> I'm not quite sure if its the same thing. If someone can acknowledge that it is,
> I could give it the same name. But otherwise, that would just be confusing ...
> 
> > E.g. if someone wanted to increase the probability of the first case and
> > decrease the probability of the last case, then with the '.threshold' convention
> > they'd have to change for every entry, but with the '.proportion_of_total'
> > convention they'd only have to change the first and last entries.
> > 
> Oh, you are suggesting to change the whole mechanism, not just the name.
> Honestly, I didn't like the proportion_of_total mechanism because it 
> requires you to parse the data twice. Again, I'm oldschool so I try to provide
> my data in such a form that it requires the least amount of actual processing.
> 

It would be the same number of passes.  One for each the actual generation, and
one in testmgr_onetime_init() to verify the numbers add up to exactly 100%.
(A verification pass would still be needed in the '.threshold' convention too,
to verify that the numbers are all < 100% and in increasing order.)

I'd rather optimize for making it easy to write and change the test vectors,
since those are much more lines of code than the .c code that runs the tests.

Thanks!

- Eric
