Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BE6C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8082560FC4
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhJ2NON (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:14:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56396 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhJ2NON (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 09:14:13 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mgRfS-0002nG-Ve; Fri, 29 Oct 2021 21:11:35 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mgRfF-0003Cv-9w; Fri, 29 Oct 2021 21:11:21 +0800
Date:   Fri, 29 Oct 2021 21:11:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     krzysztof.kozlowski@canonical.com, vz@mleia.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] crypto: s5p-sss - Add error handling in
 s5p_aes_probe()
Message-ID: <20211029131121.GB12278@gondor.apana.org.au>
References: <20211021013422.21396-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021013422.21396-1-tangbin@cmss.chinamobile.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 21, 2021 at 09:34:22AM +0800, Tang Bin wrote:
> The function s5p_aes_probe() does not perform sufficient error
> checking after executing platform_get_resource(), thus fix it.
> 
> Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
> Changes from v2
>  - add Cc: <stable@vger.kernel.org>
> 
> Changes from v1
>  - add fixed title
> ---
>  drivers/crypto/s5p-sss.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
