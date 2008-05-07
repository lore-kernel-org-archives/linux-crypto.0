From: Patrick McHardy <kaber@trash.net>
Subject: Re: [HIFN 03/n]: Indicate asynchronous processing to crypto API
Date: Wed, 07 May 2008 14:29:10 +0200
Message-ID: <4821A096.2020405@trash.net>
References: <48219D24.1040702@trash.net> <48219E58.4000503@trash.net> <20080507122307.GA17128@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62588 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYEGM3u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:29:50 -0400
In-Reply-To: <20080507122307.GA17128@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> Hi.
>
> On Wed, May 07, 2008 at 02:19:36PM +0200, Patrick McHardy (kaber@trash.net) wrote:
>   
>>     hifn_setup_crypto() needs to return -EINPROGRESS on success to indicate
>>     asynchronous processing to the crypto API. This also means it must not
>>     return the errno code returned by hifn_process_queue(), if any.
>>     
>
> Then how to indicate that error occured?
> What if we will return -EINPROGRESS in case of success and negative
> errno otherwise?
>   

The completion handler should be called with the error code,
a later patch of mine will change that. Returning it while
enqueing a new request is wrong since the error affects a
different request. Queue processing should happen on completion
of requests anyway to make sure the queue is kept running
while requests are queued (and avoid reordering).

>   
>> @@ -2202,9 +2202,9 @@ static int hifn_setup_crypto(struct ablkcipher_request *req, u8 op,
>>  		return err;
>>  
>>  	if (dev->started < HIFN_QUEUE_LENGTH &&	dev->queue.qlen)
>> -		err = hifn_process_queue(dev);
>> +		hifn_process_queue(dev);
>>  
>> -	return err;
>> +	return -EINPROGRESS;
>>     
>
> Thus we are not able to return any error at all...
>   

We are, errors affecting *this request* are returned as they should be.

