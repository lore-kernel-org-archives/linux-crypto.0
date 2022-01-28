Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C1BC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346401AbiA1GXP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:23:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60594 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346397AbiA1GXN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:23:13 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKf4-0000v2-9h; Fri, 28 Jan 2022 17:23:07 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:23:06 +1100
Date:   Fri, 28 Jan 2022 17:23:06 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tomasz Kowalik <tomaszx.kowalik@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Mateuszx Potrola <mateuszx.potrola@intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - fix a signedness bug in
 get_service_enabled()
Message-ID: <YfOLyuKzFc8h0j/e@gondor.apana.org.au>
References: <20220111071806.GD11243@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111071806.GD11243@kili>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 11, 2022 at 10:18:06AM +0300, Dan Carpenter wrote:
> The "ret" variable needs to be signed or there is an error message which
> will not be printed correctly.
> 
> Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
