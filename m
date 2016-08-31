From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: caam - fix IV loading for authenc
 (giv)decryption
Date: Wed, 31 Aug 2016 23:19:15 +0800
Message-ID: <20160831151915.GG28366@gondor.apana.org.au>
References: <1472471534-9544-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40110 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964863AbcHaPTS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 11:19:18 -0400
Content-Disposition: inline
In-Reply-To: <1472471534-9544-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 29, 2016 at 02:52:14PM +0300, Horia Geantă wrote:
> For algorithms that implement IV generators before the crypto ops,
> the IV needed for decryption is initially located in req->src
> scatterlist, not in req->iv.
> 
> Avoid copying the IV into req->iv by modifying the (givdecrypt)
> descriptors to load it directly from req->src.
> aead_givdecrypt() is no longer needed and goes away.
> 
> Cc: <stable@vger.kernel.org> # 4.3+
> Fixes: 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
