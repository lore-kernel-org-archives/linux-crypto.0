Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5BD310652
	for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2026 13:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786021584; cv=none; b=RGDeFQO4nFXl9huWh/mahQcWTs/Hh3jCK1VRKr5wprEETL1jfmtFPcJo/pwmzkQkAwwZHCijM2oLwkkl620NSIJiFK40NmnHrYK4ox+RIRW028okvZ2MyIvN7avsVl1XacbAmeNwybiLC4eNyKOdnM1kmuA/riVQ4SrA9p+9Vy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786021584; c=relaxed/simple;
	bh=OzAc1F2Y6Gcmxu2zII4YVzJyWZmAUlHTRSH7Z+pI/0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EVT8rLISUhlFPruqHr3U/UuPF61scWSCM+GHSl5rev93iW0wDLtDuQXpfaC8UkYEMEkSqPBYJigXxvNUa2vkGp9IKcgZCp9OUB9FT8ft9IHKRp8Je6RlHTUaYnsBUQohpmzhbagpiXUHEJ+JmPGGFmMEYrEQfp5g5Yz0Ryj24jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sxsj+gDx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rGmQxQYd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sxsj+gDx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rGmQxQYd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786021579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qdrRzVBf5DG7sDXX93QUMBT7+/4/2gBMdmZZGH0xBog=;
	b=Sxsj+gDxu7cauWhrJlSKDVYltzxvifGJEIQj5/d/SV4xzhboB+Numtsa4rITuc2k8FA9R7
	mk47pX2kNkYu8Yl+g4gbbLpTFovpJ8CBYB2DuDsbHTG8HomjegTKFGXEZa4TCLbCKgqmVl
	DZ97pvz23XJeszWc8XGRq83eqRD4cRQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-SGGpwEDWOZafhpkYKzzi3Q-1; Thu, 06 Aug 2026 09:06:18 -0400
X-MC-Unique: SGGpwEDWOZafhpkYKzzi3Q-1
X-Mimecast-MFC-AGG-ID: SGGpwEDWOZafhpkYKzzi3Q_1786021577
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f835ac1aeso1465677f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Aug 2026 06:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786021577; x=1786626377; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qdrRzVBf5DG7sDXX93QUMBT7+/4/2gBMdmZZGH0xBog=;
        b=rGmQxQYdE8bgGzLcKnG87gYNbDHThEurbY+8dhMC/uUkObNLPNpp89dLR2K/OZjTLC
         ES2guWCA6Umg0W3vFM18X5aYO2Nmy5wE3wGNYDMzxq9Og9FT4FOOY6oPMbnSqyjSOCSD
         mIDIcGPeLYHIPKyYBuFHnSaj8M0XGtT+S18cqk/cmVucmuz1SvK2+1HdwWC1jQ4oBqM6
         lmyKroQlENbFKqAJA3Mp4dK4Z2LCW5UnXntWaIZHxQ4vMuDATWtm5V5a/P0XIx+aPrFm
         YnZr5RgSupQVqyzvtXtik8FS9xBrN9XnEJyS0vr7OdO8RImFxjE0SDbK9mPMhcDya5hX
         33sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786021577; x=1786626377;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qdrRzVBf5DG7sDXX93QUMBT7+/4/2gBMdmZZGH0xBog=;
        b=cVNVJFTim1GCABsri6d+XfntzQn1GMfsalhv3HNTdq4ur6Zzy0UNkd85qjRghZ+NGe
         j+cjS1YZMO1/h03/+dcJ6F+S4unmk0jhPg6FjMJBJTQmQjGNNZC6k/58V3DwOF3QAIOx
         IjqKFOTqHppFmUI39L6dBZbNjV2GOgVuza2zex8TefjGHC5+DoUkrnhoBBjR+NhJTm2D
         FOU+rw3SEtjixdQe4ZAw6RojF1NLZIVZvf28bQelLmQxQCv8XnHsuBDmv0byLtEx5ICJ
         qYnsGqp60nu2j6OCl1fwsglp8w0b2iPGxdquATiKW6YoQ4OTtTkKSIUvby2NjOgGmfFr
         CzEg==
