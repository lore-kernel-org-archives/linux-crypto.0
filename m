Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36442 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbeJYImh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Oct 2018 04:42:37 -0400
Date: Wed, 24 Oct 2018 19:12:21 -0500
From: Rob Herring <robh@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: ccree: add dt bindings for ccree 713
Message-ID: <20181025001221.GA12740@bogus>
References: <1539696935-4433-1-git-send-email-gilad@benyossef.com>
 <1539696935-4433-3-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539696935-4433-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 16, 2018 at 02:35:32PM +0100, Gilad Ben-Yossef wrote:
> Add device tree bindings associating Arm TrustZone CryptoCell 713 with the
> ccree driver.

"dt-bindings: crypto: ..." for the subject.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> index 999fb2a..880de07 100644
> --- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> +++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> @@ -1,8 +1,9 @@
>  Arm TrustZone CryptoCell cryptographic engine
>  
>  Required properties:
> -- compatible: Should be one of: "arm,cryptocell-712-ree",
> -  "arm,cryptocell-710-ree" or "arm,cryptocell-630p-ree".
> +- compatible: Should be one of: "arm,cryptocell-713-ree",
> +  "arm,cryptocell-712-ree", "arm,cryptocell-710-ree" or
> +  "arm,cryptocell-630p-ree".

Please format 1 per line.

>  - reg: Base physical address of the engine and length of memory mapped region.
>  - interrupts: Interrupt number for the device.
>  
> -- 
> 2.7.4
> 
