Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9D0C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E3CE222B6
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550133789;
	bh=OdpAKORlifIanzxmiDBGfB+ts9ZHR7O/zQmNYJmiZZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=liL7h5abJn4AzScbtz645GrPOffWrNT37v79NH2SOOXwWqa2CiCuQU68xP2UgLqBi
	 OSjy432RFu8iwJ+DIiO123W+clyN2Nk4VvvYPbUWRAjuJAcqiTwsTKLaz0oI9abAt2
	 MqQHbWpigtFx2yJ7FmhnnG4T4hjTnGxJf9VxNg2g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732491AbfBNInI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730488AbfBNInI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:43:08 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75916222A1;
        Thu, 14 Feb 2019 08:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550133787;
        bh=OdpAKORlifIanzxmiDBGfB+ts9ZHR7O/zQmNYJmiZZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uAg+LdQwSgLpYr78rIcAPWwKiu/CMGIS2ne42jXoq0TCFnjpxcweVi3C9lpBFMMAn
         3OYGuT/FsPz442GKLgHKf3VWIsqQH0ec5wxgUfHToOs4OKp98GOSVzBL6VjixmrTu9
         ENDeUIr7CYe9JqMqEyUSG1qvMSBFZ1ARzQNSwa18=
Date:   Thu, 14 Feb 2019 00:43:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/6] crypto: arm64/aes-blk - update IV after partial
 final CTR block
Message-ID: <20190214084305.GC29560@sol.localdomain>
References: <20190214080355.8112-1-ebiggers@kernel.org>
 <20190214080355.8112-6-ebiggers@kernel.org>
 <CAKv+Gu9J_PKP0MfScA+RTV3m7FPyVwD713fBeTjn9cA8sWSVAw@mail.gmail.com>
 <20190214082827.GB29560@sol.localdomain>
 <CAKv+Gu_EuPpXvt0xLrA7H1fwWifCifpgaMDiZ_jvA0VT_7H21w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_EuPpXvt0xLrA7H1fwWifCifpgaMDiZ_jvA0VT_7H21w@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 14, 2019 at 09:33:51AM +0100, Ard Biesheuvel wrote:
> On Thu, 14 Feb 2019 at 09:28, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Feb 14, 2019 at 09:14:13AM +0100, Ard Biesheuvel wrote:
> > > On Thu, 14 Feb 2019 at 09:04, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > From: Eric Biggers <ebiggers@google.com>
> > > >
> > > > Make the arm64 ctr-aes-neon and ctr-aes-ce algorithms update the IV
> > > > buffer to contain the next counter after processing a partial final
> > > > block, rather than leave it as the last counter.  This makes these
> > > > algorithms pass the updated AES-CTR tests.
> > > >
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > >
> > > I take it this means we return an output IV even if the algorithm
> > > could never proceed in a meaningful way, given that we throw away some
> > > keystream bits that would be needed in that case.
> > >
> > > That means this change is strictly there to make the test framework
> > > happy, even for cases that can never appear in reality.
> > >
> > > Wouldn't it be better not to set out_iv for input buffers whose size
> > > is not a multiple of the block size?
> > >
> >
> > See the explanation in patch 4 for why the tests test for this.  It's not a
> > super strong argument but this seems like the best thing to do.
> >
> 
> Fair enough.
> 
> Do you have a branch with this stuff that I can drop into kernelci
> again? Preferably one that already has the tests enabled by default,
> and panics on failure.

I pushed it out to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
branch "iv-out-testing", and added a hack to enable self-tests by default and
panic on test failure.

- Eric
