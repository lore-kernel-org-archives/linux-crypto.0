From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix AES XTS error for request sizes above
 4096
Date: Mon, 23 May 2016 08:50:28 -0500
Message-ID: <57430AA4.70000@amd.com>
References: <20160520223303.7738.5391.stgit@tlendack-t1.amdoffice.net>
 <20160520233543.GB18006@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, Gary Hook <gary.hook@amd.com>,
	"David Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0059.outbound.protection.outlook.com ([207.46.100.59]:7025
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751651AbcEWOGY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 10:06:24 -0400
In-Reply-To: <20160520233543.GB18006@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/20/2016 06:35 PM, Herbert Xu wrote:
> On Fri, May 20, 2016 at 05:33:03PM -0500, Tom Lendacky wrote:
>> The ccp-crypto module for AES XTS support has a bug that can allow requests
>> greater than 4096 bytes in size to be passed to the CCP hardware. The CCP
>> hardware does not support request sizes larger than 4096, resulting in
>> incorrect output. The request should actually be handled by the fallback
>> mechanism instantiated by the ccp-crypto module.
>>
>> Add a check to insure the request size is less than or equal to the maximum
>> supported size and use the fallback mechanism if it is not.
>>
>> Cc: <stable@vger.kernel.org> # 3.14.x-
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> I'm OK with this patch but I think it doesn't always need to go into
> the fallback.  I made a test vector split as 4064 bytes + 48 bytes
> and ccp handled it just fine.  It appears that the bug is actually
> in the handling of a single SG entry that's longer than a page,
> presumably because sg_next is used unconditionally instead of
> checking whether there is more in the current SG entry.

I'll take a closer look at this. Something obviously isn't right but
the code doesn't do anything related to PAGE size checks and works
on the length specified in the SG entry.

> 
> But I'll merge your fix as it fixes a real problem.

Thanks Herbert.

Tom

> 
> Thanks,
> 
