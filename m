From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2] dt-bindings: rng: clocks property on omap_rng not
 always mandatory
Date: Fri, 24 Mar 2017 09:20:26 -0500
Message-ID: <20170324142026.eqkje56aiisgkq3e@rob-hp-laptop>
References: <1489755519-32664-1-git-send-email-thomas.petazzoni@free-electrons.com>
 <20170324135200.j7m3zzgphbetqn7p@rob-hp-laptop>
 <20170324141905.scn7vrzrcrmzplk5@rob-hp-laptop>
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
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170324141905.scn7vrzrcrmzplk5@rob-hp-laptop>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 24, 2017 at 09:19:05AM -0500, Rob Herring wrote:
> On Fri, Mar 24, 2017 at 08:52:00AM -0500, Rob Herring wrote:
> > On Fri, Mar 17, 2017 at 01:58:39PM +0100, Thomas Petazzoni wrote:
> > > Commit 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76
> > > device variant") update the omap_rng Device Tree binding to add support
> > > for the IP-76 variation of the IP. As part of this change, a "clocks"
> > > property was added, but is indicated as "Required", without indicated
> > > it's actually only required for some compatible strings.
> > > 
> > > This commit fixes that, by explicitly stating that the clocks property
> > > is only required with the inside-secure,safexcel-eip76 compatible
> > > string.
> > > 
> > > Fixes: 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76 device variant")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > > ---
> > > Changes since v1:
> > >  - Instead of indicating the property as optional, indicate it as
> > >    mandatory for the inside-secure,safexcel-eip76 compatible string, as
> > >    suggested by Rob Herring.
> > > ---
> > >  Documentation/devicetree/bindings/rng/omap_rng.txt | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Acked-by: Rob Herring <robh@kernel.org>
> 
> And applied.

Ah, I see Herbert applied it, so I've dropped it.

Rob
