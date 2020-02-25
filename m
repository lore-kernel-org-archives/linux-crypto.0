Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C107C35DF9
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 10:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79DC221927
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 10:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgBYKYQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 05:24:16 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:41676 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbgBYKYP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 05:24:15 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1j6XML-0003B1-7N; Tue, 25 Feb 2020 21:22:38 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Feb 2020 21:22:37 +1100
Date:   Tue, 25 Feb 2020 21:22:37 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Hongbo Yao <yaohongbo@huawei.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        chenzhou10@huawei.com, xuzaibo@huawei.com
Subject: Re: [PATCH -next] crypto: hisilicon - qm depends on UACCE
Message-ID: <20200225102237.GA31328@gondor.apana.org.au>
References: <20200225030356.44008-1-yaohongbo@huawei.com>
 <5E54DE89.2030703@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E54DE89.2030703@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 25, 2020 at 04:44:57PM +0800, Zhou Wang wrote:
>
> > diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> > index 8851161f722f..b35c2ec15bc2 100644
> > --- a/drivers/crypto/hisilicon/Kconfig
> > +++ b/drivers/crypto/hisilicon/Kconfig
> > @@ -40,6 +40,7 @@ config CRYPTO_DEV_HISI_QM
> >  	tristate
> >  	depends on ARM64 || COMPILE_TEST
> >  	depends on PCI && PCI_MSI
> > +	depends on UACCE
> >  	help
> >  	  HiSilicon accelerator engines use a common queue management
> >  	  interface. Specific engine driver may use this module.
> >
> 
> Indeed, this driver does not depend on uacce fully, as if there is no uacce, it still can
> register to kernel crypto.
> 
> Seems that changing uacce config to bool can avoid this problem.

You shouldn't make it a bool.  The standard way to solve this is to
add this:

	depends on UACCE || UACCE=n

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
