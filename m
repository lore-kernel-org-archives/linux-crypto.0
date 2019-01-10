Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59674 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbfAJOFb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 09:05:31 -0500
Date: Thu, 10 Jan 2019 22:05:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nagadheeraj Rottela <rnagadheeraj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        Gadam Sreerama <sgadam@cavium.com>,
        "Nagadheeraj, Rottela" <Rottela.Nagadheeraj@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium/nitrox - Use after free in
 process_response_list()
Message-ID: <20190110140515.6lfiip7tlyhxng2o@gondor.apana.org.au>
References: <20190104064611.GA30627@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104064611.GA30627@kadam>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 04, 2019 at 09:46:11AM +0300, Dan Carpenter wrote:
> We free "sr" and then dereference it on the next line.
> 
> Fixes: c9613335bf4f ("crypto: cavium/nitrox - Added AEAD cipher support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
