From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/2] dt/bindings: Add bindings for hisilicon random
 number generator
Date: Mon, 11 Apr 2016 09:43:06 -0500
Message-ID: <20160411144306.GA24637@rob-hp-laptop>
References: <1460017397-30996-1-git-send-email-wangkefeng.wang@huawei.com>
 <1460017397-30996-2-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	xuwei5@hisilicon.com, Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, guohanjun@huawei.com
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51440 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbcDKOnM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Apr 2016 10:43:12 -0400
Content-Disposition: inline
In-Reply-To: <1460017397-30996-2-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 07, 2016 at 04:23:16PM +0800, Kefeng Wang wrote:
> Document the devicetree bindings for the random number generator found
> on Hisilicon Hip04 and Hip05 soc.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  Documentation/devicetree/bindings/rng/hisi-rng.txt | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
> 
> diff --git a/Documentation/devicetree/bindings/rng/hisi-rng.txt b/Documentation/devicetree/bindings/rng/hisi-rng.txt
> new file mode 100644
> index 0000000..72efcc1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/hisi-rng.txt
> @@ -0,0 +1,12 @@
> +Hisilicon Random Number Generator
> +
> +Required properties:
> +- compatible : Should be "hisilicon,rng"
> +- reg : Offset and length of the register set of this block
> +
> +Example:
> +
> +rng@d1010000 {
> +	compatible = "hisilicon,rng";

This still needs SoC specific compatible strings.

> +	reg = <0xd1010000 0x100>;
> +};
> -- 
> 2.6.0.GIT
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
