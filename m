Return-Path: <SRS0=rgpc=NK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36316 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbeJaHQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Oct 2018 03:16:02 -0400
Date: Tue, 30 Oct 2018 17:20:42 -0500
From: Rob Herring <robh@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: crypto: ccree: add ccree 713
Message-ID: <20181030222042.GA6716@bogus>
References: <1540806616-5483-1-git-send-email-gilad@benyossef.com>
 <1540806616-5483-3-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540806616-5483-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 29 Oct 2018 09:50:13 +0000, Gilad Ben-Yossef wrote:
> Add device tree bindings associating Arm TrustZone CryptoCell 713 with the
> ccree driver.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
