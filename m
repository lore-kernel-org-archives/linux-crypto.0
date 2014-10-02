From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: aesni - fix and re-enable "by8" CTR variant
Date: Thu, 2 Oct 2014 15:15:12 +0800
Message-ID: <20141002071512.GB26145@gondor.apana.org.au>
References: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48560 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBHPY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Oct 2014 03:15:24 -0400
Content-Disposition: inline
In-Reply-To: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 28, 2014 at 10:23:58PM +0200, Mathias Krause wrote:
> This series fixes the counter overflow handling of the "by8" CTR variant
> which lead to failing cryptomgr tests and, in turn, disabling this
> optimization with commit 7da4b29d496b.
> 
> Patch 1 fixes the bug, patch 2 removes some unused defines (left overs
> from the unification of the initial source files) and patch 3 re-enables
> the code.
> 
> The fix was tested by me, doing tcrypt and dm-crypt tests. It was also
> tested by Romain who initially reported the issue.
> 
> The patches should go on top of crypto-2.6.git.
> 
> In case this doesn't get merged for v3.17, patches 1 and 3 may be cc'ed
> to stable to propagate the fix.
> 
> Please apply!

All applied.  Thanks!

I'll hold off on the stable propagation until this is in the tree
and has been tested for a while first.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
