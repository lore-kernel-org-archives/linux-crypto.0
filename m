From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: caam/qi - return -EBADMSG for ICV check
 failure
Date: Thu, 15 Feb 2018 23:51:14 +0800
Message-ID: <20180215155114.GK7352@gondor.apana.org.au>
References: <20180129083837.21174-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39594 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424663AbeBOPvZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 10:51:25 -0500
Content-Disposition: inline
In-Reply-To: <20180129083837.21174-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 29, 2018 at 10:38:35AM +0200, Horia Geantă wrote:
> Crypto drivers are expected to return -EBADMSG in case of
> ICV check (authentication) failure.
> 
> In this case it also makes sense to suppress the error message
> in the QI dequeue callback.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
