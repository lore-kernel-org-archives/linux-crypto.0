Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A43C35CBD6
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 12:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781180612; cv=none; b=OazIwqOoXAqpigKMhFFyEHjhFH9+I17kZRr6h+Ywzdw0cUlUDVr+H0NCkO7GfjRlBA8vL2B3WlNFStpeJhaDtry4lIBu9qb1KomKib645erP7vyY4dUTnN1OaH3PNiaNUcUhk0nVDAk3wd3TSKKa/KtA2cWDWkUYBHaw/tzAedQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781180612; c=relaxed/simple;
	bh=5o4uZfIewxYg8nMi5ai68NOliBQBC5fgwexMfo7Y0Io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jHrg+qBDhBLoCRcSphxz1esjhaC178Lu/PF02aWrGmzygDmRM1MQavJQHFCkRYadbGGNcjYibwzjr3lYuqrLnrIEIVc4PvAXhluOwPT14M4LHs/FTmB8cr0s/EXyoWt8P5pSdbjOBjHWsIz/ZHFbMENivBbcB+pLJ/3Ci/W6tA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rDMyA0To; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDMyA0To"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36ba285e98bso7784547a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 05:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781180610; x=1781785410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XWWde8oTiwpIrCzHwuGTBaaddX/30yZJJn3ORVLoQD4=;
        b=rDMyA0To7eYCGKdkD0X1hvFeSWK3dK1uJej6aK5E6la/0LYWBBMuh44DuxHEztONY+
         YpaNPMZP9micyD4LIG5bP+vxSxX+N6LIEd90f9ZpbsdTcksPtX/HJAPbe2Lt+XaZLdgV
         FAoHhuGV/8Efx3rRn7JqEZcj/KcnAPgmDicH0/SpD+V0yl/VjC5DWuX3PhxWWrdRBHKe
         Y59GlYJI9M3uyuBBL14k1YVjOq6cFqshbXbIsc0J77R2kaUz5AJY4meFRazr7+MfpoNF
         DRsA2Z+fM8PXfIatGLImrFpICNfQtrMGp1qL/7wjIoDIo17wbhPdSpa/QQXdGmprOulY
         jbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781180610; x=1781785410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWWde8oTiwpIrCzHwuGTBaaddX/30yZJJn3ORVLoQD4=;
        b=JI2In7rl9A5kYkZuzJtHCpA5/TSZP+b9Jnnk00yJOMFssuJTKRETXlDIP0gRSsD94I
         SHGlRRo+0Xeo+vZ/+SbGzpmgt6k4Yx1W7o0HEYc3/cxESd45HAfBUPH21b6WwMmzV5Cp
         n0L+LvUKHhLw240Ad+h898BnzUk16mBL5TNcFruoXHNru8hMY9SGLAsBBYT/ruEXgyuT
         Gx8f5g32NCfnBoR3TnSHoLNAi9jYIpy1T0EizsZo5tp7V1jMJoW+aeUYu6Mo64CjJhXE
         pxA7HFefAyOMmkdfUyZBhYt3vVEJE7tBxG8Il0/shZGyPR+t59687Twn78Xmfu9TWjTH
         9b2A==
X-Forwarded-Encrypted: i=1; AFNElJ9mc0l0d3Ddg6tuTlJAsB7dmCOzcjkJQFZzVp/oag6xgyp4ceScYoBvfMKNB4frv8JbiY+oczjqmVW5haw=@vger.kernel.org
X-Gm-Message-State: AOJu0YytsGpgqaYdM7MmLoShSmIoJD2I3mDv12tBaYEV3sVKmrCg4SFX
	Y41xZqOVSr/9+lHHX3eq7edoPHAWLTwjX1RhLcMQckdEZxf5NCrMS3Ii
X-Gm-Gg: Acq92OHnH+g8G4lKIu0z62lH66K6ymxITdBqQHg8VwrVFj34SYFkK0bscXpk6XK0YLo
	74gP8Vus57xXgg0Cvrk7njiRZ9+eFNpA+8+CIdZVQOgj4ApOP+TE/MlWL58Qua9kSnTHTZNvW/T
	RByROajl6p/sLWuu1Yw5f3K0gI2r7ZtMtZTO5+KNqcKp2i2tpnuk/Ic/qTb3kP/kBRAs6ggXyY7
	VNLN+sxxGQkBSz8+yCxCSGxcU2NBROtLm7SQtcajFpSVECPTqB0nicDNZyquLPsMTFhjYUt0Ei2
	rRlgfEuBph9SAY4ypdSHJQCrmKmqjq1EffiIoiizJLSSiULLvJ8tvtO2hmqOXY+i7vA8YkJjfDf
	PrAqSZOFBAxfeZswmei6rfN0VBwnQlMrjzj11/EjPCQswfQLCNkuxTygTAncjTjDN3JEBC3ZW1q
	m3hijIfkxUY87GXEGNZxuy7qQAnWxI+BTGaxk7JRrlvw==
X-Received: by 2002:a17:90b:3a05:b0:36d:b12f:613c with SMTP id 98e67ed59e1d1-3779f186dcfmr2904451a91.10.1781180609829;
        Thu, 11 Jun 2026 05:23:29 -0700 (PDT)
Received: from [192.168.89.2] ([27.232.220.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3774f4c2e5asm2564395a91.0.2026.06.11.05.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 05:23:29 -0700 (PDT)
Message-ID: <61bf60fd-2ccb-4d23-be5e-041c7c312510@gmail.com>
Date: Thu, 11 Jun 2026 21:23:25 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfrm: extend ESP offload infrastructure for packet
 engines
To: Leon Romanovsky <leon@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 netdev@vger.kernel.org
References: <20260523121522.3023992-1-hurryman2212@gmail.com>
 <20260523121522.3023992-2-hurryman2212@gmail.com>
 <20260611115646.GN327369@unreal>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <20260611115646.GN327369@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/11/26 20:56, Leon Romanovsky wrote:
> On Sat, May 23, 2026 at 09:15:20PM +0900, Jihong Min wrote:
>> Some ESP offload engines operate on whole ESP packets rather than the
>> generic software trailer layout. They can generate outbound ESP padding,
>> next-header and ICV bytes in hardware, and inbound decapsulation can
>> return an already-trimmed packet with the recovered next-header value.
> 
> How does this differ from the existing IPsec packet‑offload support in the
> Linux kernel?
> 
> Thanks

Hi Leon,

The short answer is that the series did not explain the relationship
with the existing XFRM packet-offload model clearly enough.

Existing XFRM_DEV_OFFLOAD_PACKET already represents the high-level model
where hardware handles ESP packet processing instead of only crypto
transforms. What I was trying to handle in this series was a narrower
case: EIP93 is a look-aside crypto/IPsec engine, not the netdev itself,
so the Airoha netdev had to attach that engine into its TX/RX path and
let it generate or consume the ESP packet framing. The extra hooks in
this series were meant for that look-aside integration, but looking
back, the split between the existing packet-offload model and the new
plumbing was not clean enough.

At this point, though, I think the right thing is to withdraw this
EIP93/Airoha series.

The reason is related to the SOE work I mentioned in the other patch
thread. Many Airoha SoCs also have a higher-performance IP block called
SOE (Secure Offload Engine). I recently wrote and tested a driver for
that block, and I am currently carrying it here: [kernel: add bonding
LAG XFRM offload infrastructure and Airoha
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


