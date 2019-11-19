Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2805C432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8257822449
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKSWuX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:50:23 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50178 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfKSWuX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 17:50:23 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iXCKB-00018Q-9n; Wed, 20 Nov 2019 06:50:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iXCKA-0000FY-0I; Wed, 20 Nov 2019 06:50:18 +0800
Date:   Wed, 20 Nov 2019 06:50:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Remove broken queue flushing
Message-ID: <20191119225017.mjrak2fwa5vccazl@gondor.apana.org.au>
References: <20191119051731.yev6dcsp2znjaagz@gondor.apana.org.au>
 <20191119192405.imfi6q4u3g2zgstc@ca-dmjordan1.us.oracle.com>
 <20191119215345.jr7y47b37ivshwcm@gondor.apana.org.au>
 <20191119224432.vr7lyoaqdzpelszo@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119224432.vr7lyoaqdzpelszo@ca-dmjordan1.us.oracle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 19, 2019 at 05:44:32PM -0500, Daniel Jordan wrote:
> 
> I assume you mean the third patch you recently posted, "crypto: pcrypt - Avoid
> deadlock by using per-instance padata queues".  That's true, the problem is
> fixed there, and the bug being present in bisection doesn't seem like enough
> justification to implement something short-lived just to prevent it.

Right.  But as pcrypt is the only user this should still work.
 
> Makes sense to me, though I don't see how it's enforced now in pcrypt.  I'm not
> an async crypto person, but wouldn't unloading the pcrypt module when there are
> still outstanding async jobs break this rule?

It's enforced through module reference counting.  While there are
any outstanding requests, there must be allocated crypto tfms.  Each
crypto tfm maintains a module reference count on pcrypt which
prevents it from being unloaded.

> Actually, I'm working on an RFC right now to add more users for padata.  It
> should be posted in the coming week or two, and I hope it can be part of that
> discussion.

OK.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
