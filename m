From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3] crypto: caam: fix some compile warnings
Date: Tue, 3 Mar 2015 12:59:53 -0600
Message-ID: <20150303125953.8585904680288a9734566b42@freescale.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
	<1425365453-19358-2-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: <yanjiang.jin@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:58753
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756375AbbCCVhb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 16:37:31 -0500
In-Reply-To: <1425365453-19358-2-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 3 Mar 2015 14:50:51 +0800
<yanjiang.jin@windriver.com> wrote:

> This commit is to avoid the below warnings:
> 
> drivers/crypto/caam/sg_sw_sec4.h:88:12: warning:
> 'dma_map_sg_chained' defined but not used [-Wunused-function]
>  static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>             ^
> drivers/crypto/caam/sg_sw_sec4.h:104:12: warning:
> 'dma_unmap_sg_chained' defined but not used [-Wunused-function]
>  static int dma_unmap_sg_chained(struct device *dev,
>             ^

I'm not seeing these warnings - both caamalg.c and caamhash.c use
those functions fine.

> -static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
> +static inline int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>  			      unsigned int nents, enum dma_data_direction dir,
>  			      bool chained)

not to mention this isn't how to fix a defined but not used warning:
marking the functions inline results in different compiler output.

NACK from me.

Kim
