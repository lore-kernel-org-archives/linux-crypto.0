Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38980 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbeLWECb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:02:31 -0500
Date: Sun, 23 Dec 2018 12:02:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-crypto@vger.kernel.org, shawnguo@kernel.org
Subject: Re: [PATCH] crypto: mxc-scc - fix build warnings on ARM64
Message-ID: <20181223040229.ij6jjwb62xecwdl6@gondor.apana.org.au>
References: <1544694752-9293-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544694752-9293-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 13, 2018 at 07:52:32AM -0200, Fabio Estevam wrote:
> The following build warnings are seen when building for ARM64 allmodconfig:
> 
> drivers/crypto/mxc-scc.c:181:20: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
> drivers/crypto/mxc-scc.c:186:21: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
> drivers/crypto/mxc-scc.c:277:21: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
> drivers/crypto/mxc-scc.c:339:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> drivers/crypto/mxc-scc.c:340:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> 
> Fix them by using the %zu specifier to print a size_t variable and using
> a plain %x to print the result of a readl().
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/crypto/mxc-scc.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
