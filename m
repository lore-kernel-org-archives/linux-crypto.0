From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/12] crypto: caam - fixes
Date: Wed, 15 Feb 2017 13:33:48 +0800
Message-ID: <20170215053348.GD14043@gondor.apana.org.au>
References: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43927 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbdBOFd7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:33:59 -0500
Content-Disposition: inline
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 10, 2017 at 02:07:13PM +0200, Horia Geantă wrote:
> This batch consists mostly of DMA API related fixes and simplifications.
> 
> Since no no arch calls:
> dma_debug_add_bus(&platform_bus_type);
> DMA API debugging does not have the chance to report leaks when modules
> are removed.
> 
> I am not sure why dma_debug_add_bus() is not used for the platform bus,
> however when I did that for testing purposes, I could notice quite a few
> problems in caam driver.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
