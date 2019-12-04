Return-Path: <SRS0=RobT=Z2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5665C43603
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 17:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84656205ED
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Dec 2019 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575479029;
	bh=Rg7nyzvwfwIYzVjnkUXf8QOE5Y4wtZstmcvLNSdA/hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mhkNx7BILYMypA+6F84HKcz+jomJYPfayqGyixYrYpe4/LEjEDjXjWxqcx1T2DObb
	 GffVslaoL+By1xZpNQOB5oZC6t4JURhw+MpUnUtdJHPC59Nw9jx01EQWuif7tAbRf4
	 8zRWW/ReeSgGIyL6QfQAn/8wSryChsD/mL0kQCNE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfLDRDt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbfLDRDs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 12:03:48 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0180D205ED;
        Wed,  4 Dec 2019 17:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575479028;
        bh=Rg7nyzvwfwIYzVjnkUXf8QOE5Y4wtZstmcvLNSdA/hU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hJzz11e7SLuj5ugZk/7BaJJP3ctrZ1/Gh6QBCB+GQsYKzxnRkQ8AAMq3Fy2sqzEni
         j0wV8crvttS4mnTJ9zIob1To01kIVRII99vjDuCAtzVWVmeGFiWugvqkqSKAWIr3xn
         ZzfmwlnLqA7nYpW8pYANjYPyvx1yZEw2hQIpP4RM=
Date:   Wed, 4 Dec 2019 09:03:46 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/7] crypto: more self-test improvements
Message-ID: <20191204170346.GA1023@sol.localdomain>
References: <20191201215330.171990-1-ebiggers@kernel.org>
 <CAKv+Gu_5pcDeXxLnG_5_jMPc0VDBT3CFr5Hnpb-e4irPLu8JDg@mail.gmail.com>
 <CAKv+Gu9fQV4-KFz=wnBkNEHa3F8cWMuX9CG=a67qhVgFkZ=cPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9fQV4-KFz=wnBkNEHa3F8cWMuX9CG=a67qhVgFkZ=cPw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 04, 2019 at 02:42:58PM +0000, Ard Biesheuvel wrote:
> On Tue, 3 Dec 2019 at 12:39, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Sun, 1 Dec 2019 at 21:54, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > This series makes some more improvements to the crypto self-tests, the
> > > largest of which is making the AEAD fuzz tests test inauthentic inputs,
> > > i.e. cases where decryption is expected to fail due to the (ciphertext,
> > > AAD) pair not being the correct result of an encryption with the key.
> > >
> > > It also updates the self-tests to test passing misaligned buffers to the
> > > various setkey() functions, and to check that skciphers have the same
> > > min_keysize as the corresponding generic implementation.
> > >
> > > I haven't seen any test failures from this on x86_64, arm64, or arm32.
> > > But as usual I haven't tested drivers for crypto accelerators.
> > >
> > > For this series to apply this cleanly, my other series
> > > "crypto: skcipher - simplifications due to {,a}blkcipher removal"
> > > needs to be applied first, due to a conflict in skcipher.h.
> > >
> > > This can also be retrieved from git at
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> > > tag "crypto-self-tests_2019-12-01".
> > >
> > > Eric Biggers (7):
> > >   crypto: aead - move crypto_aead_maxauthsize() to <crypto/aead.h>
> > >   crypto: skcipher - add crypto_skcipher_min_keysize()
> > >   crypto: testmgr - don't try to decrypt uninitialized buffers
> > >   crypto: testmgr - check skcipher min_keysize
> > >   crypto: testmgr - test setting misaligned keys
> > >   crypto: testmgr - create struct aead_extra_tests_ctx
> > >   crypto: testmgr - generate inauthentic AEAD test vectors
> > >
> >
> > I've dropped this into kernelci again, let's see if anything turns out
> > to be broken.
> >
> > For this series,
> >
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> >
> 
> Results here:
> https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.4-9340-g16839329da69/
> 
> Only the usual suspects failed (rk3288)
> 

Great, thanks.  I wouldn't be surprised if all AEAD implementations are
correctly rejecting inauthentic inputs at the moment, but we should still have
the test just in case.

- Eric
