From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/3] Documentation: devicetree: add Freescale SCC bindings
Date: Fri, 12 Feb 2016 10:37:42 -0600
Message-ID: <20160212163742.GA6769@rob-hp-laptop>
References: <1455199485-24458-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36185 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbcBLQhr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2016 11:37:47 -0500
Content-Disposition: inline
In-Reply-To: <1455199485-24458-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 11, 2016 at 03:04:43PM +0100, Steffen Trumtrar wrote:
> Add documentation for the Freescale Security Controller (SCC)
> found on i.MX25 SoCs.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  .../devicetree/bindings/crypto/fsl-imx-scc.txt          | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt

Acked-by: Rob Herring <robh@kernel.org>
