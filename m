Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:52892 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbeK2Rqs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 12:46:48 -0500
Date: Thu, 29 Nov 2018 14:42:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yael Chemla <yael.chemla@foss.arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: crypto: ccree: add dt bindings for
 ccree 703
Message-ID: <20181129064218.53qc33vus5anla76@gondor.apana.org.au>
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
 <1542102039-22256-3-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542102039-22256-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 13, 2018 at 09:40:36AM +0000, Gilad Ben-Yossef wrote:
> Add device tree bindings associating Arm TrustZone CryptoCell 703 with the
> ccree driver.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 1 +
>  1 file changed, 1 insertion(+)

Which tree is this patch meant to go through?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
