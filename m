From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/3] dt: Add DT bindings documentation for SUNXI Security System
Date: Sat, 24 May 2014 21:43:42 +0200
Message-ID: <201405242143.42693.marex@denx.de>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <201405241321.32147.marex@denx.de> <5380F0E3.7020008@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
	devicetree@vger.kernel.org, linux@arm.linux.org.uk,
	herbert@gondor.apana.org.au, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, rdunlap@infradead.org,
	linux-kernel@vger.kernel.org, robh+dt@kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, galak@codeaurora.org,
	grant.likely@linaro.org, maxime.ripard@free-electrons.com,
	davem@davemloft.net
To: Tomasz Figa <tomasz.figa@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:42409 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaEXToe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 May 2014 15:44:34 -0400
In-Reply-To: <5380F0E3.7020008@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday, May 24, 2014 at 09:20:03 PM, Tomasz Figa wrote:
> Hi Marek,
> 
> On 24.05.2014 13:21, Marek Vasut wrote:
> > On Thursday, May 22, 2014 at 05:09:54 PM, LABBE Corentin wrote:
> > 
> > Missing commit message. Please fix this and send a V2.
> > 
> >> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> >> ---
> >> 
> >>  Documentation/devicetree/bindings/crypto/sunxi-ss.txt | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>  create mode 100644
> >>  Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> >> b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt new file mode
> >> 100644
> >> index 0000000..356563b
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> >> @@ -0,0 +1,9 @@
> >> +* Allwinner Security System found on A20 SoC
> >> +
> >> +Required properties:
> >> +- compatible : Should be "allwinner,sun7i-a20-crypto".
> > 
> > Why sun7i-a20 ? Is the crypto unit different in other sunxi chips ? Can
> > that not be described by DT props ?
> 
> A widely used convention is to define compatible strings after first
> SoCs on which particular IP blocks appear. It is quite common among IP
> blocks for which there is no well defined versioning scheme.

Well yeah, that's fine. But in this case, "sun7i" is the entire group of CPUs 
manufactured by AW. I find that information redundant, the "allwinner,a20-
crypto" would suffice. But I wonder if that IP block might have appeared even 
earlier ? Or if it is CPU family specific, thus "allwinner,sun7i-crypto" would 
be a better string ?

Best regards,
Marek Vasut
