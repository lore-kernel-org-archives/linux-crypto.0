Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B78C1C84B1
	for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 08:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745657344; cv=none; b=GBeFF/2LSV+CkZ9CJNbQluGgFNtojXLZ2e3FAibuwnFx3flTpdplYEC8e7hDi6rWRu+CHi2pFs73KXxkhx1YNTylKV83AJwHFlBN5mBLGtzK3G0nixvxjNbaDrwdiysrmApGeIdUtcp7Ys2u/JlPDPm8sFrdwBa3cAjwQoS4l6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745657344; c=relaxed/simple;
	bh=VvhVJUxbujEt/82Oh7MWqz07P+csAPrSW3Yrsyxj8m4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fnzMIvYGzTBZLF3owhPfoUr5D4altygdZat7v/NhGm1ZFoTTxDRl7LTHM8D53feEXRGXWbQJiEUfdGcD1VCWGAliH0S9q+upFaNrPl60cE78A4IahzvFx/iNAf9M26G55JRTAXeQrK9svrVbhz3sUVLb5BZp4+BJCjl4KPyZouM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BVmrSyAg; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BVmrSyAg"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so28721225e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 01:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745657340; x=1746262140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Mdj+zoH4lFIbvlYYukY12hViRcNCFHIXiPCq2FExRIs=;
        b=BVmrSyAgR8qBrBoAvoopYKLZPp6Mm4MnSjMIie9oW+6PUmb+3j168vIYOj57XwCqfb
         B8AtkT8qfRLQsMRYp4TbDZxNXkkiVovfI3CP4x5purvPylTtKSjG0n2Xe7Zyo18J5UXO
         kv8RS3f5lqII2JlEoQDu+qOwqYX/8yxDCNfXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745657340; x=1746262140;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mdj+zoH4lFIbvlYYukY12hViRcNCFHIXiPCq2FExRIs=;
        b=Ko8PWQ9driegJtngvcx1N0vz56yvNnb6SVEmeiEm2on+tPATKPRUzxyCEHFUutXNr/
         VDxQDWDr9PwY97KPER+yWE0uEDxg0fTFklGsj4ovI/XXEFaQGLEE+UYaecVg9J9lDH2d
         JJ1UYEBz/k2223lG2EPdRPn5Kpy+vSTFRSrXLLccR/kpDPpJWUGWXCaytN3dgEpAKE1+
         GQ0aNi1CLBl8bpkmiBUfO2iXUOubnVWHGtx9yi2mO5Ii+R7LD74CXWdK21HUex7NBQ9b
         FMQG9Kd5LTiM5kOf3clwdR+9plfUOAZy7JE/l4Twj+af5DqrcjodZWSooJEJXwjrYkp/
         KFvw==
X-Forwarded-Encrypted: i=1; AJvYcCX6ftixQYVTwZbSdRSfmM5HCmRW71oRzl4sc8Y7Gq5z0g31tsz39yCGUwGeC1RuySORviHtMaHIK7QpU30=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXrOtWKBq94ljd50sCtPNlG/c8agIwjPHcdJr6bUX0ds8MePCc
	S/vx6ni6YXFdPAa3A+szzp+R1lvadhjomd3FV7vLr4IKTGNvbJfxOBDtg83GKg==
X-Gm-Gg: ASbGncujxUvymVTWkUfQtQqtlv1yD0YTzhh6+fx8MoXHsQ3M3ijabc7Tynl0rYNHFdl
	lP5Xyo7eO2/wce32+YShcD/aY3EYFz71hETeEp7ik99EWFEfCV5ZJ9FjJk7VUrOUwqJ3mQgKKC8
	pvn6KVxEo3tHVLnyFrZhCBCupeWOfEzGpBdKeYQVWIzp76mkLOgn1kJ3YOJ4O8qCANbjmgjNdxX
	jxbqLu+SIDDm1snJEj4Amv1wCxjNmzW90/FqNXKa9OZZ6Tx6ICV5wWJIpa/0+j5CIsTUyDr1MW/
	gI+5efPFOkN6t4Q5c+VH8wDCJZobKdOEbG3mpN+dHo3lotKgk87a6D4GBY8VT0gDv6sbOjJAwqz
	++uFCLAIF0r5hm9USCGG3V5A=
X-Google-Smtp-Source: AGHT+IHPZeKdxZvPYe2TepgSAn88bwYI7vcjTjP6rkOEVPWEl8fuLc+bJpWvPfDlNT6FlBQvkJudFg==
X-Received: by 2002:a05:600c:46cf:b0:439:9424:1b70 with SMTP id 5b1f17b1804b1-440ab871770mr18150425e9.30.1745657340509;
        Sat, 26 Apr 2025 01:49:00 -0700 (PDT)
Received: from [192.168.1.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a52f89b2sm53032105e9.8.2025.04.26.01.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Apr 2025 01:48:59 -0700 (PDT)
Message-ID: <dc47e9ba-e23d-45d2-bae1-cac8bac2310b@broadcom.com>
Date: Sat, 26 Apr 2025 10:49:00 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] ARM: bcm: Add some BCMBCA peripherals
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, William Zhang <william.zhang@broadcom.com>,
 Anand Gore <anand.gore@broadcom.com>, Kursad Oney
 <kursad.oney@broadcom.com>, Florian Fainelli
 <florian.fainelli@broadcom.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?=
 <rafal@milecki.pl>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Olivia Mackall
 <olivia@selenic.com>, Ray Jui <rjui@broadcom.com>,
 Scott Branden <sbranden@broadcom.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
