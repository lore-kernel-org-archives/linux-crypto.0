From: Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] arm64: dts: ls1012a: add crypto node
Date: Fri, 24 Mar 2017 15:34:23 +0800
Message-ID: <20170324073420.GM30608@dragon>
References: <20170322122939.22117-1-horia.geanta@nxp.com>
 <20170324015606.GC30608@dragon>
 <DB4PR04MB0847D837CB2762D5094720CB983E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harninder Rai <harninder.rai@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bhaskar U <bhaskar.upadhaya@nxp.com>,
        Will Deacon <will.deacon@arm.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbdCXHfE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 03:35:04 -0400
Content-Disposition: inline
In-Reply-To: <DB4PR04MB0847D837CB2762D5094720CB983E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 24, 2017 at 07:17:50AM +0000, Horia Geantă wrote:
> >> +		sec_mon: sec_mon@1e90000 {
> > 
> > Hyphen is more preferred to be used in node name than underscore.
> > 
> This would imply changing the
> Documentation/devicetree/bindings/crypto/fsl-sec4.txt binding and
> dealing with all the consequences, which IIUC is probably not worth.

I do not care the bindings doc that much, since I'm not the maintainer
of it.  What are the consequences specifically, if we use a better node
name in dts than bindings example?

Shawn
