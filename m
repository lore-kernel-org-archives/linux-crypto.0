From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv2 06/27] crypto: ahash: increase the maximum allowed
 statesize
Date: Mon, 4 Jul 2016 12:27:00 +0300
Message-ID: <577A2BE4.1090202@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-7-git-send-email-t-kristo@ti.com>
 <20160624103209.GA19607@gondor.apana.org.au> <5770B283.8000902@ti.com>
 <20160627050031.GA5673@gondor.apana.org.au> <577A298E.4040803@ti.com>
 <20160704091925.GA31964@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <davem@davemloft.net>, <lokeshvutla@ti.com>,
	<linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40154 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbcGDJ1e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 05:27:34 -0400
In-Reply-To: <20160704091925.GA31964@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/07/16 12:19, Herbert Xu wrote:
> On Mon, Jul 04, 2016 at 12:17:02PM +0300, Tero Kristo wrote:
>>
>> I need some clarification on this, afaik request_alloc related
>> functionality only works per-request basis. The export / import
>> functionality however is supposed to work across multiple requests.
>> The test code for example does this:
>
> Why are you trying to allocate memory in export/import at all?
> The preferred approach is to unconditionally allocate the memory
> in ahash_request_alloc.

The driver allocates a largish buffer for copying the input data from 
the sgs into a sequential space. If I don't save the contents of this 
buffer anywhere, the export/import doesn't work as expected it seems.

Actually I am now wondering why the driver allocates this sequential 
buffer at all, DMA should be possible to use over the sgs just fine, at 
least some other crypto drivers are doing this.

-Tero
