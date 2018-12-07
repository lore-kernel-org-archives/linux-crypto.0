Return-Path: <SRS0=/ZR5=OQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:49084 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbeLGGTS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Dec 2018 01:19:18 -0500
Date: Fri, 7 Dec 2018 14:19:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yangtao Li <tiny.windzz@gmail.com>
Cc: davem@davemloft.net, Jampala.Srikanth@cavium.com,
        sgadam@cavium.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium/nitrox convert to DEFINE_SHOW_ATTRIBUTE
Message-ID: <20181207061913.fpwputw75qi3fn4e@gondor.apana.org.au>
References: <20181201095630.6232-1-tiny.windzz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181201095630.6232-1-tiny.windzz@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 01, 2018 at 04:56:30AM -0500, Yangtao Li wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 48 ++++---------------
>  1 file changed, 9 insertions(+), 39 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
