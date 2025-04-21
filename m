Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 7284E70830;
	Mon, 21 Apr 2025 08:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745225439; cv=none; b=uX3XB/uOoWgTRntq2o02J+og66VKHnN8CueM/QM/aw3evgAiPFLEUHCDkqTiAyRVtPMRDRgVWcHADxjkXY+Kl55t/kqNS+WDOtct1pn8AWN7mkV2obrGBqrA8Zt8DJNQj4d3JpNmoDajLem5I5d8ib/QldGi23oYh8Z73xoTwiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745225439; c=relaxed/simple;
	bh=xsonTwJHhHFspOne+zY7lEzLXKjSZ+d9ysyxg6qfREc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:In-Reply-To:
	 Content-Type; b=imDWImE/fyasaP6FLZ4z/lzEomKnMN2Jcmwv6940kA4j0NPkXooWLvpH0+B3ywAj9WpvlFT5LWulGoC328VzbMOSzd9Zz1jJ+ZoA6k1NGed4ouTyqVR1K+rxolry6lBHo+Nw1l+eJqF4+qQSi+j3ZIP9YNyhs/RFSPNXT5ZXBVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from [172.30.20.101] (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 4E02F602637EF;
	Mon, 21 Apr 2025 16:50:31 +0800 (CST)
Message-ID: <fe8468d5-7bb3-4acf-960f-fa23a0000faa@nfschina.com>
Date: Mon, 21 Apr 2025 16:50:30 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
Content-Language: en-US
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, davem@davemloft.net,
 herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-hardening@vger.kernel.org
In-Reply-To: <efe80b82-4b64-46cb-97d6-4ae2f4d82b97@nfschina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/4/21 16:46, Su Hui wrote:
> On 2025/4/21 16:32, Christophe JAILLET wrote:
>> Le 21/04/2025 à 09:43, Su Hui a écrit :
>>> On 2025/4/21 15:10, Christophe JAILLET wrote:
>>>> Le 21/04/2025 à 07:51, Su Hui a écrit :
>>>>> It's safer to use size_add() to replace open-coded aithmetic in 
>>>>> allocator
>>>>> arguments, because size_add() can prevent possible overflow problem.
>>>>>
>>>>> Signed-off-by: Su Hui <suhui@nfschina.com>
>>>>> ---
>>>>>   include/crypto/aead.h     | 3 ++-
>>>>>   include/crypto/akcipher.h | 4 +++-
>>>>>   include/crypto/kpp.h      | 3 ++-
>>>>>   3 files changed, 7 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
>>>>> index 0e8a41638678..cf212d28fe18 100644
>>>>> --- a/include/crypto/aead.h
>>>>> +++ b/include/crypto/aead.h
>>>>> @@ -10,6 +10,7 @@
>>>>>     #include <linux/atomic.h>
>>>>>   #include <linux/container_of.h>
>>>>> +#include <linux/overflow.h>
>>>>
>>>> You could move this 1 line below, to keep alphabetical order.
>>>> And why do you say that it is redundant in your follow-up mail?
>>> Thanks for your suggestion, I didn't notice this alphabetical order 
>>> at first :( .
>>> Because I found that  <linux/crypto.h> includes <linux/slab.h>, and
>>> <linux/slab.h> includes <linux/overflow.h>, so this overflow.h is 
>>> redundant.
>>
>> It is usually considered best practice to include what is used, and 
>> not relying on indirect includes.
>>
>> Should these others includes change one day, then some apparently 
>> unrelated files will fails to built.
>>
> I already send a v2 patch, too fast for this v2 sending :(.
> v2: 
> https://lore.kernel.org/all/20250421083116.1161805-1-suhui@nfschina.com/
>
> I agreed with 'include what is used'.  So I guess v1 is enough and v2 
> maybe a wrong patchset.
> Sorry for the noise.

Oh, I forget to keep alphabetical order, so v3 is needed if there is no 
other suggestions.

