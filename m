Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59646 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfAJOEl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 09:04:41 -0500
Date: Thu, 10 Jan 2019 22:04:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH v2] crypto: caam - fix SHA support detection
Message-ID: <20190110140437.xjcky3ckd2u47fcn@gondor.apana.org.au>
References: <20181221124316.23572-1-horia.geanta@nxp.com>
 <20181221124746.32670-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181221124746.32670-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 21, 2018 at 02:47:46PM +0200, Horia Geantă wrote:
> The addition of Chacha20 + Poly1305 authenc support inadvertently broke
> detection of algorithms supported by MDHA (Message Digest Hardware
> Accelerator), fix it.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: d6bbd4eea243 ("crypto: caam/jr - add support for Chacha20 + Poly1305")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.

I deleted the stables cc because the offending patch was only merged
recently.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
