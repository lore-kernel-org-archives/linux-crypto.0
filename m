From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2] dt-bindings: rng: clocks property on omap_rng not
 always mandatory
Date: Fri, 24 Mar 2017 08:52:00 -0500
Message-ID: <20170324135200.j7m3zzgphbetqn7p@rob-hp-laptop>
References: <1489755519-32664-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devicetree@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        stable@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35147 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752767AbdCXNwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 09:52:04 -0400
Content-Disposition: inline
In-Reply-To: <1489755519-32664-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 17, 2017 at 01:58:39PM +0100, Thomas Petazzoni wrote:
> Commit 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76
> device variant") update the omap_rng Device Tree binding to add support
> for the IP-76 variation of the IP. As part of this change, a "clocks"
> property was added, but is indicated as "Required", without indicated
> it's actually only required for some compatible strings.
> 
> This commit fixes that, by explicitly stating that the clocks property
> is only required with the inside-secure,safexcel-eip76 compatible
> string.
> 
> Fixes: 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76 device variant")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
> Changes since v1:
>  - Instead of indicating the property as optional, indicate it as
>    mandatory for the inside-secure,safexcel-eip76 compatible string, as
>    suggested by Rob Herring.
> ---
>  Documentation/devicetree/bindings/rng/omap_rng.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>
