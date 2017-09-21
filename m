From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix LS1021A support on ARMv7
 multiplatform kernel
Date: Thu, 21 Sep 2017 16:07:17 +0800
Message-ID: <20170921080717.GG7718@gondor.apana.org.au>
References: <20170901141259.848-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44926 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbdIUIHf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 04:07:35 -0400
Content-Disposition: inline
In-Reply-To: <20170901141259.848-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 01, 2017 at 05:12:59PM +0300, Horia Geantă wrote:
> When built using multi_v7_defconfig, driver does not work on LS1021A:
> [...]
> caam 1700000.crypto: can't identify CAAM ipg clk: -2
> caam: probe of 1700000.crypto failed with error -2
> [...]
> 
> It turns out we have to detect at runtime whether driver is running
> on an i.MX platform or not.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 6c3af9559352 ("crypto: caam - add support for LS1021A")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
