From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: rng: Add new compatible qcom,prng-v2
Date: Tue, 26 Jun 2018 20:57:43 +0530
Message-ID: <20180626152743.GD22377@vkoul-mobl>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <20180619095430.26358-2-vkoul@kernel.org>
 <20180625190609.GA3586@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        devicetree@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625190609.GA3586@rob-hp-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 25-06-18, 13:06, Rob Herring wrote:
> On Tue, Jun 19, 2018 at 03:24:29PM +0530, Vinod Koul wrote:
> > Later qcom chips support v2 of the prng, so add new compatible
> > qcom,prng-v2 for this.
> > 
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> > ---
> > 
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: devicetree@vger.kernel.org
> >  Documentation/devicetree/bindings/rng/qcom,prng.txt | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/rng/qcom,prng.txt b/Documentation/devicetree/bindings/rng/qcom,prng.txt
> > index 8e5853c2879b..03fd218bd21a 100644
> > --- a/Documentation/devicetree/bindings/rng/qcom,prng.txt
> > +++ b/Documentation/devicetree/bindings/rng/qcom,prng.txt
> > @@ -2,7 +2,8 @@ Qualcomm MSM pseudo random number generator.
> >  
> >  Required properties:
> >  
> > -- compatible  : should be "qcom,prng"
> > +- compatible  : should be "qcom,prng" for 8916 etc
> > +              : should be "qcom,prng-v2" for 8996 and later
> 
> Either use SoC specific compatibles or convince me 'v2' is a meaningful 
> and specific enough version. Some other QC IP has x.y.z versioning for 
> example.

The specs says QC RNG V2 :)

Said that Stephen suggested to make it qcom,prng-ee to point out that we
are pointing to an execution environment in the IP, so will do that
instead unless you have better idea

-- 
~Vinod
