From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v1 3/3] crypto: ccp - Protect against poorly marked end
 of sg list
Date: Thu, 28 May 2015 12:30:15 -0500
Message-ID: <556750A7.6020003@amd.com>
References: <20150527094305.GA28142@gondor.apana.org.au>
 <5565D0B2.8070708@amd.com> <20150528003612.GA2739@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0148.outbound.protection.outlook.com ([207.46.100.148]:37964
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753942AbbE1RaZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 13:30:25 -0400
In-Reply-To: <20150528003612.GA2739@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/27/2015 07:36 PM, Herbert Xu wrote:
> On Wed, May 27, 2015 at 09:12:02AM -0500, Tom Lendacky wrote:
>>
>>> The reason I'm asking is because while this patch fixes your driver
>>> everybody else will still crash and burn should something like this
>>> happen again.
>>
>> A number of other drivers already have similar sg-count functions in
>> them.
>
> Perhaps you can help abstract this into a helper that everybody can
> call?

I can do that.  Something like an sg_nents_for_len() function that takes
an sg pointer and a u64 length as arguments. The function should also
return an error if the length requirement isn't satisfied.

Thanks,
Tom

>
> Cheers,
>
