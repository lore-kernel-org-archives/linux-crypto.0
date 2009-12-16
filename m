From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR
 offload
Date: Wed, 16 Dec 2009 16:41:44 -0600
Message-ID: <20091216164144.daff5468.kim.phillips@freescale.com>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, dan.j.williams@intel.com,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	B04825@freescale.com, R58472@freescale.com,
	Dipen Dudhat <Dipen.Dudhat@freescale.com>,
	Maneesh Gupta <Maneesh.Gupta@freescale.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:32833 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbZLPWg6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Dec 2009 17:36:58 -0500
In-Reply-To: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 16 Dec 2009 21:04:58 +0530
Vishnu Suresh <Vishnu@freescale.com> wrote:

> Expose Talitos's XOR functionality to be used for
> RAID Parity calculation via the Async_tx layer.
> 
> Known Issue:
> When used with fsldma, random crashes are observed
> on some platforms. Hence, inter-operability with fsldma
> is currently disabled
> 
> Thanks to Surender Kumar and Lee Nipper for their help in
> realising this driver
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
> Signed-off-by: Maneesh Gupta <Maneesh.Gupta@freescale.com>
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> ---
> Changes with respect to v1 as per comments received
> o. Rebased to linux-next as of 20091216
> o. The selection is based exclusive of fsldma
> o. Intoduced a new Kernel Configuration variable
>    *. This enables selecting the Cryptographic functionality
>       of Talitos along with fsldma.
>    *. Disables the XOR parity calculation offload, if fsldma enabled
>       either as kernel in-built or as a module
>    *. Once the inter-operability with fsldma is resolved, this option
>       can be removed

wait, why can't the interoperability bug be fixed in the first place?

Kim
