From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue
 handling
Date: Tue, 3 Mar 2015 18:23:32 -0600
Message-ID: <20150303182332.546523088b5891a776880c0f@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-6-git-send-email-mort@bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
	Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
To: Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0114.outbound.protection.outlook.com ([157.56.111.114]:59520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753486AbbCDA2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 19:28:53 -0500
In-Reply-To: <1425388897-5434-6-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue,  3 Mar 2015 08:21:37 -0500
Martin Hicks <mort@bork.org> wrote:

> @@ -1170,6 +1237,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>  						     edesc->dma_len,
>  						     DMA_BIDIRECTIONAL);
>  	edesc->req.desc = &edesc->desc;
> +	/* A copy of the crypto_async_request to use the crypto_queue backlog */
> +	memcpy(&edesc->req.base, areq, sizeof(struct crypto_async_request));

this seems backward, or, at least can be done more efficiently IMO:
talitos_cra_init should set the tfm's reqsize so the rest of
the driver can wholly embed its talitos_edesc (which should also
wholly encapsulate its talitos_request (i.e., not via a pointer))
into the crypto API's request handle allocation.  This
would absorb and eliminate the talitos_edesc kmalloc and frees, the
above memcpy, and replace the container_of after the
crypto_dequeue_request with an offset_of, right?

When scatter-gather buffers are needed, we can assume a slower-path
and make them do their own allocations, since their sizes vary
depending on each request.  Of course, a pointer to those
allocations would need to be retained somewhere in the request
handle.

Only potential problem is getting the crypto API to set the GFP_DMA
flag in the allocation request, but presumably a
CRYPTO_TFM_REQ_DMA crt_flag can be made to handle that.

Kim
