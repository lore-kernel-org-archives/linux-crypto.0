Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D255C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 04:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5024F2146E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 04:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfBTEGe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 23:06:34 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:40038 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBTEGe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 23:06:34 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gwJ9U-0000Oi-Nh; Wed, 20 Feb 2019 12:06:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gwJ9Q-0001iV-NW; Wed, 20 Feb 2019 12:06:28 +0800
Date:   Wed, 20 Feb 2019 12:06:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Eric Biggers <ebiggers@google.com>
Subject: Re: [RFC PATCH] crypto: pcrypt - forbid recursive instantiation
Message-ID: <20190220040628.673rc2ffs7dxepu2@gondor.apana.org.au>
References: <20171230083744.vuclnbs677tj7pi2@gauss3.secunet.de>
 <20180310232231.19191-1-ebiggers3@gmail.com>
 <20180323002152.GA30497@gondor.apana.org.au>
 <20180408225528.GH685@sol.localdomain>
 <20180409085807.2cwvr5cocz6gfbmv@gauss3.secunet.de>
 <20180409190739.GC203367@gmail.com>
 <20180418053533.wuo6bj2okqdu2hrf@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418053533.wuo6bj2okqdu2hrf@gauss3.secunet.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 18, 2018 at 07:35:33AM +0200, Steffen Klassert wrote:
> 
> Yes sure, I just wanted to know if it is worth to think about
> preventing template recursions. If there is a valid usecase,
> then we don't even need to think in this direction.
> 
> While I think each pcrypt instance should have it's own
> padata instance on the long run, it would be good to have
> a not so intrusive fix that can be backported to the stable
> trees.

Steffen, has there been any progress on this work?

We need to fix this soon or we'll have to disable pcrypt because
it is a security issue.

It's not just about nested templates either.  You can trigger
the same issue where a pcrypt instance over an AEAD algorithm
that uses a fallback which also happens to be pcrypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
