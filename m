From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1 3/4] Crypto: Add support for APM X-Gene SoC CRC32C h/w
 accelerator driver
Date: Fri, 31 Jul 2015 15:13:58 +0800
Message-ID: <20150731071358.GA25228@gondor.apana.org.au>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
 <1438258268-3099-4-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, arnd@arndb.de,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com
To: Rameshwar Prasad Sahu <rsahu@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41443 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbGaHOU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 03:14:20 -0400
Content-Disposition: inline
In-Reply-To: <1438258268-3099-4-git-send-email-rsahu@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 30, 2015 at 05:41:07PM +0530, Rameshwar Prasad Sahu wrote:
>
> +		.cra_name		= "xgene(crc32c)",
> +		.cra_driver_name	= "crc32c-xgene",

This looks wrong.  If you're implementing crc32c then cra_name
should be just crc32c, i.e., the name of the algorithm that you
are providing.

> +MODULE_DESCRIPTION("APM X-Gene SoC CRC32C HW accelerator driver");
> +MODULE_AUTHOR("Rameshwar Prasad Sahu <rsahu@apm.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("1.0");

You should add a MODULE_ALIAS_CRYPTO too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
