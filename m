From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/3] Documentation: devicetree: add Freescale RNGC binding
Date: Thu, 3 Mar 2016 17:56:14 -0600
Message-ID: <20160303235614.GA23064@rob-hp-laptop>
References: <1456761156-27664-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45589 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbcCCX4U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 18:56:20 -0500
Content-Disposition: inline
In-Reply-To: <1456761156-27664-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 29, 2016 at 04:52:34PM +0100, Steffen Trumtrar wrote:
> Add binding documentation for the Freescale RNGC found on
> some i.MX2/3/5 SoCs.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/rng/mxc_rngc.txt | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/mxc_rngc.txt

Acked-by: Rob Herring <robh@kernel.org>
