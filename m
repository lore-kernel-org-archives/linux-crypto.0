Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFDDC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 20:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED2420B7C
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 20:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565384178;
	bh=9YD79O77gYo18NL4hO/76PzgKBkUFUlGBSyw9gvR5dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PkO/7zl1a0k5XUiGzRaakwdvsnATs3u1k3KLBoZ7lQCF2uH+LbAbKZ9b7h11LAllo
	 MBUg8uYFdgVKcRwPS/PXPfu9aNeIuREPmJYmqyLKb8hTjEs1xZ+MgSz05ckJPbFd06
	 xnkKrCInvq53S5EbswcPVlAJPJ2MChEjqVlr2WAc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfHIU4R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 16:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfHIU4R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 16:56:17 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFEE52086D;
        Fri,  9 Aug 2019 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565384176;
        bh=9YD79O77gYo18NL4hO/76PzgKBkUFUlGBSyw9gvR5dc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ODBhUdcLjWmDSoBmZyWYE1tniWyOzL+Nh9qMK40a7zob7mhKOi10DKbvINdSOHVrS
         4cDWRBqQW1F+HPctdnkJnFkbTqbsChWxmLYbNb3MzUnDCNJAU+lNygzkweAGSVSJS0
         6NPly6n0dW9PNYxbHbVaBGT4Ar6vO45coMuv5xhM=
Date:   Fri, 9 Aug 2019 13:56:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Message-ID: <20190809205614.GB100971@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808083059.GB5319@sol.localdomain>
 <MN2PR20MB297328E243D74E03C1EF54ACCAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <67b4f0ee-b169-8af4-d7af-1c53a66ba587@gmail.com>
 <MN2PR20MB29739B9D16130F5C06831C92CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190808171508.GA201004@gmail.com>
 <MN2PR20MB2973387C1A083138866EE45FCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190809171720.GC658@sol.localdomain>
 <MN2PR20MB2973BE617D7BC075BB7BB1ACCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973BE617D7BC075BB7BB1ACCAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 09, 2019 at 08:29:59PM +0000, Pascal Van Leeuwen wrote:
> > 
> > There's no proof that other attacks don't exist.
> >
> As you can't prove something doesn't exist ...

Of course you can, that's what the security proofs for crypto constructions
always do.  They prove that no efficient attack exists (in some attack model)
unless the underlying crypto primitives are weak.

> 
> > If you're going to advocate
> > for using it regardless, then you need to choose a different (weaker) attack
> > model, then formally prove that the construction is secure under that model.
> > Or show where someone else has done so.
> > 
> I'm certainly NOT advocating the use of this. I was merely pointing out a
> legacy use case that happens to be very relevant to people stuck with it,
> which therefore should not be dismissed so easily.
> And how this legacy use case may have further security implications (like
> the tweak encryption being more sensitive than was being assumed, so you
> don't want to run that through an insecure implementation).

Obviously there are people already using bad crypto, whether this or something
else, and they often need to continue to be supported.  I'm not disputing that.

What I'm disputing is your willingness to argue that it's not really that bad,
without a corresponding formal proof which crypto constructions always have.

- Eric
