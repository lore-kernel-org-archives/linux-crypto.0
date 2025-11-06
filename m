Received: from mail-io1-f99.google.com (mail-io1-f99.google.com [209.85.166.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E90C24469E
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 20:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762461905; cv=none; b=SQvCa9zHhkklfEYyHMUSVvCpzaBJYDu8gUPtaSZPFYrAG9zcllnUSZpVql3uHV2drEdKxWtf7ZW+ff0jSc7s14GcIjn0Tor8tLOL+2JC8WDVnjks6DjPDLd8WQOeverXKtosXa9jzzmrZo2WMiH7PCRGeZcV+DKorqJJXgDtA18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762461905; c=relaxed/simple;
	bh=Z8uWVHiXtU/sipIn2JMDjsO8DomjkdUGyvjEVgsyAYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dde1ubqzWVE/gvNP+ZX9DARym054eW31tRacvYj5qSWjoY/EoCgKEC0HhXdesPST24M3KuNkUgiUrIhL2do7Uy0BM7OtiTdTIexcydCIsZMy0ewDMgyEM8WRcCv9jM3dFVOHsiEV77hiZGqwqWrL2EH5s5m4gP3gRdg5T3oGgJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GsNdt4Ql; arc=none smtp.client-ip=209.85.166.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GsNdt4Ql"
Received: by mail-io1-f99.google.com with SMTP id ca18e2360f4ac-93e89a59d68so2158439f.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 12:45:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762461903; x=1763066703;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RW4FoR0yOC2JMiMbLT5SyorvPZhEQ/Yzvp8kSN7SoHg=;
        b=IPIDtr4KkCKOo4vdAm/rKVAntvyweyoqzrXM6nBowvFg7XzL4yCMV9Ft0otTDaf6ti
         AadzCiJW3DYx6ALtFVuSHg4dL8v4AA7C/ZlPLBASTQs7u55pDpLA/83c2HF3fHdgskAV
         5cYDPmo6jWbwVkdldmSSSsu2zfkwiBaNDazHsi8Bf6ww8d3KKQIRccspsErf888D5aqL
         oJi0D6pva4Skl/OGcNhXVxNMoaLJHr8ssf2DjYxWJrwri6shDzualyMTghSZob6/AjEu
         2esKeOgyk7dCMJ5rf5gJRPdKxxyLQQc8RPJtNTKh1Np5H9x9zQElNgQkDGgfwYYjBeC6
         9RQQ==
X-Gm-Message-State: AOJu0Yxq/J0YErfiwUutxe4T5g0ou3Fazc6MJpZMeTsXCb0BuElLUaWo
	pBWvuSQHhPu8V79FuXV6hZtznEE8gF8JrzCfJKSpm6hdU1qKM1GmSYTY9t/1iOTkCzVxXTAnqpM
	qcJObQyZQta9mQybElzX6QJYuFaoK95B+DRD+w52eO/yNPgsAUj5DR0N4L4XiCm/Fujt1nZeDFk
	uNAGQgh5/aozR25Gff0+U42NaN0M2abmTLOLcxlqTTXBbUc7Xyl4FM0ZDjXBnOyEgmhGZ/8VraR
	PEjqSXF38G+IzEVelh6RS2k
X-Gm-Gg: ASbGncsrF4sS1qENFM6JJgRj5pRRx4A1s7PmnjrqqT8tX74AN8PJM+tOIeKt11Q8AUT
	/B4GVmhope6GzRaQwy7nrSZbgEilr+FqO2MO/eBPSbsR5aOYEdWWq7WYts5uMuGZU1Y6XfXUcci
	/hmQ665I0g53ikgRgB+h4opLC0sFQnCrGTVGCq+tOLl//s1eZotEQC57P4bAyGLZwggLfOdSrI+
	LGx/8bXZ7rTkTFVmwKXFUL1utPhChZPInM1q2OpGyy40sqj6mVyQ4gV0UApqJRyU3RIKrurokPA
	78bMOu2Ux5yfa7xo1z2vtLGYJbR483QsvFX24wF81Xwj7Q1JxkurAnA0XqzJvGTbPX91IQUvaAs
	3PmClguh7F1czYJHLy2gc3o+hjIzgHd3KC0fOUvj/ao4kQe7VD7tGVtszBK70PBTvXjjOio+GBm
	HLjnV5VOFtbUXz6ymv0LtT/KY+bPrzI+Pv5GOzhWg=
X-Google-Smtp-Source: AGHT+IHtb0kDCZ6WJ8m5hgRWDZ0+t71ESTtJNMMGO9HNEVuKXDMsRdMLpM+ax7IzGCyHpdqWyEKqCuFjODuy
X-Received: by 2002:a05:6e02:1fcc:b0:433:3322:e35a with SMTP id e9e14a558f8ab-4335f4606femr12751745ab.15.1762461903288;
        Thu, 06 Nov 2025 12:45:03 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-12.dlp.protect.broadcom.com. [144.49.247.12])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-5b746872602sm365070173.20.2025.11.06.12.45.02
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 12:45:03 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3407734d98bso94731a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 12:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1762461902; x=1763066702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RW4FoR0yOC2JMiMbLT5SyorvPZhEQ/Yzvp8kSN7SoHg=;
        b=GsNdt4QlRRoPTJY2wKeTLkox45eGKk9IaripPFgnUqo1g6lJY+k4m+alf4uscLWbKb
         XyEhsiuYOkvTdird8tOqvRtPpLWNTEOjbYpuqpoAXpOnABo+n1Qd+A5YjQDrjxv1nikI
         nAilKWofe+RwD1hYUQMjSmxN1j5QlYcWljgR4=
X-Received: by 2002:a17:90b:3c86:b0:32e:6fae:ba52 with SMTP id 98e67ed59e1d1-3434c4e3c44mr582836a91.6.1762461901853;
        Thu, 06 Nov 2025 12:45:01 -0800 (PST)
X-Received: by 2002:a17:90b:3c86:b0:32e:6fae:ba52 with SMTP id 98e67ed59e1d1-3434c4e3c44mr582806a91.6.1762461901417;
        Thu, 06 Nov 2025 12:45:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c30b96dsm346476a91.5.2025.11.06.12.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 12:45:00 -0800 (PST)
Message-ID: <b0fd87c3-0127-49b1-9784-51b3738c3b79@broadcom.com>
Date: Thu, 6 Nov 2025 12:44:59 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] hwrng: bcm2835 - Simplify with
 of_device_get_match_data()
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
 <20251106-crypto-of-match-v1-2-36b26cd35cff@linaro.org>
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
In-Reply-To: <20251106-crypto-of-match-v1-2-36b26cd35cff@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/6/25 08:31, Krzysztof Kozlowski wrote:
> Driver's probe function matches against driver's of_device_id table,
> where each entry has non-NULL match data, so of_match_node() can be
> simplified with of_device_get_match_data().
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
