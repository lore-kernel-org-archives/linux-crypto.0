From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 1/3] crypto: brcm: DT documentation for Broadcom SPU
 hardware
Date: Mon, 30 Jan 2017 14:18:17 -0600
Message-ID: <20170130201817.hcawwnn2rapuguj4@rob-hp-laptop>
References: <1485362689-11294-1-git-send-email-rob.rice@broadcom.com>
 <1485362689-11294-2-git-send-email-rob.rice@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Steve Lin <steven.lin1@broadcom.com>
To: Rob Rice <rob.rice@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35053 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752256AbdA3UST (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 15:18:19 -0500
Content-Disposition: inline
In-Reply-To: <1485362689-11294-2-git-send-email-rob.rice@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 25, 2017 at 11:44:47AM -0500, Rob Rice wrote:
> Device tree documentation for Broadcom Secure Processing Unit
> (SPU) crypto hardware.
> 
> Signed-off-by: Steve Lin <steven.lin1@broadcom.com>
> Signed-off-by: Rob Rice <rob.rice@broadcom.com>
> ---
>  .../devicetree/bindings/crypto/brcm,spu-crypto.txt | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt

Acked-by: Rob Herring <robh@kernel.org>
