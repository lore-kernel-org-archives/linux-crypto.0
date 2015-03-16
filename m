From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue handling
Date: Mon, 16 Mar 2015 12:02:51 +0200
Message-ID: <5506AA4B.303@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-6-git-send-email-mort@bork.org>
 <20150303182332.546523088b5891a776880c0f@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0127.outbound.protection.outlook.com ([65.55.169.127]:15184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751345AbbCPKDI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2015 06:03:08 -0400
In-Reply-To: <20150303182332.546523088b5891a776880c0f@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/4/2015 2:23 AM, Kim Phillips wrote:
> Only potential problem is getting the crypto API to set the GFP_DMA
> flag in the allocation request, but presumably a
> CRYPTO_TFM_REQ_DMA crt_flag can be made to handle that.

Seems there are quite a few places that do not use the
{aead,ablkcipher_ahash}_request_alloc() API to allocate crypto requests.
Among them, IPsec and dm-crypt.
I've looked at the code and I don't think it can be converted to use
crypto API.

This means that the CRYPTO_TFM_REQ_DMA would be visible to all of these
places. Some of the maintainers do not agree, as you've seen.

An alternative would be for talitos to use the page allocator to get 1 /
2 pages at probe time (4 channels x 32 entries/channel x 64B/descriptor
= 8 kB), dma_map_page the area and manage it internally for talitos_desc
hw descriptors.
What do you think?

Thanks,
Horia
