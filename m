Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD44C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C49C2085B
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565371045;
	bh=Wom0p8ShZdx7BDDBg4tUdjswURtdxQA7z+Qu2rPusww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=E84dOcdGtFavY+kRkIWP5aE4JYFhofocM24zKpgY2oYjxh50yhBHnnWO0qQtj3soh
	 URxwD1IPn0J1jYYCy1C7LaB4qPjQpIOP8aCmQsv2RmPMQt7CvGFQ1s58I3xC+vfJB+
	 OrAxs2X03MRnbOf0Y+GRigiRoGa2mmWf0vhWCXwA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfHIRRY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 13:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfHIRRX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 13:17:23 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09A132085B;
        Fri,  9 Aug 2019 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565371042;
        bh=Wom0p8ShZdx7BDDBg4tUdjswURtdxQA7z+Qu2rPusww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXMS8KR1Jrs2cXtfclvYLceVoE/XQ9PHuodJ6YXUgrT/cs/98FkobLO9o0LCRYSJX
         HVGZZW3xuSpJRZ1NRS3+iWkoltZQcZkqKS9O2Fw/+rni0qkj+lI4fpxL0+kKlFHB2+
         lysDkXLihFb80HkcLQVDRg69rqB2a2udQEK4lPt0=
Date:   Fri, 9 Aug 2019 10:17:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Message-ID: <20190809171720.GC658@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
 <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808083059.GB5319@sol.localdomain>
 <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
 <MN2PR20MB29739B9D16130F5C06831C92CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808171508.GA201004@gmail.com>
 <MN2PR20MB2973387C1A083138866EE45FCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973387C1A083138866EE45FCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 09, 2019 at 09:17:23AM +0000, Pascal Van Leeuwen wrote:
