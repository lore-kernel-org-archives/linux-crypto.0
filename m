Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FBEC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242510AbiA1GXg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:23:36 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60596 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242520AbiA1GXc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:23:32 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKfN-0000yO-4l; Fri, 28 Jan 2022 17:23:26 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:23:25 +1100
Date:   Fri, 28 Jan 2022 17:23:25 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     horia.geanta@nxp.com, andrei.botila@nxp.com,
        andrew.smirnov@gmail.com, fredrik.yhlen@endian.se, hs@denx.de,
        linux-crypto@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
Message-ID: <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
References: <20220111124104.2379295-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111124104.2379295-1-festevam@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 11, 2022 at 09:41:04AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
> in HRWNG") the following CAAM errors can be seen on i.MX6:
> 
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> 
> OP_ALG_PR_ON is enabled unconditionally, which may cause the problem
> on i.MX devices.
> 
> Fix the problem by only enabling OP_ALG_PR_ON on platforms that have
> Management Complex support.
> 
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
>  drivers/crypto/caam/caamrng.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
