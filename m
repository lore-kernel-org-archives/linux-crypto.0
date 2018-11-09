Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37376 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKITb6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:31:58 -0500
Date: Fri, 9 Nov 2018 17:51:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        Gadam Sreerama <sgadam@cavium.com>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cavium/nitrox - fix a DMA pool free failure
Message-ID: <20181109095145.irclkx232fq3ahqv@gondor.apana.org.au>
References: <1539910247-9250-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539910247-9250-1-git-send-email-wang6495@umn.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 18, 2018 at 07:50:43PM -0500, Wenwen Wang wrote:
> In crypto_alloc_context(), a DMA pool is allocated through dma_pool_alloc()
> to hold the crypto context. The meta data of the DMA pool, including the
> pool used for the allocation 'ndev->ctx_pool' and the base address of the
> DMA pool used by the device 'dma', are then stored to the beginning of the
> pool. These meta data are eventually used in crypto_free_context() to free
> the DMA pool through dma_pool_free(). However, given that the DMA pool can
> also be accessed by the device, a malicious device can modify these meta
> data, especially when the device is controlled to deploy an attack. This
> can cause an unexpected DMA pool free failure.
> 
> To avoid the above issue, this patch introduces a new structure
> crypto_ctx_hdr and a new field chdr in the structure nitrox_crypto_ctx hold
> the meta data information of the DMA pool after the allocation. Note that
> the original structure ctx_hdr is not changed to ensure the compatibility.
> 
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_algs.c | 12 +++++++-----
>  drivers/crypto/cavium/nitrox/nitrox_lib.c  | 22 +++++++++++++++++-----
>  drivers/crypto/cavium/nitrox/nitrox_req.h  |  7 +++++++
>  3 files changed, 31 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
