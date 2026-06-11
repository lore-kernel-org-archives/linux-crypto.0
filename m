Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8593451C8
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 12:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781180245; cv=none; b=bV+O8QwXzmnv4XKlDNGwl808MF12zkKhq3CO3hKO59h8Blqken8HHWzvpPMUerVpyYJ5g23EDV5V1i1TEWGEgBbG0mTBh3XDZ2S9bz/bdt0T1t1BvjNJZL71EfufCkoEEIE6yIWPHPdKK4wPcx6R0CviOGJ08LCY3/I8bmFvkX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781180245; c=relaxed/simple;
	bh=rgVYSbR9nGU825Ny5DIQRKXtJgO2UBjS+6c1oxdgHEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FSzpo9e9axc0opA4HVbJHB8YF/pzA1Xvl9hyNg+CyWS9+Ba0DpLEsUd9dSak13Ht8k07kY7o1dOIQ5tS+dAHHdGtp3VDLSftgL6x53zj6NsLt5b8aV6nazgp1YoBl3M3pTw7KWTUMbdTO6QlzEh/MlbS5WCzyXoLQD4juAQc6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLI4Pf+/; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLI4Pf+/"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36b8d414666so4419147a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 05:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781180243; x=1781785043; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xKVTpr4aNyZx4lSh79VinADzKQEIbf4Ts/2xtaUoVwc=;
        b=MLI4Pf+/Fcbnmfr4ssc1QksgYABd3MMy4k4UjenxEnL18e7h5XGBBvIgroSZQLyel4
         QHbWXFigntayJpgq/OhKIJFUPhI7QI9vsimJx/2L/xmXbmoZ9yE8Ymn62k/QlPuu425Q
         xU3y38VKZ4BjKca2PGef3xlJLHnaNbYyf60PYM8CMoFwY6WMKZHnN7oFfNqqEy3Xno1X
         DTnmPdUDSHukAEQU7DEXKnHiXm8fLS1HjJkMNqEUjtaneP3EmvBZanh/na87xpUtp8eM
         5DOV/IVPNkZrUur9f1mOU6qpjRdiexJ40Y3eIPh4VFZCiYefm38OLYd7myNRjyvuoDhD
         h3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781180243; x=1781785043;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xKVTpr4aNyZx4lSh79VinADzKQEIbf4Ts/2xtaUoVwc=;
        b=XF4nY6SgGsVGRVW178QAIWhSN4DQyf4hZ4rN+SzicOt0QrfnNLVpc+BQMyEDCi0PSM
         xVJqQD06oyhEIPxWiwZMNr3QRZUSgl7lQ3c/KchX7QXzR0QDciRc2yfbrjJ+MXBA/7jg
         +zodcyh/aT17lCH4MCgwgJTNMmTuLwGZmAzULForseYMUqW81UEP+9Yz8Pcr5GBg5Smb
         qOk9m9RGy+x7IFNbyWmw2oepXlz9Co0rXbTxP5VWbvV29SjW4ADTkp7N5RNFcvUhdJr+
         D9oFMESGmjyN0FSIIvAOD8XU0SeheVuEfxorlSnRa+8+p4qs/ObDQ5YHlvBJY1N3fRiA
         yyRg==
X-Forwarded-Encrypted: i=1; AFNElJ//Om2/p876SYzPsw+jCzuMsVve9KdZHvlEGqSHQnZYHv2wOEN81RoYifuerfWypZ6a+X0NouMQL4/SD8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP+rWJ+0HJl7+6bPNCFMeNnilmrr4CA/tRMr27oBu/hPLogwEO
	J0w1k4D5QWt63YTkKAUwwi1PmKsNyDmdW9Fh0KmNti8rsQgSFujhXrbq
X-Gm-Gg: Acq92OGAzwXaJtiOgjYfBWfo1uQ6cLJUaJxFLjOK1mo4+OAckkPgyRVF7HaRgPCuTuS
	sRs0mYGgTpdyjZnnH/BbZ2MuRuW5aXlOunowFi9F9vz7894O6uPtbhSg9rNi94A5X2p3/W2VzsG
	UUvrwm75Jmrbu+iAtnr3/aMvN/x2hbvilBW4Jj8jSaBsSRMCxiquak/r6iE8Z13QtNBUcGgGm1m
	4JlmZAgUmK149cy8fpwtT4CuqBgrXm0SX/cMnCmOYFNrP7/b7pwDQ+QMz32UgMpRrJO/pZCXGRk
	8KLzsoLpOqPrq1ncIMKagPy8tzrPIcfHn61sPWZW4d8D3BxdAhlV5Dzp0lpT9CWDXs4oB65SJ+I
	2ZOrlL/Chu/H8OThb9BfCosdRaZ8VZK9TCp9tTfvfmi7w48gPdI4SFPxWmbdNOtzF7vKBwa6249
	2ISaiiMNVkIUqNk7LV2bxbojIEDREmoEM8sYj2B+N3enzsXK/AwtWm
