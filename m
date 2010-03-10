From: Dimitrios Siganos <dimitris@siganos.org>
Subject: Re: hmac(sha1)
Date: Wed, 10 Mar 2010 02:48:02 +0000
Message-ID: <4B970862.5060904@siganos.org>
References: <20100309030852.GA8153@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:58129
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab0CJCsH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Mar 2010 21:48:07 -0500
In-Reply-To: <20100309030852.GA8153@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Dimitrios Siganos <dimitris@siganos.org> wrote:
>   
>> I am using linux 2.6.28, and in that version, the crc32 implementation 
>> is of type AHASH. According to git, crc32 was converted to SHASH on 25 
>> Dec 2008. I am basing my AHASH implementation on the crc32 AHASH.
>>     
>
> Unless you're implementing a software async driver, I don't think
> crc32c is going to be of that much help.
>
> Cheers,
>   
Yes, it looks like crc32 is a synchronous implementation masquerading as 
an asynchronous one, so it doesn't help me very much.

Can you please answer the following questions with regards to an 
ahash_alg implementation:

1) Do I need to implement .digest?

2) Please confirm that .init should setup a context in the req->ctx to 
be used by .update and .final and that .final should destroy that context.

3) Can the .init request carry data?

4) Can the .final request carry data?

5) If any of  the functions (.init, .update, .final) completes the work 
scheduled synchronously, it should return 0 and not call the complete 
function of the request.

6) If any of  the functions (.init, .update, .final) returns without 
completing the work scheduled, it should return -EINPROGRESS and call 
the complete function (if not NULL) of the req when the work is completed.

7) When calling the complete function, what context should it be called 
from? For example, can it be interrupt context? Should I take any 
precautions/locks before calling the complete function callback?

8) Could you say a few words about the threading model that is in 
effect? For example, if I move the context in the req struct, do I need 
any kind of locking? Can I assume that the tfm, will not be changing 
under my feet, when inside a init/update/final call?

9) Is there a concept of a default key for a hash? For example, could 
.init be called calling set_key prior to it? If yes, what should the key 
be in that case?

I hope it is not too many questions :-)

Dimitris
