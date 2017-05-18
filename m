From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] crypto: tcrypt - include rsa test
Date: Thu, 18 May 2017 11:35:40 +0800
Message-ID: <20170518033540.GA31889@gondor.apana.org.au>
References: <20170425132639.20178-1-horia.geanta@nxp.com>
 <20170425132639.20178-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41728 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755090AbdERDf4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 23:35:56 -0400
Content-Disposition: inline
In-Reply-To: <20170425132639.20178-2-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 25, 2017 at 04:26:35PM +0300, Horia Geantă wrote:
> From: Radu Alexe <radu.alexe@nxp.com>
> 
> Signed-off-by: Radu Alexe <radu.alexe@nxp.com>
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

I think it's time to stop adding new algorithms to tcrypt as you
should be able to test any algorithm using name/type/mask.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
