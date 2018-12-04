Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39738 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbeLDUOe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 15:14:34 -0500
Date: Tue, 4 Dec 2018 14:14:31 -0600
From: Rob Herring <robh@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Yael Chemla <yael.chemla@foss.arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: crypto: ccree: add dt bindings for
 ccree 703
Message-ID: <20181204201431.GA15089@bogus>
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
 <1542102039-22256-3-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542102039-22256-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 13 Nov 2018 09:40:36 +0000, Gilad Ben-Yossef wrote:
> Add device tree bindings associating Arm TrustZone CryptoCell 703 with the
> ccree driver.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
