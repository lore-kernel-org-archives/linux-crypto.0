Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A549C25B4E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 10:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjATKMa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 05:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjATKM3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 05:12:29 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B618B745;
        Fri, 20 Jan 2023 02:12:28 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIoNi-002B7X-4u; Fri, 20 Jan 2023 18:12:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jan 2023 18:12:22 +0800
Date:   Fri, 20 Jan 2023 18:12:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jarkko Sakkinen <jarkko@profian.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] crypto: ccp: Sanitize sev_platform_init() error
 messages
Message-ID: <Y8ppBmdsqcCHDn9v@gondor.apana.org.au>
References: <20230110191201.29666-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110191201.29666-1-jarkko@profian.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 10, 2023 at 07:12:00PM +0000, Jarkko Sakkinen wrote:
>
> @@ -1337,8 +1343,7 @@ void sev_pci_init(void)
>  	/* Initialize the platform */
>  	rc = sev_platform_init(&error);
>  	if (rc)
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> -			error, rc);
> +		dev_err(sev->dev, "SEV: failed to INIT rc %d\n", rc);

Please remove error and replace it with NULL.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
