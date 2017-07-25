From: Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 0/4] crypto: caam - add Job Ring support for DPAA2 parts
Date: Tue, 25 Jul 2017 21:50:02 +0800
Message-ID: <20170725135000.GC29754@dragon>
References: <20170718153050.15330-1-horia.geanta@nxp.com>
 <20170725132129.GB29754@dragon>
 <VI1PR0401MB2591E386907CD8EA92DED08498B80@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Douglass <dan.douglass@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbdGYNuq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 09:50:46 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2591E386907CD8EA92DED08498B80@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 25, 2017 at 01:31:52PM +0000, Horia Geantă wrote:
> On 7/25/2017 4:22 PM, Shawn Guo wrote:
> > On Tue, Jul 18, 2017 at 06:30:46PM +0300, Horia Geantă wrote:
> >> This patch set adds support for CAAM's legacy Job Ring backend / interface
> >> on platforms having DPAA2 (Datapath Acceleration Architecture v2), like
> >> LS1088A or LS2088A.
> >>
> >> I would like to get the DT patches through the crypto list (to make sure
> >> they don't end up merged before driver support).
> > 
> > Unless it's really urgent (usually critical bug fix), the DTS patches
> > should go through arm-soc tree.  We usually take DTS patches after the
> > driver counterpart has been accepted by subsystem maintainers, or in the
> > best case, has landed on mainline.
> 
> Thanks for the clarification.
> 
> Do I have to re-post the DTS patches once the driver is accepted or a
> ping should suffice or...?

A ping is sufficient.

Shawn
