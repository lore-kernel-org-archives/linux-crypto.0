From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH V4 2/2] ARM: dts: imx7s: add snvs rtc clock
Date: Thu, 11 Jan 2018 16:11:45 -0600
Message-ID: <20180111221145.7bmkxsqmx7qjw3tq@rob-hp-laptop>
References: <1515491526-14060-1-git-send-email-Anson.Huang@nxp.com>
 <1515491526-14060-2-git-send-email-Anson.Huang@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk,
        mturquette@baylibre.com, sboyd@codeaurora.org,
        adriana.reus@nxp.com, stefan@agner.ch, dongas86@gmail.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
To: Anson Huang <Anson.Huang@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33205 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933167AbeAKWLr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 17:11:47 -0500
Content-Disposition: inline
In-Reply-To: <1515491526-14060-2-git-send-email-Anson.Huang@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 09, 2018 at 05:52:06PM +0800, Anson Huang wrote:
> Add i.MX7 SNVS RTC clock.
> 
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> ---
> change since v3:
> 	add optional for clocks in binding doc statement.
>  Documentation/devicetree/bindings/crypto/fsl-sec4.txt | 17 +++++++++++++++++
>  arch/arm/boot/dts/imx7s.dtsi                          |  2 ++
>  2 files changed, 19 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
