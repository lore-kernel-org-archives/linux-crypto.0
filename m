Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id AE2782110;
	Mon, 21 Apr 2025 08:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745225189; cv=none; b=gFHqodIbZ9Of6qUtxAxbMBFtEmYWo0QiZKcmygDDj5IE4kCZubg+cblUHbVUkV94y58SagCOhmueeV41tUUTA47N+dFOCo91GxXLgjjLKPPmQuRxoMmwpFAlcHABputQdIG74lENFp2lAEkdldT/cbV+HrtWsoeWPI1nVKwF0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745225189; c=relaxed/simple;
	bh=aqfZ6Jg26//5UcQAkRIrgHGKQeNyBDtxkL3UKkadzDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type; b=pt9C2wcojWSFy1aOJZxRSE8mDOVsYpO3+OyPhZXIHgfSYbnucXG7ZTACQRadqpifRePG06BJI6OO0bxaZiSfJN1hwHNQwxIHfaY+hg/2IdEG/XI59xgYMnKhx4ONHDmpA4kkL68U3dLabJKCOrihI61p5jUGgZ3eZfBcUkXE5sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from [172.30.20.101] (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id B68196025D456;
	Mon, 21 Apr 2025 16:46:21 +0800 (CST)
Message-ID: <efe80b82-4b64-46cb-97d6-4ae2f4d82b97@nfschina.com>
Date: Mon, 21 Apr 2025 16:46:20 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
Content-Language: en-US
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, davem@davemloft.net,
 herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-hardening@vger.kernel.org
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
In-Reply-To: <5f9b16a3-f3ba-4ccf-bf49-a84c5419d5d2@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/4/21 16:32, Christophe JAILLET wrote:
> Le 21/04/2025 à 09:43, Su Hui a écrit :
>> On 2025/4/21 15:10, Christophe JAILLET wrote:
>>> Le 21/04/2025 à 07:51, Su Hui a écrit :
>>>> It's safer to use size_add() to replace open-coded aithmetic in 
>>>> allocator
>>>> arguments, because size_add() can prevent possible overflow problem.
>>>>
>>>> Signed-off-by: Su Hui <suhui@nfschina.com>
>>>> ---
>>>>   include/crypto/aead.h     | 3 ++-
>>>>   include/crypto/akcipher.h | 4 +++-
>>>>   include/crypto/kpp.h      | 3 ++-
>>>>   3 files changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
>>>> index 0e8a41638678..cf212d28fe18 100644
>>>> --- a/include/crypto/aead.h
>>>> +++ b/include/crypto/aead.h
>>>> @@ -10,6 +10,7 @@
>>>>     #include <linux/atomic.h>
>>>>   #include <linux/container_of.h>
>>>> +#include <linux/overflow.h>
>>>
>>> You could move this 1 line below, to keep alphabetical order.
>>> And why do you say that it is redundant in your follow-up mail?
>> Thanks for your suggestion, I didn't notice this alphabetical order 
>> at first :( .
>> Because I found that  <linux/crypto.h> includes <linux/slab.h>, and
>> <linux/slab.h> includes <linux/overflow.h>, so this overflow.h is 
>> redundant.
>
> It is usually considered best practice to include what is used, and 
> not relying on indirect includes.
>
> Should these others includes change one day, then some apparently 
> unrelated files will fails to built.
>
I already send a v2 patch, too fast for this v2 sending :(.
v2: https://lore.kernel.org/all/20250421083116.1161805-1-suhui@nfschina.com/

I agreed with 'include what is used'.  So I guess v1 is enough and v2 
maybe a wrong patchset.
Sorry for the noise.

Su Hui
