Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AC8C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F108216C8
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564448137;
	bh=Bw/aDhn9XEJ4q0v3fT16iBxP1DOC5+3aDdlb813K5UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1AEU7qDdUE2oqfHeW29pEh17BGV5wQoEIUxy71uwA4H95nVpq6ffuf/jjjUiSEWtl
	 5BJPoJ5Zlx97W4CzS2PTo7AnfYZAh94g+rFGj2G4AsoeykqoAWXWGi/dlWJle7YhRq
	 haVQh4P17oDly459WVW7EYy/+CSRz0oZjn0R8VVs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfG3Azg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 20:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbfG3Azg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 20:55:36 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A113206DD;
        Tue, 30 Jul 2019 00:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564448134;
        bh=Bw/aDhn9XEJ4q0v3fT16iBxP1DOC5+3aDdlb813K5UY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vlOlj8MVC2P04UW6kVpeeOEORFQ4DxYgsiD2+MY/H9Bbst95TuRNzD6/g80MCiMuI
         IRbicYXEWU4MJl4FMWd1jnzcKiYGkhDhcRbOwn0o7lxGNdl6FN09VqzZN9ZUC7Fwgm
         rxizgXgdN8D0wcHcD1y6KtZGWMjK5uW6qAfEV/SQ=
Date:   Mon, 29 Jul 2019 17:55:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190730005532.GL169027@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729223112.GA7529@gondor.apana.org.au>
 <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729235304.GJ169027@gmail.com>
 <MN2PR20MB2973302B66749E5E6EC4F444CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973302B66749E5E6EC4F444CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 30, 2019 at 12:37:06AM +0000, Pascal Van Leeuwen wrote:
> > > You're the expert, but shouldn't there be some priority to the checks
> > > being performed? To me, it seems reasonable to do things like length
> > > checks prior to even *starting* decryption and authentication.
> > > Therefore, it makes more sense to get -EINVAL than -EBADMSG in this
> > > case. IMHO you should only get -EBADMSG if the message was properly
> > > formatted, but the tags eventually mismatched. From a security point
> > > of view it can be very important to have a very clear distinction
> > > between those 2 cases.
> > >
> > 
> > Oh, I see.  Currently the fuzz tests assume that if encryption fails with an
> > error (such as EINVAL), then decryption fails with that same error.
> > 
> Ah ok, oops. It should really log the error that was returned by the
> generic decryption instead. Which should just be a matter of annotating
> it back to vec.crypt_error?
> 

It doesn't do the generic decryption yet though, only the generic encryption.

> > Regardless of what we think the correct decryption error is, running the
> > decryption test at all in this case is sort of broken, since the ciphertext
> > buffer was never initialized.
> >
> You could consider it broken or just some convenient way of getting
> vectors that don't authenticate without needing to spend any effort ...
> 

It's not okay for it to be potentially using uninitialized memory though, even
if just in the fuzz tests.

> > So for now we probably should just sidestep this
> > issue by skipping the decryption test if encryption failed, like this:
> > 
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 96e5923889b9c1..0413bdad9f6974 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -2330,10 +2330,12 @@ static int test_aead_vs_generic_impl(const char *driver,
> >  					req, tsgls);
> >  		if (err)
> >  			goto out;
> > -		err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, cfg,
> > -					req, tsgls);
> > -		if (err)
> > -			goto out;
> > +		if (vec.crypt_error != 0) {
> > +			err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name,
> > +						cfg, req, tsgls);
> > +			if (err)
> > +				goto out;
> > +		}
> >  		cond_resched();
> >  	}
> >  	err = 0;
> > 
> > I'm planning to (at some point) update the AEAD tests to intentionally generate
> > some inauthentic inputs, but that will take some more work.
> > 
> > - Eric
> >
> I believe that's a rather essential part of verifying AEAD decryption(!)
> 

Agreed, which is why I am planning to work on it :-).  Actually a while ago I
started a patch for it, but there are some issues I haven't had time to address
quite yet:
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/commit/?h=wip-crypto&id=687f4198ba09032c60143e0477b48f94c5714263

- Eric
