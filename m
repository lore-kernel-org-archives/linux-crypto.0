From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Tue, 13 Apr 2010 18:33:59 +0300
Message-ID: <4BC48EE7.5000306@nokia.com>
References: <1270744533.1666.9.camel@Nokia-N900> <20100413085921.GA8988@gondor.apana.org.au> <4BC43BEB.90901@nokia.com> <20100413100308.GA9600@gondor.apana.org.au> <4BC44446.2010405@nokia.com> <20100413121004.GB10822@gondor.apana.org.au> <4BC47543.1020508@nokia.com> <4BC48178.4020104@nokia.com> <20100413144250.GB12695@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Uri Simchoni <uri@jdland.co.il>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:55369 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0DMPeO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 11:34:14 -0400
In-Reply-To: <20100413144250.GB12695@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 13/04/10 17:42, ext Herbert Xu wrote:
> On Tue, Apr 13, 2010 at 05:36:40PM +0300, Dmitry Kasatkin wrote:
>    
>> Also one more question.
>>
>> can reqa and reqb could come from the same tfm as well?
>>      
> Yes of course.
>
> Two packets coming from different CPUs going to through the same
> IPsec SA for instance.
>
>    
Then state must be kept in req ctx, not tfm ctx.
Right?

Then when handling different request HW must be re-initialized.
If handling the same request then no need to reinitialize.

Also not possible to call update(reqa) until previous completed.
Otherwise it will mess up data in reqa.

Thanks

> Cheers,
>    
