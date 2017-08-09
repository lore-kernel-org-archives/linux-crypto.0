From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 1/4] dt-bindings: crypto: add ARTPEC crypto
Date: Wed, 9 Aug 2017 18:26:20 -0500
Message-ID: <20170809232620.xvygh4bhyfyfuoqq@rob-hp-laptop>
References: <cover.1501830919.git.larper@axis.com>
 <b493a0eb939fe97f7e604c0c83916e0dac1d2bce.1501830919.git.larper@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        mark.rutland@arm.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Persson <larper@axis.com>
To: Lars Persson <lars.persson@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:38646 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752091AbdHIX0W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 19:26:22 -0400
Content-Disposition: inline
In-Reply-To: <b493a0eb939fe97f7e604c0c83916e0dac1d2bce.1501830919.git.larper@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 04, 2017 at 09:18:45AM +0200, Lars Persson wrote:
> Document the device tree bindings for the ARTPEC crypto accelerator on
> ARTPEC-6 and ARTPEC-7 SoCs.
> 
> Signed-off-by: Lars Persson <larper@axis.com>
> ---
>  .../devicetree/bindings/crypto/artpec6-crypto.txt        | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/artpec6-crypto.txt

I acked v2. Please add acks when posting new versions.

Acked-by: Rob Herring <robh@kernel.org>
