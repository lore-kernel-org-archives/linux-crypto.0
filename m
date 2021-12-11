Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499DEC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Dec 2021 05:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhLKF4v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:56:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57718 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhLKF4v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Dec 2021 00:56:51 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mvvND-00051h-Eq; Sat, 11 Dec 2021 16:56:44 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 11 Dec 2021 16:56:43 +1100
Date:   Sat, 11 Dec 2021 16:56:43 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/qm - fix incorrect return value of
 hisi_qm_resume()
Message-ID: <20211211055643.GE6841@gondor.apana.org.au>
References: <20211204104301.32666-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211204104301.32666-1-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 04, 2021 at 06:43:01PM +0800, Weili Qian wrote:
> When hisi_qm_resume() returns 0, it indicates that the device has started
> successfully.  If the device fails to start, hisi_qm_resume() needs to
> return the actual error code to the caller instead of 0.
> 
> Fixes: d7ea53395b72 ("crypto: hisilicon - add runtime PM ops")
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
