Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C96C4727C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 23:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F55D23A7B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 23:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgIUXvo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 19:51:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41180 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgIUXvo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 19:51:44 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kKVaq-0007nf-Gx; Tue, 22 Sep 2020 09:51:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Sep 2020 09:51:36 +1000
Date:   Tue, 22 Sep 2020 09:51:36 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200921235136.GA6796@gondor.apana.org.au>
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921232639.GK29330@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 21, 2020 at 04:26:39PM -0700, Paul E. McKenney wrote:
>
> > But this reasoning could apply to any data structure that contains
> > a spin lock, in particular ones that are dereferenced through RCU.
> 
> I lost you on this one.  What is special about a spin lock?

I don't know, that was Eric's concern.  He is inferring that
spin locks through lockdep debugging may trigger dependencies
that require smp_load_acquire.

Anyway, my point is if it applies to crng_node_pool then it
would equally apply to RCU in general.

> > So my question if this reasoning is valid, then why aren't we first
> > converting rcu_dereference to use smp_load_acquire?
> 
> For LTO in ARM, rumor has it that Will is doing so.  Which was what
> motivated the BoF on this topic at Linux Plumbers Conference.

Sure, if RCU switches over to smp_load_acquire then I would have
no problems with everybody else following in its footsteps.

Here is the original patch in question:

https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
