Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE13C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 01:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C8BA2245C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 01:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfKTBKT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 20:10:19 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58322 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfKTBKT (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Tue, 19 Nov 2019 20:10:19 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iXEVe-0003Pi-3i; Wed, 20 Nov 2019 09:10:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iXEVb-0000OH-LM; Wed, 20 Nov 2019 09:10:15 +0800
Date:   Wed, 20 Nov 2019 09:10:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] padata: Remove unused padata_remove_cpu
Message-ID: <20191120011015.qzhn3yd6w5qhze3l@gondor.apana.org.au>
References: <20191119223250.jaefneeatsa52nhh@gondor.apana.org.au>
 <20191119225101.t4ktiggrdyptd3ii@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119225101.t4ktiggrdyptd3ii@ca-dmjordan1.us.oracle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 19, 2019 at 05:51:01PM -0500, Daniel Jordan wrote:
> On Wed, Nov 20, 2019 at 06:32:50AM +0800, Herbert Xu wrote:
> > The function padata_remove_cpu was supposed to have been removed
> > along with padata_add_cpu but somehow it remained behind.  Let's
> > kill it now as it doesn't even have a prototype anymore.
> 
> Documentation/padata.txt still has a reference to this function that should be
> removed.

It also has references to all the other functions that have long
disappeared, such as padata_add_cpu.  Would you like to send a
patch to remove all of them?

> Do you plan on posting other fixes in this area?  Asking so I know which to
> work on further.  Thanks.

Not at this point.  So feel free to rebase your work on top of these
patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
