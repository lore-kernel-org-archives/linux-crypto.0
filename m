Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EC6C4743C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 19:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0984B611AD
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 19:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFWTNZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jun 2021 15:13:25 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:23209 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWTNZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jun 2021 15:13:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624475452;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Er6400DpBGbkMILlHTzXNng0HTW044QxiD2DGJNhQ2g=;
    b=XkRIt2DI70riYYUbHi+mvVcL+uz7TXq4h/86ttAbh91nh+hhWc5cp05KvgFhP4wPIU
    T1f8whgxXEdkeXwp2WS7OvOu3o9h31lVX97zUvJpXtt6c7h+BL4Kt18QYJOEYusWx4kO
    10608oc8bX/U/nRD/KC1FlRSnPVCv2cT0W80fl69w+tYAmv+c9Sg8tST01rMilRYZ2xs
    tnG0P5MswXI/4RhSGGvkM2R4kwZuI4wAAlMkyvKU5TLvcTaPSDxUR5lN/Jo7nLIRInuN
    L46MpTxBDQY0MOrpx2Xos0AHwoaVzkfbLFCYpviiEQdBN4eeLp/mJMCpg4SHPuryewQI
    ic0w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShFkMdZNkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.27.5 DYNA|AUTH)
    with ESMTPSA id L04113x5NJAp20R
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 23 Jun 2021 21:10:51 +0200 (CEST)
Message-ID: <7acf0d4a63f7c94d8355101dd03cbfeb58c05d17.camel@chronox.de>
Subject: Re: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A
 rev1
From:   Stephan Mueller <smueller@chronox.de>
To:     =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        James Morris <jamorris@linux.microsoft.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Simo Sorce <simo@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        hpa@zytor.com, tytso@mit.edu
Date:   Wed, 23 Jun 2021 21:10:51 +0200
In-Reply-To: <9ca2fdb4-8cee-3667-c90a-358255fb8f54@digikod.net>
References: <20210623120751.3033390-1-mic@digikod.net>
         <9dbbf4e751cb4953fe63079cdc917a0bb3a91670.camel@chronox.de>
         <a4e1c071-32af-9650-e6fd-8943b3a79bb0@linux.microsoft.com>
         <8811360.37IJKxs2K1@positron.chronox.de>
         <9ca2fdb4-8cee-3667-c90a-358255fb8f54@digikod.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, dem 23.06.2021 um 20:04 +0200 schrieb Mickaël Salaün:
> 
> On 23/06/2021 19:27, Stephan Müller wrote:
> > Am Mittwoch, 23. Juni 2021, 19:00:29 CEST schrieb James Morris:
> > 
> > Hi James,
> > 
> > > On Wed, 23 Jun 2021, Stephan Mueller wrote:
> > > > > These changes replace the use of the Linux RNG with the Jitter RNG,
> > > > > which is NIST SP800-90B compliant, to get a proper entropy input and a
> > > > > nonce as defined by FIPS.
> > > > 
> > > > Can you please help me understand what is missing in the current code
> > > > which
> > > > seemingly already has achieved this goal?
> > > 
> > > The advice we have is that if an attacker knows the internal state of the
> > > CPU, then the output of the Jitter RNG can be predicted.
> > 
> > Thank you for the hint. And I think such goal is worthwhile (albeit I have
> > to 
> > admit that if an attacker is able to gain the internal state of a CPU, I
> > would 
> > assume we have more pressing problems that a bit of entropy).
> > 
> > Anyways, the current code does:
> > 
> > - in regular mode: seed the DRBG with 384 bits of data from get_random_bytes
> > 
> > - in FIPS mode: seed the DRBG with 384 bits of data from get_random_bytes 
> > concatenated with 384 bits from the Jitter RNG
> > 
> > 
> > If I understand the suggested changes right, I would see the following
> > changes 
> > in the patch:
> > 
> > - in the regular case: 640 bits from get_random_bytes
> 
> Why 640 bits?

 		if (!reseed)
 			entropylen = ((entropylen + 1) / 2) * 3;

-> Entropylen is 384 in case of a security strength of 256 bits.

Your code does the following if the Jitter RNG is not allocated (i.e. in non-
fips mode):

ret = drbg_get_random_bytes(drbg, entropy, entropylen + strength);

so: entropylen + strength = 384 + 256, no?

> 
> > 
> > - in FIPS mode: 256 bits of data from get_random_bytes concatenated with 384
> > bits from the Jitter RNG
> 
> In both cases there are 256 bits for the entropy input and 128 bits for
> the nonce.

I see in the code path with the Jitter RNG:

ret = crypto_rng_get_bytes(drbg->jent, entropy,
 						   entropylen);

--> 384 bits from the Jitter RNG

ret = drbg_get_random_bytes(drbg, entropy + entropylen,
+						    strength);

--> 256 bits from get_random_bytes

What am I missing here?


>  If Jitter RNG is not available, then urandom is used instead,
> which means that the system is not FIPS compliant.

Agreed, the existing does does exactly the same with the exception that it
pulls 384 bits from get_random_bytes instead of 640 in non-FIPS mode (i.e.
when the Jitter RNG is not allocated).

In FIPS mode, the current code draws 384 bits from get_random_bytes and
separately 384 bits from the Jitter RNG. So, each data block from either
entropy source could completely satisfy the SP800-90A requirement.

> 
> This follows the SP800-90Ar1, section 8.6.7: [a nonce shall be] "A value
> with at least (security_strength/2) bits of entropy".

Agreed, but what is your code doing different than the existing code?
> 
> > 
> > So, I am not fully sure what the benefit of the difference is: in FIPS mode 
> > (where the Jitter RNG is used), the amount of data pulled from 
> > get_random_bytes seems to be now reduced.
> 
> We can increase the amount of data pulled from get_random_bytes (how to
> decide the amount?), but as we understand the document, this should be
> part of the personalization string and additional input, not the nonce.

There is no need to have a personalization string or additional input. Note,
those two values are intended to be provided by a caller or some other
environment.

If you want to stuff more seed into the DRBG, you simply enlarge the seed
buffer and pull more from the entropy sources. I have no objections doing
that. All I am trying to point out is that the 90A standard does not require
more entropy than 256 bits during initialization plus 128 bits of nonce == 384
bits of data. But the DRBGs all allow providing more data as seed.

> I guess it may not change much according to the implementation, as for
> the order of random and entropy concatenation, but these changes align
> with the specifications and it should help FIPS certifications.

Are you saying the order of data from the entropy sources matters in the
entropy buffer? I have not seen that in the standard, but if you say this is
the goal, then allow me to understand which order you want to see?

The current code contains the order of:

<384 bits get_random_bytes> || <384 bits Jitter RNG>

Thanks
Stephan
> 
> > 
> > Maybe I miss a point here, but I currently fail to understand why the
> > changes 
> > should be an improvement compared to the current case.
> > 
> > Ciao
> > Stephan
> > 
> > 


