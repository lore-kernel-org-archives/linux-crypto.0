Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DCCC388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 21:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4230208E4
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603490014;
	bh=Ij37+nLWdhORElfqYs8jtc6OQd/BGn0J09kWaWaub44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rBcTP8qPXy+Dlryn3E2D246fNfNGPsKLoQlqFZ1+Hwl0vOBg8LJJifCZ6cFmA3MdR
	 EOIWDwznncPvUMcnygXYH8uxG29XORBrHhq4ugluWn50EYU28Lkh8cHXm7igZJa213
	 qxYm94lW89Z4fZLjFqLVxG0ZT9vurPEbmskUWKxY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756966AbgJWVxd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 17:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756964AbgJWVxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 17:53:32 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE4720857;
        Fri, 23 Oct 2020 21:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603490012;
        bh=Ij37+nLWdhORElfqYs8jtc6OQd/BGn0J09kWaWaub44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nugwVx/zVZIlwfzOET6+GuwwgnQJjNPwjBmYCB7gf+774kJ69BUcUP+RTBwca/lsB
         qRxXBt0K8ECFwoDH04ZlccuEerj8ssPgYIUvGXt4T2CzH1oeS3WeRcFofla8b2y37r
         qwaDS8+OekhJASNfUtZR9bhduF5kZ7eg7ifGd4Vw=
Date:   Fri, 23 Oct 2020 14:53:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2 1/6] crypto: Use memzero_explicit() for clearing state
Message-ID: <20201023215329.GA180517@gmail.com>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-2-nivedita@alum.mit.edu>
 <20201022043633.GD857@sol.localdomain>
 <20201023153927.GA217686@rani.riverdale.lan>
 <20201023155604.GA3908702@gmail.com>
 <20201023204536.GB27708@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023204536.GB27708@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 24, 2020 at 07:45:36AM +1100, Herbert Xu wrote:
> On Fri, Oct 23, 2020 at 08:56:04AM -0700, Eric Biggers wrote:
> >
> > When clearing memory because "it may be sensitive" rather than "it's needed for
> > the code to behave correctly", I think it's best to use memzero_explicit() to
> > make the intent clear, even if it seems that memset() is sufficient.  Also keep
> > in mind that support for compiling the kernel with LTO (link-time optimization)
> > is being worked on (and some people already do it), which results in more code
> > being optimized out.
> 
> The rule up until now has been that we only use memzero_explicit for
> stack variables.  At this point please don't convert anything else
> as it will cause too much churn.
> 
> If LTO did arrive we should do a global conversion.
> 

LTO is actively being worked on, now up to v6:
https://lkml.kernel.org/lkml/20201013003203.4168817-1-samitolvanen@google.com/
And in the real world it's already being used; the Android Compatibility
Definition Document strongly recommends enabling CFI, which depends on LTO.

It's doubtful that anyone will do a global conversion from memset() to
memzero_explicit(), as it's too hard to find all the places that should be
converted.  They are in lots of different subsystems; the crypto subsystem will
have the most, but not all.  We just need to fix as many as we can.  If you'd
like to do something more comprehensive than this patch, that would be great,
but I hope we don't wait forever for a global conversion that never happens.

FWIW, kfree_sensitive() (formerly kzfree) already got converted by
https://git.kernel.org/linus/8982ae527fbef170, and it wasn't really
controversial.  Some people even wanted Cc stable (which I disagreed with, but
it apparently made the final version).

- Eric
