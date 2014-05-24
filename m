From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/3] dt: Add DT bindings documentation for SUNXI Security System
Date: Sat, 24 May 2014 21:59:30 +0200
Message-ID: <201405242159.30505.marex@denx.de>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <201405242143.42693.marex@denx.de> <5380F85F.7020601@gmail.com>
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
Received: from mail-out.m-online.net ([212.18.0.9]:47244 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaEXT75 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 May 2014 15:59:57 -0400
In-Reply-To: <5380F85F.7020601@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday, May 24, 2014 at 09:51:59 PM, Tomasz Figa wrote:
[...]
> >>> Why sun7i-a20 ? Is the crypto unit different in other sunxi chips ? Can
> >>> that not be described by DT props ?
> >> 
> >> A widely used convention is to define compatible strings after first
> >> SoCs on which particular IP blocks appear. It is quite common among IP
> >> blocks for which there is no well defined versioning scheme.
> > 
> > Well yeah, that's fine. But in this case, "sun7i" is the entire group of
> > CPUs manufactured by AW. I find that information redundant, the
> > "allwinner,a20- crypto" would suffice. But I wonder if that IP block
> > might have appeared even earlier ? Or if it is CPU family specific, thus
> > "allwinner,sun7i-crypto" would be a better string ?
> 
> I'm not aware of Allwinner naming schemes too much, so please correct me
> if I'm wrong, but if A20 implies sun7i, then "allwinner,a20-crypto"
> would be better indeed.

True.

> Whether it was really the first SoC is another thing. Obviously this
> needs to be checked, although it isn't really that important. For this
> particular naming scheme you need to specify all the SoCs for which
> given compatible string can be used for this IP anyway, because there is
> usually no other source of information about this available (except
> directly comparing two datasheets...).

Better get the DT stuff correctly right from the start. That's why I'm asking 
what chips contains the IP block, so we can guess the right name.

Best regards,
Marek Vasut
