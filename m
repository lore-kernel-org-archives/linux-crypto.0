From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v2 3/4] crypto: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Wed, 23 Aug 2017 16:51:09 +0200
Message-ID: <20170823145109.GA7433@linux-mips.org>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
 <20170823025707.27888-4-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@linux-mips.org, malat@debian.org, noloader@gmail.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <20170823025707.27888-4-prasannatsmkumar@gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 23, 2017 at 08:27:06AM +0530, PrasannaKumar Muralidharan wrote:

> Add RNG node to jz4780 dtsi. This driver uses registers that are part of
> the register set used by Ingenic CGU driver. Make RNG node as child of
> CGU node.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
> Changes in v2:
> * Add "syscon" in CGU node's compatible section
> * Make RNG child node of CGU.
> 
>  arch/mips/boot/dts/ingenic/jz4780.dtsi | 6 +++++-

This barely touched arch/mips so probably should be funnelled along with
the rest of the series:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

Or I can take everything.

  Ralf
