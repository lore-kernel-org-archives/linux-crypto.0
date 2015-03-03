From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/3] crypto: caam_rng: fix rng_unmap_ctx's DMA_UNMAP
 size problem
Date: Tue, 3 Mar 2015 13:31:20 -0600
Message-ID: <20150303133120.6706da49d0f7188a8213fe36@freescale.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
	<1425365453-19358-3-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: <yanjiang.jin@windriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425365453-19358-3-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 3 Mar 2015 14:50:52 +0800
<yanjiang.jin@windriver.com> wrote:

> -		dma_unmap_single(jrdev, ctx->sh_desc_dma, DESC_RNG_LEN,
> -				 DMA_TO_DEVICE);
> +		dma_unmap_single(jrdev, ctx->sh_desc_dma,
> +				desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);

alignment: the 'd' in desc_bytes should fall directly under the 'j'
in jrdev.

Also, DESC_RNG_LEN should be corrected to (4 * CAAM_CMD_SZ).

Kim
