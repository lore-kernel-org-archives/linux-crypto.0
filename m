Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C63C433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F027B20720
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGIIDH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:03:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35050 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgGIIDH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 04:03:07 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtRWH-0006mS-NX; Thu, 09 Jul 2020 18:03:02 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 18:03:01 +1000
Date:   Thu, 9 Jul 2020 18:03:01 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org, j-keerthy@ti.com
Subject: Re: [PATCHv5 2/7] crypto: sa2ul: Add crypto driver
Message-ID: <20200709080301.GA11760@gondor.apana.org.au>
References: <20200701080553.22604-1-t-kristo@ti.com>
 <20200701080553.22604-3-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701080553.22604-3-t-kristo@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 01, 2020 at 11:05:48AM +0300, Tero Kristo wrote:
> From: Keerthy <j-keerthy@ti.com>
> 
> Adds a basic crypto driver and currently supports AES/3DES
> in cbc mode for both encryption and decryption.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> [t-kristo@ti.com: major re-work to fix various bugs in the driver and to
>  cleanup the code]
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>  drivers/crypto/Kconfig  |   14 +
>  drivers/crypto/Makefile |    1 +
>  drivers/crypto/sa2ul.c  | 1391 +++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/sa2ul.h  |  380 +++++++++++
>  4 files changed, 1786 insertions(+)
>  create mode 100644 drivers/crypto/sa2ul.c
>  create mode 100644 drivers/crypto/sa2ul.h

I get lots of sparse warnings with this driver.  Please fix them
and resubmit.

../drivers/crypto/sa2ul.c:402:24: warning: incorrect type in assignment (different base types)
../drivers/crypto/sa2ul.c:402:24:    expected unsigned int [usertype]
../drivers/crypto/sa2ul.c:402:24:    got restricted __be32 [usertype]
../drivers/crypto/sa2ul.c:603:31: warning: cast to restricted __be32
../drivers/crypto/sa2ul.c:603:31: warning: cast to restricted __be32
../drivers/crypto/sa2ul.c:603:31: warning: cast to restricted __be32
../drivers/crypto/sa2ul.c:603:31: warning: cast to restricted __be32
../drivers/crypto/sa2ul.c:603:31: warning: cast to restricted __be32
../drivers/crypto/sa2ul.c:920:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:940:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:958:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:972:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:1003:35: warning: incorrect type in assignment (different base types)
../drivers/crypto/sa2ul.c:1003:35:    expected unsigned int [usertype]
../drivers/crypto/sa2ul.c:1003:35:    got restricted __be32 [usertype]
../drivers/crypto/sa2ul.c:628:41: warning: incorrect type in assignment (different base types)
../drivers/crypto/sa2ul.c:628:41:    expected unsigned int [usertype]
../drivers/crypto/sa2ul.c:628:41:    got restricted __be32 [usertype]
../drivers/crypto/sa2ul.c:528:22: warning: incorrect type in assignment (different base types)
../drivers/crypto/sa2ul.c:528:22:    expected unsigned int [usertype]
../drivers/crypto/sa2ul.c:528:22:    got restricted __be32 [usertype]
../drivers/crypto/sa2ul.c:1236:34: warning: Using plain integer as NULL pointer
../drivers/crypto/sa2ul.c:1310:27: warning: incorrect type in assignment (different base types)
../drivers/crypto/sa2ul.c:1310:27:    expected unsigned int [usertype]
../drivers/crypto/sa2ul.c:1310:27:    got restricted __be32 [usertype]
../drivers/crypto/sa2ul.c:1348:34: warning: Using plain integer as NULL pointer
../drivers/crypto/sa2ul.c:1570:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:1586:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:1602:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:1658:30: warning: incorrect type in assignment (different base types)
../drivers/crypto/sa2ul.c:1658:30:    expected unsigned int [usertype]
../drivers/crypto/sa2ul.c:1658:30:    got restricted __be32 [usertype]
../drivers/crypto/sa2ul.c:1846:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:1859:33: warning: missing braces around initializer
../drivers/crypto/sa2ul.c:1873:34: warning: Using plain integer as NULL pointer
../drivers/crypto/sa2ul.c:2167:6: warning: symbol 'sa_register_algos' was not declared. Should it be static?
../drivers/crypto/sa2ul.c:2199:6: warning: symbol 'sa_unregister_algos' was not declared. Should it be static?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
