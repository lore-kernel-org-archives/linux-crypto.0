From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: Re: [RFC PATCH] [XFRM] xfrm_algo: correct usage of RIPEMD-160
Date: Mon, 02 Jun 2008 09:02:08 +0200
Message-ID: <48439AF0.30508@swiss-it.ch>
References: <1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch> <1212340578-15574-2-git-send-email-rueegsegger@swiss-it.ch> <20080602065132.GA11128@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:33056 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYFBHCM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 03:02:12 -0400
In-Reply-To: <20080602065132.GA11128@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior wrote:
> * Adrian-Ken Rueegsegger | 2008-06-01 19:16:18 [+0200]:
> 
>> This patch fixes the usage of RIPEMD-160 in xfrm_algo which in turn
>> allows hmac(rmd160) to be used as authentication mechanism in IPsec
>> ESP and AH (see RFC 2857).
>>
>> Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
>> ---
>> net/xfrm/xfrm_algo.c |    4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
>> index ac765dd..23a2cc0 100644
>> --- a/net/xfrm/xfrm_algo.c
>> +++ b/net/xfrm/xfrm_algo.c
>> @@ -200,8 +200,8 @@ static struct xfrm_algo_desc aalg_list[] = {
>> 	}
>> },
>> {
>> -	.name = "hmac(ripemd160)",
>> -	.compat = "ripemd160",
>> +	.name = "hmac(rmd160)",
>> +	.compat = "rmd160",
> 
> On the other hand you could rename the algorithm itself couldn't you?

Yes, that would be the other way to do it. Is there a preference or specific reason
for renaming the hash algorithm than changing the reference to the algorithm?

Thanks,
Adrian

> 
> Sebastian
