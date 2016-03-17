From: okaya@codeaurora.org
Subject: Re: [PATCH 1/3] crypto: marvell/cesa - replace dma_to_phys with
 dma_map_single
Date: Thu, 17 Mar 2016 19:17:24 -0400
Message-ID: <80402e2f82651814b1411a25b1740288@codeaurora.org>
References: <1458252137-24497-1-git-send-email-okaya@codeaurora.org>
 <20160317225459.GA19428@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, timur@codeaurora.org,
	cov@codeaurora.org, nwatters@codeaurora.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48400 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030931AbcCQXR0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Mar 2016 19:17:26 -0400
In-Reply-To: <20160317225459.GA19428@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016-03-17 18:54, Russell King - ARM Linux wrote:
> On Thu, Mar 17, 2016 at 06:02:15PM -0400, Sinan Kaya wrote:
>> Getting ready to remove dma_to_phys API. Drivers should not be
>> using this API for DMA operations. Instead, they should go
>> through the dma_map or dma_alloc APIs.
>> 
>> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
>> ---
>>  drivers/crypto/marvell/cesa.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/crypto/marvell/cesa.c 
>> b/drivers/crypto/marvell/cesa.c
>> index c0656e7..52ddfa4 100644
>> --- a/drivers/crypto/marvell/cesa.c
>> +++ b/drivers/crypto/marvell/cesa.c
>> @@ -350,8 +350,8 @@ static int mv_cesa_get_sram(struct platform_device 
>> *pdev, int idx)
>>  	if (IS_ERR(engine->sram))
>>  		return PTR_ERR(engine->sram);
>> 
>> -	engine->sram_dma = phys_to_dma(cesa->dev,
>> -				       (phys_addr_t)res->start);
>> +	engine->sram_dma = dma_map_single(cesa->dev, engine->sram,
>> +					  DMA_TO_DEVICE);
> 
> Documentation/DMA-API.txt
> 
> dma_addr_t
> dma_map_single(struct device *dev, void *cpu_addr, size_t size,
>                       enum dma_data_direction direction)
> 
> Notes:  Not all memory regions in a machine can be mapped by this API.
> Further, contiguous kernel virtual space may not be contiguous as
> physical memory.  Since this API does not provide any scatter/gather
> capability, it will fail if the user tries to map a non-physically
> contiguous piece of memory.  For this reason, memory to be mapped by
> this API should be obtained from sources which guarantee it to be
> physically contiguous (like kmalloc).
> 
> Specifically, ioremapped memory will *not* work as you expect with
> dma_map_single().


What is the correct way? I don't want to write engine->sram_dma = sram
