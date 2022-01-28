Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C077EC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 18:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350652AbiA1SvD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 13:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiA1SvD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 13:51:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355A4C061714
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jan 2022 10:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C983F61D27
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jan 2022 18:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8CAC36AE5;
        Fri, 28 Jan 2022 18:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643395862;
        bh=X6TkSrh9zEQcBfvshKL78wGojaGYRDYazpy2mCqa8a8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jtHLZuyKZ2fPs69Bv6pq02Eg9UctQ5c6Bh+01hwTFgO3OMOWJnkzUz2iH1g/Hqnah
         t5bYTtX/y/zVQeLFIEGV+WkXGDOYxS+oSw+oy2aFGzX7/EOavADBfTqdXSsn/Q4zp2
         +DctMQCpjQdW+nU4QYj/Sn3T6dEFbLl6G/GiS4+9eNZ2CYaSMaoo1tkjbKgyIy3FF7
         Z4wFa/6SBdGBfKGQiJYf/BpAYZKyyoQmQ2UPi9l4kLFtGbLJ01no8fKaeAPmT4Uq4t
         kc2gcei8FjLFsIJk281bBDB/D/D6WGT4OkFqFlxYrVYl2kjl4aLVBA5GWzhC//1/Wo
         AG7EXZRLqdBVA==
Date:   Fri, 28 Jan 2022 10:51:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        simo@redhat.com, Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 0/7] Common entropy source and DRNG management
Message-ID: <YfQ7FDJqb2zhVcfp@sol.localdomain>
References: <2486550.t9SDvczpPo@positron.chronox.de>
 <YfHP3xs6f68wR/Z/@sol.localdomain>
 <9785493.cvP5XnM2Xn@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9785493.cvP5XnM2Xn@tauon.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 28, 2022 at 04:37:26PM +0100, Stephan Mueller wrote:
> Am Mittwoch, 26. Januar 2022, 23:49:03 CET schrieb Eric Biggers:
> 
> Hi Eric,
> 
> > On Wed, Jan 26, 2022 at 08:02:54AM +0100, Stephan Müller wrote:
> > > The current code base of the kernel crypto API random number support
> > > leaves the task to seed and reseed the DRNG to either the caller or
> > > the DRNG implementation. The code in crypto/drbg.c implements its own
> > > seeding strategy. crypto/ansi_cprng.c does not contain any seeding
> > > operation. The implementation in arch/s390/crypto/prng.c has yet
> > > another approach for seeding. Albeit the crypto_rng_reset() contains
> > > a seeding logic from get_random_bytes, there is no management of
> > > the DRNG to ensure proper reseeding or control which entropy sources
> > > are used for pulling data from.
> > 
> > ansi_cprng looks like unused code that should be removed, as does the s390
> > prng.
> > 
> > With that being the case, what is the purpose of this patchset?
> 
> I would agree that ansi_csprng could be eliminated at this stage. However, the 
> S390 DRBG code base provides access to the CPACF DRBG implemented in the IBM Z 
> processors. That implementation must be seeded from software. See the function 
> invocation of cpacf_klmd or cpacf_kmc in the prng.c file.

We should still just get rid of that, since equivalent functionality is
available in software, is better tested, and isn't performance-critical.

> The extraction of the entropy source and DRNG management into its own 
> component separates out the security sensitive implementation currently found 
> in multiple locations following the strategy found in the crypto API where 
> each moving part is separated and encapsulated.
> 
> The current implementation of the ESDM allows an easy addition of new entropy 
> sources which are properly encapsulated in self-contained code allowing self-
> contained entropy analyses to be performed for each. These entropy sources 
> would provide their seed data completely separate from other entropy sources 
> to the DRNG preventing any mutual entanglement and thus challenges in the 
> entropy assessment. I have additional entropy sources already available that I 
> would like to contribute at a later stage. These entropy sources can be 
> enabled, disabled or its entropy rate set as needed by vendors depending on 
> their entropy source analysis. Proper default values would be used for the 
> common case where a vendor does not want to perform its own analysis or a 
> distro which want to provide a common kernel binary for many users.

What is the actual point of this?  The NIST DRBGs are already seeded from
random.c, which is sufficient by itself but doesn't play well with
certifications, and from Jitterentropy which the certification side is happy
with.  And the NIST DRBGs are only present for certification purposes anyway;
all real users use random.c instead.  So what problem still needs to be solved?

> 
> The conditioning hash that is available to the entropy sources is currently 
> fixed to a SHA-256 software implementation. To support conveying more entropy 
> through the conditioning hash, I would like to contribute an extension that 
> allows the use of the kernel crypto API's set of message digest 
> implementations to be used. This would not only allow using larger message 
> digests, but also hashes other than SHA.

This doesn't need to be configurable, and shouldn't be; just choose an
appropriate hash.

> Depending on use cases, it is possible that different initial seeding 
> strategies are required to be considered for the DRNG. The initial patch set 
> provides the oversampling of entropy sources and of the initial seed string in 
> addition to the conventional approach of providing at least as much entropy as 
> the security strength of the DRNG. There is a different seeding strategy in 
> the pipeline that is considered by other cryptographers for which I would like 
> to contribute the respective patch.

It would be better to standardize on one way of doing it so that people can't
choose the wrong way.

> NUMA-awareness is another aspect that should be considered. The DRNG manager 
> is prepared to instantiate one DRNG per node. The respective handler code, 
> however, is not part of the initial code drop.

random.c is already NUMA-optimized.

> In addition to the different DRNG implementations discussed before, there is 
> the possibility to add an implementation to support atomic operations. The 
> current DRBG does not guarantee to be suitable for such use cases.

random.c already supports atomic operations.

- Eric
