Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D504C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 20:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A0421873
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563566835;
	bh=80Hivj/nEVTRYUrxp0HNd0We587GJGRh9x+v/QGu+Xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qmH11TkJUawGsJkSAKRwl/8aV5egFij7HGIFSAUkWPwOAcsIMF8u+8oEaUz4mqcRf
	 0G3s6+kpCJcPIbj1KNB9JeS4RtNJG89oDTgE2Vi2KuLSEqHDSa3h3gMEyA7Ufo6wwV
	 zKxcljv42qP3DKjy5EF6+wQeJiQ/w0tDYYFRcYC0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbfGSUHO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 16:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfGSUHO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 16:07:14 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF10B2186A;
        Fri, 19 Jul 2019 20:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563566834;
        bh=80Hivj/nEVTRYUrxp0HNd0We587GJGRh9x+v/QGu+Xg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PqyOHBUntjLeZ/GftUerdJ2Baqq2iqDMqCWASXFeBFAYc8kdtS2PM+6hqaPK9eSBE
         TmC8rtN0elqyOodP5nGclq9DxLbbRi4aVCYoqbcve+MaaQKxrx3dLLp6W+95xUx8k6
         mlMn7LYdCOZU18q7VhKewSK8x2lZVlR3xTppiljE=
Date:   Fri, 19 Jul 2019 13:07:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: generic ahash question
Message-ID: <20190719200711.GD1422@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <MN2PR20MB297347B80C7E3DCD19127B05CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719162303.GB1422@gmail.com>
 <MN2PR20MB2973067B1373891A5899ECBBCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973067B1373891A5899ECBBCACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 19, 2019 at 07:33:30PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Eric Biggers
> > Sent: Friday, July 19, 2019 6:23 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>
> > Subject: Re: generic ahash question
> > 
> > On Fri, Jul 19, 2019 at 02:41:03PM +0000, Pascal Van Leeuwen wrote:
> > > Hi,
> > >
> > > I recall reading somewhere in the Linux Crypto documentation that support for finup() and digest()
> > > calls were explicitly added to support hardware that couldn't handle seperate init/update/final
> > > calls so they could at least be used with e.g. the IPsec stack.  I also noticed that testmgr *does*
> > >  attempt to verify these seperate calls ...
> > >
> > > So I'm guessing there must be some flags that I can set to indicate I'm not supporting seperate
> > > init/update/final calls so that testmgr skips those specific tests? Which flag(s) do I need to set?
> > >
> > 
> > Where does the documentation say that?
> 
> For finup:
> "As some hardware cannot do update and final separately, this callback was added to allow such 
> hardware to be used at least by IPsec"
> 
> For digest:
> "Just like finup, this was added for hardware which cannot do even the finup, but can only do the 
> whole transformation in one run."
> 
> Those statement sort of imply (to me) that it's OK to only support digest or only finup and digest.
> 

Can you send a patch to fix this documentation?

- Eric
