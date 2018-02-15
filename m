From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] hwrng: make symbol imx_rngc_pm_ops static
Date: Thu, 15 Feb 2018 23:42:21 +0800
Message-ID: <20180215154221.GC7352@gondor.apana.org.au>
References: <1516673336-170194-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516673336-170194-1-git-send-email-weiyongjun1@huawei.com>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 23, 2018 at 02:08:56AM +0000, Wei Yongjun wrote:
> Fixes the following sparse warnings:
> 
> drivers/char/hw_random/imx-rngc.c:303:1: warning:
>  symbol 'imx_rngc_pm_ops' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
