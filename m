From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/4] crypto: caam - constify key data
Date: Thu, 28 Dec 2017 18:02:39 +1100
Message-ID: <20171228070239.GC9639@gondor.apana.org.au>
References: <20171219101607.15323-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48990 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbdL1HCq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Dec 2017 02:02:46 -0500
Content-Disposition: inline
In-Reply-To: <20171219101607.15323-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 19, 2017 at 12:16:04PM +0200, Horia Geantă wrote:
> Key data is not modified, it is copied in the shared descriptor.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
