From: Martin Kaiser <martin@kaiser.cx>
Subject: Re: [PATCH v2 1/3] Documentation: devicetree: add Freescale RNGC
 binding
Date: Mon, 17 Jul 2017 23:04:25 +0200
Message-ID: <20170717210425.GB15429@reykholt.kaiser.cx>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <20160318194213.GA10766@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Pawel Moll <pawel.moll@arm.com>,
 Ian Campbell <ijc+devicetree@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
 linux-crypto@vger.kernel.org, kernel@pengutronix.de,
 Kumar Gala <galak@codeaurora.org>,
 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>,
 linux-arm-kernel@lists.infradead.org
To: Rob Herring <robh@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20160318194213.GA10766@rob-hp-laptop>
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

Hi,

I'd like to pick this up and get the rngc driver merged finally.

Thus wrote Rob Herring (robh@kernel.org):

> The MXC name is still not dead?

looks like no. There's still CONFIG_ARCH_MXC etc. The other similar rng
driver is called mxc-rnga.c so it makes sense to use mxc-rngc.

> >  1 file changed, 16 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rng/mxc_rngc.txt

> > diff --git a/Documentation/devicetree/bindings/rng/mxc_rngc.txt b/Documentation/devicetree/bindings/rng/mxc_rngc.txt
> > new file mode 100644
> > index 000000000000..e147a6dde40a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rng/mxc_rngc.txt
> > @@ -0,0 +1,16 @@
> > +Freescale RNGC (Random Number Generator Version C)
> > +
> > +Required properties:
> > +- compatible : Should be "fsl,imx25-rng"

> What about i.MX3/5 compatible strings?

I couldn't find an imx5 chip that has this rng. I added a compatible
string for imx35.

Best regards,

   Martin
