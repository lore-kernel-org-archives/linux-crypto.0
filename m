From: Martin Kaiser <martin@kaiser.cx>
Subject: Re: [PATCH v2 2/3] ARM: i.MX25: add RNGC node to dtsi
Date: Mon, 17 Jul 2017 23:05:23 +0200
Message-ID: <20170717210523.GC15429@reykholt.kaiser.cx>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1457705200-16951-2-git-send-email-s.trumtrar@pengutronix.de>
 <20160401085259.GH18833@tiger>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Pawel Moll <pawel.moll@arm.com>,
 Ian Campbell <ijc+devicetree@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
 Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
 kernel@pengutronix.de, Kumar Gala <galak@codeaurora.org>,
 Steffen Trumtrar <s.trumtrar@pengutronix.de>,
 linux-arm-kernel@lists.infradead.org
To: Shawn Guo <shawnguo@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20160401085259.GH18833@tiger>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Dear all,

I'd like to pick this up and get the rgnc driver merged.

Thus wrote Shawn Guo (shawnguo@kernel.org):

> > +			rng: rng@53fb0000 {
> > +				compatible = "fsl,imx25-rng";
> > +				reg = <0x53fb0000 0x4000>;
> > +				clocks = <&clks 109>;
> > +				clock-names = "ipg";

> I think clock-names can be dropped too.

done. I'll upload a new version shortly.

Best regards,
Martin
