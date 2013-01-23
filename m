From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - Added property fsl,sec-era in SEC4.0
 device tree binding.
Date: Wed, 23 Jan 2013 16:34:58 -0600
Message-ID: <20130123163458.0a2b229571f25c25517ad299@freescale.com>
References: <1358919295-18151-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	<devicetree-discuss@lists.ozlabs.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:26597
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241Ab3AWWhf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jan 2013 17:37:35 -0500
In-Reply-To: <1358919295-18151-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cc'ing devicetree-discuss.  Start using scripts/get_maintainers.pl.

On Wed, 23 Jan 2013 11:04:55 +0530
Vakul Garg <vakul@freescale.com> wrote:

> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> @@ -54,8 +54,13 @@ PROPERTIES
>     - compatible
>        Usage: required
>        Value type: <string>
> -      Definition: Must include "fsl,sec-v4.0". Also includes SEC
> -           ERA versions (optional) with which the device is compatible.
> +      Definition: Must include "fsl,sec-v4.0"
> +
> +   - fsl,sec-era
> +      Usage: required

what's the rationale for going from optional to required?

>  EXAMPLE
>  	crypto@300000 {
> -		compatible = "fsl,sec-v4.0", "fsl,sec-era-v2.0";
> +		compatible = "fsl,sec-v4.0";
> +		fsl,sec-era = <0x2>;

use decimal notation

Kim
