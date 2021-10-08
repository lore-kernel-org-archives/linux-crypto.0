Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441D0C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 11:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E80360F43
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Oct 2021 11:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240999AbhJHL4l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Oct 2021 07:56:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55910 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240776AbhJHL4d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Oct 2021 07:56:33 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mYoSS-00039z-4U; Fri, 08 Oct 2021 19:54:36 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mYoSO-000705-6v; Fri, 08 Oct 2021 19:54:32 +0800
Date:   Fri, 8 Oct 2021 19:54:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolai Stange <nstange@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>
Subject: Re: [PATCH 8/8] crypto: api - make the algorithm lookup priorize
 non-larvals
Message-ID: <20211008115432.GC26495@gondor.apana.org.au>
References: <20211003181413.12465-1-nstange@suse.de>
 <20211003181413.12465-9-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003181413.12465-9-nstange@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 03, 2021 at 08:14:13PM +0200, Nicolai Stange wrote:
> crypto_alg_mod_lookup() invokes the crypto_larval_lookup() helper
> to run the actual search for matching crypto_alg implementation and
> larval entries. The latter is currently considering only the individual
> entries' relative ->cra_priority for determining which one out of multiple
> matches to return. This means that it would potentially dismiss a matching
> crypto_alg implementation in working state in favor of some pending
> testing larval of higher ->cra_priority. Now, if the testmgr instance
> invoked asynchronously on that testing larval came to the conclusion that
> it should mark the tests as failed, any pending crypto_alg_mod_lookup()
> waiting for it would be made to fail as well with -EAGAIN.
> 
> In summary, crypto_alg_mod_lookup() can fail spuriously with -EAGAIN even
> though an implementation in working state would have been available, namely
> if the testmgr asynchronously marked another, competing implementation of
> higher ->cra_priority as failed.
> 
> This is normally not a problem at all with upstream, because the situation
> where one algorithm passed its tests, but another competing one failed to
> do so, would indicate a bug anyway.
> 
> However, for downstream distributions seeking FIPS certification, simply
> amending the list in crypto/testmgr.c with ->fips_allowed = 0 entries
> matching on ->cra_driver_name would provide a convenient way of
> selectively blacklisting implementations from drivers/crypto in fips
> mode. Note that in this scenario failure of competing crypto_alg
> implementations would become more common, in particular during device
> enumeration. If the algorithm in question happened to be needed for e.g.
> module signature verification, module loading could spuriously fail during
> bootup, which is certainly not desired.
> 
> For transparency: this has not actually been observed, I merely came to
> the conclusion that it would be possible by reading the code.
> 
> Make crypto_alg_lookup() run an additional search for non-larval matches
> upfront in the common case that the request has been made for
> CRYPTO_ALG_TESTED instances.
> 
> Signed-off-by: Nicolai Stange <nstange@suse.de>
> ---
>  crypto/api.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

It's not clear that this new behaviour is desirable.  For example,
when we construct certain complex algorithms, they may depend on a
generic version of that same algorithm as a fallback.  We do not
want users to get the generic version while the better version is
being tested.

Can you please explain what your failure scenario and perhaps we
can come up with another way of resolving your problem?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
