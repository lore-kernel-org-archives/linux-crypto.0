Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97E0C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 11:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90DF610D0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 11:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhJVLyQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Oct 2021 07:54:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56236 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232670AbhJVLyQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Oct 2021 07:54:16 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mdt5Z-0001Wj-Nx; Fri, 22 Oct 2021 19:51:57 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mdt5O-0007JW-RH; Fri, 22 Oct 2021 19:51:46 +0800
Date:   Fri, 22 Oct 2021 19:51:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolai Stange <nstange@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>
Subject: Re: [PATCH 8/8] crypto: api - make the algorithm lookup priorize
 non-larvals
Message-ID: <20211022115146.GA27997@gondor.apana.org.au>
References: <20211003181413.12465-1-nstange@suse.de>
 <20211003181413.12465-9-nstange@suse.de>
 <20211008115432.GC26495@gondor.apana.org.au>
 <87lf30rmd8.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf30rmd8.fsf@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 11, 2021 at 10:34:11AM +0200, Nicolai Stange wrote:
>
> In order to keep a FIPS certification manageable in terms of scope,
> we're looking for a way to disable everything under drivers/crypto iff
> fips_enabled == 1. The most convenient way to achieve this downstream
> would be to add dummy entries to testmgr.c like so:

How about testing based on the flag CRYPTO_ALG_KERN_DRIVER_ONLY?
That flag is meant to correspond to pretty much exactly drivers/crypto.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
