Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37258 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbeKITXd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:23:33 -0500
Date: Fri, 9 Nov 2018 17:43:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: John Garry <john.garry@huawei.com>
Cc: davem@davemloft.net, Jonathan.Cameron@huawei.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH 0/2] crypto: hisilicon - A couple of fixes
Message-ID: <20181109094342.vp52m6ckyhiya3yz@gondor.apana.org.au>
References: <1541421315-25623-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541421315-25623-1-git-send-email-john.garry@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 05, 2018 at 08:35:13PM +0800, John Garry wrote:
> This patchset fixes a couple of issues I discovered while attempting to
> bringup the driver.
> 
> John Garry (2):
>   crypto: hisilicon -  Fix NULL dereference for same dst and src
>   crypto: hisilicon -  Fix reference after free of memories on error
>  path
> 
>  drivers/crypto/hisilicon/sec/sec_algs.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
