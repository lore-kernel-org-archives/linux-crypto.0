Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99897C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Feb 2022 16:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiBFQIa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Feb 2022 11:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiBFQIa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Feb 2022 11:08:30 -0500
X-Greylist: delayed 178 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 08:08:28 PST
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1476C06173B
        for <linux-crypto@vger.kernel.org>; Sun,  6 Feb 2022 08:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644163343;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ajoLvXOqNUsQDqmDZKsWT4JQr84dpEvj/4vqEVhVNZQ=;
    b=FFwpIsca12VqssxpQD5wcww02Xywkw82X+hgU1cY+IvKW9QgfDtvD0UJqYUN7RoD0s
    Db5vozmgtt9diDru2HA4LqUdCGDTbtElqKxR+mT4pWlsiPULAcAl+vRrbJPf3Y7AN3Re
    UYAFfLgNpQp0rALhgaqq352iUYMhCo5ZV+S6Vr4EsmAKxptfKFuW9RAjPZyHlhp78fUl
    qB6HoBigNqCyhdYdgmyv4x72Slvy7nOJo+KDCebYMO+C/WBUj4ZhGQ5JhmlghCGy+XxQ
    0g5Xvg2jNrVrXr6Y3gdMSTxaILHioKilwd1LE2ctFprQ/sqCgl5Us64glgKYhzYLbH5p
    oFbA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvcOeibdLc="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.39.0 DYNA|AUTH)
    with ESMTPSA id z28df7y16G2MNjO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 6 Feb 2022 17:02:22 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH 0/7] Common entropy source and DRNG management
Date:   Sun, 06 Feb 2022 17:02:21 +0100
Message-ID: <2092435.IRzVExRRsL@tauon.chronox.de>
In-Reply-To: <Yf30GEJi/61RNq8A@gondor.apana.org.au>
References: <2486550.t9SDvczpPo@positron.chronox.de> <YfQ7FDJqb2zhVcfp@sol.localdomain> <Yf30GEJi/61RNq8A@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Samstag, 5. Februar 2022, 04:50:48 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 28, 2022 at 10:51:00AM -0800, Eric Biggers wrote:
> > > The extraction of the entropy source and DRNG management into its own
> > > component separates out the security sensitive implementation currently
> > > found in multiple locations following the strategy found in the crypto
> > > API where each moving part is separated and encapsulated.
> > > 
> > > The current implementation of the ESDM allows an easy addition of new
> > > entropy sources which are properly encapsulated in self-contained code
> > > allowing self- contained entropy analyses to be performed for each.
> > > These entropy sources would provide their seed data completely separate
> > > from other entropy sources to the DRNG preventing any mutual
> > > entanglement and thus challenges in the entropy assessment. I have
> > > additional entropy sources already available that I would like to
> > > contribute at a later stage. These entropy sources can be enabled,
> > > disabled or its entropy rate set as needed by vendors depending on
> > > their entropy source analysis. Proper default values would be used for
> > > the common case where a vendor does not want to perform its own
> > > analysis or a distro which want to provide a common kernel binary for
> > > many users.> 
> > What is the actual point of this?  The NIST DRBGs are already seeded from
> > random.c, which is sufficient by itself but doesn't play well with
> > certifications, and from Jitterentropy which the certification side is
> > happy with.  And the NIST DRBGs are only present for certification
> > purposes anyway; all real users use random.c instead.  So what problem
> > still needs to be solved?
> Indeed.  Stephan, could you please explain exactly what additional
> seeding sources are needed over the current jitter+/dev/random sources
> (and why).  Or even better, add those seeding sources that we must have
> in your patch series so that they can be evaluated together.
> 
> As it stands this patch series seems to be adding a lot of code without
> any uses.

Thank you for the clarification. I will provide that information.
> 
> Thanks,


Ciao
Stephan


