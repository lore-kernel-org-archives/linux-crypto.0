From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 0/4]crypto:chcr- Bug Fixes for 4.10
Date: Mon, 23 Jan 2017 21:39:46 +0800
Message-ID: <20170123133946.GA19957@gondor.apana.org.au>
References: <cover.1484309965.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hariprasad@chelsio.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58353 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750828AbdAWNkC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 08:40:02 -0500
Content-Disposition: inline
In-Reply-To: <cover.1484309965.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 05:59:19PM +0530, Harsh Jain wrote:
> This patch series is based on Herbert's cryptodev-2.6 tree.
> It includes several critical bug fixes.
> 
> Atul Gupta (3):
>   crypto:chcr-Change flow IDs
>   crypto:chcr- Fix panic on dma_unmap_sg
>   crypto:chcr- Check device is allocated before use
> Julia Lawall (1):
>   crypto:chcr-fix itnull.cocci warnings

Patches 2 and 3 look critical, but the other ones do not.  Please
don't mix fixes targeted for this cycle with other patches.

Please resubmit them as two separate series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
