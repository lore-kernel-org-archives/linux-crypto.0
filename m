Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17933242D90
	for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 11:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750679710; cv=none; b=IDsl0XSZnajgpOOQDGuS6U9d5b6tlJhkLpIkj8pdLuLl/g4wtRP5Ce7gw2cxLrSZK8JQLjEjD1JvGszQwkqdJoUb5dGwsdnZpsHxNqgsX6K2lTiLRBk2OL2rq/NX62NZc5rfqDOosOca1HU5vexyki9V5pHykCD1KEnKIG5f4kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750679710; c=relaxed/simple;
	bh=DBoHB3g5lCybxegUqBfzOCEqqnq81NacHLbyicWWd6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=an3ksEfITsbsD4jaoKciHpDoASVjpPl+FFNjVFMH03s0/bb19Y8LGrp5FD11jGpUmw2LMP57iRNLDibVcmZmCX2t98sFX99cmaLcVBeOCah7SoXgL0WszgnYmeFWwGazvK9NJOju7YbkUJi7k7glCLvth4gAxu44LgERHLJAOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWJ31u5t; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWJ31u5t"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad89ee255easo746343866b.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jun 2025 04:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750679707; x=1751284507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=g07DgH9mtTRbBYxoH6YLsPXyTQbQTUkM8ZR4WkVgW+Y=;
        b=AWJ31u5tMxabRb5cD1Dm/Ie3BC4hoQwrSr++98OXgUrjyVrR7R0Mv1wLMJTBz4s56p
         7HkbeFl2hByVNDj+L109XasISWjyqYP6fiJ1NnSjhXH/AQ784AVU4E0Vry1zZL5YQeQB
         IZCR9KPma89K27tsr3JB+vgg3zScbIbTJ/i/rzqUcBepZdTL444Rjm2BOs7SGm+vveat
         EfKn2u0QEmp8qrh/38a21DSMvtyUf9YXs2Tq1TmHW/ey/oJVAKoG/zrAOdq9z+U63TBd
         rk97wEDwuskgUQ4M5KhMKYPjLGK5YKM4DSMpkKJ4D5ITnR3x87+EmKNm0ft1Vdng4jgB
         pwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750679707; x=1751284507;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g07DgH9mtTRbBYxoH6YLsPXyTQbQTUkM8ZR4WkVgW+Y=;
        b=RPBss7vsL1iufSf6pHQfjStSieVL90t0hGO4KwRyeW2NpnSACRS/2LnCkPRw3S2Qjk
         4PvudmN7U7b7TrmsscVcjBCLahLFHdA7gSLUTGPdRa4G9PS+at8viGq51n9kBeyHfH7+
         9OhtcjnIEkL5DkhK+89l2jPJ1v5vYQ4dJ5NVElJjLq52cM7wSzArEscMchiF5UiYHNgY
         7QSkKxEDxDugpX6dX/66DeUln5cUqrvOzQ4g51WOL67ZyS021Tia2gOkWH+hlnx+GR0B
         6YVVbN4Rf35NkA5u2ygXcj/N3VHjFtlDz1qHfzSfbVW3qUSqaNp/Yd62LIyhwerGkkM4
         b3CQ==
X-Gm-Message-State: AOJu0YxLk1lIY+xquNWLsUWUOmhyr2VJH232dOjcm/Bd5miwtFPJPlQ6
	/E9sXZwxZsMGJ8oKVY45b4nQV54VVrxhKViYhjA49j+MZHg80RlN3HExEp92pQ==
