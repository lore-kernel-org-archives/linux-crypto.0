From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC][PATCH 4/4] crypto: Updated makefiles to add QAT
Date: Tue, 03 Jun 2014 12:16:22 -0700
Message-ID: <538E1F06.8070300@infradead.org>
References: <20140603182400.GA18752@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: john.griffin@intel.com, bruce.w.allan@intel.com,
	karen.xiang@intel.com, pingchaox.yang@intel.com, bo.cui@intel.com,
	davem@davemloft.net, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dwmw2@infradead.org, ben@decadent.org.uk
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaFCTQf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Jun 2014 15:16:35 -0400
In-Reply-To: <20140603182400.GA18752@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/03/2014 11:24 AM, Tadeusz Struk wrote:
> Update to makefiles etc.
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  Documentation/ioctl/ioctl-number.txt | 1 +
>  MAINTAINERS                          | 6 ++++++
>  drivers/crypto/Kconfig               | 1 +
>  drivers/crypto/Makefile              | 1 +
>  firmware/Makefile                    | 1 +
>  5 files changed, 10 insertions(+)
> 

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index f066fa2..1f20814 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -418,4 +418,5 @@ config CRYPTO_DEV_MXS_DCP
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called mxs-dcp.
>  
> +source "drivers/crypto/qat/Kconfig"

Missing that file ^^^^^^^^^^^^^^^^^^^

>  endif # CRYPTO_HW


-- 
~Randy
