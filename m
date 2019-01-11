Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33240 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfAKGcA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:32:00 -0500
Date: Fri, 11 Jan 2019 14:31:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: YueHaibing <yuehaibing@huawei.com>
Cc: Markus Elfring <elfring@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: ux500 catch dma submission error
Message-ID: <20190111063148.q6zah2ms3d5n7yrp@gondor.apana.org.au>
References: <1545977433-125317-1-git-send-email-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545977433-125317-1-git-send-email-yuehaibing@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 28, 2018 at 06:10:33AM +0000, YueHaibing wrote:
> Test cookie return by dmaengine_submit() and return error if any.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/ux500/cryp/cryp_core.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
