Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20461D5147;
	Mon, 21 Apr 2025 08:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745224368; cv=none; b=Kodtiy2TcQv6syRpkq5dXOOmlh0eHlFPvCaQNk0itk97tYQ6a3vIOPpSvDVNLF+DEFMWYK7Oaa6xGhnuiIxq3BRfl4jHiudGNxANiUAmRXEFsKL8QB9OCPvjdKTje762XV1CGP87KsOlg4aQ3G2REkz8yLpScyW0zCTvc3MvZzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745224368; c=relaxed/simple;
	bh=SRf/xT1V/XLzxNA+vzzNLq8nrTmSw0Pc4JJe9nocbNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g74iT8HEh2MQK1z85+M3voazGfWQvYjAcN/8t2Z8dv+NNj/wXteFwcpnfRL3Qsl9RAS2ejzJc7RTC0XC7b5L59JFFzwTF9Viw3/pSS8oSrdt/S81scGYOaZTI0Lip8BWMaQ7c/8TQdHcP5hbaB85UR4QCRtRup3wCdGz6qSajX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=hHdtemre; arc=none smtp.client-ip=80.12.242.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="hHdtemre"
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 6mZouxXhh2zsA6mZsuAMLP; Mon, 21 Apr 2025 10:32:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1745224357;
	bh=p3Q7HKc453zyGbz3/3Er3c4MCg4AKkAZAozw5ZLwmEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=hHdtemre2G7puVHkN1Xh3nu+lFN8YLDxuFwQk/KcZXcRTjj8N4N0wExbWte700HiY
	 VyI02mol2I4EvPZyFE1XqWhy+gK62dotvFFkA3xxmcdbh6jvDhVwGgwukWtyisKt51
	 dZw7EYG6pyt9noUp/7x0u6tdP/DAaYad3A9VMAjLHLzbBqypSdqehwEslSJO/UCgap
	 UYeAKQREUwkbPvzVDjddexpRPftEqP9nKBTyE0MtuSWciteLeFmGOSatHzcoz5F1z/
	 ObCyRRaZx/eJYYxy5UWYw0RaXXujt1recUSU5Ckwu3pAkZQZAGpThtyPxMomt72LCr
	 jyt7jzVovEQ3A==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Mon, 21 Apr 2025 10:32:37 +0200
X-ME-IP: 90.11.132.44
Message-ID: <5f9b16a3-f3ba-4ccf-bf49-a84c5419d5d2@wanadoo.fr>
Date: Mon, 21 Apr 2025 10:32:28 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
To: Su Hui <suhui@nfschina.com>, davem@davemloft.net,
 herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-hardening@vger.kernel.org
References: <c86fcb5b-73d0-4d55-833f-26a16713e325@wanadoo.fr>
 <bade4ad1-2be7-45a4-8232-0be5fe2e7ef7@nfschina.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <bade4ad1-2be7-45a4-8232-0be5fe2e7ef7@nfschina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 21/04/2025 à 09:43, Su Hui a écrit :
> On 2025/4/21 15:10, Christophe JAILLET wrote:
>> Le 21/04/2025 à 07:51, Su Hui a écrit :
>>> It's safer to use size_add() to replace open-coded aithmetic in 
>>> allocator
>>> arguments, because size_add() can prevent possible overflow problem.
>>>
>>> Signed-off-by: Su Hui <suhui@nfschina.com>
>>> ---
>>>   include/crypto/aead.h     | 3 ++-
>>>   include/crypto/akcipher.h | 4 +++-
>>>   include/crypto/kpp.h      | 3 ++-
>>>   3 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
>>> index 0e8a41638678..cf212d28fe18 100644
>>> --- a/include/crypto/aead.h
>>> +++ b/include/crypto/aead.h
>>> @@ -10,6 +10,7 @@
>>>     #include <linux/atomic.h>
>>>   #include <linux/container_of.h>
>>> +#include <linux/overflow.h>
>>
>> You could move this 1 line below, to keep alphabetical order.
>> And why do you say that it is redundant in your follow-up mail?
> Thanks for your suggestion, I didn't notice this alphabetical order at 
> first :( .
> Because I found that  <linux/crypto.h> includes <linux/slab.h>, and
> <linux/slab.h> includes <linux/overflow.h>, so this overflow.h is 
> redundant.

It is usually considered best practice to include what is used, and not 
relying on indirect includes.

Should these others includes change one day, then some apparently 
unrelated files will fails to built.

CJ
