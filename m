Received: from os-cillation.de (mx.os-c.de [213.165.83.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77439366049;
	Wed, 22 Jul 2026 16:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.165.83.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784736741; cv=none; b=FZs4OLPPjWWW4mJWGTmGZQSrusLbuzZ2uGMvv6FmmCEXPEX9IBICZQOVPW24yWm9o6Z+59BzIa668UN1lF8bubLMvQmTaMwWCf5rQpEiFKYmQZ7/Ntii5ruWWI7+jUpI0QJfVJv4hcF+Zx9rjxk8VbqbRhUVl7S1ASx9SKSN93g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784736741; c=relaxed/simple;
	bh=eJjuKKsjgWWdyXTxehS64GPkUy7EGaDO5AeTWOgfsxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iqaSSPVEemuAvaimcGuM6SAEekHFmRXrbbMnfrjZKO5huDk7+71VuaeaGjhL/tUkkelHrld0azCKGwUpwSqYfoHZ1WquDLud4EbEmgC6YuRzkx9YcDrXf13M92R0ceK6GZWG7GpAd7k9j/6vE/MnFarKYvfqZwWIc8RHjdlZrjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=os-cillation.de; spf=pass smtp.mailfrom=os-cillation.de; dkim=pass (2048-bit key) header.d=os-cillation.de header.i=@os-cillation.de header.b=Ne8DmMy3; arc=none smtp.client-ip=213.165.83.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=os-cillation.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os-cillation.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=os-cillation.de header.i=@os-cillation.de header.b="Ne8DmMy3"
Received: from core2024.osc.gmbh (ip-094-079-177-042.um30.pools.vodafone-ip.de [94.79.177.42])
	by os-cillation.de (Postfix) with ESMTPSA id B40FFC063E;
	Wed, 22 Jul 2026 18:12:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=os-cillation.de;
	s=202409; t=1784736736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RtwCgKftCMaYUmCdplbepptu53yvpvEnd71jrue0up0=;
	b=Ne8DmMy3uESdnbeBo1T1JNR4IbehobA5+dPArRgNlSYLnJPD4j6qCmAqO0+91Uaaa7pbSf
	+ZxGZWZH2G8nno1Up8s/1K1OyR+evRt7IP51IBX05NqR7o+rQDc4w5FNQT3Gix0biLbG6/
	c/U9lont7tlQLbe2VAyaWXhco8pe+OYJAc+woWHhvieHEcUHWgqa4IdOSom6bp13KThWiM
	mkiIpzSvHnC4lr4bvKAiK2kKMHoOc6yEyFw+0kViVo5p0chw0l607aLrOo0/30weLpKSV0
	0BCmcT5qyyrk5lpFBSX3AdNT2UC52aDmC0uMsTgPye7f4BikbgHb21vSRa8ZzQ==
Authentication-Results: os-cillation.de;
	auth=pass smtp.auth=os-c@schweissgut.net smtp.mailfrom=hd@os-cillation.de
Received: from [192.168.3.45] (hd2022.osc.gmbh [192.168.3.45])
	by core2024.osc.gmbh (Postfix) with ESMTPSA id 5222D204EEB;
	Wed, 22 Jul 2026 18:12:16 +0200 (CEST)
Message-ID: <19613c3e-9756-45fc-84b6-b650ba3723a7@os-cillation.de>
Date: Wed, 22 Jul 2026 18:12:16 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Thomas Huth <thuth@redhat.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-2-ebiggers@kernel.org>
 <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
 <20260721195004.GA3383223@google.com>
Content-Language: en-US
From: Hendrik Donner <hd@os-cillation.de>
Autocrypt: addr=hd@os-cillation.de; keydata=
 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 li+2
In-Reply-To: <20260721195004.GA3383223@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 7/21/26 21:50, Eric Biggers wrote:
> On Tue, Jul 21, 2026 at 08:59:21PM +0200, Hendrik Donner wrote:
>> Hello,
>>
>> On 7/14/26 00:32, Eric Biggers wrote:
>>> pcrypt was originally intended to improve IPsec performance.  However,
>>> it's no longer useful for that.  Reports from the rare cases that anyone
>>> has actually tried to use it over the years indicate that it actually
>>> reduces IPsec performance, e.g.:
>>>
>>> * https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations
>>> * https://users.strongswan.narkive.com/liqTaTq8/strongswan-problem-with-pcrypt
>>> * https://unix.stackexchange.com/questions/594336/ipsec-multithreading-via-pcrypt-worse-than-single-thread
>>>
>>> It's also undocumented and quite difficult to actually use.  Its design
>>> is also broken, in that any unprivileged program can enable pcrypt
>>> systemwide at any time (by instantiating it using AF_ALG).
>>>
>>> Meanwhile, pcrypt has been a regular source of bugs, including at least
>>> four that have received CVEs.
>>>
>>> Let's just remove it.  No one seems to care about it anymore other than
>>> people looking for vulnerabilities.
>>>
>>
>> my company is a user. We have a hardware platform based on an IMX6 SoC
>> using IPSec and configure pcrypt using crconf. Current performance
>> difference:
>>
>> iperf3 -c <IP> --time 60 -R
>>
>> pcrypt:
>> Download: 107 Mbits/sec
>>
>> No pcrypt:
>> Download: 59.3 Mbits/sec
>>
>> iperf3 -c <IP> --time 60
>>
>> pcrypt:
>> Upload: 65.9 Mbits/sec
>>
>> No pcrypt:
>> Upload: 52.0 Mbits/sec
>>
>> The relevant crypto templates are configured in early userspace and
>> since i got curious, that has been the case since 2017.
>>
>> Mostly using
>>
>> pcrypt(gcm_base(ctr-aes-neonbs,ghash-generic))
>>
>> nowadays, AES-CBC in the past/as a fallback option.
>>
>> So at least on some platforms there is still a significant performance
>> boots, at least for downloads in this case.
> 
> Thanks for bringing up your use case.
> 
> Have you looked into alternative solutions such as Receive Side Scaling
> (https://docs.kernel.org/networking/scaling.html#rss-receive-side-scaling)?
> AFAIK it's not just the crypto performance that makes pcrypt unnecessary
> these days, but also the design of the networking layer.

I'm looking into this more, the IMX.6 is a bit limited with IRQ handling 
and queue distribution.

> 
> I understand that i.MX6 doesn't have the ARMv8 crypto extensions.
> However, surely you could at least use the NEON-optimized GHASH code?
> Is there a reason you're not using it?

I think it was historically not working well for us, retested:

NEON GHASH with pcrypt:

Download: 116 Mbits/sec
Upload: 74.3 Mbits/sec

NEON GHASH baseline:

Download: 90.7 Mbits/sec
Upload: 60.8 Mbits/sec

Looks better, still a ~15 Mbit improvement with pcrypt.

I want to point out that without IPSec our baseline is:

Download: 942 Mbits/sec
Upload: 942 Mbits/sec

Intel IGB ethernet.

Regards,
Hendrik

> 
> - Eric