X-Received: by 2002:a17:90b:5607:b0:35e:d015:d675 with SMTP id 98e67ed59e1d1-3779d7a1208mr3111460a91.7.1781180242867;
        Thu, 11 Jun 2026 05:17:22 -0700 (PDT)
Received: from [192.168.89.2] ([27.232.220.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3775558f317sm2486069a91.9.2026.06.11.05.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 05:17:22 -0700 (PDT)
Message-ID: <bfc283bc-a5db-4e96-a447-e8e79cc97d34@gmail.com>
Date: Thu, 11 Jun 2026 21:17:18 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] crypto: inside-secure: add EIP93 ESP packet backend
To: Simon Horman <horms@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 netdev@vger.kernel.org
References: <20260523121522.3023992-1-hurryman2212@gmail.com>
 <20260523121522.3023992-3-hurryman2212@gmail.com>
 <20260527100824.GJ2256768@horms.kernel.org>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <20260527100824.GJ2256768@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/27/26 19:08, Simon Horman wrote:
> On Sat, May 23, 2026 at 09:15:21PM +0900, Jihong Min wrote:
>> Expose an EIP93 packet-mode IPsec backend for netdev drivers that need
>> ESP encapsulation and decapsulation offload without advertising EIP93
>> itself as a netdev.
>>
>> Add provider selection, capability reporting, SA lifecycle management,
>> IPsec request completion, and provider fault notification around the
>> existing EIP93 descriptor path.
>>
>> Assisted-by: Codex:gpt-5.5
>> Signed-off-by: Jihong Min <hurryman2212@gmail.com>
> 
> ...
> 
>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-ipsec.c b/drivers/crypto/inside-secure/eip93/eip93-ipsec.c
> 
> ...
> 
>> +static void eip93_ipsec_abort_requests(struct eip93_ipsec *ipsec, int err)
>> +{
>> +	struct eip93_ipsec_sa *sa;
>> +
>> +	while (true) {
>> +		bool found = false;
>> +
>> +		spin_lock_bh(&ipsec->lock);
>> +		list_for_each_entry(sa, &ipsec->sa_list, node) {
>> +			spin_lock(&sa->lock);
>> +			if (sa->aborting) {
>> +				spin_unlock(&sa->lock);
>> +				continue;
>> +			}
>> +
>> +			sa->aborting = true;
>> +			found = refcount_inc_not_zero(&sa->refcnt);
>> +			spin_unlock(&sa->lock);
>> +			if (found)
>> +				break;
>> +		}
>> +		spin_unlock_bh(&ipsec->lock);
>> +		if (!found)
>> +			return;
>> +
>> +		eip93_ipsec_abort_sa(sa, err);
>> +		eip93_ipsec_sa_put(sa);
> 
> sa is the iterator for the list_for_each_entry loop.
> However, here it is used outside of that context.
> 
> 	"If list_for_each_entry, etc complete a traversal of the list, the
> 	iterator variable ends up pointing to an address at an offset from
> 	the list head, and not a meaningful structure.  Thus this value
> 	should not be used after the end of the iterator.
> 
> 	https://www.spinics.net/lists/linux-kernel-janitors/msg11994.html
> 
> Flagged by Coccinelle.
> 

Hi Simon,

Thanks for the feedback, and sorry for noticing this mail so late.

Your point is correct. The `list_for_each_entry()` iterator should not
be used outside the loop like that. If I continued with this series, I
would fix it by keeping a separate selected SA pointer before dropping
the lock.

At this point, though, I think the right thing is to withdraw this
EIP93/Airoha series.

The reason is that many Airoha SoCs also have a higher-performance IP
block called SOE (Secure Offload Engine). I recently wrote and tested a
driver for that block, and I am currently carrying it here: [kernel: add
bonding LAG XFRM offload infrastructure and Airoha
support](https://github.com/hurryman2212/OpenW1700k-test/commit/fbfe8f919f836bb62b3849f803865a4d9b8dc76f).
With the EIP93 path I could get around 1 Gbps, while the SOE path can
reach about 5 Gbps in my current setup. Because of that, integrating
this EIP93 ESP packet path directly into `airoha_eth` is no longer the
most useful direction for Airoha Ethernet.

That said, SOE exists only on some Airoha SoCs. EIP93 can still be
useful on other platforms as a look-aside ESP packet offloader, but I
think that needs a cleaner infrastructure than this series had. The
look-aside offloader should be able to live as a separate module, not be
tied directly to one specific netdev driver, while still allowing
compatible netdevs to attach it into the XFRM path. I think that needs a
more general infrastructure extension, so I would rather revisit the
EIP93 work later on top of that kind of model.


Sincerely,
Jihong Min

>> +	}
>> +}
> 
> ...

