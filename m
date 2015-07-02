From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH 09/10] crypto: omap-aes: gcm: Add support for PIO mode
Date: Thu, 2 Jul 2015 15:47:59 +0530
Message-ID: <55950FD7.8080803@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com> <1435814320-30347-10-git-send-email-lokeshvutla@ti.com> <20150702080636.GH4033@saruman.tx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: <balbi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46266 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbbGBKSJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 06:18:09 -0400
In-Reply-To: <20150702080636.GH4033@saruman.tx.rr.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 02 July 2015 01:36 PM, Felipe Balbi wrote:
> On Thu, Jul 02, 2015 at 10:48:39AM +0530, Lokesh Vutla wrote:
>> Add support for PIO mode for GCM mode.
>>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> 
> why do you require PIO ? Is there any situation where DMA can't be
> used? What would that case be ?

Cannot think of any case where DMA can't be used.
But the current driver already supports PIO for all other AES modes.
I do not want to break it, so added support for PIO  for GCM :)

Thanks and regards,
Lokesh
