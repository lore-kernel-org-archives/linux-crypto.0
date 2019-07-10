Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC297C73C63
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 01:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B3E2073D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 01:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562723250;
	bh=Tsxx7CaSMOqfOopAnK5QN0Wr6X2fs3hEmJ+QnjoILec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=k9eJrUdulFYIMiVcmSQg78eaonoDetiwUKH38SoTvx+bGtvsTqz2HbubQX/yjRzVD
	 s4/SuCJEiqICKnxVP+2vM0+1yeQRkJaTuHKcDJ5YphkSiYZNx3Uphjq9MgNQW10Kas
	 NYCyrTqjHoX9DEoPasKtbtjlWwiZ8W7qbLR2eijQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfGJBr3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Jul 2019 21:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfGJBr2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jul 2019 21:47:28 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F5020651;
        Wed, 10 Jul 2019 01:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562723248;
        bh=Tsxx7CaSMOqfOopAnK5QN0Wr6X2fs3hEmJ+QnjoILec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAPITBIuo7LQGOSiRMkxU50wQdz9eP1kvXDFoPG9hzGK945L43N7jWbCme0PUGsqo
         /m4P3QOrSvvw+sFEIbV8Vx/ge4M3I5Yp7dEenjvs4ebCsewoUxywEQOI7Dfzmg00aC
         qzrSpaadubVbABqHYmShXAUlUt6f82m4555FZGnI=
Date:   Tue, 9 Jul 2019 18:47:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gary R Hook <ghook@amd.com>
Cc:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - memset structure fields to zero before
 reuse
Message-ID: <20190710014726.GA10582@sol.localdomain>
Mail-Followup-To: Gary R Hook <ghook@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <156218168473.3184.15319927087462863547.stgit@sosrh3.amd.com>
 <20190705194028.GB4022@sol.localdomain>
 <2cc5e065-0fce-5278-9c38-3bdd4755f21f@amd.com>
 <20190709201014.GH641@sol.localdomain>
 <c770ea90-fad8-8379-76ad-889e410b6d74@amd.com>
 <20190709225622.GN641@sol.localdomain>
 <6cd19eb1-0322-95d1-8a2b-b0078ae40cca@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cd19eb1-0322-95d1-8a2b-b0078ae40cca@amd.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 09, 2019 at 11:34:08PM +0000, Gary R Hook wrote:
> On 7/9/19 5:56 PM, Eric Biggers wrote:
> > On Tue, Jul 09, 2019 at 10:09:16PM +0000, Gary R Hook wrote:
> >> On 7/9/19 3:10 PM, Eric Biggers wrote:
> >>> On Mon, Jul 08, 2019 at 05:08:09PM +0000, Gary R Hook wrote:
> >>>> On 7/5/19 2:40 PM, Eric Biggers wrote:
> >>>>> Hi Gary,
> >>>>>
> >>>>> On Wed, Jul 03, 2019 at 07:21:26PM +0000, Hook, Gary wrote:
> >>>>>> The AES GCM function reuses an 'op' data structure, which members
> >>>>>> contain values that must be cleared for each (re)use.
> >>>>>>
> >>>>>> Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> >>>>>>
> >>>>>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> >>>>>> ---
> >>>>>>     drivers/crypto/ccp/ccp-ops.c |   12 +++++++++++-
> >>>>>>     1 file changed, 11 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> Is this patch meant to fix the gcm-aes-ccp self-tests failure?
> >>>>
> >>>> Yessir, that is the intention. Apologies for not clarifying that point.
> >>>>
> >>>> grh
> >>>
> >>> Okay, it would be helpful if you'd explain that in the commit message.
> >>
> >> Gah. Of course. I'll repost.
> >>
> >>> Also, what branch does this patch apply to?  It doesn't apply to cryptodev.
> >>
> >> I have endeavored to make a "git pull" and a full build a required,
> >> regular part of my submission process, having made (plenty of) mistakes
> >> in the past. I did so last week before posting this, and the patch
> >> applied then, and applies now in my local copy, before and after a git
> >> pull today.
> >>
> >> We've been having trouble with our SMTP mail server, and patches have
> >> been going out base64 encoded. I'm willing to bet that's what you're
> >> wrestling with.
> >>
> >> The last patch of mine that Herbert applied appeared to be encoded
> >> thusly, but he was able to successfully apply it.
> >>
> >> I've been experimenting with changing the transfer encoding value
> >> (charset=) to iso-8859-1 and us-ascii, but the best I can do is an
> >> encoding that contains a lot of "=##" stuff. I'm not sure that's any
> >> better, but my recent documentation patches contained those, and Herbert
> >> was also able to apply them.
> >>
> >> We'd really like to know what Herbert does to accommodate these
> >> non-textual emails? And is that something that others could do?
> >>
> > 
> > What I did was simply save your email and use 'git am -3' to try to apply it.
> > It didn't work.
> > 
> > Yes, your email is base64 encoded, which apparently 'git am' handles.  But even
> > after base64 decoding your patch has an extra blank line at the end, which
> > corrupts it since it's part of the diff context.
> 
> I was unaware of this behavior. Thanks for letting me know.
> 
> > Can't you just use git send-email like everyone else?
> 
> Sure, until I find the time to fix stgit's email function.
> 
> It's still going to be quoted-printable text; I can't fix that problem 
> without the mail gateway cooperating. But I presume it will be in the 
> proper format. Look for a v2 and let me know how it comes out.
> 
> grh

Yes the v2 patch applies.

- Eric
