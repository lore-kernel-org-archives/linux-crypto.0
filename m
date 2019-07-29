Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9443C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 18:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEAD220C01
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564424597;
	bh=DTH50qU1QwFxt8MwI2Nh+/cqhkr4KUVzzivDSY6XImQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FcY821GcwZ14XfNMMhE231Wc548zt/2h+/+TaejBuUGVui3E92yh2gSR/RQirIpOv
	 fViOLb/dXk8KZZmvBoWB0/qXjU5U2UD1BTDGo9xfqpzwn9MH7cXazYB1O+Oa5s3Z+h
	 +TYCxpl35waLzA5YIhtr9rGdzZ3WAzRf7ZD1entc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbfG2SXR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 14:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387675AbfG2SXR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 14:23:17 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B585F2073F;
        Mon, 29 Jul 2019 18:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564424595;
        bh=DTH50qU1QwFxt8MwI2Nh+/cqhkr4KUVzzivDSY6XImQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bnoo1PCKlJcr1Y53YHYsqXrybksHH7C5QgbUReLoK9QVPacD9jh1AlWSQbQDMzXGF
         +qsPIzX4ayQN/Vqj7YWmMAyRfeJAcujYPrFqem3QQqTlvUciMWFb9laEXCGyclfcSU
         gnUeIQrKpTV07+olZ1AOJaqCJdD5ptAHTHcJP9Gg=
Date:   Mon, 29 Jul 2019 11:23:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190729182313.GC169027@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973D5FCC4F9724833FB8DADCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973D5FCC4F9724833FB8DADCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 04:10:06PM +0000, Pascal Van Leeuwen wrote:
> Hi Eric,
> 
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Pascal Van Leeuwen
> > Sent: Monday, July 29, 2019 11:11 AM
> > To: Eric Biggers <ebiggers@kernel.org>; Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@davemloft.net
> > Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for AEAD fuzz
> > testing
> > 
> > Hi Eric,
> > 
> > Thanks for your feedback!
> > 
> > > -----Original Message-----
> > > From: Eric Biggers <ebiggers@kernel.org>
> > > Sent: Sunday, July 28, 2019 7:31 PM
> > > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@davemloft.net;
> > Pascal Van Leeuwen
> > > <pvanleeuwen@verimatrix.com>
> > > Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for AEAD fuzz
> > testing
> > > >
> > > > +struct len_range_set {
> > > > +	const struct len_range_sel *lensel;
> > > > +	unsigned int count;
> > > > +};
> > > > +
> > > >  struct aead_test_suite {
> > > >  	const struct aead_testvec *vecs;
> > > >  	unsigned int count;
> > > >  };
> > > >
> > > > +struct aead_test_params {
> > > > +	struct len_range_set ckeylensel;
> > > > +	struct len_range_set akeylensel;
> > > > +	struct len_range_set authsizesel;
> > > > +	struct len_range_set aadlensel;
> > > > +	struct len_range_set ptxtlensel;
> > > > +};
> > > > +
> > > >  struct cipher_test_suite {
> > > >  	const struct cipher_testvec *vecs;
> > > >  	unsigned int count;
> > > > @@ -143,6 +156,10 @@ struct alg_test_desc {
> > > >  		struct akcipher_test_suite akcipher;
> > > >  		struct kpp_test_suite kpp;
> > > >  	} suite;
> > > > +
> > > > +	union {
> > > > +		struct aead_test_params aead;
> > > > +	} params;
> > > >  };
> > >
> > > Why not put these new fields in the existing 'struct aead_test_suite'?
> > >
> > > I don't see the point of the separate 'params' struct.  It just confuses things.
> > >
> > Mostly because I'm not that familiar with C datastructures (I'm not a programmer
> > and this is pretty much my first serious experience with C), so I didn't know how
> > to do that / didn't want to break anything else :-)
> > 
> > So if you can provide some example on how to do that ...
> > 
> Actually, while looking into some way to combine these fields into 
> 'struct aead_test_suite':  I really can't think of a way to do that that
> would be as convenient as the current approach which allows me to:
> 
> - NOT have these params for the other types (cipher, comp, hash etc.), at
>   least for now

> - NOT have to touch any declarations in the alg_test_desc assignment that
>   do not need this
> - conveniently use a macro line __LENS (idea shamelessly borrowed from
>   __VECS) to assign the struct ptr / list length fields pairs
> 
> If you know of a better way to achieve all that, then feel free to teach
> me. But, frankly I do not see why having 1 entry defining the testsuite 
> and  a seperate entry defining the fuzz test parameters would necessarily
> be confusing? Apart from 'params' perhaps not being a really good name, 
> being too generic and all, 'fuzz_params' would probably be better?
> 

Doesn't simply putting the fields in 'struct aead_test_suite' work?

The reason the current approach confuses me is that it's unclear what should go
in the aead_test_suite and what should go in the aead_test_params, both now and
in the future as people add new stuff.  They seem like the same thing to me.

- Eric