> <trimmed to: list due to being somewhat off-topic>
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Thursday, August 8, 2019 7:15 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: Milan Broz <gmazyland@gmail.com>; Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com;
> > dm-devel@redhat.com
> > Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> > 
> > On Thu, Aug 08, 2019 at 01:23:10PM +0000, Pascal Van Leeuwen wrote:
> > > > -----Original Message-----
> > > > From: Milan Broz <gmazyland@gmail.com>
> > > > Sent: Thursday, August 8, 2019 2:53 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Eric Biggers
> > <ebiggers@kernel.org>
> > > > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.org;
> > > > herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com
> > > > Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> > > >
> > > > On 08/08/2019 11:31, Pascal Van Leeuwen wrote:
> > > > >> -----Original Message-----
> > > > >> From: Eric Biggers <ebiggers@kernel.org>
> > > > >> Sent: Thursday, August 8, 2019 10:31 AM
> > > > >> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > >> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.org;
> > > > >> herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-
> > devel@redhat.com;
> > > > >> gmazyland@gmail.com
> > > > >> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> > > > >>
> > > > >> On Wed, Aug 07, 2019 at 04:14:22PM +0000, Pascal Van Leeuwen wrote:
> > > > >>>>>> In your case, we are not dealing with known plaintext attacks,
> > > > >>>>>>
> > > > >>>>> Since this is XTS, which is used for disk encryption, I would argue
> > > > >>>>> we do! For the tweak encryption, the sector number is known plaintext,
> > > > >>>>> same as for EBOIV. Also, you may be able to control data being written
> > > > >>>>> to the disk encrypted, either directly or indirectly.
> > > > >>>>> OK, part of the data into the CTS encryption will be previous ciphertext,
> > > > >>>>> but that may be just 1 byte with the rest being the known plaintext.
> > > > >>>>>
> > > > >>>>
> > > > >>>> The tweak encryption uses a dedicated key, so leaking it does not have
> > > > >>>> the same impact as it does in the EBOIV case.
> > > > >>>>
> > > > >>> Well ... yes and no. The spec defines them as seperately controllable -
> > > > >>> deviating from the original XEX definition - but in most practicle use cases
> > > > >>> I've seen, the same key is used for both, as having 2 keys just increases
> > > > >>> key  storage requirements and does not actually improve effective security
> > > > >>> (of the algorithm itself, implementation peculiarities like this one aside
> > > > >>> :-), as  XEX has been proven secure using a single key. And the security
> > > > >>> proof for XTS actually builds on that while using 2 keys deviates from it.
> > > > >>>
> > > > >>
> > > > >> This is a common misconception.  Actually, XTS needs 2 distinct keys to be a
> > > > >> CCA-secure tweakable block cipher, due to another subtle difference from XEX:
> > > > >> XEX (by which I really mean "XEX[E,2]") builds the sequence of masks starting
> > > > >> with x^1, while XTS starts with x^0.  If only 1 key is used, the inclusion of
> > > > >> the 0th power in XTS allows the attack described in Section 6 of the XEX paper
> > > > >> (https://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf).
> > > > >>
> > > > > Interesting ... I'm not a cryptographer, just a humble HW engineer specialized
> > > > > in implementing crypto. I'm basing my views mostly on the Liskov/Minematsu
> > > > > "Comments on XTS", who assert that using 2 keys in XTS was misguided.
> > > > > (and I never saw any follow-on comments asserting that this view was wrong ...)
> > > > > On not avoiding j=0 in the XTS spec they actually comment:
> > > > > "This difference is significant in security, but has no impact on effectiveness
> > > > > for practical applications.", which I read as "not relevant for normal use".
> > 
> > See page 6 of "Comments on XTS":
> > 
> > 	Note that j = 0 must be excluded, as f(0, v) = v for any v, which
> > 	implies ρ = 1. Moreover, if j = 0 was allowed, a simple attack based on
> > 	this fact existed, as pointed out by [6] and [3]. Hence if XEX is used,
> > 	one must be careful to avoid j being 0.
> >
> Ok, I missed that part. Something to do with being surrounded by far too 
> much math :-P
> 
> I did figure out by myself that forcing the ciphertext to 0 for the first
> block and being able to observe the plaintext coming out would give you
> S ^ E(S) if both keys are equal due do D(0 ^ E(x)) being x.
> I guess that's the f(0,v) = v in the above.
> Which would give you E(S) as S is usually known. (But this doesn't have to
> be the case! S *can* be made a secret within the XTS specification!)
> Which in turn would give you all tweaks E(S) * alpha(j), reducing the
> encryption /for that sector only/ to just basic ECB.
> 
> Still, that does not constitute a full attack on the sector at hand (which
> is not so relevant, since it was leaking plaintext, so you can assume it 
> does not contain any sensitive data!), let alone any other sector on the 
> disk or even the key. At least, I have not seen that demonstrated yet.
> 
> So it may be bad in the general cryptographic sense, but I still doubt it 
> has very significant practicle implications if you assume the system is 
> not leaking any plaintext from any sensitive areas of the disk.
> 
> Still, FIPS seems to consider it a risk so who am I to doubt that ;-)
> 
> > The part you quoted is only talking about XTS *as specified*, i.e. with 2 keys.
> > 
> Ok, that makes sense actually. Would have been better if they mentioned
> that that statement only only holds if the keys are not equal ... (which,
> BTW, is not a requirement mentioned anywhere in the XTS specification)
> 
> > > > >
> > > > > In any case, it's frequently *used* with both keys being equal for performance
> > > > > and key storage reasons.
> > 
> > It's broken, so it's broken.  Doesn't matter who is using it.
> > 
> Well, it does kind of matter for people that still want to read their disk
> - and possibly continue to use it - encrypted with the "broken" version :-)
> 
> And "broken" is a relative term anyway. As long as you can't get to the key,
> decrypt random sectors or manipulate random bits, it may be secure enough 
> for its purpose.
> 
> > > >
> > > > There is already check in kernel for XTS "weak" keys (tweak and encryption keys must
> > not be
> > > > the same).
> > > >
> > > >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/crypto/xts
> > .h#
> > > > n27
> > > >
> > > > For now it applies only in FIPS mode... (and if I see correctly it is duplicated in
> > all
> > > > drivers).
> > > >
> > > I never had any need to look into FIPS for XTS before, but this actually appears
> > > to be accurate. FIPS indeed *requires this*. Much to my surprise, I might add.
> > > Still looking for some actual rationale that goes beyond suggestion and innuendo
> > > (and is not too heavy on the math ;-) though.
> > 
> > As I said, the attack is explained in the original XEX paper.  Basically the
> > adversary can submit a chosen ciphertext query for the first block of sector 0
> > to leak the first "mask" of that sector, then submit a chosen plaintext or
> > ciphertext query for the reminder of the sector such that they can predict the
> > output with 100% certainty.  (The standard security model for tweakable block
> > ciphers says the output must appear random.)
> > 
> Yes, but that only affects a sector that was leaking plaintext to begin 
> with. I'm not impressed until you either recover the key or can decrypt
> or manipulate *other* sectors on the disk.
> 

There's no proof that other attacks don't exist.  If you're going to advocate
for using it regardless, then you need to choose a different (weaker) attack
model, then formally prove that the construction is secure under that model.
Or show where someone else has done so.

- Eric
