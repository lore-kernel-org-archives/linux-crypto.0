From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix IV loading for authenc (giv)decryption
Date: Fri, 26 Aug 2016 22:39:56 +0800
Message-ID: <20160826143956.GF20096@gondor.apana.org.au>
References: <1472220822-18888-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44299 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbcHZOkC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2016 10:40:02 -0400
Content-Disposition: inline
In-Reply-To: <1472220822-18888-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 26, 2016 at 05:13:42PM +0300, Horia Geantă wrote:
> 
> In terms of optimizations, would it be safe to assume all "geniv" authenc
> algorithms - {echainiv, seqiv}(authenc) - get assoc,iv,ciphertext in
> req->src for decryption?

Yes.  They all get the raw IPsec packet, apart from the ESN munging.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
