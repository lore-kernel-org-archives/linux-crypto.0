From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 2/2] crypto: tcrypt: Fix linkage error on ARM on division
 of s64
Date: Tue, 28 Jun 2016 10:49:12 +0200
Message-ID: <57723A08.1010704@samsung.com>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
 <20160628084138.GD15985@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60605 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbcF1ItT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 04:49:19 -0400
In-reply-to: <20160628084138.GD15985@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/28/2016 10:41 AM, Herbert Xu wrote:
> On Tue, Jun 28, 2016 at 09:23:07AM +0200, Krzysztof Kozlowski wrote:
>> gcc 4.7.3 for ARM on Ubuntu couldn't link tcrypt module because of
>> division of s64:
>> 	ERROR: "__aeabi_ldivmod" [crypto/tcrypt.ko] undefined!
>>
>> Fixes: 087bcd225c56 ("crypto: tcrypt - Add speed tests for SHA multibuffer algorithms")
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> I'd prefer to be consistent here and just use unsigned long like
> every other speed test in tcrypt.  This code has some serious
> issues, such as not waiting for completion in case of an error.
> 
> Let me try to fix them up.
> 
> Thanks!
> 
> ---8<---
> Subject: crypto: tcrypt - Use unsigned long for mb ahash cycle counter
> 
> For the timescales we are working against there is no need to
> go beyond unsigned long.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Works fine for me:

Reported-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof
