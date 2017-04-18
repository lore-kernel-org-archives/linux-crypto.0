From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/4] staging: add ccree crypto driver
Date: Tue, 18 Apr 2017 16:13:55 +0100
Message-ID: <20170418151355.GI17866@leverpostej>
References: <1492524470-13847-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gilad.benyossef@arm.com, Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:58026 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdDRPOW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 11:14:22 -0400
Content-Disposition: inline
In-Reply-To: <1492524470-13847-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Tue, Apr 18, 2017 at 05:07:50PM +0300, Gilad Ben-Yossef wrote:
> Arm TrustZone CryptoCell 700 is a family of cryptographic hardware
> accelerators. It is supported by a long lived series of out of tree
> drivers, which I am now in the process of unifying and upstreaming.
> This is the first drop, supporting the new CryptoCell 712 REE. 
> 
> The code still needs some cleanup before maturing to a proper
> upstream driver, which I am in the process of doing. However,
> as discussion of some of the capabilities of the hardware and
> its application to some dm-crypt and dm-verity features recently
> took place I though it is better to do this in the open via the
> staging tree.
> 
> A Git repository based off of Linux 4.11-rc7 is available at
> https://github.com/gby/linux.git branch ccree.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: Binoy Jayan <binoy.jayan@linaro.org>
> CC: Ofir Drang <ofir.drang@arm.com>
> 
> Gilad Ben-Yossef (4):
>   staging: add ccree crypto driver
>   staging: ccree: add TODO list
>   staging: ccree: add devicetree bindings
>   MAINTAINERS: add Gilad BY as maintainer for ccree
> 
>  .../devicetree/bindings/crypto/arm-cryptocell.txt  |   23 +

I'm interested in looking at the DT binding, but for some reason I've
only recevied the cover letter so far.

Are my mail servers being particularly slow today, or has something gone
wrong with the Cc list for the remaining patches?

Thanks,
Mark.
