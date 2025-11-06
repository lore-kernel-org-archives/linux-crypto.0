Received: from mail-il1-f227.google.com (mail-il1-f227.google.com [209.85.166.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C5C32E6BD
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 20:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762461253; cv=none; b=CBGtyd6PtUj8kHQLAoIg0m2xji65NkMq9edZ4orgu0Y0Sq9gz++0dUDfZy2d+ZrZ3AQgwNSx8SrHwopk9VbmFWzgH1akDo3nGIAy6rhKrb0aTieVmVhmd0iobKiyIfDpIgzyGe8Aq1s4fPzfHiMlsk2ycWaqcH8YikNYbktugJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762461253; c=relaxed/simple;
	bh=6EYQTYVE/8/8+6LqWi+B6QjStsG0lMlB/gZzewfvXFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5kxzel9USwwC5qdP7Va33iJ1F0T878/LIuhWRnknxfit/VzTetg6jxeanPpuxaB35GdHR94iU0jHeSqGK/EmWsV1XVYPsj2Ns9j6h/l/8YNz3t7TCyC5OBAJMtDCesDWuvhnW/aRVXuBXlYLT73MgoIJF7bW4Kykaqnsuo+QXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=DANDgZ+l; arc=none smtp.client-ip=209.85.166.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DANDgZ+l"
Received: by mail-il1-f227.google.com with SMTP id e9e14a558f8ab-433217b58d9so149505ab.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 12:34:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762461250; x=1763066050;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DzkV34otxN0ctVlzxZXpqYiYjaDeaTvbElNgle63bc8=;
        b=wgo8OwO3mtwg48HVeNXtguomWoZ5H9Ht5AJMB3GVDa0vdoj9Odlns/Ord+0Afr3TxI
         U6I1vHmD1QGRpcJ9yNlFH4psYuYjMNoaPdXt3xjeBN5Oqtj/Bw2e6xe86if+pSS07/ik
         LXhxlYwHcknWhDRj9NySqw9qHFVejtG6VF8ei32aN3xrmRgp+/kNJOkIW9WTPTP3P4YP
         kea8cJS4hflsx8khZNGWHnCiB93vzrQvJYOEi9rI3Xk9YBKbIkcwpTsS5Puf3DzzLmNp
         zocaW/rc4uE5quezj9hGE0ArLgAHdZvoeL+lJPAMP2NOSZS5GcApssBLx7xcwbkc2U8f
         Tz8Q==
X-Gm-Message-State: AOJu0Yz7PDtyKu057qd+pvLIaUpDL8po9FCpaS6m0u/ZFRxDh3BMbUN2
	R9g+HASeEpCJgN1V3AJjXqROA1JZo/q2vZ4Mt1h4oWzVKbMPQQqwf4gXlM4VWb/Bs2v2usUHio0
	ifYhvg5s+XGg8FXzTIR5b3pV30jXCPqUH2hcyp1boIGHxfHGClJwh3PTdGopwP8AC7SHJXFEE3K
	WOeTroI2G9/hrmHxyqLa1zu3lqYskyJrFkKN2qUdnJoNdSwMzLmK56nO8xx1jRh8Zm2gSBps7ZH
	TzArGvPjFl5Puc3Ar6mxENX
X-Gm-Gg: ASbGncuvSsgzzO8k3byF0lZ7oaVpa6O2LivCcMNnLgb3qRgjxuvd8DxaqMOkJ3XRVxa
	GD/xAM8B6ZF0PZjjV0w9CRZQDE6Enmlfu4XZk7wwH6PZoezCiX84DpalLNARnTdUeKiNw6Y37UE
	0+OMAJs1gO05qrnxK4IJWidaAreE8tljTO0fjenW0qOmjsvQk68EVLdhzl6PBghrBiGm01twaL7
	4UaGWX0jx86rSD+CFUzX0fdby8C+f30S0gfQ7D9/Jcc9sGCdsF8+68lPsuPwCrl+ZjiIUBgTtbT
	OvLHwO+jZ2JUQQGO3BxZn/rRjGkXymjZAeejBnjMKXMCCZMV1dmHy5G4+EgLD3zcZOvvUPadbHd
	Moie9n87UIDwoDgPVxUnQdlMDxoc3oxmhmyAkAPFawuTK8KuybUHbdyzlwCfaEtOAUu7xOeJaU4
	xRGj+umEFMrRjcLmqq7rHkJuYzNZVdkJa3BKK8Nx0=
X-Google-Smtp-Source: AGHT+IE7ssXWYG1Kl6zLN9o6XRXBLYlcIm6Oz9AC7dNpVJKn5DIP/VQrt3e66z6nYAh8AL+d7zdnNkdrmmDq
X-Received: by 2002:a05:6e02:1686:b0:433:2091:8a86 with SMTP id e9e14a558f8ab-4335f3ab152mr13708665ab.6.1762461250426;
        Thu, 06 Nov 2025 12:34:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-5b746739b58sm335181173.1.2025.11.06.12.34.10
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 12:34:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b993eb2701bso45844a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 12:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1762461249; x=1763066049; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DzkV34otxN0ctVlzxZXpqYiYjaDeaTvbElNgle63bc8=;
        b=DANDgZ+lEJQM7x/a8fUxFjWhS31ALEgzMjyMZupHMEohB/WMPKC4ejtHEKcd/3dEaC
         +DCH281wf3xrHmCeEC6QysjxyVwMX8ZuxSQRhKzI/53626FPoHNdOjGq7zNXjJNXxy/e
         NF4jPi8rRJbIltaORobmPqrBFdN+v58xHu/o4=
X-Received: by 2002:a17:902:f54b:b0:294:fb47:b62b with SMTP id d9443c01a7336-297c03be1cbmr9200335ad.21.1762461248974;
        Thu, 06 Nov 2025 12:34:08 -0800 (PST)
X-Received: by 2002:a17:902:f54b:b0:294:fb47:b62b with SMTP id d9443c01a7336-297c03be1cbmr9200015ad.21.1762461248558;
        Thu, 06 Nov 2025 12:34:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096b8ffsm37038865ad.21.2025.11.06.12.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 12:34:07 -0800 (PST)
Message-ID: <c6aafc19-a3ce-41b3-b3ba-f82494f9c9e9@broadcom.com>
Date: Thu, 6 Nov 2025 12:34:05 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] hwrng: bcm2835 - Move MODULE_DEVICE_TABLE() to table
 definition
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Scott Branden <sbranden@broadcom.com>,
 Jesper Nilsson <jesper.nilsson@axis.com>,
 Lars Persson <lars.persson@axis.com>, "David S. Miller"
 <davem@davemloft.net>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Srujana Challa <schalla@marvell.com>,
 Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@axis.com
References: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
 <20251106-crypto-of-match-v1-1-36b26cd35cff@linaro.org>
Content-Language: en-US, fr-FR
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
In-Reply-To: <20251106-crypto-of-match-v1-1-36b26cd35cff@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/6/25 08:31, Krzysztof Kozlowski wrote:
> Convention is to place MODULE_DEVICE_TABLE() immediately after
> definition of the affected table, so one can easily spot missing such.
> There is on the other hand no benefits of putting MODULE_DEVICE_TABLE()
> far away.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
--
Florian
