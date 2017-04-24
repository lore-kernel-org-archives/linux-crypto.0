From: Igal Liberman <igall@marvell.com>
Subject: RE: [PATCH v3 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Mon, 24 Apr 2017 08:50:32 +0000
Message-ID: <8ff65d6a5e5e4d388d3c5a384e4f5fd6@IL-EXCH01.marvell.com>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-3-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "thomas.petazzoni@free-electrons.com"
 <thomas.petazzoni@free-electrons.com>,
 "boris.brezillon@free-electrons.com" <boris.brezillon@free-electrons.com>,
 Nadav Haklai <nadavh@marvell.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 Ofer Heifetz <oferh@marvell.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "davem@davemloft.net" <davem@davemloft.net>, "jason@lakedaemon.net"
 <jason@lakedaemon.net>, "andrew@lunn.ch" <andrew@lunn.ch>,
 "gregory.clement@free-electrons.com" <gregory.clement@free-electrons.com>,
 "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170424075407.19730-3-antoine.tenart@free-electrons.com>
Content-Language: en-US
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

[...]

> +	priv->clk = of_clk_get(dev->of_node, 0);
> +	if (!IS_ERR(priv->clk)) {
> +		ret = clk_prepare_enable(priv->clk);
> +		if (ret) {
> +			dev_err(dev, "unable to enable clk (%d)\n", ret);
> +			return ret;
> +		}
> +	} else {
> +		/* The clock isn't mandatory */
> +		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +	}
> +
> +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));

The correct address width of the engine in Marvell SoCs is 40bit.

> +	if (ret)
> +		goto err_clk;
> +
> +	priv->context_pool = dmam_pool_create("safexcel-context", dev,
> +					      sizeof(struct
> safexcel_context_record),
> +					      1, 0);
> +	if (!priv->context_pool) {
> +		ret = -ENOMEM;
> +		goto err_clk;
> +	}
> +

Thanks,
Igal
