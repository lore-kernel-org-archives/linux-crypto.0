From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: Async Crypto API
Date: Wed, 27 Jan 2010 08:45:12 +0200
Message-ID: <4B5FE0F8.5090806@nokia.com>
References: <20100123032039.GA5551@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:20958 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0A0Gpr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2010 01:45:47 -0500
In-Reply-To: <20100123032039.GA5551@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

1 more question.

>From what context "crypto_completion_t" can be called?
irq/tasklet/process
or something else?


Thanks,
Dmitry



ext Herbert Xu wrote:
> Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
>   
>> Hello,
>>
>> I have one question about async api.
>>
>> I work on AHASH driver and wonder about one thing.
>>
>> while calculating hash, client might call many times
>>
>> ahash_request_set_crypt(req, &sg, sha1, len);
>> crypto_ahash_update(req);
>> ..
>> ..
>> ahash_request_set_crypt(req, &sg, sha1, len);
>> crypto_ahash_finup(req);
>>
>> right?
>>
>> But because it is async and driver does not wait_for_completion,
>> previous request may not be completed before client will call next update.
>>
>> But what should be the behavior of the driver?
>>     
>
> If any async operation returns EINPROGRESS, the client must not
> proceed until that operation has completed.
>
> Cheers,
>   
