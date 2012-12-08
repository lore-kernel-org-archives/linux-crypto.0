From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH] Revert "crypto: caam - Updated SEC-4.0 device tree
 binding for ERA information."
Date: Sat, 8 Dec 2012 04:30:03 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B9413FB3F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1354870649-3656-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:29286
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932966Ab2LHEaH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2012 23:30:07 -0500
In-Reply-To: <1354870649-3656-1-git-send-email-vakul@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kindly ignore this.
I would send another patch updating device tree binding directly with the new proposed property.

> -----Original Message-----
> From: devicetree-discuss [mailto:devicetree-discuss-
> bounces+vakul=freescale.com@lists.ozlabs.org] On Behalf Of Vakul Garg
> Sent: Friday, December 07, 2012 2:27 PM
> To: linux-crypto@vger.kernel.org; linuxppc-dev@ozlabs.org; devicetree-
> discuss@lists.ozlabs.org
> Subject: [PATCH] Revert "crypto: caam - Updated SEC-4.0 device tree
> binding for ERA information."
> 
> This reverts commit a2c0911c09190125f52c9941b9d187f601c2f7be.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
> Instead of adding SEC era information in crypto node's compatible, a new
> property 'fsl,sec-era' is being introduced into crypto node.
> 
>  .../devicetree/bindings/crypto/fsl-sec4.txt        |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> index fc9ce6f..bd7ce12 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> @@ -54,8 +54,7 @@ PROPERTIES
>     - compatible
>        Usage: required
>        Value type: <string>
> -      Definition: Must include "fsl,sec-v4.0". Also includes SEC
> -           ERA versions (optional) with which the device is compatible.
> +      Definition: Must include "fsl,sec-v4.0"
> 
>     - #address-cells
>         Usage: required
> @@ -107,7 +106,7 @@ PROPERTIES
> 
>  EXAMPLE
>  	crypto@300000 {
> -		compatible = "fsl,sec-v4.0", "fsl,sec-era-v2.0";
> +		compatible = "fsl,sec-v4.0";
>  		#address-cells = <1>;
>  		#size-cells = <1>;
>  		reg = <0x300000 0x10000>;
> --
> 1.7.7.6
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
