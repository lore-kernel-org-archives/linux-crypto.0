From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium - add release_firmware to all return case
Date: Tue, 22 Aug 2017 15:58:18 +0800
Message-ID: <20170822075818.GF6269@gondor.apana.org.au>
References: <20170814115854.19495-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: george.cherian@cavium.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:40874 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932170AbdHVH6a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 03:58:30 -0400
Content-Disposition: inline
In-Reply-To: <20170814115854.19495-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 14, 2017 at 01:58:54PM +0200, Corentin Labbe wrote:
> Two return case misses to call release_firmware() and so leak some
> memory.
> 
> This patch create a fw_release label (and so a common error path)
> and use it on all return case.
> 
> Detected by CoverityScan, CID#1416422 ("Resource Leak")
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
