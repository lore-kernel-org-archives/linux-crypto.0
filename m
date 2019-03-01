Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D1AC43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 03:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C5E920854
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 03:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfCADiK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 22:38:10 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56610 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfCADiH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 22:38:07 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzYzu-0007q4-AC; Fri, 01 Mar 2019 11:38:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzYzq-0003LN-Kh; Fri, 01 Mar 2019 11:38:02 +0800
Date:   Fri, 1 Mar 2019 11:38:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Eric Biggers <ebiggers@google.com>
Subject: Re: [RFC PATCH] crypto: pcrypt - forbid recursive instantiation
Message-ID: <20190301033802.cm7wjouxq4hwyrji@gondor.apana.org.au>
References: <20171230083744.vuclnbs677tj7pi2@gauss3.secunet.de>
 <20180310232231.19191-1-ebiggers3@gmail.com>
 <20180323002152.GA30497@gondor.apana.org.au>
 <20180408225528.GH685@sol.localdomain>
 <20180409085807.2cwvr5cocz6gfbmv@gauss3.secunet.de>
 <20180409190739.GC203367@gmail.com>
 <20180418053533.wuo6bj2okqdu2hrf@gauss3.secunet.de>
 <20190220040628.673rc2ffs7dxepu2@gondor.apana.org.au>
 <20190220114208.GD3087@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220114208.GD3087@gauss3.secunet.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 12:42:08PM +0100, Steffen Klassert wrote:
> 
> I had a look on what we need to use separate padata
> instances for each pcrypt instance. But that's comlicated
> and will create incompatibilities on the sysfs cpuset
> configuration options. So that's not really a thing that
> could be a fix.

I don't see why it'll create incompatibilities for the cpu mask
configuration.  You can just maintain two global configuration
masks as you do now, and read them from each instance.  What's
the problem with that?

> > We need to fix this soon or we'll have to disable pcrypt because
> > it is a security issue.
> > 
> > It's not just about nested templates either.  You can trigger
> > the same issue where a pcrypt instance over an AEAD algorithm
> > that uses a fallback which also happens to be pcrypt.
> 
> Would it be possible to forbid pcrypt for algorithms
> that needs a fallback?

This is complicated and not fool-proof.  pcrypt itself might
be embedded into some other algorithm directly rather than as
a fallback.

Basically anyone who does a crypto_alloc_aead could end up with
a pcrypt instance unwittingly.  If they were then used as part
of another AEAD algorithm's encrypt/decrypt path then we'd have
a dead-lock as we do now.

Granted we may not have this situation right now but relying on
it to never occur is not a good choice IMHO.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
