Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874EFC761A9
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 04:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CEF02089E
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 04:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564460792;
	bh=1q7efFxt0n1/Q6WBtRnJVyYiA7yYxENtcYDLXaZtXeU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=A1ErLX1lldvYS70nDe77MTW75Hw/BuHqRNleW5Ws6eaS/+SCSXK1+yBCb6oT85ev4
	 a7ZidpxMH5hN6In+g8hlyAp8ncyn/6gfjY8YSR7e18RnWRZrA9QCVBq8LzEtWu45Od
	 Fd+7VRP4glWx2Q77vtFXrcOfdhs+1/Y7K6Hi+QlM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfG3E0b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 00:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfG3E0a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 00:26:30 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF2320693;
        Tue, 30 Jul 2019 04:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564460789;
        bh=1q7efFxt0n1/Q6WBtRnJVyYiA7yYxENtcYDLXaZtXeU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSqMNHFr/Rv3LAAluYhoGAvkQ9bJs7eaIwuLMHf7cp3K1AMlfy6RntV8AMk6W/N6I
         5Dwd4tNrgbN2E2laY70Svh6jww/ZvN68yq0w3Pp/iYMHnzl1MzPyklG9GlGy1pF+oK
         oTTbgLK2V4ntMhR6Gsu56N6Bpu5oM9d0IYYQqYp0=
Date:   Mon, 29 Jul 2019 21:26:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190730042627.GC1966@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729223112.GA7529@gondor.apana.org.au>
 <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729235304.GJ169027@gmail.com>
 <MN2PR20MB2973302B66749E5E6EC4F444CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190730005532.GL169027@gmail.com>
 <MN2PR20MB297328E526D41CE90707DAFACADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB297328E526D41CE90707DAFACADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 30, 2019 at 01:26:17AM +0000, Pascal Van Leeuwen wrote:
> > > > Oh, I see.  Currently the fuzz tests assume that if encryption fails with an
> > > > error (such as EINVAL), then decryption fails with that same error.
> > > >
> > > Ah ok, oops. It should really log the error that was returned by the
> > > generic decryption instead. Which should just be a matter of annotating
> > > it back to vec.crypt_error?
> > >
> > 
> > It doesn't do the generic decryption yet though, only the generic encryption.
> > 
> I didn't look at the code in enough detail to pick that up, I was expecting
> it do do generic decryption and compare that to decryption with the algorithm
> being fuzzed. So what does it do then? Compare to the original input to the
> encryption? Ok, I guess that would save a generic decryption pass but, as we
> see here, it would not be able to capture all the details of the API.

Currently to generate an AEAD test vector the code just generates a "random"
plaintext and encrypts it with the generic implementation.

My plan is to extend the tests to also sometimes generate a "random" ciphertext
and try to decrypt it; and also sometimes try to decrypt a corrupted ciphertext.

> 
> > > > Regardless of what we think the correct decryption error is, running the
> > > > decryption test at all in this case is sort of broken, since the ciphertext
> > > > buffer was never initialized.
> > > >
> > > You could consider it broken or just some convenient way of getting
> > > vectors that don't authenticate without needing to spend any effort ...
> > >
> > 
> > It's not okay for it to be potentially using uninitialized memory though, even
> > if just in the fuzz tests.
> > 
> Well, in this particular case things should fail before you even hit the
> actual processing, so memory contents should be irrelevant really.
> (by that same reasoning you would not actually hit vectors that don't
> authenticate, by the way, there was an error in my thinking there)

But the problem is that that's not what's actually happening, right?  "authenc"
actually does the authentication (of uninitialized memory, in this case) before
it gets around to failing due to the cbc length restriction.

Anyway, I suggest sending the patch I suggested as 1 of 2 to avoid this case (so
your patch does not cause test failures), then this patch as 2 of 2.

- Eric
