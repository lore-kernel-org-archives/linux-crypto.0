From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2 ] Bug Fixes for 4.10
Date: Fri, 3 Feb 2017 18:20:32 +0800
Message-ID: <20170203102032.GA2632@gondor.apana.org.au>
References: <cover.1485233822.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42845 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752808AbdBCKUx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 05:20:53 -0500
Content-Disposition: inline
In-Reply-To: <cover.1485233822.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 24, 2017 at 10:34:31AM +0530, Harsh Jain wrote:
> This patch series includes critical bug fixes
> 
> Atul Gupta (2):
>   crypto:chcr- Fix panic on dma_unmap_sg
>   crypto:chcr- Check device is allocated before use

All applied.  I also added the key length check as I think it can
be exploited through algif_aead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
