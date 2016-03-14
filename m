From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Use different flag vars for nested locks
Date: Mon, 14 Mar 2016 09:15:39 -0500
Message-ID: <56E6C78B.60504@amd.com>
References: <20160311163942.4791.47157.stgit@taos>
 <20160312022202.GA29618@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0092.outbound.protection.outlook.com ([65.55.169.92]:34176
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965200AbcCNObG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Mar 2016 10:31:06 -0400
In-Reply-To: <20160312022202.GA29618@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 03/11/2016 08:22 PM, Herbert Xu wrote:
> On Fri, Mar 11, 2016 at 10:40:11AM -0600, Gary R Hook wrote:
>> @@ -128,14 +128,14 @@ static struct ccp_device *ccp_get_device(void)
>>   	 */
>>   	read_lock_irqsave(&ccp_unit_lock, flags);
>>   	if (!list_empty(&ccp_units)) {
>> -		write_lock_irqsave(&ccp_rr_lock, flags);
>> +		write_lock_irqsave(&ccp_rr_lock, rrflags);
> The right thing to do is to drop the _irqsave on the inner lock.
>
> Also why is this a write lock at all as nobody seems to take it
> as a read lock?
Roger on the _irqsave.

As for this being a read-write lock: an optimization during development 
removed the need for a read acquisition. This use of the lock was 
overlooked, and now only needs to be a spin lock.

Since the function of this patch has changed, and the subject line 
should be different, do you prefer a v2 patch, or a new patch? This one 
can be ignored, of course.

Gary
