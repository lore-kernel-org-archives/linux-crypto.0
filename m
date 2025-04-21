Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id AD6C219ABB6;
	Mon, 21 Apr 2025 07:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745221431; cv=none; b=oLnic7KTXyl8hM+HyCuEg7dY42ZL5v1lfm/2PkwILO23RI8xW+vVcODAzjm0Bh8J8eTYsMNlx2en+mWcBujPSzFwvQvYDtvoMCq2pRjlq4oQP0e4pNxIxKqDbd4NAU5Mct04MEvk6qGqBBFgBGjmgjUjF9IOV947zX6KR10fMP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745221431; c=relaxed/simple;
	bh=9mr/4ygQi24ODHbaZeN0vo/LVPGCcnhTa5BHpr99sRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type; b=dt1umVfZjN87aAtXiIbjY2RdNOkQkTv5abpXdvYZ2B88C5ziPFbL8i/g1mDAnbS3aHDQ9QfA+j+iBY+PVAX0Qe8S6DqmkrcoFa9p1gKAoF3UIKp7/KQyCeLYCnZMTGskFqWCEHQ7tJmlHQ2auO8xG7cjGpR0g+2y3/GdHDD/Skk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from [172.30.20.101] (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id C17DE60252AD4;
	Mon, 21 Apr 2025 15:43:38 +0800 (CST)
Message-ID: <bade4ad1-2be7-45a4-8232-0be5fe2e7ef7@nfschina.com>
Date: Mon, 21 Apr 2025 15:43:37 +0800
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
In-Reply-To: <c86fcb5b-73d0-4d55-833f-26a16713e325@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/4/21 15:10, Christophe JAILLET wrote:
> Le 21/04/2025 à 07:51, Su Hui a écrit :
>> It's safer to use size_add() to replace open-coded aithmetic in 
>> allocator
>> arguments, because size_add() can prevent possible overflow problem.
>>
>> Signed-off-by: Su Hui <suhui@nfschina.com>
>> ---
>>   include/crypto/aead.h     | 3 ++-
>>   include/crypto/akcipher.h | 4 +++-
>>   include/crypto/kpp.h      | 3 ++-
>>   3 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
>> index 0e8a41638678..cf212d28fe18 100644
>> --- a/include/crypto/aead.h
>> +++ b/include/crypto/aead.h
>> @@ -10,6 +10,7 @@
>>     #include <linux/atomic.h>
>>   #include <linux/container_of.h>
>> +#include <linux/overflow.h>
>
> You could move this 1 line below, to keep alphabetical order.
> And why do you say that it is redundant in your follow-up mail?
Thanks for your suggestion, I didn't notice this alphabetical order at 
first :( .
Because I found that  <linux/crypto.h> includes <linux/slab.h>, and
<linux/slab.h> includes <linux/overflow.h>, so this overflow.h is 
redundant.
>
>>   #include <linux/crypto.h>
>>   #include <linux/slab.h>
And I also found these <linux/{atomic,container_of,slab,types,list}.h> 
is included by
<linux/crypto.h>, I am trying to remove these redundant headers in v2 patch.

It's sad that remving these duplicate header files didn't save any 
compilation time,
only save some code space.
>>   #include <linux/types.h>
>> @@ -433,7 +434,7 @@ static inline struct aead_request 
>> *aead_request_alloc(struct crypto_aead *tfm,
>> --- a/include/crypto/kpp.h
>> +++ b/include/crypto/kpp.h
>> @@ -11,6 +11,7 @@
>>     #include <linux/atomic.h>
>>   #include <linux/container_of.h>
>> +#include <linux/overflow.h>
>
> You could move this 1 line below, to keep alphabetical order.
This overflow.h is redundant too.
>
>>   #include <linux/crypto.h>
>>
>
