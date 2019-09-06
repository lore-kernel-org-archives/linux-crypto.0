Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245A3C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 12:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA600206CD
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 12:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389786AbfIFMSw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:18:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60794 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389695AbfIFMSw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 08:18:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i6DCS-0006EQ-Fm; Fri, 06 Sep 2019 22:18:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2019 22:18:43 +1000
Date:   Fri, 6 Sep 2019 22:18:43 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCHv2] crypto: inside-secure - Fix unused variable warning
 when CONFIG_PCI=n
Message-ID: <20190906121843.GA22696@gondor.apana.org.au>
References: <1567757243-16598-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567757243-16598-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 06, 2019 at 10:07:23AM +0200, Pascal van Leeuwen wrote:
>
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index e12a2a3..2331b31 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1505,29 +1505,29 @@ static int __init safexcel_init(void)
>  {
>  	int rc;
>  
> -#if IS_ENABLED(CONFIG_OF)
> -		/* Register platform driver */
> -		platform_driver_register(&crypto_safexcel);
> +#if IS_ENABLED(CONFIG_PCI)
> +	/* Register PCI driver */
> +	rc = pci_register_driver(&safexcel_pci_driver);
>  #endif
>  
> -#if IS_ENABLED(CONFIG_PCI)
> -		/* Register PCI driver */
> -		rc = pci_register_driver(&safexcel_pci_driver);
> +#if IS_ENABLED(CONFIG_OF)
> +	/* Register platform driver */
> +	rc = platform_driver_register(&crypto_safexcel);
>  #endif
>  
> -	return 0;
> +	return rc;
>  }

According to the Kconfig it is theoretically possible for both
PCI and OF to be off (with COMPILE_TEST enabled).  So you should
add an rc = 0 at the top.

You also need to check rc after each registration and abort if
an error is detected.  After the second step, aborting would
also require unwinding the first step.

So something like:

	int rc = 0;

#if IS_ENABLED(CONFIG_PCI)
	/* Register PCI driver */
	rc = pci_register_driver(&safexcel_pci_driver);
#endif
	if (rc)
		goto out;

#if IS_ENABLED(CONFIG_OF)
	/* Register platform driver */
	rc = platform_driver_register(&crypto_safexcel);
#endif
	if (rc)
		goto undo_pci;

undo_pci:
#if IS_ENABLED(CONFIG_PCI)
	pci_unregister_driver(&safexcel_pci_driver);
#endif
out:
	return rc;

As you can see, these ifdefs get out-of-control pretty quickly.
In fact, we can remove all the CONFIG_PCI ifdefs by adding just
one more stub function in pci.h for pcim_enable_device.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
