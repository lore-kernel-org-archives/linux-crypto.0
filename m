From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/4] crypto: jz4780-rng: Add JZ4780 PRNG devicetree
 binding documentation
Date: Fri, 25 Aug 2017 16:57:34 -0500
Message-ID: <20170825215734.f5rc7fzxpl3ynnwl@rob-hp-laptop>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
 <20170823025707.27888-2-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        mark.rutland@arm.com, ralf@linux-mips.org, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@linux-mips.org, malat@debian.org, noloader@gmail.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <20170823025707.27888-2-prasannatsmkumar@gmail.com>
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

On Wed, Aug 23, 2017 at 08:27:04AM +0530, PrasannaKumar Muralidharan wrote:
> Add devicetree bindings for hardware pseudo random number generator
> present in Ingenic JZ4780 SoC.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
> Changes in v2:
> * Add "syscon" in CGU node's compatible section
> * Make RNG child node of CGU.
> 
>  .../bindings/crypto/ingenic,jz4780-rng.txt           | 20 ++++++++++++++++++++

bindings/rng/ for RNG h/w.

>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
> new file mode 100644
> index 0000000..a0c18e5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
> @@ -0,0 +1,20 @@
> +Ingenic jz4780 RNG driver
> +
> +Required properties:
> +- compatible : Should be "ingenic,jz4780-rng"
> +
> +Example:
> +
> +cgu: jz4780-cgu@10000000 {
> +	compatible = "ingenic,jz4780-cgu", "syscon";
> +	reg = <0x10000000 0x100>;
> +
> +	clocks = <&ext>, <&rtc>;
> +	clock-names = "ext", "rtc";
> +
> +	#clock-cells = <1>;
> +
> +	rng: rng@d8 {

unit-address requires reg property.

> +		compatible = "ingenic,jz480-rng";
> +	};
> +};
> -- 
> 2.10.0
> 
