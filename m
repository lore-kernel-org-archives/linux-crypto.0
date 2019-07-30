Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0117BC76186
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC3CD208E3
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564445846;
	bh=uNWL3nAuQhLKy7P4HMS9rxU4DNFN9LxDKnVvSzSoYto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CeFJg+0tXrmIg3QD51lMdMRA2Ittuh8ENvgJEm7C45qeUwgaLV64dYFjqH47zoKZB
	 RmeRYTTgDy6rBUAEzfX+nYYbJ9gui1NsvKQ4d9+ZQkV02HQKRfn+QWL3bpJVNd1FqI
	 GaNgEeEV3pqvh+5f0BVli50uQQ+/cbZiH64x9yFc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfG3ARZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 20:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbfG3ARZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 20:17:25 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A3DF20679;
        Tue, 30 Jul 2019 00:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564445844;
        bh=uNWL3nAuQhLKy7P4HMS9rxU4DNFN9LxDKnVvSzSoYto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YaED0/ZtySKKxDafTCEfd/G3ixQs2UTwJLxrbreciePD0eCLbHCViaskq2OvWUa/s
         Yd22oSXpRkbe0bOd8fhpeL2KlCOicZEEqbd1Mw3/U4/6J+nCVm2Eo1GFP/NKpz4Pze
         LIkVIGKmXwxL08L8cbnwW+o7hAJLrN9T/rnOgTyY=
Date:   Mon, 29 Jul 2019 17:17:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190730001722.GK169027@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 10:16:48PM +0000, Pascal Van Leeuwen wrote:
> > > > Note that the "empty test suite" message shouldn't be printed (especially not at
> > > > KERN_ERR level!) if it's working as intended.
> > > >
> > > That's not my code, that was already there. I already got these messages before my
> > > modifications, for some ciphersuites. Of course if we don't want that, we can make
> > > it a pr_warn pr_dbg?
> > 
> > I didn't get these error messages before this patch.  They start showing up
> > because this patch changes alg_test_null to alg_test_aead for algorithms with no
> > test vectors.
> >
> Ok, I guess I caused it for some additional ciphersuites by forcing them
> to be at least fuzz tested. But there were some ciphersuites without test
> vectors already reporting this in my situation because they did not point
> to alg_test_null in the first place. 

Are you sure?  I don't see anything that had no test vectors but didn't use
alg_test_null.

> So it wasn't entirely clear what the
> whole intention was in the first place, as it wasn't consistent.
> If we all agree on the logging level we want for this message, then I can
> make that change.

I suggest at least downgrading it to KERN_INFO, since that's the level used for
logging that there wasn't any test description found at all:

	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);

> 
> > > > Why not put these new fields in the existing 'struct aead_test_suite'?
> > > >
> > > > I don't see the point of the separate 'params' struct.  It just confuses things.
> > > >
> > > Mostly because I'm not that familiar with C datastructures (I'm not a programmer
> > > and this is pretty much my first serious experience with C), so I didn't know how
> > > to do that / didn't want to break anything else :-)
> > >
> > > So if you can provide some example on how to do that ...
> > 
> > I'm simply suggesting adding the fields of 'struct aead_test_params' to
> > 'struct aead_test_suite'.
> > 
> My next mail tried to explain why that's not so simple ...

The only actual issue is that you can't reuse the __VECS() macro because it adds
an extra level of braces, right?

> Actually, the patch *should* (didn't try yet) make it work for both: if both
> alen and clen are valid (>=0) then it creates a key blob from those ranges. 
> If only clen is valid (>=0) but a alen is not (i.e., -1), then it will just
> generate a random key the "normal" way with length clen.
> So, for authenc you define both ranges, for other AEAD you define only a
> cipher key length range with the auth key range count at 0.
> 

Okay, I guess that makes sense.  It wasn't obvious to me though.

- Eric