X-Gm-Gg: ASbGncs0H/1gsSVh1TWD7fB3wF4CS9sAfUKXjSKg+JvqyvDJDZTfMSNV4x8NwPd5OjA
	8zFGHrszuFJ/3qGqux38dvL92s19dS4mooIyZAHEdDzstQEN6lDxc7kOsuFhCwho5ceZJh2AvkG
	8PHLxIHcKl9jHLK34WFr6Khnl3IIzHa0vvfJV+nrnXXkQUDI7ErFlVLCA/zkgCSDR7frSzXVCCJ
	mbkgYJeTQqOLEsvWLHsuu8bq8Rq9xXoffEtV9jCpdzwaeLLpKegaiobsIiQH6Qz6sYqrZoG5KDH
	dX/aGyutYwIiv0u6PwjL+eDa3JtoFWLFfeNH0sa8VnMXv85zg772EaGb5Fud2v3OWuv+XuHWjoV
	0K0VDkfDKRQ==
X-Google-Smtp-Source: AGHT+IHJpwaMwrE4rRYDyw8cW4+8w6qw9qyp0n9KYAAdbHCw5hP6f1+4kgIVyn561TUeZ6KsOALsoA==
X-Received: by 2002:a17:907:7214:b0:ade:7bd:e0ec with SMTP id a640c23a62f3a-ae057fa0dfemr1182353166b.56.1750679706698;
        Mon, 23 Jun 2025 04:55:06 -0700 (PDT)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0541bb5c3sm692303566b.129.2025.06.23.04.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 04:55:06 -0700 (PDT)
Message-ID: <27689dcc-3018-472f-9db1-efba8f9d52d1@gmail.com>
Date: Mon, 23 Jun 2025 13:55:05 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] dm-crypt: Extend state buffer size in crypt_iv_lmk_one
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
 <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
 <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
 <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>
 <aFk2diodY0QhmZS8@gondor.apana.org.au>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <aFk2diodY0QhmZS8@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 1:11 PM, Herbert Xu wrote:
> On Mon, Jun 23, 2025 at 11:40:39AM +0200, Mikulas Patocka wrote:
>>
>> 345 bytes on the stack - I think it's too much, given the fact that it
>> already uses 345 bytes (from SHASH_DESC_ON_STACK) and it may be called in
>> a tasklet context. I'd prefer a solution that allocates less bytes.
>>
>> I don't see the beginning of this thread, so I'd like to ask what's the
>> problem here, what algorithm other than md5 is used here that causes the
>> buffer overflow?
> 
> The md5 export size has increased due to the partial block API
> thus triggering the overflow.
> 
> How about this patch?

For v2:

Tested-by: Milan Broz <gmazyland@gmail.com>

Just for the context, the patch fixes OOPS on 32bit (but 64bit should overflow struct too):

: Oops: Oops: 0000 [#1] SMP
: CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.16.0-rc2+ #993 PREEMPT(full)
: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
: Workqueue: kcryptd-254:0-1 kcryptd_crypt [dm_crypt]
: EIP: __crypto_shash_export+0xf/0x90
: Code: 4a c1 c7 40 20 a0 b4 4a c1 81 cf 0e 00 04 08 89 78 50 e9 2b ff ff ff 8d 74 26 00 55 89 e5 57 56 53 89 c3 89 d6 8b 00 8b 40 14 <8b> 50 fc f6 40 13 01 74 04 4a 2b 50 14 85 c9 74 10 89 f2 89 d8 ff
: EAX: 303a3435 EBX: c3007c90 ECX: 00000000 EDX: c3007c38
: ESI: c3007c38 EDI: c3007c90 EBP: c3007bfc ESP: c3007bf0
: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010216
: CR0: 80050033 CR2: 303a3431 CR3: 04fbe000 CR4: 00350e90
: Call Trace:
:  crypto_shash_export+0x65/0xc0
:  crypt_iv_lmk_one+0x106/0x1a0 [dm_crypt]

...

The bisect was

efd62c85525e212705368b24eb90ef10778190f5 is the first bad commit
commit efd62c85525e212705368b24eb90ef10778190f5 (HEAD)
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Apr 18 10:59:04 2025 +0800

     crypto: md5-generic - Use API partial block handling

     Use the Crypto API partial block handling.

Milan

