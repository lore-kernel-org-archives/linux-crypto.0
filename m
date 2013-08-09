From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/4] crypto: omap-sham: Add OMAP5/AM43XX SHAM Support
Date: Fri, 9 Aug 2013 16:31:34 +0100
Message-ID: <20130809153134.GT27325@e106331-lin.cambridge.arm.com>
References: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
 <1374821957-30141-3-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"joelf@ti.com" <joelf@ti.com>, "rnayak@ti.com" <rnayak@ti.com>,
	"nsekhar@ti.com" <nsekhar@ti.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56323 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963Ab3HIPcL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 11:32:11 -0400
Content-Disposition: inline
In-Reply-To: <1374821957-30141-3-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 26, 2013 at 07:59:15AM +0100, Lokesh Vutla wrote:
> Add support for the OMAP5 version of the SHAM module
> that is present on OMAP5 and AM43xx SoCs.
> 
> This module is very simialar to OMAP4 version of SHAM module,
> and adds SHA384 SHA512 hardware-accelerated hash functions to it.
> To handle the higher digest size of SHA512, few SHA512_DIGEST_i
> (i=1-16, and first 8 registers are duplicated from SHA_DIGEST_i
> registers) registers are added at the end of register set.
> So adding the above register offsets and module info in pdata.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  drivers/crypto/omap-sham.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 

> +	{
> +		.compatible	= "ti,omap5-sham",
> +		.data		= &omap_sham_pdata_omap5,
> +	},

No binding update?

Mark.
