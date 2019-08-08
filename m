Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C711C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 17:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C2D21880
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565284514;
	bh=kyGM/qQKhDJIBrPc+j1pg6hHWKXYr9tMgkcFnysFN74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QAB8i1Vt7myhOuOn8XU+6pP0ymq93CeWSgrX1vS4LciaJjNjVhivU7b0fHOI0NIG3
	 YiKSGHif3LwSb4yK4j95MgeieJWwRwG8qXfJe1Rt42VuuMPw1QqBq4rWLgInk4QVVP
	 dDAhlmNE5LrHC8fwp87IUc+QDiWIezNEGWvhjA+o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404079AbfHHRPN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 13:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbfHHRPN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 13:15:13 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021E92184E;
        Thu,  8 Aug 2019 17:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565284512;
        bh=kyGM/qQKhDJIBrPc+j1pg6hHWKXYr9tMgkcFnysFN74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L/AUcgekcAa7FaOUC3I52nk2J7FozQrmXzSY5K0YJO02HLbXWWmF4MAj/sQpNLcDt
         j85pchv/GzqFwmQkofIYd3qj7AyxPhWGJxFUIhySd28nPKcgI9q1wa4W0KmBOk+W7z
         Y0qUS3HM+qIqVbRigJO68to35ZCul45HwEZvLLy4=
Date:   Thu, 8 Aug 2019 10:15:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Message-ID: <20190808171508.GA201004@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
 <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808083059.GB5319@sol.localdomain>
 <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
 <MN2PR20MB29739B9D16130F5C06831C92CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB29739B9D16130F5C06831C92CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 08, 2019 at 01:23:10PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: Milan Broz <gmazyland@gmail.com>
> > Sent: Thursday, August 8, 2019 2:53 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Eric Biggers <ebiggers@kernel.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.org;
> > herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com
> > Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> > 
> > On 08/08/2019 11:31, Pascal Van Leeuwen wrote:
> > >> -----Original Message-----
> > >> From: Eric Biggers <ebiggers@kernel.org>
> > >> Sent: Thursday, August 8, 2019 10:31 AM
> > >> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > >> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; linux-crypto@vger.kernel.org;
> > >> herbert@gondor.apana.org.au; agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com;
> > >> gmazyland@gmail.com
> > >> Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> > >>
> > >> On Wed, Aug 07, 2019 at 04:14:22PM +0000, Pascal Van Leeuwen wrote:
> > >>>>>> In your case, we are not dealing with known plaintext attacks,
> > >>>>>>
> > >>>>> Since this is XTS, which is used for disk encryption, I would argue
> > >>>>> we do! For the tweak encryption, the sector number is known plaintext,
> > >>>>> same as for EBOIV. Also, you may be able to control data being written
> > >>>>> to the disk encrypted, either directly or indirectly.
> > >>>>> OK, part of the data into the CTS encryption will be previous ciphertext,
> > >>>>> but that may be just 1 byte with the rest being the known plaintext.
> > >>>>>
> > >>>>
> > >>>> The tweak encryption uses a dedicated key, so leaking it does not have
> > >>>> the same impact as it does in the EBOIV case.
> > >>>>
> > >>> Well ... yes and no. The spec defines them as seperately controllable -
> > >>> deviating from the original XEX definition - but in most practicle use cases
> > >>> I've seen, the same key is used for both, as having 2 keys just increases
> > >>> key  storage requirements and does not actually improve effective security
> > >>> (of the algorithm itself, implementation peculiarities like this one aside
> > >>> :-), as  XEX has been proven secure using a single key. And the security
> > >>> proof for XTS actually builds on that while using 2 keys deviates from it.
> > >>>
> > >>
> > >> This is a common misconception.  Actually, XTS needs 2 distinct keys to be a
> > >> CCA-secure tweakable block cipher, due to another subtle difference from XEX:
> > >> XEX (by which I really mean "XEX[E,2]") builds the sequence of masks starting
> > >> with x^1, while XTS starts with x^0.  If only 1 key is used, the inclusion of
> > >> the 0th power in XTS allows the attack described in Section 6 of the XEX paper
> > >> (https://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf).
> > >>
> > > Interesting ... I'm not a cryptographer, just a humble HW engineer specialized
> > > in implementing crypto. I'm basing my views mostly on the Liskov/Minematsu
> > > "Comments on XTS", who assert that using 2 keys in XTS was misguided.
> > > (and I never saw any follow-on comments asserting that this view was wrong ...)
> > > On not avoiding j=0 in the XTS spec they actually comment:
> > > "This difference is significant in security, but has no impact on effectiveness
> > > for practical applications.", which I read as "not relevant for normal use".

See page 6 of "Comments on XTS":

	Note that j = 0 must be excluded, as f(0, v) = v for any v, which
	implies ρ = 1. Moreover, if j = 0 was allowed, a simple attack based on
	this fact existed, as pointed out by [6] and [3]. Hence if XEX is used,
	one must be careful to avoid j being 0.

The part you quoted is only talking about XTS *as specified*, i.e. with 2 keys.

> > >
> > > In any case, it's frequently *used* with both keys being equal for performance
> > > and key storage reasons.

It's broken, so it's broken.  Doesn't matter who is using it.

> > 
> > There is already check in kernel for XTS "weak" keys (tweak and encryption keys must not be
> > the same).
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/crypto/xts.h#
> > n27
> > 
> > For now it applies only in FIPS mode... (and if I see correctly it is duplicated in all
> > drivers).
> > 
> I never had any need to look into FIPS for XTS before, but this actually appears
> to be accurate. FIPS indeed *requires this*. Much to my surprise, I might add.
> Still looking for some actual rationale that goes beyond suggestion and innuendo 
> (and is not too heavy on the math ;-) though.

As I said, the attack is explained in the original XEX paper.  Basically the
adversary can submit a chosen ciphertext query for the first block of sector 0
to leak the first "mask" of that sector, then submit a chosen plaintext or
ciphertext query for the reminder of the sector such that they can predict the
output with 100% certainty.  (The standard security model for tweakable block
ciphers says the output must appear random.)

- Eric
