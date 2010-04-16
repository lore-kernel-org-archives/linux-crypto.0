From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Fri, 16 Apr 2010 10:44:37 +0300
Message-ID: <4BC81565.8040808@nokia.com>
References: <4BC443DB.1030602@nokia.com> <20100413120243.GA10822@gondor.apana.org.au> <4BC46ADB.3000501@nokia.com> <20100413144527.GC12695@gondor.apana.org.au> <4BC48AE1.4010103@jdland.co.il> <4BC48C08.7040608@nokia.com> <20100414004453.GA18044@gondor.apana.org.au> <4BC562BB.4040800@nokia.com> <20100414064423.GA20555@gondor.apana.org.au> <4BC565EA.2090109@nokia.com> <20100414065500.GA20713@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52948 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0DPHpf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Apr 2010 03:45:35 -0400
In-Reply-To: <20100414065500.GA20713@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

crypto_ahash_update()
crypto_ahash_dinup()
crypto_ahash_final()

obviously might need to return -EINPROGRESS

but can
crypto_ahash_init(req)

be synchronous?

Or it could also return EINPROGRESS, though not sense.

- Dmitry


On 14/04/10 09:55, ext Herbert Xu wrote:
> On Wed, Apr 14, 2010 at 09:51:22AM +0300, Dmitry Kasatkin wrote:
>    
>> What do you mean by "merge operation".
>> request merging?
>>      
> By buffering user data, you're in essence merging requests.
>
> I have no objections to doing that, but let's not do it in every
> driver.
>
> Of course, the ultimate solution is for the end-user to produce
> requests that do not need merging.  So when considering this we
> need to be aware of what users are being targeted.
>
> Thanks,
>    
