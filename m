From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/2] dt/bindings: Add bindings for hisilicon random
 number generator
Date: Mon, 4 Apr 2016 00:15:49 -0500
Message-ID: <20160404051549.GF17806@rob-hp-laptop>
References: <1459474664-11264-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, xuwei5@hisilicon.com,
 linux-crypto@vger.kernel.org, guohanjun@huawei.com,
 linux-arm-kernel@lists.infradead.org
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1459474664-11264-1-git-send-email-wangkefeng.wang@huawei.com>
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

On Fri, Apr 01, 2016 at 09:37:43AM +0800, Kefeng Wang wrote:
> Document the devicetree bindings for the random number generator
> found on Hisilicon Hip04 and Hip05 soc.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  Documentation/devicetree/bindings/rng/hisi-rng.txt | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
> 
> diff --git a/Documentation/devicetree/bindings/rng/hisi-rng.txt b/Documentation/devicetree/bindings/rng/hisi-rng.txt
> new file mode 100644
> index 0000000..80f29b6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/hisi-rng.txt
> @@ -0,0 +1,12 @@
> +Hisilicon Random Number Generator
> +
> +Required properties:
> +- compatible : Should be "hisilicon,hisi-rng"

hisi is a bit redundant with hisilicon and please define SoC specific 
compatible strings.

> +- reg : Offset and length of the register set of this block
> +
> +Example:
> +
> +rng@d1010000 {
> +	compatible = "hisilicon,hisi-rng";
> +	reg = <0xd1010000 0x100>;
> +};
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
