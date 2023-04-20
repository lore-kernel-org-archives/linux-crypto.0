Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822FEC77B72
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Apr 2023 10:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbjDTKVj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Apr 2023 06:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbjDTKVP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2023 06:21:15 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688D9769B;
        Thu, 20 Apr 2023 03:20:07 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ppRNs-000Ybg-Tl; Thu, 20 Apr 2023 18:19:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 20 Apr 2023 18:19:26 +0800
Date:   Thu, 20 Apr 2023 18:19:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Yang <mmyangfl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jia Jie Ho <jiajie.ho@starfivetech.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        William Zhang <william.zhang@broadcom.com>,
        Jenny Zhang <jenny.zhang@starfivetech.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: histb - Move driver to
 drivers/char/hw_random/histb-rng.c
Message-ID: <ZEERrqU8rHzDAPI2@gondor.apana.org.au>
References: <20230410091408.56638-1-mmyangfl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410091408.56638-1-mmyangfl@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 10, 2023 at 05:13:54PM +0800, David Yang wrote:
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 4fdf07ae3c54..1a241f37abed 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -335,6 +335,18 @@ config HW_RANDOM_HISI
>  
>  	  If unsure, say Y.
>  
> +config HW_RANDOM_HISTB
> +	tristate "Hisilicon STB Random Number Generator support"
> +	depends on ARCH_HISI || COMPILE_TEST
> +	depends on HW_RANDOM
> +	default ARCH_HISI

Please drop the dependency on HW_RANDOM.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