Content-Language: en-US
From: Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 xsBNBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAHNMEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPsLB
 IQQQAQgAywUCZWl41AUJI+Jo+hcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFr
 ZXktdXNhZ2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2Rp
 bmdAcGdwLmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29t
 Lm5ldAUbAwAAAAMWAgEFHgEAAAAEFQgJChYhBNXZKpfnkVze1+R8aIExtcQpvGagAAoJEIEx
 tcQpvGagWPEH/2l0DNr9QkTwJUxOoP9wgHfmVhqc0ZlDsBFv91I3BbhGKI5UATbipKNqG13Z
 TsBrJHcrnCqnTRS+8n9/myOF0ng2A4YT0EJnayzHugXm+hrkO5O9UEPJ8a+0553VqyoFhHqA
 zjxj8fUu1px5cbb4R9G4UAySqyeLLeqnYLCKb4+GklGSBGsLMYvLmIDNYlkhMdnnzsSUAS61
 WJYW6jjnzMwuKJ0ZHv7xZvSHyhIsFRiYiEs44kiYjbUUMcXor/uLEuTIazGrE3MahuGdjpT2
 IOjoMiTsbMc0yfhHp6G/2E769oDXMVxCCbMVpA+LUtVIQEA+8Zr6mX0Yk4nDS7OiBlvOwE0E
 U8AbwQEIAKxr71oqe+0+MYCc7WafWEcpQHFUwvYLcdBoOnmJPxDwDRpvU5LhqSPvk/yJdh9k
 4xUDQu3rm1qIW2I9Puk5n/Jz/lZsqGw8T13DKyu8eMcvaA/irm9lX9El27DPHy/0qsxmxVmU
 pu9y9S+BmaMb2CM9IuyxMWEl9ruWFS2jAWh/R8CrdnL6+zLk60R7XGzmSJqF09vYNlJ6Bdbs
 MWDXkYWWP5Ub1ZJGNJQ4qT7g8IN0qXxzLQsmz6tbgLMEHYBGx80bBF8AkdThd6SLhreCN7Uh
 IR/5NXGqotAZao2xlDpJLuOMQtoH9WVNuuxQQZHVd8if+yp6yRJ5DAmIUt5CCPcAEQEAAcLB
 gQQYAQIBKwUCU8AbwgUbDAAAAMBdIAQZAQgABgUCU8AbwQAKCRCTYAaomC8PVQ0VCACWk3n+
 obFABEp5Rg6Qvspi9kWXcwCcfZV41OIYWhXMoc57ssjCand5noZi8bKg0bxw4qsg+9cNgZ3P
 N/DFWcNKcAT3Z2/4fTnJqdJS//YcEhlr8uGs+ZWFcqAPbteFCM4dGDRruo69IrHfyyQGx16s
 CcFlrN8vD066RKevFepb/ml7eYEdN5SRALyEdQMKeCSf3mectdoECEqdF/MWpfWIYQ1hEfdm
 C2Kztm+h3Nkt9ZQLqc3wsPJZmbD9T0c9Rphfypgw/SfTf2/CHoYVkKqwUIzI59itl5Lze+R5
 wDByhWHx2Ud2R7SudmT9XK1e0x7W7a5z11Q6vrzuED5nQvkhAAoJEIExtcQpvGagugcIAJd5
 EYe6KM6Y6RvI6TvHp+QgbU5dxvjqSiSvam0Ms3QrLidCtantcGT2Wz/2PlbZqkoJxMQc40rb
 fXa4xQSvJYj0GWpadrDJUvUu3LEsunDCxdWrmbmwGRKqZraV2oG7YEddmDqOe0Xm/NxeSobc
 MIlnaE6V0U8f5zNHB7Y46yJjjYT/Ds1TJo3pvwevDWPvv6rdBeV07D9s43frUS6xYd1uFxHC
 7dZYWJjZmyUf5evr1W1gCgwLXG0PEi9n3qmz1lelQ8lSocmvxBKtMbX/OKhAfuP/iIwnTsww
 95A2SaPiQZA51NywV8OFgsN0ITl2PlZ4Tp9hHERDe6nQCsNI/Us=
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/6/2025 5:32 PM, Linus Walleij wrote:
> This adds a bunch peripherals to the Broadcom BRCMBCA
> SoC:s that I happened to find documentation for in some
> vendor header files.
> 
> It started when I added a bunch of peripherals for the
> BCM6846, and this included really helpful peripherals
> such as the PL081 DMA, for which I think the most common
> usecase is to be used as a memcpy engine to offload
> transfer of blocks from NAND flash to/from the NAND
> flash controller (at least this is how the STMicro
> FSMC controller was using it).
> 
> So I took a sweep and added all the stuff that has
> bindings to:
> 
> ARM:
> - BCM6846
> - BCM6855
> - BCM6878
> - BCM63138
> - BCM63148
> - BCM63178
> 
> ARM64:
> - BCM4908
> - BCM6856
> - BCM6858
> - BCM63158
> 
> There are several "holes" in this SoC list, I simply
> just fixed those that I happened to run into documentation
> for.
> 
> Unfortunately while very similar, some IP blocks vary
> slightly in version, the GPIO block is differently
> integrated on different systems, and the interrupt assignments
> are completely different, so it's safest to add these to each
> DTSI individually.
> 
> I add the interrupt binding for the RNG block in the
> process as this exists even if Linux isn't using the
> IRQ, and I put the RNG and DMA engines as default-enabled
> because they are not routed to the outside and should
> "just work" so why not.
> 
> I did a rogue patch adding some stuff to BCM6756 based
> on guessed but eventually dropped it. If someone has
> docs for this SoC I can add it.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Linus can you resubmit a v3 addressing William's feedback? I will drop 
your series for now. Thanks!
-- 
Florian

