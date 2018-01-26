From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr.c: test misuse of result in ahash
Date: Fri, 26 Jan 2018 23:44:52 +0800
Message-ID: <20180126154452.GC4002@gondor.apana.org.au>
References: <CGME20180116142614eucas1p1c171b69192a4b8f7871075ff712bb7ba@eucas1p1.samsung.com>
 <9d678a28-8cb3-1ab8-cefe-1bafff2a18d9@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39624 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751881AbeAZQ2c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jan 2018 11:28:32 -0500
Content-Disposition: inline
In-Reply-To: <9d678a28-8cb3-1ab8-cefe-1bafff2a18d9@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 16, 2018 at 03:26:13PM +0100, Kamil Konieczny wrote:
> Async hash operations can use result pointer in final/finup/digest,
> but not in init/update/export/import, so test it for misuse.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
