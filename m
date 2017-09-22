From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/12] crypto: crypto4xx: remove bad list_del
Date: Fri, 22 Sep 2017 18:14:33 +0800
Message-ID: <20170922101433.GK16270@gondor.apana.org.au>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38760 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbdIVKOv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 06:14:51 -0400
Content-Disposition: inline
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 25, 2017 at 03:47:14PM +0200, Christian Lamparter wrote:
> alg entries are only added to the list, after the registration
> was successful. If the registration failed, it was never added
> to the list in the first place.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
