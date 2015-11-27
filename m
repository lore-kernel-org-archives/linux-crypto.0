From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] hw_random: core, sleep interruptible in read
Date: Fri, 27 Nov 2015 16:40:34 +0100
Message-ID: <56587972.8050405@suse.cz>
References: <1448567789-2470-1-git-send-email-jslaby@suse.cz>
 <20151127130603.GA29503@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36053 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbbK0Pki (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 10:40:38 -0500
In-Reply-To: <20151127130603.GA29503@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/27/2015, 02:06 PM, Herbert Xu wrote:
> On Thu, Nov 26, 2015 at 08:56:29PM +0100, Jiri Slaby wrote:
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index a064237ff362..f003df162e09 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -238,7 +238,10 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>>  			goto out;
>>  		}
>>  
>> -		mutex_lock(&reading_mutex);
>> +		if (mutex_lock_interruptible(&reading_mutex)) {
>> +			err = -EINTR;
> 
> Shouldn't this be ERESTARTSYS?

Yes, it actually can, given the retval is returned only if no data were
read yet.

thanks,
-- 
js
suse labs
