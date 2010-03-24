From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Wed, 24 Mar 2010 09:31:51 +0200
Message-ID: <4BA9BFE7.3080209@nokia.com>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com> <20100323113239.GA29837@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53734 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0CXHnc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Mar 2010 03:43:32 -0400
In-Reply-To: <20100323113239.GA29837@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 23/03/10 13:32, ext Herbert Xu wrote:
> On Wed, Mar 17, 2010 at 03:12:49PM +0200, Dmitry Kasatkin wrote:
>    
>> Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
>> was not ported to new crypto APIs and removed from the source tree.
>>
>> This driver implements async and sync crypto API.
>>
>> It still contains pr_debug() for debugging purpose.
>> Will be remove for integration.
>>
>> Dmitry Kasatkin (2):
>>    sec: omap sha1&  md5 driver
>>    sec: Makefile/Kconfig update for omap sha1 md5 driver
>>      
> It looks good to me as far as the Crypto API is concerned.
>
> My only question is what's your plan with respect to HMAC? If
> you're going to do it in hardware then it's fine as it is.
>
> Otherwise you need to implement export/import and we also need
> to add ahash support to hmac.c.
>
> Thanks,
>    

Hello,

Thanks for looking to it.

No hw is not doing hmac.
I need to look to this then.

Will comeback in a while.

- Dmitry



