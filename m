Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EDD43C048;
	Wed, 29 Jul 2026 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785312155; cv=none; b=OdUYgd5mJJaiAPqMPqaxQ71/zekmjvZC0ApLS8ZG2KXMjc+zRQCE8htx7psPh6WI/cbjtcv9f0ORLxNy99AtAYtYAIKykjWLS9L0jbqW/drCxetTiVP8t+NYCxbDvJQDOuc9ZTk8+HSc/7j4dxmwkApNgnfwZDY87U8vsm2AOwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785312155; c=relaxed/simple;
	bh=uMejWgyIoN6ZG84OfrMAsYDqnTdw7AkNMiD/RACqftE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MPgTAHo0pIkGPvgrbtKSA+16exbscVmSEJptUywHzCHI9ctZ3EOLB358OdB2RPhDsQjtzvTbgQiJ0Hnfnk/lhJJyOc3L+KM05qDdVKzqV3W8xz4rcAGoC34UCGK3NDP7zKt/7px5b+OVopOu9YhJ2WnLP1PPQaUBi6/Cz8OOD6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhOSZ2XI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhOSZ2XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641201F000E9;
	Wed, 29 Jul 2026 08:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785312151;
	bh=ETDvRVLoFd8Kn+xtd3X2yg3Wj607hdJ9xcrOiy6lh68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DhOSZ2XIZzmUHm5UHLW4cink/2JeNlJqCtKvUsqJhNX4vGUTQGseKrwMZM0s9Eopv
	 DgZ+ywXKt70saNOe+MrDvY+uDZSpsEKHcHsECiK6Aw/JPwEWyekxrKtk81AEgzkLRh
	 1IHO+/xa7DNg6NyAQQVzOKvAU0rMAyuL7OyKvXkN/5ID7xRNmSe7JB5ncVuUuQqDud
	 wcgd/dHJmF3dxDgJZWX3vC1/dKXedt2gtokpp2XvpG3s59JKFrabF2TqPyA8XNpEL8
	 1R+CA8jlcLA4csqcXj9rPjlAUAX9AyHPetSw3nTQA4BgcpDxoJkGkj/ky+Okcz+hl9
	 BCJROv4sKQosA==
Message-ID: <15904301-fd03-45e5-b909-dfce52449726@kernel.org>
Date: Wed, 29 Jul 2026 10:02:27 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Eric Biggers <ebiggers@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Demi Marie Obenour <demiobenour@gmail.com>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh>
 <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh> <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh> <20260724155144.GA2032@sol>
 <20260728152241.GA4281@quark>
Content-Language: en-US
From: Konrad Dybcio <konradybcio@kernel.org>
In-Reply-To: <20260728152241.GA4281@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/28/26 5:22 PM, Eric Biggers wrote:
> On Fri, Jul 24, 2026 at 08:51:44AM -0700, Eric Biggers wrote:
>> It is consuming a lot of the community's time to help maintain,
>> including dealing with LLM-found bugs, with no clear benefit to anyone.
>> Even considering *just today* we can see someone sent a bug fix:
>> https://lore.kernel.org/linux-crypto/20260724081537.191992-2-thorsten.blum@linux.dev/
> 
> Another example:
> https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
> 
>> It definitely *was* causing problems before it was disabled via the
>> crypto priority system (which made it unused in the kernel) and dropped
>> it from AF_ALG (which removed most of the unprivileged attack surface).
>> When anyone accidentally used it, it caused at least a huge performance
>> problem, and sometimes other problems too like filesystem hangs.  It was
>> an issue for years.
> 
> This actually seems to have been an overly-optimistic characterization!
> As per
> https://lore.kernel.org/linux-crypto/d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com/
> this driver drains the battery on every system with the module loaded,
> even when no crypto requests are actually sent to it.

Unfortunately removing it drains way more battery, because the buses
never hit sync_state and are kept at their maximum frequencies:

[   18.021823] qnoc-glymur interconnect-1: sync_state() pending due to 1dfa000.crypto
[   18.029605] qnoc-glymur 16e0000.interconnect: sync_state() pending due to 1dfa000.crypto

(it transiently also pins DRAM and friends to max-freq which absolutely
kills battery life)

I understand your concerns given the past handling of this driver,
however I believe the nuclear option comes with way too much fallout..

Konrad
