From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/3] fix some CAAM warnings.
Date: Tue, 3 Mar 2015 15:39:49 +0200
Message-ID: <54F5B9A5.5080300@freescale.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <kim.phillips@freescale.com>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: <yanjiang.jin@windriver.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3/3/2015 8:50 AM, yanjiang.jin@windriver.com wrote:
> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> Hi,
> 
> This patch series  fix some CAAM compile and runtime warnings.
> The patches 0001 and 0002 are same as V1.
> 
> I have tested this on fsl-p5020ds board using upstream 4.0.0-rc1+ with the below configs:
> 
> CONFIG_DMA_API_DEBUG=y
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> 
> Change log:
> v2:
> 
> Abandon the v1 patch 0003-crypto-caamhash-add-two-missed-dma_mapping_error.patch.
> Replace the v1 patch 0004-crypto-caamhash-replace-kmalloc-with-kzalloc.patch with the new
> patch 0003-crypto-caamhash-fix-uninitialized-edesc-sec4_sg_byte.patch.
> 
> Yanjiang Jin (3):
>   crypto: caam: fix some compile warnings
>   crypto: caam_rng: fix rng_unmap_ctx's DMA_UNMAP size problem
>   crypto: caamhash: - fix uninitialized edesc->sec4_sg_bytes field
> 
>  drivers/crypto/caam/caamhash.c   | 1 +
>  drivers/crypto/caam/caamrng.c    | 4 ++--
>  drivers/crypto/caam/sg_sw_sec4.h | 8 ++++----
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 

For the series
Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

Thanks!
Horia