X-Forwarded-Encrypted: i=1; AHgh+RrrfI+9wgLu+2iJhRDtfGNIXMW8qUkFsDv5gJ0ISo4qrkZ5lkxnTSZzULfJreDVqw34vyGF7l8fhzhFoNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdNGFcLB6JSg0hjDZOl/nso22p31EfK6WNb1DZx3f4RkNWvHFy
	ZCzNQ+wxyPrEkQMN/scJ1OeMJHFhC06yoMVmnLFdJdxFTKr6TMOwseDOgJQaG/pHNQ1DUEOAIGl
	XNRiBVTcdY66RvM9ceZsQu38Qo70liO/YGQYunxPkhu5brwCUUh2ahc4e1X/43ZBkoA==
X-Gm-Gg: AR+sD13C4EF8GbdHHjmFOu4syFt5Ox3D2iobgicTyEqW4WMN+J+cSsycxpe20GP+gOQ
	MDMBUge0AvrcKkW1Vkbm0DV8v5IugIEoXX6lWdxjvIj5aOgsw13Lh7r/PA1EjWrPht+n8VCuzK0
	a6/N2b7RM1wlZW74HN5OapN0OMJp07wgrk2wFtMEwNxBo/BlFKyjkA18Z97Qoo74/86Q6wb+GvW
	tgZfLn0MCJuLpg9VQbOrnkb4WC6mOhMdLOFhlfehM3uZaj+iljGDbJF6eN4YBtjHHdNmDrcpcq0
	nTuRWqHITkkzLxfxNf+gQ/TtVPdAMJoe7klaUlNYUGTJvsZYDhsCNTFSFZ2CEbO8rxNLHFfW
X-Received: by 2002:adf:e012:0:20b0:47f:5b52:5579 with SMTP id ffacd0b85a97d-47fec532b8cmr19120061f8f.18.1786021577022;
        Thu, 06 Aug 2026 06:06:17 -0700 (PDT)
X-Received: by 2002:adf:e012:0:20b0:47f:5b52:5579 with SMTP id ffacd0b85a97d-47fec532b8cmr19119980f8f.18.1786021576640;
        Thu, 06 Aug 2026 06:06:16 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff79a7f07sm6573381f8f.8.2026.08.06.06.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 06:06:15 -0700 (PDT)
Message-ID: <3224cf7a-ae7c-45c8-82e5-126f2957fc79@redhat.com>
Date: Thu, 6 Aug 2026 15:06:14 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] net/tcp-ao: clear the aes_cmac_key when done
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Neal Cardwell <ncardwell@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kuniyuki Iwashima <kuniyu@google.com>,
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org
References: <20260805143611.818559-1-thuth@redhat.com>
 <20260805143611.818559-4-thuth@redhat.com> <20260805210259.GI3438@quark>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260805210259.GI3438@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/08/2026 23.02, Eric Biggers wrote:
> On Wed, Aug 05, 2026 at 04:36:06PM +0200, Thomas Huth wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> Clear the local aes_cmac_key structure via __cleanup() function
>> when we're done with it to avoid that sensitive data could leak on
>> the stack.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   net/ipv4/tcp_ao.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
>> index a56bb79e15e0e..12c724fed8a26 100644
>> --- a/net/ipv4/tcp_ao.c
>> +++ b/net/ipv4/tcp_ao.c
>> @@ -141,7 +141,7 @@ void tcp_ao_calc_traffic_key(const struct tcp_ao_key *mkt, u8 *traffic_key,
>>   					traffic_key);
>>   		return;
>>   	case TCP_AO_ALGO_AES_128_CMAC: {
>> -		struct aes_cmac_key k;
>> +		struct aes_cmac_key k __cleanup(aes_cmac_zeroize_key);
>>   
>>   		aes_cmac_preparekey(&k, mkt->key, AES_KEYSIZE_128);
>>   		aes_cmac(&k, input, input_len, traffic_key);
> 
> Similar to the bluetooth patch: This is okay, but it seems the TCP-AO
> code has never really tried to do key zeroization, which is why I didn't
> include a memzero_explicit() here.  Lots of cases, like the various
> traffic key buffers, have never been zeroized and still aren't.
> 
> The '__cleanup' trick makes this specific case trivial enough that sure,
> it might as well be done anyway.  But it would be nice to have a more
> comprehensive patch that actually tried to zeroize all TCP-AO keys.
> Otherwise random individual fixes like this trickle in over time and it
> takes a lot longer.
Ok, I'll put this on my TODO list and will send a separate patch - for this 
series here, I'd prefer to limit it to aes_cmac_key / aes_cmac_ctx.

  Thomas

