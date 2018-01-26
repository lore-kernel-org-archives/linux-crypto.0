From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: axis - remove unnecessary
 platform_get_resource() error check
Date: Fri, 26 Jan 2018 23:45:06 +0800
Message-ID: <20180126154506.GD4002@gondor.apana.org.au>
References: <1516188407-145156-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39608 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbeAZQ2K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jan 2018 11:28:10 -0500
Content-Disposition: inline
In-Reply-To: <1516188407-145156-1-git-send-email-weiyongjun1@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 17, 2018 at 11:26:47AM +0000, Wei Yongjun wrote:
> devm_ioremap_resource() already checks if the resource is NULL, so
> remove the unnecessary platform_get_resource() error check.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
