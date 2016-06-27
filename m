From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv2 06/27] crypto: ahash: increase the maximum allowed
 statesize
Date: Mon, 27 Jun 2016 07:58:43 +0300
Message-ID: <5770B283.8000902@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-7-git-send-email-t-kristo@ti.com>
 <20160624103209.GA19607@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <davem@davemloft.net>, <lokeshvutla@ti.com>,
	<linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49930 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbcF0E7U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Jun 2016 00:59:20 -0400
In-Reply-To: <20160624103209.GA19607@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/06/16 13:32, Herbert Xu wrote:
> On Wed, Jun 22, 2016 at 04:23:39PM +0300, Tero Kristo wrote:
>> The statesize is used to determine the maximum size for saved ahash
>> context. In some cases, this can be much larger than what is currently
>> allocated for it, for example omap-sham driver uses a buffer size of
>> PAGE_SIZE. Increase the statesize to accommodate this.
>>
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>
> Nack.  The exported state is supposed to consist of the actual
> hash state, plus at most one block worth of unhashed data.  It's
> limited so that we can store it on the stack.
>
> So no I'm not taking this patch.
>

Ok, I think I need to allocate the storage space locally then within the 
driver. Would it be ok to call kmalloc / free in the export / import 
implementation of the driver? The size of the unhashed buffer in 
omap-sham is unfortunately rather large.

-Tero
